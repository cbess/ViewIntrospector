//
//  CBUIViewManager.h
//  CBIntrospector
//
//  Created by Christopher Bess on 5/2/12.
//  Copyright (c) 2012 C. Bess. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBUIView;
@protocol CBUIViewManagerDelegate;

@interface CBUIViewManager : NSObject
@property (nonatomic, weak) id<CBUIViewManagerDelegate> delegate;
@property (nonatomic, strong) CBUIView *currentView;
@property (nonatomic, copy) NSString *syncDirectoryPath; // the last known sync directory
@property (nonatomic, assign) BOOL syncing;

- (void)sync;
// tells the device to select the specified view
- (void)updateSelectedViewToView:(CBUIView *)selectedView;
@end

@protocol CBUIViewManagerDelegate <NSObject>
- (void)viewManagerSavedViewToDisk:(CBUIViewManager *)manager;
- (void)viewManagerUpdatedViewFromDisk:(CBUIViewManager *)manager;
- (void)viewManagerClearedView:(CBUIViewManager *)manager;
@end
