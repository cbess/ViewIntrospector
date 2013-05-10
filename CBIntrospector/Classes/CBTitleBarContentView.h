//
//  CBTitleBarContentView.h
//  ViewIntrospector
//
//  Created by C. Bess on 5/9/13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol CBTitleBarContentViewDelegate;

@interface CBTitleBarContentView : NSView

@property (nonatomic, weak) id<CBTitleBarContentViewDelegate> delegate;
@property (nonatomic, strong) NSArray *platforms;
@property (nonatomic, strong) NSArray *projects;

/**
 * Reloads the project and platform controls
 */
- (void)reload;

@end

@protocol CBTitleBarContentViewDelegate <NSObject>

/**
 * Tells the delegate that there is a search string being input.
 */
- (void)titleBarContentView:(CBTitleBarContentView *)contentView searchString:(NSString *)searchString;

/**
 * Tells the delegate that the platform selection has changed.
 */
- (void)titleBarContentView:(CBTitleBarContentView *)contentView platformSelectedIndex:(NSInteger)selectedIndex;

/**
 * Tells the delegate that the project selection has changed.
 */
- (void)titleBarContentView:(CBTitleBarContentView *)contentView projectSelectedIndex:(NSInteger)selectedIndex;

@end