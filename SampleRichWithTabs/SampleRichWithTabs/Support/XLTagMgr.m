//
//  XLTagMgr.m
//  XtifyLib
//
//  Created by Sucharita Gaat on 11/10/11.
//  Copyright (c) 2011 Xtify. All rights reserved.
//

#import "XLTagMgr.h"
#include "XLTag.h"
#include "XLappMgr.h"

static XLTagMgr* mTagMgr = nil;

@implementation XLTagMgr

@synthesize localObjectContext, localObjectModel ,localStoreCoordinator, tagsChanged;
+(XLTagMgr *)get
{
	if (nil == mTagMgr)
	{
		mTagMgr = [[XLTagMgr alloc] init];
	}
	return mTagMgr;
}
- (id)init
{
	if (self = [super init ]) {
		[self managedObjectContext];
        [self sendTagsToServerBulk];	
        self.tagsChanged = FALSE;
        recentTags=[NSMutableDictionary new];
    }
	return self;
}

-(void)insertTag:(NSString *)tagName withFlag:(NSString *)isSet
{
	
	XLTag *aDbMessage = (XLTag *)[NSEntityDescription 
                                        insertNewObjectForEntityForName:@"XLTag" 
										inManagedObjectContext:localObjectContext];
	
	aDbMessage.tagName=tagName;
    aDbMessage.isSet = isSet;
	
	
	NSError *error;
	if (![localObjectContext save:&error]) { // Commit the change.
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"***Getting database error=[%@]. Creating a new DB.",[error userInfo]);
		}
		[[XLappMgr get] recreateTagDb];// recovery recreate the database
	}
    	NSLog(@"added record=%@ to Tag entity",aDbMessage);
	
}	

- (NSMutableDictionary *)getRecentTags
{
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"XLTag" 
											  inManagedObjectContext:localObjectContext];
	[fetchRequest setEntity:entity];
	
	NSError *error = nil;
	NSArray *fetchedArrayObjects = [localObjectContext executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedArrayObjects ==nil) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
		return nil;
	}	
	if ([fetchedArrayObjects count]==0) {
		//XTLOG(@"No Actions to remove");
		return nil;
	}	
	
	XLTag *aMessage; 
	for (int i=0; i<[fetchedArrayObjects count];i++) 
	{
		aMessage= (XLTag *)[fetchedArrayObjects objectAtIndex:(NSUInteger)i];
       
        [recentTags setValue:[aMessage isSet] forKey:[aMessage tagName]];
    }
	return recentTags;
}	

-(void)deleteTagRow:(NSString *)tagName
{
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"XLTag" 
											  inManagedObjectContext:localObjectContext];
	[fetchRequest setEntity:entity];
	
	NSError *error = nil;
	NSArray *fetchedArrayObjects = [localObjectContext executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedArrayObjects ==nil) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return;
	}	
	if ([fetchedArrayObjects count]==0) {
		//XTLOG(@"No Actions to remove");
		return;
	}	
    XLTag *aMessage; 
    
	for (int i=0; i<[fetchedArrayObjects count];i++) 
	{
        aMessage= (XLTag *)[fetchedArrayObjects objectAtIndex:(NSUInteger)i];
        if([aMessage tagName] == tagName)
            [localObjectContext deleteObject:[fetchedArrayObjects objectAtIndex:(NSUInteger)i]];
	}
	// Save the context.
    
	if (![localObjectContext save:&error]) {
		NSLog(@"Unresolved store error %@, %@", error, [error userInfo]);
		[[XLappMgr get] recreateTagDb];// recovery recreate the database
	}
	

    
}
-(void)removeTags
{
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init]autorelease];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"XLTag" 
											  inManagedObjectContext:localObjectContext];
	[fetchRequest setEntity:entity];
	
	NSError *error = nil;
	NSArray *fetchedArrayObjects = [localObjectContext executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedArrayObjects ==nil) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		return;
	}	
	if ([fetchedArrayObjects count]==0) {
		return;		//XTLOG(@"No Actions to remove");
	}	
    
	for (int i=0; i<[fetchedArrayObjects count];i++) 
	{
		[localObjectContext deleteObject:
         [fetchedArrayObjects objectAtIndex:(NSUInteger)i]];
	}
	// Save the context.
    
	if (![localObjectContext save:&error]) {
		NSLog(@"Unresolved store error %@, %@", error, [error userInfo]);
		[[XLappMgr get] recreateTagDb];// recovery recreate the database
	}
	
}	
- (NSManagedObjectContext *)managedObjectContext {
    
    if (localObjectContext != nil) {
        return localObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        localObjectContext = [[NSManagedObjectContext alloc] init];
        [localObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return localObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel 
{

    if (localObjectModel != nil) {
        return localObjectModel;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"sampleapp" ofType:@"mom"]; // app model
    if (modelPath==nil) {
        NSLog(@"*** ERROR Creating data store. modelPath for sampleapp.mom is nil");
    }
    localObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    
    return localObjectModel;

}    
    
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (localStoreCoordinator != nil) {
        return localStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbName = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"SampleApp.sqlite"];
    if (![fileManager fileExistsAtPath:dbName]) {
		NSLog(@"Local store %@ doesn't exist.", dbName);
    }
    NSURL *storeUrl = [NSURL fileURLWithPath:dbName];
    NSError *error = nil;
    localStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![localStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            BOOL success = [fileManager removeItemAtPath:dbName error:&error];
            if (!success) {
                NSLog(@"Error: %@", [error localizedDescription]);
            } else {
                [localStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
            
            }
        }       
    }    
    
    return localStoreCoordinator;
}


- (void) sendTagsToServerBulk
{
    if(!tagsChanged)
    {
        return;
    }
    
	NSString *xid = [[XLappMgr get] getXid];
    if(xid != nil)
    {
        NSMutableDictionary *tagdic = [self getRecentTags];
        
		NSMutableArray *toBeTagged = [NSMutableArray new];
		NSMutableArray *toBeUntagged = [NSMutableArray new];
		for(NSString *key in tagdic)
		{
			NSLog(@"Key =%@ Val = %@",key, [tagdic valueForKey:key]);
			if([[tagdic valueForKey:key] isEqualToString:@"true"])
			{
				[toBeTagged addObject:key];
			}
			else
			{
				[toBeUntagged addObject:key];
			}
		}
		
		if([toBeTagged count] > 0)
			[[XLappMgr get]  addTag:toBeTagged];
		if([toBeUntagged count] > 0)
			[[XLappMgr get]  unTag:toBeUntagged];
        self.tagsChanged = false;
        [toBeTagged release];
        [toBeUntagged release];
    }
}
- (void) notifyTagsChanged:(BOOL) value
{
    self.tagsChanged = value;
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)dealloc{
    [recentTags release];
    [super dealloc];
}

@end
