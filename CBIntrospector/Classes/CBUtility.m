//
//  CBUtility.m
//  CBIntrospector
//
//  Created by Christopher Bess on 5/3/12.
//  Copyright (c) 2012 C. Bess. All rights reserved.
//

#import "CBUtility.h"
#import "NSObject+JSON.h"

static NSString * const kCBUserDirectoryPath = @"Library/Application Support/iPhone Simulator";

@implementation CBUtility
+ (CBUtility *)sharedInstance
{
    static CBUtility *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [CBUtility new];
    });
    
    return sharedObject;
}

- (void)showMessageBoxWithString:(NSString *)msg
{
	NSAlert *alert = [NSAlert new];
	[alert setMessageText:msg];
	
	[alert runModal];
}

- (NSDictionary *)dictionaryWithJSONFilePath:(NSString *)path
{
    NSError *error = nil;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path
                                                            encoding:NSUTF8StringEncoding
                                                               error:&error];
    if (error)
        return nil;
    
    NSDictionary *jsonInfo = [jsonString objectFromJSONString];
    return jsonInfo;
}

- (int)updateIntValueWithTextField:(NSTextField *)textField addValue:(NSInteger)addValue
{
    if (!textField)
        return 0;
    
    textField.intValue = textField.intValue + addValue;
    return textField.intValue;
}

- (NSString *)simulatorDirectoryPath
{
    return [NSHomeDirectory() stringByAppendingFormat:@"/%@", kCBUserDirectoryPath];
}

- (id)objectWithClass:(Class)klass inNibNamed:(NSString *)nibNamed
{
    NSNib *nib = [[NSNib alloc] initWithNibNamed:nibNamed bundle:nil];
    NSArray *nibObjects = nil;
    [nib instantiateWithOwner:nil topLevelObjects:&nibObjects];
    
    // find the class
    for (id object in nibObjects)
    {
        if ([object isKindOfClass:klass])
            return object;
    }
    
    return nil;
}

@end
