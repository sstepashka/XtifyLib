//
//  AboutSetting.m
//  SampleRich
//
//  Created by xtify on 11/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AboutSetting.h"

@implementation AboutSetting

- (id)init {
    self = [super init];
	if (self != nil) {
		self.title = @"Test Page";
		UIImage* sImage = [UIImage imageNamed:@"setting.png"];
		self.tabBarItem.image = sImage;
		UILabel *subjectLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,0, 200, 100)] autorelease];
		subjectLabel.font = [UIFont systemFontOfSize:16.0];
		subjectLabel.numberOfLines = 0;
		subjectLabel.textColor = [UIColor blueColor];
		subjectLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(20.0)];
		subjectLabel.backgroundColor = [UIColor clearColor];
		//bodyLabel.textAlignment = UITextAlignmentLeft;   
		subjectLabel.text = @"About SampleRich";
		[self.view addSubview:subjectLabel];
		UILabel *bodyLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,12, 300, 175)] autorelease];
		bodyLabel.font = [UIFont systemFontOfSize:17];
		bodyLabel.numberOfLines = 0;
		bodyLabel.textColor = [UIColor  blackColor];
		bodyLabel.backgroundColor = [UIColor clearColor];
		//bodyLabel.textAlignment = UITextAlignmentLeft;   
		bodyLabel.lineBreakMode = NSLineBreakByWordWrapping;
		bodyLabel.text=@"This is an app to help users use the Xtify SDK and to use the TabBarController";
		[self.view addSubview:bodyLabel];
	}
	
	self.hidesBottomBarWhenPushed = YES;
	return self;
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
