//
//  XLTagMgr.h
//  XtifyLib
//
//  Created by Sucharita Gaat on 11/10/11.
//  Copyright (c) 2011 Xtify. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface XLTagMgr : NSObject{
    NSManagedObjectContext *localObjectContext;	 
    NSManagedObjectModel *localObjectModel;
    NSPersistentStoreCoordinator *localStoreCoordinator;
    BOOL tagsChanged;
    NSMutableDictionary *recentTags;
}

- (NSString *)applicationDocumentsDirectory ;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectContext *) managedObjectContext;

+(XLTagMgr *) get;
-(void)insertTag:(NSString *)tagName withFlag:(NSString *)isSet;
- (NSMutableDictionary *) getRecentTags ;
-(void) removeTags;
-(void)  deleteTagRow:(NSString *)tagName;
- (void) sendTagsToServerBulk;
- (void) notifyTagsChanged:(BOOL) value;

@property (nonatomic, retain, readonly) NSManagedObjectContext *localObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *localObjectModel ;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *localStoreCoordinator;
@property (nonatomic, assign) BOOL tagsChanged;

@end
