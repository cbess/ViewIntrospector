//
//  CBProjectWindow.m
//  CBIntrospector
//
//  Created by Christopher Bess on 6/4/12.
//  Copyright (c) 2012 C. Bess. All rights reserved.
//

#import "CBProjectWindow.h"
#import "CBPathItem.h"
#import "CBIntrospectorWindow.h"
#import "CBPlatform.h"

@interface CBProjectWindow () <NSOutlineViewDataSource>
@property (weak) IBOutlet NSOutlineView *outlineView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet CBIntrospectorWindow *introspectorWindow;
@property (nonatomic, strong) NSArray *pathItems;
@end

@implementation CBProjectWindow
@synthesize outlineView;
@synthesize progressIndicator;
@synthesize introspectorWindow;
@synthesize pathItems = _pathItems;

#pragma mark - Misc

- (void)reloadTree
{
    [self.progressIndicator startAnimation:nil];
    NSRegularExpression *guidRegex = [NSRegularExpression regularExpressionWithPattern:@"([A-Z0-9]{8})-([A-Z0-9]{4})-([A-Z0-9]{4})-([A-Z0-9]{4})-([A-Z0-9]{12})"
                                                                               options:0 error:nil];
    // build the path items collection
    NSArray *pathItems = [CBPathItem pathItemsAtPath:[[CBUtility sharedInstance] simulatorDirectoryPath] recursive:YES block:^BOOL(CBPathItem *item) {
        BOOL isDir;
        if ([item.name hasSuffix:@".app"])
            return YES;
        else if ([item.name isEqualToString:@"Applications"])
            return YES;
        else if ([[CBUtility sharedInstance] isVersionString:item.name]
                 && ([[NSFileManager defaultManager] fileExistsAtPath:item.path isDirectory:&isDir] && isDir))
            return YES;
        else if ([guidRegex matchesInString:item.name options:NSMatchingReportCompletion range:NSMakeRange(0, item.name.length)].count)
            return YES;
        
        return NO; 
    }];
    
    self.pathItems = pathItems;
    [self.outlineView reloadData];
    
    [self.progressIndicator stopAnimation:nil];
    CBDebugLog(@"%lu top level path items", pathItems.count);
}

#pragma mark - Events

- (IBAction)openProjectClicked:(id)sender 
{
    CBPathItem *item = [self.outlineView itemAtRow:self.outlineView.selectedRow];
    if (!item || [[CBUtility sharedInstance] isVersionString:item.name])
        return;
    
    [self.introspectorWindow switchProjectToDirectoryPath:item.path];
    CBDebugLog(@"project opened");
}

- (IBAction)reloadButtonClicked:(id)sender 
{
    [self reloadTree];
    [self.outlineView expandItem:self.pathItems.lastObject expandChildren:YES];
}

#pragma mark - Outline Datasource

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(CBPathItem *)item
{
    if (item == nil)
    {
        return self.pathItems.count;
    }
    
    if ([[CBUtility sharedInstance] isVersionString:item.name])
    {
        NSArray *appDirItems = item.subItems;
        CBPathItem *appDirItem = appDirItems.lastObject;
        return appDirItem.subItems.count;   
    }
    
    return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(CBPathItem *)item
{
    if (item == nil)
        return YES;
    return [[CBUtility sharedInstance] isVersionString:item.name];
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(CBPathItem *)item
{
    if (item == nil)
    {
        return [self.pathItems objectAtIndex:index];
    }
    
    if ([[CBUtility sharedInstance] isVersionString:item.name])
    {
        NSArray *appDirItems = item.subItems;
        CBPathItem *appDirItem = appDirItems.lastObject;
        CBPathItem *guidItem = [appDirItem.subItems objectAtIndex:index];
        NSArray *appItems = guidItem.subItems;
        return appItems.lastObject;
    }
    
    return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(CBPathItem *)item
{
    return item.name;
}
@end
