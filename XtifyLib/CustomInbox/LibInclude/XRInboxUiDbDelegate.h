//
//  XRInboxUiDbDelegate.h
//  XtifyLib
//
//  Created by gilad on 10/20/12.
//
//
//  For custom Inbox, Inbox View Controller UI must adopt XRInboxUiDbDelegate protocol and
//      provides data model,
//              database name,
//              inbox entity name, and
//              tableView, the UI element
//   all of which will be use by XRInboxDbInterface

#import <Foundation/Foundation.h>

@protocol XRInboxUiDbDelegate <NSObject>

@required

- (NSString *) getInboxDbName;
- (NSString *) getDbModelName;
- (NSString *) getInboxEntityName;
- (UITableView *)getInboxTableView ;

// Notify Inbox VC after getPending server call is completed. Parameter, the number of new messages received
- (void) didGetPendingResult:(int)newMessages;

@end
