//
//  CBPlatform.m
//  ViewIntrospector
//
//  Created by C. Bess on 5/10/13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import "CBPlatform.h"
#import "CBPathItem.h"

@implementation CBPlatform

+ (NSArray *)platformsFromArrayOfPathItems:(NSArray *)pathItems
{
    NSMutableArray *platforms = [NSMutableArray arrayWithCapacity:pathItems.count];
    // iterate platform level (ie. 6.1, 6.3, etc)
    for (CBPathItem *platformDirItem in pathItems)
    {
        CBPathItem *appDirItem = platformDirItem.subItems.lastObject;
        
        // create platform
        CBPlatform *platform = [CBPlatform new];
        platform.name = platformDirItem.name;
        
        // iterate each platform directory item (ie. AppName.app, etc)
        for (CBPathItem *guidItem in appDirItem.subItems)
        {
            CBPathItem *projectDirItem = guidItem.subItems.lastObject;
            
            // may be nil, if something else is in the directory besides app bundles
            NSString *projName = [projectDirItem.name stringByReplacingOccurrencesOfString:@".app" withString:[NSString string]];
            if (projName == nil)
                continue;
            
            // create project
            CBProject *project = [CBProject new];
            project.name = [projectDirItem.name stringByReplacingOccurrencesOfString:@".app" withString:[NSString string]];
            project.path = projectDirItem.path;
            
            // store as platform project
            project.platform = platform;
            [platform.projects addObject:project];
        }
        
        // sort projects
        [platform.projects sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        [platforms addObject:platform];
    }
    
    return platforms;
}

#pragma mark - Properties

- (NSMutableArray *)projects
{
    if (_projects == nil)
        _projects = [NSMutableArray arrayWithCapacity:10];
    return _projects;
}

#pragma mark - Overrides

- (NSString *)description
{
    return nssprintf(@"<%@ name:%@>", [super description], self.name);
}

@end
