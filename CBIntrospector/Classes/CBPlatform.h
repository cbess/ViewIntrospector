//
//  CBPlatform.h
//  ViewIntrospector
//
//  Created by C. Bess on 5/10/13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBProject.h"

@interface CBPlatform : NSObject

/**
 * Builds an array of CBPlatform objects that contain CBProjects using the specified path items.
 */
+ (NSArray *)platformsFromArrayOfPathItems:(NSArray *)pathItems;

// array of CBProject objects
@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, copy) NSString *name;

@end
