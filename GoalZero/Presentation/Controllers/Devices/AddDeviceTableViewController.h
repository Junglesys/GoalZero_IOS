//
//  AddDeviceTableViewController.h
//  GoalZero
//
//  Created by Seth Burch on 11/20/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddDeviceTableViewCell;

@interface AddDeviceTableViewController : UITableViewController

@property(nonatomic,strong) NSArray * devicePeripherals;

- (IBAction)doneBtnClicked:(id)sender;
-(void)addDeviceAndShowDashboard:(AddDeviceTableViewCell*)cell;

@end
