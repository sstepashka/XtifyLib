//
//  XLhmSupport.h
//  Xtify SDK Multi Markets Support
//
//  Created by Gilad on 10/18/11.
//  Copyright 2011 Xtify. All rights reserved.
//

#import <UIKit/UIKit.h>
#define xMarketToAppkey		@"Market_appkey" // Market to app key mapping
#define xCountryToLocale    @"Locale_Desc"


@interface XLhmSupport : NSObject {
    
	NSString *userCountryCode ;
    NSMutableDictionary *appKeyMapping;
    NSMutableDictionary *countryInitialMapping;
    NSMutableDictionary *localeCountryMapping;
    NSMutableDictionary *localeLanguageMapping;
    
}
+(XLhmSupport*) get;

-(void) changeCountryCode:(NSString *)newCountryCode;
-(NSString *)getAppkey ;
- (void) setCountryLocaleDict;

@property (nonatomic, retain) NSString *userCountryCode;
@property (nonatomic, retain) NSMutableDictionary *appKeyMapping;
@property (nonatomic, retain) NSMutableDictionary *localeCountryMapping;
@property (nonatomic, retain) NSMutableDictionary *countryInitialMapping;
@property (nonatomic, retain) NSMutableDictionary *localeLanguageMapping;
@end
