//
//  CompanyInboxVC.h
//  XtifyPad
//
//  Created by gilad on 10/20/12.
//
//

#import <UIKit/UIKit.h>
#import "XRInboxUiDbDelegate.h"

@interface CompanyInboxVC : UITableViewController <XRInboxUiDbDelegate>
{
 // landscape future   BOOL isShowingLandscapeView;

}
- (void) getPendingCustom ; // get the pending messages and update the badge upon return

@end
