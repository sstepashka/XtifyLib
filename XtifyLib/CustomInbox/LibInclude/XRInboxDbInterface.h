//
//     File: XRInboxDbInterface.h
//  Xtify Library
//
//  Created by Gilad on 9/17/12.
//  Copyright (c) 2012 Xtify. All rights reserved.
//
//  Data model interface to Xtify Rich Inbox
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class XLRichJsonMessage,RichDbMessage;

@interface XRInboxDbInterface : NSObject < NSFetchedResultsControllerDelegate> {
    
}

+(XRInboxDbInterface *)get;

- (void) updateParentVCandDB:(id)delegatedInboxVC ;
- (void) readLocalStore;
- (RichDbMessage *) addRichMessageToDb:(XLRichJsonMessage *)inputMsg ;
- (int) getUnreadMessageCount;
- (int) getMessageCount ;
- (int) decrementMessageReadCount ;

- (void) setInboxUnreadMessageCount: (int) newCount;
- (RichDbMessage *) addEmptyMid:(NSString *)pushMid ;


// Inbox TableViewController Interface
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section ;
- (RichDbMessage *) cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)iterateOverFectch ;
-(id) getDbMessageByMid:(NSString *)mid;
- (void) removeExpiredMessages; // remove all expired message from data store
@end
