//
//  DeviceTableViewController.h
//  GoalZero
//
//  Created by Seth Burch on 12/2/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBChartView.h"
#import "JBBarChartView.h"
#import "JBLineChartView.h"

@interface DeviceTableViewController : UITableViewController<JBLineChartViewDelegate,JBLineChartViewDataSource>

@property(strong,nonatomic) NSString * deviceName;

// General
@property (assign, nonatomic) CGRect containerFrame;
@property (strong, nonatomic) Device* currentDevice;

// Current Stats
@property (weak, nonatomic) IBOutlet UIView *initialStatsView;
@property (weak, nonatomic) IBOutlet UILabel *voltageLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIView *firstPageView;


// Voltage History
@property (weak, nonatomic) IBOutlet UIView *voltageHistoryView;
@property (weak, nonatomic) IBOutlet UIView *voltageHistoryGraphView;



@end
