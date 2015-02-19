//
//  AddDeviceTableViewCell.m
//  GoalZero
//
//  Created by Seth Burch on 11/20/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import "AddDeviceTableViewCell.h"
#import "BluetoothService.h"


@implementation AddDeviceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addDeviceBtnClicked:(UIButton *)sender
{
    [self.parent addDeviceAndShowDashboard:self];
}
@end
