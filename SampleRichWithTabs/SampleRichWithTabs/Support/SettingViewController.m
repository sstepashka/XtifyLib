//
//  SettingViewController.m
//  XtifyRamp
//
//  Created by Gilad on 10/22/10.
//  Copyright 2010 Xtify. All rights reserved.
//

#import "SettingViewController.h"
#import "SampleTabsAppDelegate.h"
#import "TaggingPreferenceScreen.h"
#import "AboutSetting.h"
#import "XtifyGlobal.h"
#import "XLappMgr.h"
//#import "XLutils.h"

// for general screen
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0

#define kTextFieldHeight		30.0


#import "SampleTabsAppDelegate.h"
//#import "AboutSetting.h"
@implementation SettingViewController

@synthesize  isSettingChanged, settingTableView, taggingPrefController;


NSString *kAboutSection=@"Preferences";
NSString *kLocationSection=@"Location";
NSString *kBadgeSection=@"Badge Management";
NSArray *locationTableArray;
UILabel *locationSettingLabel = NULL;
UISwitch *locationSettingSwitch ;


- (id)init {
	
    self = [super init];
	if (self != nil) {
		self.title = @"Setting";
		UIImage* sImage = [UIImage imageNamed:@"setting.png"];
		self.tabBarItem.image = sImage;
		self.isSettingChanged = FALSE ;
		// set the long name shown in the navigation bar
		self.navigationItem.title=@"Setting";
		
		// create a custom navigation bar button and set it to always say "back"
		UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
		temporaryBarButtonItem.title=@"Back";
		self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
		[temporaryBarButtonItem release];
        
		
        
		listOfItems = [[NSMutableArray alloc] init];
		
		aboutTableArray = [NSArray arrayWithObjects:kAboutSection,nil];
		NSDictionary *aboutTableArrayDic = [NSDictionary dictionaryWithObject:aboutTableArray forKey:@"SettingTitle"];
        
        locationTableArray =[NSArray arrayWithObjects:@"Background Location",nil];
		NSDictionary *locationTableArrayDic = [NSDictionary dictionaryWithObject:locationTableArray forKey:@"SettingTitle"];

		
        badgeTableArray =[NSArray arrayWithObjects:@"Badge Setting",nil];
		NSDictionary *badgeTableArrayDic = [NSDictionary dictionaryWithObject:badgeTableArray forKey:@"SettingTitle"];

		[listOfItems addObject:aboutTableArrayDic];
        [listOfItems addObject:locationTableArrayDic];
		[listOfItems addObject:badgeTableArrayDic];

        badgeSettingLabel = NULL;
		badgeSettingSwitch=NULL;
        
	}
	return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return [listOfItems count]; }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	//Number of rows it should expect should be based on the section
	NSDictionary *dictionary = [listOfItems objectAtIndex:section];
	NSArray *array = [dictionary objectForKey:@"SettingTitle"];
	return [array count];
	
}

//Disply the arrow for the menu
- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	if(indexPath.section== 1){
		if(locationSettingLabel==NULL){
			locationSettingSwitch=[[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		}
		
		[locationSettingSwitch setOn:[[XLappMgr get] getBackgroundLocationRequiredFlag]];
		[locationSettingSwitch addTarget:self action:@selector(locationSettingAction:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview:locationSettingSwitch];
		cell.accessoryView = locationSettingSwitch;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
		if ([[XLappMgr get] isLocationSettingOff]) {
			[locationSettingSwitch setEnabled:NO];
		} 
		else {
			[locationSettingSwitch setEnabled:YES];
		}
        
		
	}

	if(indexPath.section== 2){
		if(badgeSettingLabel ==NULL){
            badgeSettingLabel= [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 100, 44)];
		}
		
        badgeSettingSwitch=[[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		[badgeSettingSwitch setOn:[[XLappMgr get] getBadgeMethod]];
        [badgeSettingSwitch addTarget:self action:@selector(badgeSettingAction:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview:badgeSettingSwitch];
		cell.accessoryView = badgeSettingSwitch;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
        [badgeSettingSwitch setEnabled:YES];
		
	}
	
	//get the dictionary object
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"SettingTitle"];
	NSString *cellValue = [array objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
	
	return cell;
}
- (void)locationSettingAction:(id)sender
{
	NSLog(@"location setting Action is now=%d", [sender isOn]);
	[[XLappMgr get] updateBackgroundLocationFlag:[sender isOn]];
    [self setLocationPreference:[sender isOn]];
}

- (void)badgeSettingAction:(id)sender
{
	NSLog(@"BADGE setting Action is now=%d", [sender isOn]);
	[[XLappMgr get] updateBadgeFlag:[sender isOn]];
}
- (void) setLocationPreference:(BOOL)value
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    [prefs setBool:value forKey:@"locBackground"];
}
// Adding the title for the Header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionHeader = nil;
	if(section == 1) {
		sectionHeader = kLocationSection;
	}
    if(section == 2) {
		sectionHeader = kBadgeSection;
	}
	
	
	return sectionHeader;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"SettingTitle"];
	NSString *selectedSetting = [array objectAtIndex:indexPath.row];
	
	NSLog(@"selectedSetting=%@",selectedSetting);
	
	if([selectedSetting isEqualToString:kAboutSection]){
		if (taggingPrefController == nil){
			taggingPrefController = [[[TaggingPreferenceScreen alloc] init ]retain];
		}
        SampleTabsAppDelegate *delegate = (SampleTabsAppDelegate *)[[UIApplication sharedApplication] delegate];
		UINavigationController *settNav=[delegate settingNavController];
		[settNav pushViewController:taggingPrefController animated:YES];

	}
	
}

- (void)settingsChanged
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary
                                 dictionaryWithObject:@"YES" forKey:@"locBackground"];
    
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    BOOL testvar = [defaults boolForKey:@"locBackground"];
    
    if (testvar) {
        [[XLappMgr get] updateBackgroundLocationFlag:YES];
        
    }
    else
    {
        [[XLappMgr get] updateBackgroundLocationFlag:NO];
    }
}

- (void)viewDidLoad
{		
	[super viewDidLoad];
   	
	settingTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0,0,  320, 370) style:UITableViewStyleGrouped] autorelease]; 
	settingTableView.dataSource = self;
	settingTableView.delegate = self;
	[self.view addSubview:settingTableView];
}


- (void)viewDidUnload
{
	[super viewDidUnload];
	// release all the other objects
	self.settingTableView = nil;
}

- (void)dealloc
{

	[super dealloc];
}

#pragma mark -
#pragma mark UIViewController delegate methods

// called after this controller's view was dismissed, covered or otherwise hidden
- (void)viewWillDisappear:(BOOL)animated
{
	isSettingChanged = TRUE;
	// restore the nav bar and status bar color to default
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
   [self settingsChanged];
    [self updateSettingsTable];
   //[settingTableView reloadData];
}

-(void)updateSettingsTable
{
    [settingTableView reloadData];

}
@end

