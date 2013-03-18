//
//  NSObject+JSON.m
//  ViewIntrospector
//
//  Created by Markus Emrich on 11.02.13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSString (JSON)

- (id)objectFromJSONString;
{
    return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

@end



@implementation NSDictionary (JSON)

- (NSString*)JSONString;
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:0 error:nil] encoding:NSUTF8StringEncoding];
}

@end


@implementation NSArray (JSON)

- (NSString*)JSONString;
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:0 error:nil] encoding:NSUTF8StringEncoding];
}

@end