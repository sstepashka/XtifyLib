//
//  XLXtifyOptions.m
//  XtifyPush Library
//
//  Created by Gilad on 5/11/12.
//  Copyright (c) 2012 Xtify. All rights reserved.
//

#import "XLXtifyOptions.h"
#import "XtifyGlobal.h"

static  XLXtifyOptions *xXtifyOptions=nil;

@implementation XLXtifyOptions

+ (XLXtifyOptions *)getXtifyOptions
{
    if (xXtifyOptions==nil) {
        xXtifyOptions=[[XLXtifyOptions alloc]init];
    }
    return xXtifyOptions;
}

-(id)init
{
    if (self = [super init]) {        
        xoAppKey=xAppKey;
        xoLocationRequired=xLocationRequired;
        xoBackgroundLocationRequired=xRunAlsoInBackground ;
        xoLogging =xLogging ;
        xoMultipleMarkets=xMultipleMarkets;
        xoManageBadge=xBadgeManagerMethod;
        xoDesiredLocationAccuracy =xDesiredLocationAccuracy ;
    }
    return self;
}

- (NSString *)getAppKey
{
    return xoAppKey;
}
- (BOOL) isLocationRequired
{
    return xoLocationRequired;
}
- (BOOL) isBackgroundLocationRequired 
{
    return xoBackgroundLocationRequired;
}
- (BOOL) isLogging 
{
    return xoLogging;
}
- (BOOL) isMultipleMarkets
{
    return xoMultipleMarkets;
}
- (XLBadgeManagedType)  getManageBadgeType
{
    return xoManageBadge;
}
- (CLLocationAccuracy ) geDesiredLocationAccuracy
{
    return xoDesiredLocationAccuracy;
}
- (void)xtLogMessage:(NSString *)header content:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    if (xoLogging) {
        NSString *prettyFmt=[NSString stringWithFormat:@"%@ %@", header,format];
        NSLogv(prettyFmt, args);
    }
    va_end(args);
}
@end
