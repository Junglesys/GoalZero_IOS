//
//  DashboardViewController.h
//  GoalZero
//
//  Created by Seth Burch on 11/11/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GZDeviceService.h"


@interface DashboardViewController : UIViewController<GZDeviceServiceDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIView *deviceTableView;

// Top Navigation Bar
@property (weak, nonatomic) IBOutlet UINavigationItem *mainNavigationbar;
@property (weak, nonatomic) IBOutlet UILabel *currentDeviceTitle;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;

@property (weak, nonatomic) IBOutlet UILabel *voltageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *voltageLabelView;

@property (weak, nonatomic) IBOutlet UILabel *chargedPercentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargePercentageLabelView;

- (IBAction)panGesture:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIView *mainNavbar;

-(IBAction)showSearchingForDevicesView;

@end
