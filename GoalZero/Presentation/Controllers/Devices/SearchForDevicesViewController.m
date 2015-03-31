//
//  SearchForDevicesViewController.m
//  GoalZero
//
//  Created by Seth Burch on 11/20/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import "SearchForDevicesViewController.h"
#import "AddDeviceTableViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

static const int SearchTimeSeconds = 2;
static NSString * const AddDeviceTableViewId = @"showFoundDevices";
static NSString * const FadeTransitionKey = @"kCATransitionFade";


@interface SearchForDevicesViewController ()
@property(nonatomic, strong) NSMutableArray* devicePeripherals;
@property(nonatomic, strong) UIStoryboard* currenStoryboard;
@property(nonatomic, strong) UIViewController* searchingViewController;
@property(nonatomic, strong) UIViewController* noDevicesFoundViewController;
@property(nonatomic,strong) AddDeviceTableViewController* deviceTable;
@end


@implementation SearchForDevicesViewController


#pragma mark - Base Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.activityIndicatorView.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    // UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.activityIndicatorView.frame];
    //[activityIndicator setOpaque:NO];
    //[activityIndicator setTintColor:[UIColor whiteColor]];
    // activityIndicator.transform = CGAffineTransformMakeScale(1.75, 1.75);
    
    // activityIndicator.color =[UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:1.0];
    // activityIndicator.color = [UIColor greenColor];
    // [activityIndicator startAnimating];
    
    // [self.view addSubview:activityIndicator];
    
    //self.devicePeripherals = [NSMutableArray array];
    //    self.searchingViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchingForNewDevices"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [BluetoothService addDelegate:self];
    [BluetoothService startScanningForDevices];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //    });
    
    
    
    
    //    // Display resultes
    //    [NSTimer scheduledTimerWithTimeInterval:(SearchTimeSeconds)
    //                                     target:self
    //                                   selector:@selector(showFoundDevices)
    //                                   userInfo:nil
    //                                    repeats:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SearchTimeSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Display resultes
        [NSTimer scheduledTimerWithTimeInterval:(SearchTimeSeconds)
                                         target:self
                                       selector:@selector(showFoundDevices)
                                       userInfo:nil
                                        repeats:NO];
    });
    
    [self showSearchingForDevicesView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.devicePeripherals = nil;
    self.searchingViewController = nil;
    [BluetoothService stopScanningForDevices];
    [BluetoothService  removeDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Propety Lazy Loading

- (NSMutableArray*)devicePeripherals
{
    if(!_devicePeripherals){
        _devicePeripherals = [NSMutableArray array];
    }
    return _devicePeripherals;
}

-(UIStoryboard*)currenStoryboard
{
    if(!_currenStoryboard){
        _currenStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    return _currenStoryboard;
}

- (AddDeviceTableViewController*)deviceTable
{
    if(!_deviceTable){
        _deviceTable = [self.currenStoryboard instantiateViewControllerWithIdentifier:@"AddNewDevice"];
    }
    return _deviceTable;
}

- (UIViewController*)searchingViewController
{
    if(!_searchingViewController){
        _searchingViewController = [self.currenStoryboard instantiateViewControllerWithIdentifier:@"SearchingForNewDevices"];
    }
    return _searchingViewController;
}

- (UIViewController*)noDevicesFoundViewController
{
    if(!_noDevicesFoundViewController){
        _noDevicesFoundViewController = [self.currenStoryboard instantiateViewControllerWithIdentifier:@"NoDevicesFound"];
    }
    return _noDevicesFoundViewController;
}

- (CATransition*)easeInEaseOutAnimation
{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = 0.3;
    return animation;
}


#pragma mark - View Methods

-(void)showSearchingForDevicesView
{
    CATransition* animation = [self easeInEaseOutAnimation];
    [self.mainDisplayView.layer addAnimation:animation forKey:FadeTransitionKey];
    [self.mainDisplayView addSubview:self.searchingViewController.view];
}

-(void)showNoDevicesFoundView
{
    CATransition *animation = [self easeInEaseOutAnimation];
    [self.mainDisplayView.layer addAnimation:animation forKey:FadeTransitionKey];
    [self.mainDisplayView addSubview:self.noDevicesFoundViewController.view];
}

-(void)showFoundDevices
{
    if(!self.devicePeripherals.count){
        [self showNoDevicesFoundView];
        return;
    }
    
    //[self performSegueWithIdentifier:AddDeviceTableViewId sender:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Set next controllers' devicePeripherals
        self.deviceTable.devicePeripherals = self.devicePeripherals;
        
        // Add animations
        CATransition *animation = [self easeInEaseOutAnimation];
        [self.mainDisplayView.layer addAnimation:animation forKey:FadeTransitionKey];
        [self.mainDisplayView addSubview:self.deviceTable.view];
    });
}


#pragma mark - BluetoothServiceDelegate Methods

- (void) didDiscoverDevice:(CBPeripheral *) peripheral
{
    [self.devicePeripherals addObject:peripheral];
}


#pragma mark - Storyboard Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:AddDeviceTableViewId]){
        AddDeviceTableViewController * addDeviceTableViewController =[segue destinationViewController];
        addDeviceTableViewController.devicePeripherals = self.devicePeripherals;
    }
    
}

- (IBAction)backBtnClicked:(id)sender
{
  //  AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    //[delegate transistionToDashboardViewFromView:self.view];
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
