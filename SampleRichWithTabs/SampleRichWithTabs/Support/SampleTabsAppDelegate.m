//
//  Rich Notification AppDelegate.m
//  RichNotification
//
//  Created by Gilad on 2/22/11.
//  Copyright 2011 Xtify. All rights reserved.
//

#import "SampleTabsAppDelegate.h"
#import "SettingViewController.h"
#import "AboutPage.h"
#import "XLappMgr.h" // Xtify Application Manager-- include this in your app
#import "XRInboxDbInterface.h"
#import "CompanyDetailsVC.h"
#import "CompanyCustomInbox.h"
#import "CompanyInboxVC.h"
#import "XLCustomInboxMgr.h"
#import "RichDbMessage.h"

#import "XLRichJsonMessage.h"

@interface SampleTabsAppDelegate()
{
}
- (void) successfullyGotRichMessage:(XLRichJsonMessage *)inputMsg;  // Get single message
- (void) failedToGetRichMessage:(CiErrorType )errorType;  // Something went wrong while getting the message
- (void) handleSimplePush:(NSDictionary *) aPush withAlert:(BOOL) alertFlag;
@end

@implementation SampleTabsAppDelegate

@synthesize mainViewController;
@synthesize portraitWindow;

// include this if your app uses the UITabBarController
@synthesize tabBarController;
@synthesize localViewControllersArray;
@synthesize inboxNavController, settingNavController;
@synthesize settingViewController;
@synthesize aboutControllr;

#define kInboxTabbarIndex 1 //identify the index (selectedIndex) for the Inbox main navigation controller

// Add or incorporate the functions below into your Application Delegate file
- init
{
    
	if (self = [super init]) {
        
        XLXtifyOptions *anXtifyOptions=[XLXtifyOptions getXtifyOptions];
        [[XLappMgr get ]initilizeXoptions:anXtifyOptions];
		// Examples how to receive events from Xtify SDK to your delegate
		
		[[XLappMgr get] setDidInboxChangeSelector:@selector(doMyUpdate:)];
		[[XLappMgr get] setInboxDelegate:self];
		[[XLappMgr get] setDeveloperNavigationControllerSelector:@selector(developerNavigationController:)];
		[[XLappMgr get] setDeveloperInboxNavigationControllerSelector:@selector(moveToInbox:)];
		[[XLappMgr get] setDeveloperXidNotificationSelector:@selector(doUpdateXid:)];
		[[XLappMgr get] setDeveloperRegistrationFailureSelector:@selector(failedRegistration:)];
		[[XLappMgr get] setDeveloperRegisterNotificationSelector:@selector(completeRegistration:)];
		[[XLappMgr get] setDeveloperLocationUpdatSelector:@selector(locationUpdateCompleted:)];

        [[CompanyCustomInbox get] setCallbackSelectors:@selector(successfullyGotRichMessage:) failSelector:@selector(failedToGetRichMessage:) andDelegate:self];

 	}
	return self;
}

// Add or incorporate this function in your app delegate file

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
	NSLog(@"Succeeded registering for push notifications. Device token: %@", devToken);
	[[XLappMgr get] registerWithXtify:devToken ];
	
}


// Add or incorporate this function in your app delegate file

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	NSLog(@"Application is about to Enter Background");
	[[XLappMgr get] appEnterBackground];
}

// Add or incorporate this function in your app delegate file

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"Application moved from inactive to Active state");
	[[XLappMgr get] appEnterActive];
}

// Add or incorporate this function in your app delegate file

- (void)applicationWillEnterForeground:(UIApplication *)application {
	NSLog(@"Application moved to Foreground");
    [settingViewController settingsChanged];
	[[XLappMgr get] appEnterForeground];
    [settingViewController updateSettingsTable];
}


