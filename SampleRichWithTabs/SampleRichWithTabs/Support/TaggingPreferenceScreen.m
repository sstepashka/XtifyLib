//
//  TaggingPreferenceScreen.m
//
//  Created by Sucharita on 1/31/12.
//  Copyright 2010 Xtify. All rights reserved.
//

#import "TaggingPreferenceScreen.h"
#import "XtifyGlobal.h"
#import "XLappMgr.h"
#import "XLTagMgr.h"

// for general screen
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0

#define kTextFieldHeight		30.0

#define kKey1 @"zipcode=10016"
#define kKey2 @"age:19"

@implementation TaggingPreferenceScreen

@synthesize  settingTableView, tags;
@synthesize isFdOn, isAOn, isEOn, isMOn, isElOn;



NSString *kfooddrinkSection1=@"zipcode=10016";
NSArray *fooddrinkTableArray;
UILabel *fooddrinkSettingLabel1 = NULL;
UISwitch *fooddrinkSettingSwitch ;


NSString *kapparelSection1=@"age:19";
NSArray *apparelTableArray;
UISwitch *apparelSettingSwitch ;
UILabel *apparelSettingLabel1 = NULL;

NSString *kentertainmentSection1=@"Entertainment & Leisure";
NSArray *entertainmentTableArray;
UISwitch *entertainmentSettingSwitch ;
UILabel *entertainmentSettingLabel1 = NULL;

NSString *kmediaSection1=@"Media";
NSArray *mediaTableArray;
UISwitch *mediaSettingSwitch ;
UILabel *mediaSettingLabel1 = NULL;

NSString *kelecSection1=@"Electronics";
NSArray *elecTableArray;
UISwitch *elecSettingSwitch ;
UILabel *elecSettingLabel1 = NULL;

static TaggingPreferenceScreen* mTaggingPreferenceScreen = nil;

+(TaggingPreferenceScreen*)get
{
	if (nil == mTaggingPreferenceScreen)
	{
		mTaggingPreferenceScreen = [[TaggingPreferenceScreen alloc] init];
	}
	return mTaggingPreferenceScreen;
}

