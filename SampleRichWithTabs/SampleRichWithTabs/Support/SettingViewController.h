//
//  SettingViewController.h
//  XtifyRamp
//
//  Created by Gilad on 10/22/10.
//  Copyright 2010 Xtify. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaggingPreferenceScreen;
@class  AboutSetting;
@class AboutPage;

@interface SettingViewController : UIViewController <UITableViewDataSource,UIActionSheetDelegate , UITableViewDelegate> 
{
	UITableView			*settingTableView;
	Boolean				isSettingChanged;
    UISwitch        *locationSettingSwitch ;
    UISwitch        *badgeSettingSwitch ;
    UILabel     *locationSettingLabel ;
    UILabel     *badgeSettingLabel ;
    NSArray *aboutTableArray;
    NSArray *locationTableArray;
    NSArray *badgeTableArray;
    AboutSetting *aboutSettingPage;
    TaggingPreferenceScreen *taggingPref;
    
    NSMutableArray *listOfItems;
	
}
- (void)locationSettingAction:(id)sender;
- (void)badgeSettingAction:(id)sender;
- (void)settingsChanged;
-(void)updateSettingsTable;
- (void) setLocationPreference:(BOOL)value;


@property (nonatomic, retain) UITableView *settingTableView;


@property (nonatomic)Boolean isSettingChanged;
@property (nonatomic, retain) TaggingPreferenceScreen *taggingPrefController;


@end
