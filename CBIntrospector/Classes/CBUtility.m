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

@interface CBUtility ()

@property (nonatomic, readonly) NSRegularExpression *versionRegex;

@end

@implementation CBUtility
@synthesize versionRegex = _versionRegex;

+ (CBUtility *)sharedInstance
{
    static CBUtility *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [CBUtility new];
    });
    
    return sharedObject;
}

#pragma mark - Properties

- (NSRegularExpression *)versionRegex
{
    if (_versionRegex == nil)
        _versionRegex = [[NSRegularExpression alloc] initWithPattern:@"^[0-9]\\.[0-9]" options:0 error:nil];
    return _versionRegex;
}

#pragma mark - Misc

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
    return [NSHomeDirectory() stringByAppendingPathComponent:kCBUserDirectoryPath];
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

- (BOOL)isVersionString:(NSString *)string
{
    NSArray *matches = [self.versionRegex matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    return (matches.count != 0);
}

@end