- (id)init {
    self = [super init];
	if (self != nil) {
		self.title = @"Preferences";
		UIImage* sImage = [UIImage imageNamed:@"setting.png"];
		self.tabBarItem.image = sImage;
		// set the long name shown in the navigation bar
		self.navigationItem.title=@"Preference";
		
		// create a custom navigation bar button and set it to always say "back"
        
        
		UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
		self.navigationItem.backBarButtonItem.title = @"Save";
		self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
		[temporaryBarButtonItem release];
        
		listOfItems = [[NSMutableArray alloc] init];
 //       tags = [[XLTagMgr get] getRecentTags];
        
        fooddrinkTableArray =[NSArray arrayWithObjects:kfooddrinkSection1,nil];
		NSDictionary *fooddrinkTableArrayDic = [NSDictionary dictionaryWithObject:fooddrinkTableArray forKey:@"SettingTitle"];
        
		
        apparelTableArray =[NSArray arrayWithObjects:kapparelSection1,nil];
		NSDictionary *apparelTableArrayDic = [NSDictionary dictionaryWithObject:apparelTableArray forKey:@"SettingTitle"];
        
        entertainmentTableArray =[NSArray arrayWithObjects:@"Entertainment & Leisure",nil];
		NSDictionary *entertainmentTableArrayDic = [NSDictionary dictionaryWithObject:entertainmentTableArray forKey:@"SettingTitle"];
        
		mediaTableArray =[NSArray arrayWithObjects:@"Media",nil];
		NSDictionary *mediatTableArrayDic = [NSDictionary dictionaryWithObject:mediaTableArray forKey:@"SettingTitle"];
        
        elecTableArray =[NSArray arrayWithObjects:@"Electronics",nil];
		NSDictionary *elecTableArrayDic = [NSDictionary dictionaryWithObject:elecTableArray forKey:@"SettingTitle"];
        
        
        [listOfItems addObject:fooddrinkTableArrayDic];
        [listOfItems addObject:apparelTableArrayDic];
        [listOfItems addObject:entertainmentTableArrayDic];
        [listOfItems addObject:mediatTableArrayDic];
        [listOfItems addObject:elecTableArrayDic];
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	}
	
    
    if(indexPath.section== 0){
		fooddrinkSettingSwitch=[[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		
		
		[fooddrinkSettingSwitch addTarget:self action:@selector(fdpreferenceSettingAction:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview:fooddrinkSettingSwitch];
        if([[tags valueForKey:kKey1] isEqualToString:@"true"])
        {
            isFdOn = true;
            
            [fooddrinkSettingSwitch setOn:true];
        }
        
		cell.accessoryView = fooddrinkSettingSwitch;
	}
    
	if(indexPath.section== 1){
		if(apparelSettingLabel1 ==NULL){
            apparelSettingLabel1= [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 100, 44)];
		}
		
        apparelSettingSwitch=[[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		[apparelSettingSwitch addTarget:self action:@selector(apreferenceSettingAction:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview:apparelSettingSwitch];
        if ([[tags valueForKey:kKey2] isEqualToString:@"true"])
        {
            isAOn  = true;
            [apparelSettingSwitch setOn:true];
        }
		cell.accessoryView = apparelSettingSwitch;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
        [apparelSettingSwitch setEnabled:YES];
        
		
	}
    
    if(indexPath.section== 2){
		if(entertainmentSettingLabel1 ==NULL){
            entertainmentSettingLabel1= [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 100, 44)];
		}
		
        entertainmentSettingSwitch=[[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		[entertainmentSettingSwitch addTarget:self action:@selector(epreferenceSettingAction:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview:entertainmentSettingSwitch];
        if([[tags valueForKey:@"e"] isEqualToString:@"true"])
        {
            isEOn = true;
            [entertainmentSettingSwitch setOn:true];
        }
		cell.accessoryView = entertainmentSettingSwitch;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
        [entertainmentSettingSwitch setEnabled:YES];		
	}
    
    if(indexPath.section== 3){
		if(mediaSettingLabel1 ==NULL){
            mediaSettingLabel1= [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 100, 44)];
		}
		
        mediaSettingSwitch=[[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		[mediaSettingSwitch addTarget:self action:@selector(mpreferenceSettingAction:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview:mediaSettingSwitch];
        if([[tags valueForKey:@"m"] isEqualToString:@"true"])
        {
            isMOn = true;
            [mediaSettingSwitch setOn:true];
        }
		cell.accessoryView = mediaSettingSwitch;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
        [mediaSettingSwitch setEnabled:YES];
		
	}
    
    if(indexPath.section== 4){
		if(elecSettingLabel1 ==NULL){
            elecSettingLabel1= [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 100, 44)];
		}
		
        elecSettingSwitch=[[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
		[elecSettingSwitch addTarget:self action:@selector(elpreferenceSettingAction:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview:elecSettingSwitch];
        if([[tags valueForKey:@"el"] isEqualToString:@"true"])
        {
            isElOn = true;
            [elecSettingSwitch setOn:true];
        }
		cell.accessoryView = elecSettingSwitch;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;	
        [elecSettingSwitch setEnabled:YES];
		
	}
    
	//get the dictionary object
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"SettingTitle"];
	NSString *cellValue = [array objectAtIndex:indexPath.row];
	cell.textLabel.text = cellValue;
	
	return cell;
}
- (void)fdpreferenceSettingAction:(id)sender
{
    [self notifyTagsChanged];
    NSString *curtag = kKey1;
    [[XLTagMgr get] deleteTagRow:curtag];
    if([sender isOn])
        [[XLTagMgr get]insertTag:curtag withFlag:@"true"];
    else
        [[XLTagMgr get]insertTag:curtag withFlag:@"false"];
    NSLog(@"Something is now=%d", isFdOn);
}
- (void)apreferenceSettingAction:(id)sender
{
    [self notifyTagsChanged];
    NSString *curtag = kKey2;
    [[XLTagMgr get] deleteTagRow:curtag];
    if([sender isOn])
        [[XLTagMgr get]insertTag:curtag withFlag:@"true"];
    else
        [[XLTagMgr get]insertTag:curtag withFlag:@"false"];
	NSLog(@"apparel setting Action is now=%d", isAOn);
    
}
- (void)epreferenceSettingAction:(id)sender
{
    [self notifyTagsChanged];
    NSString *curtag = @"e";
    [[XLTagMgr get] deleteTagRow:curtag];
    if([sender isOn])
        [[XLTagMgr get]insertTag:curtag withFlag:@"true"];
    else
        [[XLTagMgr get]insertTag:curtag withFlag:@"false"];
	NSLog(@"entertainment setting Action is now=%d", isEOn);
    
}
- (void)mpreferenceSettingAction:(id)sender
{
    [self notifyTagsChanged];
    NSString *curtag = @"m";
    [[XLTagMgr get] deleteTagRow:curtag];
    if([sender isOn])
        [[XLTagMgr get]insertTag:curtag withFlag:@"true"];
    else
        [[XLTagMgr get]insertTag:curtag withFlag:@"false"];
	NSLog(@"media setting Action is now=%d", isMOn);
    
}
- (void)elpreferenceSettingAction:(id)sender
{
    [self notifyTagsChanged];
    NSString *curtag = @"el";
    [[XLTagMgr get] deleteTagRow:curtag];
    if([sender isOn])
        [[XLTagMgr get]insertTag:curtag withFlag:@"true"];
    else
        [[XLTagMgr get]insertTag:curtag withFlag:@"false"];
	NSLog(@"elec setting Action is now=%d", isElOn);
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	
	NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
	NSArray *array = [dictionary objectForKey:@"SettingTitle"];
	NSString *selectedSetting = [array objectAtIndex:indexPath.row];
	
	NSLog(@"selectedSetting=%@",selectedSetting);
	
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
    NSLog(@"View unload");
}

- (void)dealloc
{
    [listOfItems release];
    
	[super dealloc];
}

#pragma mark -
#pragma mark UIViewController delegate methods

// called after this controller's view was dismissed, covered or otherwise hidden
- (void)viewWillDisappear:(BOOL)animated
{
	// restore the nav bar and status bar color to default
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[XLTagMgr get] sendTagsToServerBulk];

    // test get active tags
    [[XLappMgr get] setInboxDelegate:self];
    [[XLappMgr get] setDeveloperActiveTagsSelector:@selector(myMethodToHandleGetActiveTags:)];
    [[XLappMgr get] getActiveTags];
    
}

-(void) notifyTagsChanged
{
    [[XLTagMgr get] notifyTagsChanged:TRUE];
}
- (void)viewWillAppear:(BOOL)animated
{
    tags = [[XLTagMgr get] getRecentTags];
 
  //  NSLog(@"Value for key1 is %@", [tags valueForKey:kKey1]);
  
    [self updateSettingsTable];
}

-(void)updateSettingsTable
{
    [settingTableView reloadData];
    
}

- (void) myMethodToHandleGetActiveTags :(NSMutableArray * )anArray
{
    NSLog(@"The array length is=%d",[anArray count]);
}

@end

