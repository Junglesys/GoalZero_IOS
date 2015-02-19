//
//  AddDeviceViewController.m
//  GoalZero
//
//  Created by Seth Burch on 11/11/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import "AddDeviceViewController.h"


@interface AddDeviceViewController()
@end

@implementation AddDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [BluetoothService addDelegate:self];
    [BluetoothService startScanningForDevices];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [BluetoothService stopScanningForDevices];
    [BluetoothService removeDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) didDiscoverDevice:(CBPeripheral *) peripheral
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
