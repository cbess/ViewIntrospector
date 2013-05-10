//
//  CBConstants.h
//  CBIntrospector
//
//  Created by Christopher Bess on 5/12/12.
//  Copyright (c) 2012 C. Bess. All rights reserved.
//

#ifndef CBIntrospector_CBConstants_h
#define CBIntrospector_CBConstants_h

/**
 * FYI: File synching is done rather than networking protocols to avoid network lib 
 * conflicts and its a simplier design.
 */

static NSString *const kCBCurrentViewFileName = @"current.view.json";
static NSString * const kCBTreeDumpFileName = @"viewtree.dump.json";
static NSString * const kCBViewMessageFileName = @"view.message.json";
// contains the memaddress of the selected view from the desktop client
static NSString * const kCBSelectedViewFileName = @"selected.view.json";
static NSString * const kCBMessageTypeRemoteNotification = @"messagetype.remotenotification";
static NSString * const kCBMessageTypeView = @"messagetype.view";
static NSString * const kCBMessageTypeObject = @"messagetype.object";

// stored json keys
static NSString * const kUIViewSubviewsKey = @"subviews";
static NSString * const kUIViewClassNameKey = @"class";
static NSString * const kUIViewMemoryAddressKey = @"memaddress";
static NSString * const kUIViewHiddenKey = @"hidden";
static NSString * const kUIViewAlphaKey = @"alpha";
static NSString * const kUIViewBoundsKey = @"bounds";
static NSString * const kUIViewCenterKey = @"center";
static NSString * const kUIViewFrameKey = @"frame";
static NSString * const kUIViewDescriptionKey = @"viewdescription";
static NSString * const kUIViewMessageKey = @"viewmessage";
// only used with view introspector
static NSString * const kCBMessageTypeKey = @"messagetype";

#endif
