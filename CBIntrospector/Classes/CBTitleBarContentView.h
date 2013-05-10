//
//  CBTitleBarContentView.h
//  ViewIntrospector
//
//  Created by C. Bess on 5/9/13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBPlatform.h"

@protocol CBTitleBarContentViewDelegate;

@interface CBTitleBarContentView : NSView

@property (nonatomic, weak) id<CBTitleBarContentViewDelegate> delegate;
@property (nonatomic, strong) NSArray *platforms;
@property (nonatomic, weak) CBPlatform *selectedPlatform;
@property (nonatomic, weak) CBProject *selectedProject;

/**
 * Reloads the project and platform controls
 */
- (void)reloadWithPathItems:(NSArray *)pathItems;

@end

@protocol CBTitleBarContentViewDelegate <NSObject>

/**
 * Tells the delegate that there is a search string being input.
 */
- (void)titleBarContentView:(CBTitleBarContentView *)contentView searchString:(NSString *)searchString;

@optional
/**
 * Tells the delegate that the platform selection has changed.
 */
- (void)titleBarContentView:(CBTitleBarContentView *)contentView selectedPlatform:(CBPlatform *)platform;

/**
 * Tells the delegate that the project selection has changed.
 */
- (void)titleBarContentView:(CBTitleBarContentView *)contentView selectedProject:(CBProject *)project;

@end