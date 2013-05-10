//
//  CBProject.h
//  ViewIntrospector
//
//  Created by C. Bess on 5/10/13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPlatform;

@interface CBProject : NSObject

@property (nonatomic, weak) CBPlatform *platform;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;

@end
