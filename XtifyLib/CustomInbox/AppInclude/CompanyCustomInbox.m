//
//  SampleCustomInbox.m
//  Sample Custom Inbox
//
//  Created by Gilad on 9/14/12.
//  Copyright (c) 2012 Xtify. All rights reserved.
//

#import "CompanyCustomInbox.h"

#import "XLCustomInboxMgr.h"
#import "XLRichJsonMessage.h"
#import "XRInboxDbInterface.h"
#import "XRInboxUiDbDelegate.h"
#import "CompanyDetailsVC.h"
#import "RichDbMessage.h"
#import "XLappMgr.h"

@interface CompanyCustomInbox()
{
    XLCustomInboxMgr *aCustomeInboxMgr;
    id<XRInboxUiDbDelegate>  notifyToObject ;
    NSString *msgId;
}

- (void) successfullyPendinghMessage:(NSMutableArray *)allInputMsgs; // Get pending messages
- (void) failedToGetPendingMessages:(CiErrorType )errorType;  // Something went wrong while getting the message

@end
@implementation CompanyCustomInbox

static CompanyCustomInbox* mSampleCustomInbox = nil;

+(CompanyCustomInbox *)get
{
	if (nil == mSampleCustomInbox)
	{
		mSampleCustomInbox = [[CompanyCustomInbox alloc] init];
        
	}
	return mSampleCustomInbox;
}

- (id) init
{
    if (self = [super init]) {
        aCustomeInboxMgr= [[XLCustomInboxMgr alloc] init];
        
    }
    return self;
}

- (void) setCallbackSelectors:(SEL)aSuccessSelector failSelector:(SEL)aFailureSelector andDelegate:(id)aDelegate
{
    //For the rich message, the delegate and the call back are different than the pending call
    [aCustomeInboxMgr setCiMessagSelectors:aSuccessSelector failSelector:aFailureSelector andDelegate:aDelegate];
    
    [aCustomeInboxMgr setCiPendingSelectors:@selector(successfullyPendinghMessage:) failSelector:@selector(failedToGetPendingMessages:) andDelegate:self];

}
- (void) handleRichPush:(NSDictionary *) aPush withAlert:(BOOL) alertFlag
{
  //  check if rich
    if (aPush !=nil && [aPush objectForKey:@"RN"]!=[NSNull null] && [[aPush objectForKey:@"RN"] length] > 0 ) {
        msgId= [[NSString alloc]initWithString:[aPush objectForKey:@"RN"]];
   /* if using handleAnyNotification then   insertSimpleClick:msgId allready called
        [[XLappMgr get] insertSimpleClick:msgId ];
     */   
        
        // App was active when notification has arrived. Open a dialog with an OK and cancel button
        if (alertFlag)
        {
            UIAlertView *alertView ;
            NSBundle *bundle = [NSBundle mainBundle];
            NSDictionary *info = [bundle infoDictionary];
            NSString *prodName = [[NSString alloc]initWithString:[info objectForKey:@"CFBundleDisplayName"]];
            NSDictionary *aps=[aPush objectForKey:@"aps"];
            NSDictionary *alert=[aps objectForKey:@"alert"];
            NSString *body=[alert objectForKey:@"body"] ==[NSNull null] ? @"Alert" : [alert objectForKey:@"body"];
            NSString *action=[alert objectForKey:@"action-loc-key"] ==[NSNull null]  ?@"Open" : [alert objectForKey:@"action-loc-key"];
            if ([msgId isEqualToString:@""] )
                alertView = [[UIAlertView alloc] initWithTitle:prodName message:body
                                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            else {
                alertView = [[UIAlertView alloc] initWithTitle:prodName message:body
                                                      delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:action, nil];
            }
            [alertView show];
            [alertView	 release];
            [prodName release];
        }
        else // no alert just get the message and display
        {
            [aCustomeInboxMgr getCIMessage:msgId];
        }

    }

}
- (void) getPending:(id)notifyObject
{
    notifyToObject =notifyObject;
    [aCustomeInboxMgr getCIPenddingNotifications];
}
#pragma mark -
#pragma mark - UIAlertViewDelegate
//User clicks the 'Open' after a push when the app is open.
// this is the application which puts the message
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) { // user select open
         [aCustomeInboxMgr getCIMessage:msgId];
	}
	else // user selected cancel
	{
        [self getPending:nil]; // just get the message and add to inbox
		
	}
}

- (void) successfullyPendinghMessage:(NSMutableArray *)allInputMsgs
{
    XRInboxDbInterface *myParentViewController = [XRInboxDbInterface get];
    if ( myParentViewController !=nil ) {
        NSLog(@"Successfully Got Pendingh Messages. Total messages=%d",[allInputMsgs count]);
        for (XLRichJsonMessage *inputMsg in allInputMsgs) {
            [myParentViewController addRichMessageToDb:inputMsg];
        }
        if (notifyToObject ) {
            [notifyToObject didGetPendingResult:[allInputMsgs count]];
        }
    }
    
}
- (void) failedToGetPendingMessages:(CiErrorType )errorType
{
    switch (errorType) {
        case ciNoError:
            NSLog(@"No Error=%d", errorType);
            break;
            /*      case ciMessageNotFoundError:
             NSLog(@"Message Not Found Error");
             break;
             */    case ciHttpServerError:
            NSLog(@"HTTP Server Error");
            break;
        case ciAppKeyNotSet:
            NSLog(@"App key not set");
            break;
        case ciXIDisNil:
            NSLog(@"XID is nil");
        default:
            NSLog(@"Unknown Error");
            break;
    }
}

@end
