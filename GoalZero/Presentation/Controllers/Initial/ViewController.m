//
//  ViewController.m
//  Goal Zero
//
//  Created by Seth Burch on 10/2/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import "ViewController.h"
#import "BluetoothService.h"

@interface ViewController ()
@property(nonatomic, weak) BluetoothService * bluetoohService;
@property(nonatomic, strong) NSMutableArray * bleDevices;
@property(nonatomic, strong) NSMutableArray * dataArray;
@property(nonatomic, strong) UIAlertView * connectToDeviceAlert;
@property(nonatomic, weak) NSDictionary * selectedDevice;
@end

@implementation ViewController
static NSString * searchingString = @"Searching for devices";

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self.textView setHidden:true];
    
}

-(NSMutableArray*)bleDevices{
    if(!_bleDevices){
        _bleDevices = [NSMutableArray array];
    }
    return _bleDevices;
}

-(NSMutableArray*)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



-(void)viewDidDisappear:(BOOL)animated
{
   // [self.bluetoohService removeObserveForDiscoveredDevices:self selector:@selector(newDiscoveredDevice:)];
   // [self.bluetoohService removeObserveForNewdDeviceData:self selector:@selector(newDeviceData:)];
}



-(void)newDiscoveredDevice: (NSNotification *)notification
{
    NSDictionary *data = notification.object;
    
    //[self.bleDevices setObject:data forKey:[data objectForKey:@"Name"]];
    
    [self.bleDevices addObject:data];
    [self.blePicker reloadAllComponents];
}


-(void)newDeviceData: (NSNotification *)notification
{
    NSString *data = notification.object;
    
    if([self.dataArray containsObject:data])
        return;
    
    if (self.dataArray) {
        
        NSString * sdata = [self.dataArray lastObject];
        
        if([sdata isEqualToString:data]){
            return;
        }
    }
    
    [self.dataArray addObject:data];
    
    //NSString * totalStr = [self.textView.text stringByAppendingString:data];
    

    
    [self.textView setText:data];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int devices = self.bleDevices.count;
    
    // Show searching if none are found
    return !devices ? 1 : devices;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(!self.bleDevices.count){
        return searchingString;
    }
    
    NSDictionary *data = [self.bleDevices objectAtIndex:row];
    
    return [data objectForKey:@"Name"];
}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(!self.bleDevices.count){
        return;
    }
    
    // Set selected device
    self.selectedDevice = [self.bleDevices objectAtIndex:row];
    
    NSString * message = [NSString stringWithFormat:@"Connect to %@?", [self.selectedDevice objectForKey:@"Name"]];
    
    self.connectToDeviceAlert = [[UIAlertView alloc]initWithTitle:@"Connect?" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    [self.connectToDeviceAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.connectToDeviceAlert)
    {
        switch (buttonIndex) {
            case 0:// No
                break;
            case 1:// Yes
            {
//                id peripheral = [self.selectedDevice objectForKey:@"Peripheral"];
//                [self.bluetoohService connectToPeripheral:peripheral];
//                [self.blePicker setHidden:true];
//                 [self.textView setHidden:false];
            }
                break;
            default:
                break;
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)bluetoohService: (BluetoothService*) bluetoohService { }

@end
