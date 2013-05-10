//
//  CBProject.m
//  ViewIntrospector
//
//  Created by C. Bess on 5/10/13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import "CBProject.h"
#import "CBPlatform.h"

@implementation CBProject

- (NSString *)description
{
    return nssprintf(@"<%@ platform:%@ project:%@>", [super description], self.platform.name, self.name);
}

@end
