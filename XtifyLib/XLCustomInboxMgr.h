//
//  XLCustomInboxMgr.h
//  SampleRich
//
//  Created by Gilad on 4/24/12.
//  Copyright (c) 2012 Xtify. All rights reserved.
//
// Customized Inbox (ci)

#import <Foundation/Foundation.h>

typedef enum {
    ciNoError = 0,
    ciHttpServerError , 
    ciAppKeyNotSet,
    ciXIDisNil ,
    ciMessageNotFound,
    ciDuplicateMessage,
    ciJsonNotValid,
    ciUnknownError 

} CiErrorType ;

@interface XLCustomInboxMgr : NSObject
{
}


- (void) setCiMessagSelectors:(SEL)aSuccessSelector failSelector:(SEL)aFailureSelector andDelegate:(id)aDelegate;
- (void) setCiPendingSelectors:(SEL)aSuccessSelector failSelector:(SEL)aFailureSelector andDelegate:(id)aDelegate;

// Get a single rich message
- (void) getCIMessage:(NSString *)mid;

// Get pending messages
- (void) getCIPenddingNotifications;


@end
