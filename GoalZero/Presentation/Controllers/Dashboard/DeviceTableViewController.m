//
//  DeviceTableViewController.m
//  GoalZero
//
//  Created by Seth Burch on 12/2/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import "DeviceTableViewController.h"
#import "AppDelegate.h"
#import "Device.h"
#import "DeviceData.h"

@interface DeviceTableViewController ()
@property (strong, nonatomic) JBLineChartView *voltageLineChartView;
@property (strong, nonatomic) NSMutableArray *voltageData;
@end

@implementation DeviceTableViewController

- (NSMutableArray*)voltageData
{
    if(!_voltageData){
        _voltageData = [NSMutableArray array];
    }
    return _voltageData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initialStatsView.backgroundColor = [UIColor clearColor];
    
    // Get data
    [self.voltageData addObjectsFromArray:self.currentDevice.currentData.allObjects];
    
    
    
    // Set page size
    //int pageHeight = self.view.window.frame.size.height - 72;
    
//    CGRect firstPageFrame = CGRectMake(0,
//                                       0,
//                                       self.containerFrame.size.width,
//                                       self.containerFrame.size.height);
    
//    CGRect firstPageFrame = CGRectMake(self.initialStatsView.frame.origin.x,
//                                       self.initialStatsView.frame.origin.y,
//                                       self.view.window.frame.size.width,
//                                       self.view.window.frame.size.height);
    
     //[self.firstPageView setFrame:firstPageFrame];
    //[self.firstPageView setFrame:self.containerFrame];
    
    // Make edges round
    [Common makeEdgesRound:self.initialStatsView];
    [Common makeEdgesRound:self.voltageHistoryView];
    [Common makeEdgesRound:self.voltageHistoryGraphView];
    [Common makeEdgesFaded:self.initialStatsView];
    [Common makeEdgesFaded:self.voltageHistoryView];
    
    // Voltage line chart
    self.voltageLineChartView = [[JBLineChartView alloc] init];
    self.voltageLineChartView.dataSource = self;
    self.voltageLineChartView.delegate = self;
    
    self.voltageLineChartView.frame = CGRectMake(30, 0, self.voltageHistoryGraphView.frame.size.width-20, self.voltageHistoryGraphView.frame.size.height-20);
    
    //self.voltageLineChartView.backgroundColor = [UIColor blackColor];
    
    
    [self.voltageHistoryGraphView addSubview:self.voltageLineChartView];
    
    double maxVolts = 0.0;
    double minVolts = 0.0;
    
    for(DeviceData* const vals in self.voltageData){
        double val = vals.voltage.doubleValue;
        if(!maxVolts && !minVolts){
            maxVolts = val;
            minVolts = val;
        }
        if(val > maxVolts)
            maxVolts = val;
        if(val < minVolts && val > 0)
            minVolts = val;
    }
    
    NSMutableArray * averagedValues = [NSMutableArray array];
    
    //    for(DeviceData* const vals in self.voltageData){
    //    }
    int span = 30;
    int count = self.voltageData.count;
    
    for (int i = 0; i < count; ++i)
    {
        int parts = 0;
        double sum = 0.0;
        
        for (int j = 0; j < span; ++j) {
            int idx = i + j;
            if(idx >= count)
                continue;
            
            DeviceData * data = [self.voltageData objectAtIndex:idx];
            sum += data.voltage.doubleValue;
            ++parts;
        }
        
        double avg = sum / parts;
        // Smoothout
        if(i > 0){
            DeviceData * softData = [self.voltageData objectAtIndex:i-1];
            double softAvg = (avg + softData.voltage.doubleValue) / 2.0;
            [averagedValues addObject:[NSNumber numberWithDouble:softAvg]];
        }
        if(i > 1){
            DeviceData * softData = [self.voltageData objectAtIndex:i-2];
            double softAvg = (avg + softData.voltage.doubleValue) / 2.0;
            [averagedValues addObject:[NSNumber numberWithDouble:softAvg]];
        }
        [averagedValues addObject:[NSNumber numberWithDouble:avg]];
    }
    
    [self.voltageData removeAllObjects];
    [self.voltageData addObjectsFromArray:averagedValues];
    
    
    
    self.voltageLineChartView.maximumValue = maxVolts;
    self.voltageLineChartView.minimumValue = minVolts;
    
    // 427
    
    //if(self.view.frame.size.height)
    
    // Add percent value labels
    float valueLabels = 10;
    float totalHeight = 10;
    float rowHeight = (self.voltageHistoryGraphView.frame.size.height/valueLabels) - 3.8;
    
    float divisions = (maxVolts - minVolts) / valueLabels;
    
    float value = maxVolts;
    
    for (int i = valueLabels; i >= 0; --i)
    {
        
        if(i != 0){
            value -= divisions;
        }
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 50, 21)];
        //label.center = CGPointMake(160, 284);
        label.center = CGPointMake(20, totalHeight);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [NSString stringWithFormat:@"%.1fv ", value];
        [self.voltageHistoryGraphView addSubview:label];
        
        totalHeight += rowHeight;
    }
    
    
    [self.voltageLineChartView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double height = self.containerFrame.size.height+ 135;//self.view.frame.size.height - 72;// - 20;
    return height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate* del = [UIApplication sharedApplication].delegate;
    double height = self.containerFrame.size.height;//self.view.frame.size.height;// - 20;
    double width = self.containerFrame.size.width;//self.view.frame.size.width;// - 20;
    double yOffset = (cell.window.frame.size.height - height) + 135;
    
    [cell.contentView setFrame:CGRectMake(0, yOffset, width, height)];
    [cell setFrame:CGRectMake(0, yOffset, width, height)];
    
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString* cellId;
//    switch (indexPath.row) {
//        case 0:
//            cellId = @"CurrentStatsCell";
//            break;
//        case 1:
//            cellId = @"VoltageHistoryCell";
//            break;
//    }
//
//    UITableViewCell* resultsCell = [tableView dequeueReusableCellWithIdentifier:cellId];
//
//
//
//    return resultsCell;
//}




- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return .1;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor lightGrayColor];
}


- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}

static int somenumX = 0;
static int somenumY = 0;

static int AMOUNT = 72;

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    if(self.voltageData.count <= 0)
        return 0;
    return AMOUNT;//return self.voltageData.count;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    //DeviceData* data = [self.voltageData objectAtIndex:horizontalIndex];
    //return data.voltage.doubleValue;
    long idx = self.voltageData.count - horizontalIndex - 1;
    if(idx < 0)
        return 0;
    
    NSNumber* val = [self.voltageData objectAtIndex: idx];
    return val.doubleValue;
}

//- (BOOL)lineChartView:(JBLineChartView *)lineChartView shouldHideDotViewOnSelectionAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex;
//{
//    return false;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
