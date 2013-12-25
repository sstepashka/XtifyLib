//
//  RichNotificationAppDelegate.h
//  RichNotification
//
//  Created by Gilad on 2/22/11.
//  Copyright 2011 Xtify. All rights reserved.
//

@class SettingViewController, AboutPage;
#import <UIKit/UIKit.h>

@class XLappMgr;

@interface SampleTabsAppDelegate : NSObject  <UIApplicationDelegate, UITabBarControllerDelegate>
{
    
	
	// Used for the sample inbox
    UIWindow *portraitWindow;
	UIViewController *mainViewController;
	UIWindow *window;
	UINavigationController *inboxNavController ,*settingNavController;
    
    // If your application is using UITabBarController
	UITabBarController *tabBarController;
    NSMutableArray *localViewControllersArray;
    SettingViewController *settingViewController;
    AboutPage *aboutControllr;
    
    
}
- (UINavigationController *) setupPortraitUserInterface;
- (void) redirectConsoleLogToDocumentFolder; //debug log to a file
- (void) doMyUpdate:(XLappMgr *)appM ;
- (UINavigationController *) developerNavigationController:(XLappMgr *)appM ;
- (void) moveToInbox:(XLappMgr *)appM ;

@property (nonatomic, retain) NSMutableArray *localViewControllersArray;
@property (nonatomic, retain) UIViewController *mainViewController;
@property (nonatomic, retain) UIWindow *portraitWindow;
//If your application is using UITabBarController
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) UINavigationController *inboxNavController, *settingNavController;
@property (nonatomic, retain) SettingViewController *settingViewController;
@property (nonatomic, retain) AboutPage *aboutControllr;


@end