//
//  AddDeviceTableViewCell.h
//  GoalZero
//
//  Created by Seth Burch on 11/20/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddDeviceTableViewController.h"

@interface AddDeviceTableViewCell : UITableViewCell

@property (weak, nonatomic) AddDeviceTableViewController *parent;
@property (assign, nonatomic) NSInteger rowIdx;
@property (strong, nonatomic) NSUUID* deviceUuid;

@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;

- (IBAction)addDeviceBtnClicked:(UIButton *)sender;

@end
