//
//  CBTitleBarContentView.m
//  ViewIntrospector
//
//  Created by C. Bess on 5/9/13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import "CBTitleBarContentView.h"

@interface CBTitleBarContentView () <NSTextFieldDelegate>

@property (strong) IBOutlet NSTextField *titleTextField;
@property (strong) IBOutlet NSPopUpButton *platformPopupButton;
@property (strong) IBOutlet NSPopUpButton *projectPopupButton;
@property (strong) IBOutlet NSSearchField *searchField;
// project and platform super view
@property (strong) IBOutlet NSImageView *popupContainerView;

@end

@implementation CBTitleBarContentView

- (CBPlatform *)selectedPlatform
{
    if (_selectedPlatform == nil)
        return self.platforms[0];
    
    return _selectedPlatform;
}

- (NSString *)title
{
    return self.titleTextField.stringValue;
}

- (void)setTitle:(NSString *)title
{
    self.titleTextField.stringValue = title;
}

#pragma mark - Overrides

- (void)awakeFromNib
{
    self.popupContainerView.image = [NSImage imageNamed:@"platform-selector-button"];
}

#pragma mark - Misc

- (void)reloadWithPathItems:(NSArray *)pathItems
{
    CBDebugMark()
    
    self.platforms = [CBPlatform platformsFromArrayOfPathItems:pathItems];
    
    [self updatePlatformMenu];
    [self updateProjectMenu];
}

- (NSMenuItem *)menuItemWithProject:(CBProject *)project
{
    NSMenuItem *menuItem = [[NSMenuItem alloc] init];
    menuItem.title = project.name;
    menuItem.target = self;
    
    return menuItem;
}

- (void)updatePlatformMenu
{
    NSMenu *menu = self.platformPopupButton.menu;
    [menu removeAllItems];
    
    for (CBPlatform *platform in self.platforms)
    {
        NSMenuItem *menuItem = [[NSMenuItem alloc] init];
        menuItem.title = platform.name;
        
        // add project submenu
        NSMenu *submenu = [[NSMenu alloc] initWithTitle:menuItem.title];
        submenu.autoenablesItems = NO;
        for (CBProject *project in platform.projects)
        {
            NSMenuItem *submenuItem = [self menuItemWithProject:project];
            // change action to make it easier to determine post-action, rather than making a custom menu item
            submenuItem.action = @selector(projectMenuItemFromPlatformMenuClicked:);
            
            [submenu addItem:submenuItem];
        }
        
        [menu addItem:menuItem];
        [menu setSubmenu:submenu forItem:menuItem];
    }
}

- (void)updateProjectMenu
{
    NSMenu *menu = self.projectPopupButton.menu;
    [menu removeAllItems];
    
    for (CBProject *project in self.selectedPlatform.projects)
    {
        NSMenuItem *menuItem = [self menuItemWithProject:project];
        menuItem.action = @selector(projectMenuItemClicked:);
        
        [menu addItem:menuItem];
    }
}

- (CBProject *)projectWithName:(NSString *)projectName platformName:(NSString *)platformName
{
    for (CBPlatform *platform in self.platforms)
    {
        // ignore unmatching platform names
        if (![platform.name isEqualToString:platformName])
            continue;
        
        for (CBProject *project in platform.projects)
        {
            if ([project.name isEqualToString:projectName])
                return project;
        }
    }
    return nil;
}

- (void)platformMenuSelectionChanged
{
    // update the platform selection
    for (NSMenuItem *menuItem in self.platformPopupButton.menu.itemArray)
    {
        BOOL selected = [menuItem.title isEqualToString:self.selectedPlatform.name];
        menuItem.state = (selected ? NSOnState : NSOffState);
        
        if (selected)
            [self.platformPopupButton selectItem:menuItem];
    }
    
    [self updateProjectMenu];
    
    if ([self.delegate respondsToSelector:@selector(titleBarContentView:selectedPlatform:)])
        [self.delegate titleBarContentView:self selectedPlatform:self.selectedPlatform];
}

- (void)projectMenuSelectionChanged
{
    // update project selection
    for (NSMenuItem *menuItem in self.projectPopupButton.menu.itemArray)
    {
        BOOL selected = [menuItem.title isEqualToString:self.selectedProject.name];
        menuItem.state = (selected ? NSOnState : NSOffState);
        
        if (selected)
            [self.projectPopupButton selectItem:menuItem];
    }
    
    if ([self.delegate respondsToSelector:@selector(titleBarContentView:selectedProject:)])
        [self.delegate titleBarContentView:self selectedProject:self.selectedProject];
}

#pragma mark - Events

- (IBAction)reloadButtonClicked:(id)sender
{
    [self.delegate titleBarContentViewReloadButtonClicked:self];
}

- (void)projectMenuItemClicked:(NSMenuItem *)menuItem
{
    CBProject *project = [self projectWithName:menuItem.title platformName:self.selectedPlatform.name];
    self.selectedProject = project;
    
    CBDebugLog(@"project: %@", project);
    
    [self projectMenuSelectionChanged];
}

- (void)projectMenuItemFromPlatformMenuClicked:(NSMenuItem *)menuItem
{
    // find platform with assoc. title, update selected project
    NSString *platformTitle = menuItem.parentItem.title;
    for (CBPlatform *platform in self.platforms)
    {
        if ([platform.name isEqualToString:platformTitle])
        {
            self.selectedPlatform = platform;
            [self platformMenuSelectionChanged];
            break;
        }
    }
    
    [self projectMenuItemClicked:menuItem];
}

#pragma mark - TextField Delegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    [self.delegate titleBarContentView:self searchString:self.searchField.stringValue];
}

@end
