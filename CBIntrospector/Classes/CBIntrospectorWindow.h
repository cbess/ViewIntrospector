//
//  CBWindow.h
//  CBIntrospector
//
//  Created by Christopher Bess on 5/2/12.
//  Copyright (c) 2012 C. Bess. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"

@class CBUIViewManager;

@interface CBIntrospectorWindow : INAppStoreWindow

@property (weak, nonatomic, readonly) NSString *simulatorDirectoryPath;
@property (weak, nonatomic, readonly) NSString *syncDirectoryPath;
@property (nonatomic, strong) NSDictionary *treeContents;
@property (nonatomic, readonly) CBUIViewManager *viewManager;

- (void)switchProjectToDirectoryPath:(NSString *)path;
- (void)selectTreeItemWithMemoryAddress:(NSString *)memAddress;

@end
