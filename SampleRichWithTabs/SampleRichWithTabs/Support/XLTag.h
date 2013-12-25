//
//  Tag.h
//  XtifyLib
//
//  Created by Sucharita Gaat on 11/9/11.
//  Copyright (c) 2011 Xtify. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface XLTag : NSManagedObject
{
    
}
@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) NSString * isSet;
@end
