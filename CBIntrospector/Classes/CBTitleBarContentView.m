//
//  CBTitleBarContentView.m
//  ViewIntrospector
//
//  Created by C. Bess on 5/9/13.
//  Copyright (c) 2013 C. Bess. All rights reserved.
//

#import "CBTitleBarContentView.h"

@interface CBTitleBarContentView ()

@property (strong) IBOutlet NSPopUpButton *platformPopupButton;
@property (strong) IBOutlet NSPopUpButton *projectPopupButton;
@property (strong) IBOutlet NSSearchField *searchField;
// project and platform super view
@property (strong) IBOutlet NSView *popupContainerView;

@end

@implementation CBTitleBarContentView

- (void)reload
{
    CBDebugMark()
}

@end
