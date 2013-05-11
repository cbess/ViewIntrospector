//
//  CBViewMessengerWindow.m
//  CBIntrospector
//
//  Created by Christopher Bess on 7/25/12.
//  Copyright (c) 2012 C. Bess. All rights reserved.
//

#import "CBViewMessengerWindow.h"
#import "CBIntrospectorWindow.h"
#import "CBUIView.h"
#import "NSObject+JSON.h"

// specify the type of message to send to CBIntrospect
typedef enum {
    CBMessageTypeView,
    CBMessageTypeObject,
    CBMessageTypeRemoteNotification
} CBMessageType;

@interface CBViewMessengerWindow ()

@property (weak) IBOutlet NSButton *receiverViewButton;
@property (weak) IBOutlet NSTextField *messageTextField;
@property (weak) IBOutlet NSButton *sendButton;
@property (unsafe_unretained) IBOutlet NSTextView *responseTextView;
@property (nonatomic, assign) CBMessageType messageType;

@end

@implementation CBViewMessengerWindow
@synthesize receiverViewButton;
@synthesize messageTextField;
@synthesize sendButton;
@synthesize responseTextView;
@synthesize receiverView = _receiverView;
@synthesize introspectorWindow;

- (void)awakeFromNib
{
    [self.sendButton setEnabled:NO];
    self.responseTextView.font = [NSFont fontWithName:@"Monaco" size:12];
    self.messageType = CBMessageTypeView;
}

- (void)setReceiverView:(CBUIView *)receiverView
{
    if (receiverView == _receiverView)
        return;
    
    _receiverView = receiverView;
    
    // load the window
    if (receiverView)
        self.receiverViewButton.title = nssprintf(@"<%@: 0x%@>", receiverView.className, receiverView.memoryAddress);
    else
        self.receiverViewButton.title = @"UIView";
    
    [self.sendButton setEnabled:receiverView != nil];
}

- (void)makeKeyAndOrderFront:(id)sender
{
    [super makeKeyAndOrderFront:sender];
    
    [self.messageTextField becomeFirstResponder];
}

#pragma mark - Events

- (IBAction)messengerTypeSelected:(NSPopUpButton *)sender
{
    self.messageType = [sender selectedTag];
    self.receiverView = nil;

    switch (self.messageType)
    {
        case CBMessageTypeRemoteNotification:
        case CBMessageTypeObject:
            // allow sending
            [self.sendButton setEnabled:YES];
            break;
            
        default:
            break;
    }
}

- (IBAction)receiverViewButtonClicked:(id)sender 
{
    if (self.receiverView == nil)
        return;
    
    // select the view in the tree
    [self.introspectorWindow makeKeyAndOrderFront:nil];
    [self.introspectorWindow selectTreeItemWithMemoryAddress:self.receiverView.memoryAddress];
}

- (IBAction)sendMessageButtonClicked:(id)sender
{
    NSString *message = self.messageTextField.stringValue;
    BOOL hasMessage = YES;
    if (self.messageType == CBMessageTypeRemoteNotification)
    {
        // precheck message, that it is a dictionary
        if (![[message objectFromJSONString] isKindOfClass:[NSDictionary class]])
        {
            [[CBUtility sharedInstance] showMessageBoxWithString:@"Remote notification payload must be in a dictionary."];
            return;
        }
        
        NSMutableDictionary *messageInfo = [NSMutableDictionary dictionaryWithCapacity:2];
        messageInfo[kCBMessageTypeKey] = kCBMessageTypeRemoteNotification;
        messageInfo[kUIViewMessageKey] = message;
        
        if ([self writeMessageJSON:messageInfo])
        {
            [self addLogToHistory:nssprintf(@"Sent remote notification: %@", message)];
        }
        
        return;
    }
    else if (self.messageType == CBMessageTypeObject)
    {
        hasMessage = message.length;
    }
    else if (!message.length || !self.receiverView)
    {
        hasMessage = NO;
    }
    
    if (!hasMessage)
    {
        [[CBUtility sharedInstance] showMessageBoxWithString:@"No message to send."];
        return;
    }
    
    NSMutableDictionary *messageInfo = [NSMutableDictionary dictionaryWithCapacity:3];
    NSString *rawMessage = message;
    if (self.receiverView)
    {
        // replace `self` with memaddress
        rawMessage = [message stringByReplacingOccurrencesOfString:@"self" withString:[@"0x" stringByAppendingString:self.receiverView.memoryAddress]];
        messageInfo[kUIViewMemoryAddressKey] = self.receiverView.memoryAddress;
    }
    
    messageInfo[kUIViewMessageKey] = rawMessage;
    messageInfo[kCBMessageTypeKey] = kCBMessageTypeView;
    
    if ([self writeMessageJSON:messageInfo])
    {
        // append message
        NSString *selfString = nssprintf(@"<%@: 0x%@>", self.receiverView.className, self.receiverView.memoryAddress);
        NSString *logString = [message stringByReplacingOccurrencesOfString:@"self" withString:selfString];
        [self addLogToHistory:logString];
    }
}

#pragma mark - Misc

- (void)addLogToHistory:(NSString *)logString
{
    self.responseTextView.string = [self.responseTextView.string stringByAppendingFormat:@"\n=> %@", logString];
}

- (BOOL)writeMessageJSON:(NSDictionary *)jsonInfo
{
    // save to disk
    NSError *error = nil;
    NSString *jsonString = [jsonInfo JSONString];
    [jsonString writeToFile:[self.introspectorWindow.syncDirectoryPath stringByAppendingPathComponent:kCBViewMessageFileName]
                 atomically:NO
                   encoding:NSUTF8StringEncoding
                      error:&error];
    if (error)
    {
        NSAssert(NO, @"Failed to save JSON: %@", error);
        return NO;
    }
    
    return YES;
}

- (void)clearHistory
{
    self.responseTextView.string = @"";
}

@end
