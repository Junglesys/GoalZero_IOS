//
//  AddDeviceTableViewController.m
//  GoalZero
//
//  Created by Seth Burch on 11/20/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import "AddDeviceTableViewController.h"
#import "BluetoothService.h"
#import "AddDeviceTableViewCell.h"
#import "GZDeviceService.h"

@interface AddDeviceTableViewController ()

@end

static const int resultsViewIdx = 0;

@implementation AddDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devicePeripherals.count + 1;
}

-(double)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 171.0;
            break;
        default:
            return 63.0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Show Device info cell
    if(indexPath.row != resultsViewIdx)
    {
        static NSString* const CellIdentifier = @"AddDeviceTableViewCell";
        AddDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        int deviceIdx = (int)indexPath.row -1;
        CBPeripheral * peripheral = [self.devicePeripherals objectAtIndex:deviceIdx];
        cell.parent = self;
        cell.deviceNameLabel.text = peripheral.name;
        cell.deviceUuid = peripheral.identifier;
        cell.rowIdx = deviceIdx;
        return cell;
    }
    
    // Show total & BLE logo cell
    static NSString* const cellId = @"ResultsableViewCell";
    UITableViewCell* resultsCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (resultsCell == nil) {
        resultsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    UILabel* resultsLabel = (UILabel*)[resultsCell viewWithTag:1];
    resultsLabel.text = @"1 Result Found";
    
    if(self.devicePeripherals.count > 1){
        resultsLabel.text = [NSString stringWithFormat:@"%i Results Found", (int)self.devicePeripherals.count];
    }
    
    return resultsCell;
}

// Disable editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)addDeviceAndShowDashboard:(AddDeviceTableViewCell*)cell
{
    // Add device
    [GZDeviceService addNewDevice:cell.deviceUuid Name:cell.deviceNameLabel.text];
    
    // Connect to device
    [BluetoothService connectToDevice:[self.devicePeripherals objectAtIndex:cell.rowIdx]];
    
    // Show dashboard view
    [self performSegueWithIdentifier:@"showDashboardView" sender:self];
}


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

- (IBAction)doneBtnClicked:(id)sender
{
    
}
@end
