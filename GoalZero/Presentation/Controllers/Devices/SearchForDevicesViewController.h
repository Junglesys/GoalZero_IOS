//
//  SearchForDevicesViewController.h
//  GoalZero
//
//  Created by Seth Burch on 11/20/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BluetoothService.h"

@interface SearchForDevicesViewController : UIViewController<BluetoothServiceDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (IBAction)backBtnClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *mainDisplayView;
@end
