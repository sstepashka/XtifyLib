//
//  CompanyCustomInbox.h
//  Sample Custom Inbox
//
//  Created by Gilad on 9/14/12.
//  Copyright (c) 2012 Xtify. All rights reserved.
//
//  Company who wish to customize their Inbox, would implement this or similar class.

#import <UIKit/UIKit.h>

@interface CompanyCustomInbox : NSObject
{
    UITableViewController *parentViewController;
}
+(CompanyCustomInbox *)get ;

- (void) setCallbackSelectors:(SEL)aSuccessSelector failSelector:(SEL)aFailureSelector andDelegate:(id)aDelegate ;

- (void) handleRichPush:(NSDictionary *) aPush withAlert:(BOOL) flag;
- (void) getPending:(id)notifyObject;


@end
