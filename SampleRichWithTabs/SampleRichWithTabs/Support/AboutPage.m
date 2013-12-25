//
//  AboutPage.m
//
//
//  Created by Xtify on 11/18/10.
//  Copyright 2010 Xtify. All rights reserved.
//

#import "AboutPage.h"
#import "XLappMgr.h"

@interface AboutPage()
{
}
- (void)actionUpdateLocation:(id)sender ;

@end
@implementation AboutPage

- (id)init {
    self = [super init];
	if (self != nil) {
		self.title = @"Test Page";
		UIImage* sImage = [UIImage imageNamed:@"home.png"];
		self.tabBarItem.image = sImage;
        
		UILabel *subjectLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,0, 200, 150)] autorelease];
		subjectLabel.font = [UIFont systemFontOfSize:16.0];
		subjectLabel.numberOfLines = 0;
		subjectLabel.textColor = [UIColor blueColor];
		subjectLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
		subjectLabel.backgroundColor = [UIColor clearColor];
		subjectLabel.text = @"AcmeLabs Test";
		[self.view addSubview:subjectLabel];
		UILabel *bodyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,12, 300, 200)] autorelease];
		bodyLabel.font = [UIFont systemFontOfSize:17];
		bodyLabel.numberOfLines = 0;
		bodyLabel.textColor = [UIColor  blackColor];
		bodyLabel.backgroundColor = [UIColor clearColor];
		bodyLabel.lineBreakMode =  NSLineBreakByWordWrapping;
		bodyLabel.text=@"Welcome to AcmeLabs. This is a sample app for the iPhone SDK";
		[self.view addSubview:bodyLabel];
        UILabel *versionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,52, 200, 220)] autorelease];
		versionLabel.font = [UIFont systemFontOfSize:17];
		versionLabel.numberOfLines = 0;
		versionLabel.textColor = [UIColor  blackColor];
		versionLabel.backgroundColor = [UIColor clearColor];
		versionLabel.lineBreakMode = NSLineBreakByWordWrapping;
		versionLabel.text=[NSString stringWithFormat:@"SDK Version: %@",[[XLappMgr get] getSdkVer]] ;
		[self.view addSubview:versionLabel];
        
        // Update Location
        float  y=200;
        UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
        UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
        float x=55, dy=40;
        CGRect frame = CGRectMake(x, y, 200, dy);
        UIButton *locationButton = [[[UIButton alloc] initWithFrame:frame]autorelease];
        locationButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [locationButton setTitle:@"Update Location" forState:UIControlStateNormal];
        [locationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        [locationButton setBackgroundImage:newImage forState:UIControlStateNormal];
        
        UIImage *newPressedImage = [buttonBackgroundPressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        [locationButton setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
        
        [locationButton addTarget:self action:@selector(actionUpdateLocation:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:locationButton];
        
        CGFloat wid = self.view.frame.size.width;
        CGFloat ht = self.view.frame.size.height - 90;
        CGRect footerFrame = CGRectMake(0, ht, wid, 40);
        
        UIView *wrapper = [[UIView alloc] initWithFrame:footerFrame];
        UILabel *label = [[UILabel alloc] initWithFrame:
                          CGRectMake(10, 5, footerFrame.size.width*0.5, footerFrame.size.height*0.5)];
        
        [wrapper addSubview:label];
        [wrapper setBackgroundColor:[UIColor lightGrayColor]];
        label.text = @"Powered by Xtify";
        label.backgroundColor = [UIColor lightGrayColor];
        label.font = [UIFont italicSystemFontOfSize:16.0f];
        [label setCenter:CGPointMake(wrapper.frame.size.width / 2, wrapper.frame.size.height / 2)];
        [self.view addSubview:wrapper];
        [label release];
        [wrapper release];
	}
	self.hidesBottomBarWhenPushed = YES;
	return self;
}

- (void)actionUpdateLocation:(id)sender
{
   // This will initiate the location update service and submit to Xtify, the callback method specific in your app delegate will be notified when completed
        [[XLappMgr get] updateLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}


@end
