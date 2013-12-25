//
//  CompanyInboxViewCell.h
//  XtifyPad
//
//  Created by Gilad on 9/19/12.
//  Copyright (c) 2012 Xtify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichDbMessage.h"

@interface CompanyInboxViewCell : UITableViewCell 
{

 }

@property (strong, nonatomic) IBOutlet UILabel *subject;

@property (strong, nonatomic) IBOutlet UILabel *content;

@property (strong, nonatomic) IBOutlet UILabel *msgDate;
//@property (retain, nonatomic) IBOutlet UIView *unreadIndicator;

// Copy the message content to the cell
- (BOOL)setCellFromDbMessage:(RichDbMessage*)message;

- (BOOL) hasExpired:(NSDate*)myDate;
@end