// Add or incorporate this function in your app delegate file

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Application didFinishLaunchingWithOptions. launchOptions=%@",launchOptions);
    [self setupPortraitUserInterface];

    // App starts because of push notification
	if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil)
	{
		NSDictionary * aPush =[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self handleAnyNotification:aPush];
	}

    // App starts because of significant location change
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey] != nil )
    {
        [[XLappMgr get] handleSignificantLocation:application andOptions:launchOptions];
    }
    return YES;
	
}
// Add or incorporate this function in your app delegate file
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)pushMessage
{
	NSLog(@"Receiving notification, app is running. aPush=%@",pushMessage); //or user selects from the notification center
    
    NSDictionary * aPush=[[NSDictionary alloc] initWithDictionary:pushMessage];
    [self handleAnyNotification:aPush];
    
    [aPush release];
}
- (void)handleAnyNotification:(NSDictionary *)aPush
{
    // Update Notification Click metrics
    [[XLappMgr get]insertNotificationClick:aPush];
    
    BOOL withAlert=YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
	// get state -applicationState is only supported on 4.0 and above
	if (![[UIApplication sharedApplication] respondsToSelector:@selector(applicationState)])
	{
		withAlert = YES;
	}
	else
	{
		UIApplicationState state = [[UIApplication sharedApplication] applicationState];
		if (state == UIApplicationStateActive) {
			withAlert=YES; // display an alert
		}
		else {
			withAlert =NO; // don't display another alert
		}
	}
#endif
    
    //Handle Rich Notification using custom inbox
    if (aPush !=nil && [aPush objectForKey:@"RN"]!=[NSNull null] && [[aPush objectForKey:@"RN"] length] > 0 )
    {
        [[CompanyCustomInbox get] handleRichPush:aPush withAlert:withAlert];
        return;
    }
    // End custom inbox
    
    // Handle Open URL Notification
    if (aPush !=nil && [aPush objectForKey:@"URL"] !=[NSNull null] && [[aPush objectForKey:@"URL"] length] > 0 ) {
        NSLog(@"About to Open Safari");
        NSString *urlLink=[[[NSString alloc]initWithString:[aPush objectForKey:@"URL"]]autorelease];
        NSURL *url = [NSURL URLWithString:urlLink];
        if (![[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"Failed to open url:%@",[url description]);
        }
        return;
    }
    
    // Handle other Notification (The following is example for Custom Notification to display maps app)
    if (aPush !=nil && [aPush objectForKey:@"MAP"] !=[NSNull null] && [[aPush objectForKey:@"MAP"] length] > 0 ) {
        NSString *urlLink=[NSString stringWithFormat:@"http://maps.apple.com/?%@",[aPush objectForKey:@"MAP"]];
        NSURL *url = [NSURL URLWithString:urlLink];
        if (![[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"Failed to open Maps:%@",[url description]);
        }
        return ;
    }
    // Handle simple Push
    [[XLappMgr get]    setBadgeCountSpringBoardAndServer:0];
    [self handleSimplePush:aPush withAlert:withAlert];
}
       
-(void)applicationWillTerminate:(UIApplication *)application
{
	NSLog(@"applicationWillTerminate");
	[[XLappMgr get] applicationWillTerminate];
}

// Create the front screen for the inbox sample app
- (UINavigationController *) setupPortraitUserInterface
{
	UIWindow *localPortraitWindow;
	localPortraitWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.portraitWindow = localPortraitWindow;
	
	// the localPortraitWindow data is now retained by the application delegate, release the local variable
	[localPortraitWindow release];
	
    [portraitWindow setBackgroundColor:[UIColor whiteColor]];
    
	// Create a tabbar controller and an array to contain the view controllers
	tabBarController = [[UITabBarController alloc] init];
    tabBarController.delegate = self;
	localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:3];
	
    
    // Customized Inbox
    CompanyInboxVC *inboxVC = [[CompanyInboxVC alloc] initWithNibName:@"CompanyInboxVC" bundle:nil];
    
    [[XRInboxDbInterface get]updateParentVCandDB:inboxVC];
    [[XRInboxDbInterface get]removeExpiredMessages]; // removed expired message from local data store
    
	inboxVC.title=@"Inbox";
	UIImage* iImage = [UIImage imageNamed:@"inbox.png"];
	inboxVC.tabBarItem.image = iImage;
	inboxNavController = [[UINavigationController alloc] initWithRootViewController:inboxVC];
    [inboxVC release];
    
    //About
    aboutControllr = [[AboutPage alloc] init ];
    
    [localViewControllersArray insertObject:aboutControllr atIndex:0];
	[localViewControllersArray insertObject:inboxNavController atIndex:1]; //the 2nd, center tab
	
	//repeat for setting
	
	settingViewController= [[SettingViewController alloc] init];
	
	//SettingViewController *settingViewController= [[SettingViewController alloc] init];
	
	// create the navigation controller with the view controller
	settingNavController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
	[localViewControllersArray addObject:settingNavController];
	
	
	//end controllersSettingViewController
	
	// set the tab bar controller view controller array to the localViewControllersArray
	tabBarController.viewControllers = localViewControllersArray;
	
	[localViewControllersArray release];
	
	// set the window subview as the tab bar controller
	[portraitWindow addSubview:tabBarController.view];
	
	// make the window visible
	[portraitWindow makeKeyAndVisible];

	return inboxNavController;
    
    
    // If your application is using UITabBarController
    // return the navigation controller that handles the Rich page (and corresponds to the tabbaar index)
}

// Open the Inbox
// Add or incorporate function to display the inbox messages table list
- (void)tabBarController:(UITabBarController *)xtabBarController didSelectViewController:(UIViewController *)viewController
{
     //call getPenddingNotifications to update Inbox. Check Xtify documentation for proper use of custom inbox
     if (xtabBarController.selectedIndex == kInboxTabbarIndex ) // update the inbox with pending messages
     {
       // Custom inbox
        NSArray *childViewControllers =inboxNavController.childViewControllers;
        CompanyInboxVC *customVC=childViewControllers[0];
        if (customVC && [customVC respondsToSelector:@selector(getPendingCustom)]) {
            [customVC getPendingCustom];
        } // end custom inbox
    }
}

#pragma mark -
#pragma mark Custom Inbox

- (void) successfullyGotRichMessage:(XLRichJsonMessage *)inputMsg
{
    XRInboxDbInterface *xInboxInterface = [XRInboxDbInterface get];
    if ( xInboxInterface !=nil ) {
        [XLappMgr get].isInGettingMsgLoop=YES; 
        RichDbMessage *aDbMessage=[xInboxInterface addRichMessageToDb:inputMsg];
        // Display the message
        [XLappMgr get].isInGettingMsgLoop=NO;
        CompanyDetailsVC *detailsViewController=[[CompanyDetailsVC alloc] initWithNibName:@"CompanyDetailsVC" bundle:nil];
        [detailsViewController setDismissButtonDisplay:NO];
        
        // mark message as read
        [aDbMessage updateMessage:TRUE]; //message is updaged as read
        [detailsViewController setDetailsFromDbMessage:aDbMessage];
                
        [inboxNavController popToRootViewControllerAnimated:NO];
		[inboxNavController presentViewController:detailsViewController animated:YES completion:nil];
        [detailsViewController release];
        
    }
}
- (void) failedToGetRichMessage:(CiErrorType )errorType
{
    switch (errorType) {
        case ciNoError:
            NSLog(@"No Error=%d", errorType);
            break;
            /*      case ciMessageNotFoundError:
             NSLog(@"Message Not Found Error");
             break;
             */    case ciHttpServerError:
            NSLog(@"HTTP Server Error");
            break;
        case ciAppKeyNotSet:
            NSLog(@"App key not set");
            break;
        case ciXIDisNil:
            NSLog(@"XID is nil");
        default:
            NSLog(@"Unknown Error");
            break;
    }
}

#pragma mark -
#pragma mark Xtify Callback Delegate

//the navigation controller where the inbox view controller is being used
- (UINavigationController *) developerNavigationController:(XLappMgr *)appM
{
	return inboxNavController;
}

// set the index of the tabbar where the inbox is hooked to
- (void) moveToInbox:(XLappMgr *)appM
{
	tabBarController.selectedIndex =kInboxTabbarIndex ;
}

- (void)dealloc
{
    
	[super dealloc];
}

// Examples for Xtify events
// Handle inbox badge notification changes
- (void) doMyUpdate:(XLappMgr *)appM
{
	NSInteger newBadge=[appM getInboxUnreadMessageCount];
	NSLog(@"The new inbox badge unread message count is=%d",newBadge);
    
    // Set a private count of notifications
	NSInteger privateCounter=0 ;
	[appM setSpringBoardBadgeCount:newBadge+privateCounter];
	[appM setServerBadgeCount:newBadge];
}

- (void) doUpdateXid:(XLappMgr *)appM
{
	NSLog(@"Got XID=%@",[appM getXid]);
}

- (void) failedRegistration:(int)httpStatusCode
{
	NSLog(@"Failed to Registrat with httpStatusCode=%d",httpStatusCode);
}
- (void) completeRegistration:(XLappMgr *)appM
{
	NSLog(@"Complete Registration with httpStatusCode=%@",[appM getXid]);
// registration is complete and xid is available
}


-(void) locationUpdateCompleted:(CLLocation *)locationInformation
{
    CLLocationCoordinate2D lastLnownLocation = [[XLappMgr get] getLastLnownLocation];
    NSString* latString = [NSString stringWithFormat:@"%f", lastLnownLocation.latitude];
    NSString* lonString = [NSString stringWithFormat:@"%f", lastLnownLocation.longitude];
    NSString *locationString = [NSString stringWithFormat:@"%@%@%@%@" , @"Latitude:", latString, @",Longitude:" , lonString];
    
    NSLog(@"Location update completed. The cordinates are=%@",locationString);
}
- (void) handleSimplePush:(NSDictionary *) aPush withAlert:(BOOL) alertFlag
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSDictionary *aps=[aPush objectForKey:@"aps"];
    NSDictionary *alert=[aps objectForKey:@"alert"];
    NSString *body=[alert objectForKey:@"body"] ==[NSNull null] ? @"Alert" : [alert objectForKey:@"body"];
    // App was active when notification has arrived. Open a dialog with an OK and cancel button
    if (alertFlag)
    {
        UIAlertView *alertView =nil;
        NSString *action ;
        if (body !=nil && [body length]==0) {
            NSLog(@"Inbox Only. Don't show alert");
            return;
        }
        NSString *prodName = [[NSString alloc]initWithString:[info objectForKey:@"CFBundleDisplayName"]];
        if (body !=nil) {
            action=[alert objectForKey:@"action-loc-key"] ==[NSNull null]  ?@"Open" : [alert objectForKey:@"action-loc-key"];
            alertView = [[UIAlertView alloc] initWithTitle:prodName message:body
                                                  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:action, nil];
            
        }
        else {
            NSString *action_loc_key=[alert objectForKey:@"action-loc-key"] ==[NSNull null]  ?@"Open" : [alert objectForKey:@"action-loc-key"];
            action = [NSString stringWithFormat:NSLocalizedString(action_loc_key, @"")];
            
            NSString *loc_key=[alert objectForKey:@"loc-key"] ==[NSNull null] ? @"Use_a_default_message" : [alert objectForKey:@"loc-key"];
            NSString *loc_args=[alert objectForKey:@"loc-args"] ==[NSNull null] ? nil : [alert objectForKey:@"loc-args"];
            if (loc_args != nil) {
                NSString *variableOne = @"";
                NSString *variableTwo = @"";
                NSString *variableThree = @"";
                int i = 0;
                for (NSString *eachVariable in [[[aPush valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"loc-args"]) {
                    switch (i) {
                        case 0:
                            variableOne = eachVariable;
                            break;
                        case 1:
                            variableTwo = eachVariable;
                            break;
                        case 2:
                            variableThree = eachVariable;
                            
                        default:
                            break;
                    }
                    i++;
                }
                
            
                NSString *locText = [NSString stringWithFormat:NSLocalizedString(loc_key, @""),variableOne,variableTwo,variableThree];
                NSLog(@"loc_key=%@, action_loc_key=%@, action=%@",loc_key,action_loc_key,action);
                
                alertView = [[UIAlertView alloc] initWithTitle:prodName message:locText
                                                      delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:action, nil];
            }
        }
        
        [alertView show];
        [alertView	 release];
        [prodName release];
    }
    // Handle simple Push
    XLRichJsonMessage *inputSimple=[[XLRichJsonMessage alloc]init];
    [inputSimple setContent:@"(This Message has No Content)"];
    [inputSimple setSubject:body];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSLocale *en_US=[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease];
    [dateFormatter setLocale:en_US];
    NSString *isoDate = [dateFormatter stringFromDate:[NSDate date]];
    [inputSimple setDate:isoDate];
    [self successfullyGotRichMessage:inputSimple];
    // end handle simple push

}
#pragma mark -
#pragma mark - UIAlertViewDelegate
//User clicks the 'Open' after a push when the app is open.
// this is the application which puts the message
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Take some Action");
}

#pragma mark -
#pragma mark Using simulator

//Add or incorporate function to display for simulator support
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
	
	NSLog(@"Failed to register with error: %@", error);
	
	// for simulator, fake a token for debugging
#if TARGET_IPHONE_SIMULATOR == 1
	// register with xtify
  
	[[XLappMgr get] registerWithXtify:nil ];
    
	NSLog(@"Notification is disabled in simulator. Rich Inbox messages is enabled");
#endif
}

// for debugging in the background. write to log file
- (void) redirectConsoleLogToDocumentFolder
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *logPath = [documentsDirectory
						 stringByAppendingPathComponent:@"console.log"];
	freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}


@end
@implementation UINavigationBar (UINavigationBarCategory)
- (void)drawRect:(CGRect)rect
{
	//fill with solid color
	UIColor *color = //[UIColor blackColor];
	[[[UIColor alloc] initWithRed:(CGFloat)148/255 green:(CGFloat)115/255 blue:(CGFloat)244/255 alpha:(CGFloat).5f] autorelease];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
	CGContextFillRect(context, rect);
	
}
@end

