//
//  DashboardViewController.m
//  GoalZero
//
//  Created by Seth Burch on 11/11/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import "DashboardViewController.h"
#import "SettingsTableViewController.h"
#import "SearchForDevicesViewController.h"
#import "DeviceTableViewController.h"
#import "SWRevealViewController.h"


#import "Device.h"
#import "DeviceSetting.h"
#import "DeviceData.h"

@interface DashboardViewController ()
@property(nonatomic,weak) SettingsTableViewController* settingsTVC;
@property(nonatomic,strong) DeviceTableViewController* currentDeviceViewController;
//@property(nonatomic,strong) DeviceTableViewController* searchForDevicesViewController;

@property(nonatomic,strong) NSTimer* imgBgTimer;
@property(nonatomic,strong) NSTimer* timeUpdateTimer;
@property (assign) bool showingData;
@property (assign) int bgImgIdx;
@end

@implementation DashboardViewController


static const int updateBackgroundSeconds = 8;
static const int updateCurrentTimeSeconds = 10;
static NSString * showDecviceDataTransistionKey = @"kCATransitionFade";
static const double backgroundTransistionDuration = 0.90;
static const double newDataTransistionDuration = 0.30;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup popover menu
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.menuPopoverBtn addTarget:self.revealViewController
                            action:@selector(revealToggle:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    // Listen for current device data updates
    [GZDeviceService addDelegate:self];
    [GZDeviceService connectToKnownDevices];
    
    self.showingData = false;
    // [self setCurrentStatsLabelsHidden:YES];
    
    //  [self clearTitlebarLabelValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateCurrentTime];
    
    // Start backgroundImg and currentTime timers
    self.imgBgTimer = [NSTimer scheduledTimerWithTimeInterval:(updateBackgroundSeconds) target:self selector:@selector(changeBackgroundImage) userInfo:nil repeats:YES];
    self.timeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:(updateCurrentTimeSeconds) target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
}

- (void)setCurrentStatsLabelsHidden:(BOOL)isHidden
{
    self.voltageTitleLabel.hidden = isHidden;
    self.voltageLabelView.hidden = isHidden;
    self.chargedPercentTitleLabel.hidden = isHidden;
    self.chargePercentageLabelView.hidden = isHidden;
}

- (void)clearTitlebarLabelValues
{
    self.currentDeviceTitle.text = @"";
    self.currentTime.text = @"";
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    // [GZDeviceService removeDelegate:self];
    
    // Stop/remove timers
    [self.imgBgTimer invalidate];
    self.imgBgTimer = nil;
    [self.timeUpdateTimer invalidate];
    self.timeUpdateTimer = nil;
}

-(void)updateCurrentTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mm aa"];
    NSString* date = [dateFormatter stringFromDate: [NSDate date]];
    
    // Animation
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = newDataTransistionDuration;
    
    // set labels and animation
    if([self.currentDeviceTitle.text isEqualToString:@""] || [self.currentDeviceTitle.text isEqualToString:date]){
        //[self.currentDeviceTitle.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
        self.currentDeviceTitle.text = date;
        self.currentTime.text = @"";
    }
    else{
        [self.currentTime.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
        self.currentTime.text = date;
    }
}

-(void)changeBackgroundImage
{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    animation.duration = backgroundTransistionDuration;
    
    switch (++self.bgImgIdx) {
        case 1:
            self.imgBackground.image = [UIImage imageNamed:@"Gz_Bg_4.png"];
            break;
        case 2:
            self.imgBackground.image = [UIImage imageNamed:@"Gz_Bg_1.png"];
            break;
        case 3:
            self.imgBackground.image = [UIImage imageNamed:@"Gz_Bg_2.png"];
            break;
        case 4:
            self.imgBackground.image = [UIImage imageNamed:@"Gz_Bg_3.png"];
            self.bgImgIdx = 0;
            break;
        default:
            self.bgImgIdx = 0;
            break;
    }
    [self.imgBackground.layer addAnimation:animation forKey:@"kCATransitionFade"];
}

- (void) didReceiveDeviceData:(Device *)device
                 ReceivedData:(DeviceData *)data
{
    // Set/Add device view controller (Main View)
    if(!self.currentDeviceViewController){
        self.currentDeviceViewController  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceTable"];
        self.currentDeviceViewController.containerFrame = self.deviceTableView.frame;
        self.currentDeviceViewController.currentDevice = device;
        [self.deviceTableView addSubview:self.currentDeviceViewController.view];
    }
    
    // Fade-In Transition device data
    CATransition *animation = nil;
    if(!self.showingData){
        // Animation
        animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        animation.duration = newDataTransistionDuration;
        // Make views visable
        self.voltageTitleLabel.hidden = false;
        self.voltageLabelView.hidden = false;
        self.chargedPercentTitleLabel.hidden = false;
        self.chargePercentageLabelView.hidden = false;
        // Add animations
        [self.voltageTitleLabel.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
        [self.chargedPercentTitleLabel.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
    }
    
    double tempAverage = (data.mcuTemp.doubleValue + data.boardTemp.doubleValue) / 2.0;
    
    // Set new label values
    // [self.mainNavigationbar setTitle:name];
    self.currentDeviceTitle.text = device.name;;
    self.currentDeviceViewController.voltageLabel.text = [NSString stringWithFormat:@"%.1fv",data.voltage.doubleValue];
    self.currentDeviceViewController.tempLabel.text = [NSString stringWithFormat:@"%.1f°F", tempAverage];
    self.currentDeviceViewController.chargeLevelLabel.text = [NSString stringWithFormat:@"%i%%", (int)data.batteryPercent.doubleValue];
    
    // Finish animation
    if(!self.showingData){
        [self.voltageLabelView.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
        [self.chargePercentageLabelView.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
        // Data
        [self.currentDeviceViewController.voltageLabel.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
        [self.currentDeviceViewController.chargeLevelLabel.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
        [self.currentDeviceViewController.tempLabel.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
        self.showingData = true;
    }
    
    // Update current time
    [self updateCurrentTime];
}

- (void)presentDeviceSettingsPopover
{
    
}

-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceTable"];
    
}

-(IBAction)showSearchingForDevicesView
{
    //if(self.searchForDevicesViewController == nil){
    DeviceTableViewController* searchForDevicesViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchForDevice"];
    //}
    
    //    float width = self.view.frame.size.width;
    //    float height = self.view.frame.size.height;
    //   // [self.searchForDevicesViewController.view setFrame:CGRectMake(0.0, 0.0, width, height)];
    //
    //    // then add it to the main view
    //    [self.view addSubview:self.searchForDevicesViewController.view];
    //
    //    // now animate moving the current view off to the left while the next view is moved into place
    //    [UIView animateWithDuration:0.33f
    //                          delay:0.0f
    //                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
    //                     animations:^{
    //                         [self.searchForDevicesViewController.view setFrame:self.view.frame];
    //                         [self.view setFrame:CGRectMake(width, 0.0, width, height)];
    //                     }
    //                     completion:^(BOOL finished){
    //                         // do whatever post processing you want (such as resetting what is "current" and what is "next")
    //                     }];
    
    UIView *theParentView = [self.view superview];
    //
    //    CATransition *animation = [CATransition animation];
    //    [animation setDuration:0.3];
    //    [animation setType:kCATransitionPush];
    //    [animation setSubtype:kCATransitionFromRight];
    //    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //
    [theParentView addSubview:searchForDevicesViewController.view];
    //    [self.view removeFromSuperview];
    //
    //    [[theParentView layer] addAnimation:animation forKey:@"showSecondViewController"];
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showSearchingForDevices"]){
        SearchForDevicesViewController * searchingView = [segue destinationViewController];
        
        //        // get the view that's currently showing
        //        UIView *currentView = self.view;
        //        // get the the underlying UIWindow, or the view containing the current view
        //        UIView *theWindow = [currentView superview];
        //
        //        UIView *newView = searchingView.view;
        //
        //        // remove the current view and replace with myView1
        //        //[currentView removeFromSuperview];
        //        //[theWindow addSubview:newView];
        //
        //        // set up an animation for the transition between the views
        //
        //        CATransition *animation = [CATransition animation];
        //        [animation setDuration:0.5];
        //        [animation setType:kCATransitionPush];
        //        [animation setSubtype:kCATransitionFromRight];
        //        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        //        [searchingView.view.layer addAnimation:animation forKey:@"SwitchToView2"];
        //
        //        [[theWindow layer] addAnimation:animation forKey:@"SwitchToView2"];
        
        //        float width = self.view.frame.size.width;
        //        float height = self.view.frame.size.height;
        //
        //        // my nextView hasn't been added to the main view yet, so set the frame to be off-screen
        //        [searchingView.view setFrame:CGRectMake(width, 0.0, width, height)];
        //
        //        // then add it to the main view
        //        [self.view addSubview:searchingView.view];
        //
        //        // now animate moving the current view off to the left while the next view is moved into place
        //        [UIView animateWithDuration:0.33f
        //                              delay:0.0f
        //                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
        //                         animations:^{
        //                             [searchingView.view setFrame:self.view.frame];
        //                             [self.view setFrame:CGRectMake(-width, 0.0, width, height)];
        //                         }
        //                         completion:^(BOOL finished){
        //                             // do whatever post processing you want (such as resetting what is "current" and what is "next")
        //                         }];
        
        
    }
    
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}

- (IBAction)panGesture:(UIPanGestureRecognizer *)sender
{
    
}
@end




//
//- (void) didReceiveDeviceData:(NSString*)name
//                      Voltage:(double)voltage
//                 AmperageDraw:(double)amperage
//                    BoardTemp:(double)boardTemp
//                      McuTemp:(double)mcuTemp
//            BatteryPercentage:(int)percentage
//{
//
//    return;
//
//
//    // Set/Add device view controller
//    if(!self.currentDeviceViewController){
//        self.currentDeviceViewController  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DeviceTable"];
//        [self.deviceTableView addSubview:self.currentDeviceViewController.view];
//    }
//
//    // Fade-In Transition device data
//    CATransition *animation = nil;
//    if(!self.showingData){
//        // Animation
//        animation = [CATransition animation];
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        animation.type = kCATransitionFade;
//        animation.duration = newDataTransistionDuration;
//        // Make views visable
//        self.voltageTitleLabel.hidden = false;
//        self.voltageLabelView.hidden = false;
//        self.chargedPercentTitleLabel.hidden = false;
//        self.chargePercentageLabelView.hidden = false;
//        // Add animations
//        [self.voltageTitleLabel.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
//        [self.chargedPercentTitleLabel.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
//    }
//
//    // Set new label values
//    // [self.mainNavigationbar setTitle:name];
//    self.currentDeviceTitle.text = name;
//    self.currentDeviceViewController.voltageLabel.text = [NSString stringWithFormat:@"%.1fv",voltage];
//    self.currentDeviceViewController.tempLabel.text = [NSString stringWithFormat:@"%.1f°F", boardTemp];
//    self.currentDeviceViewController.chargeLevelLabel.text = [NSString stringWithFormat:@"%.2d%%", percentage];
//
//    // Finish animation
//    if(!self.showingData){
//        [self.voltageLabelView.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
//        [self.chargePercentageLabelView.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
//        // Data
//        [self.currentDeviceViewController.voltageLabel.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
//        [self.currentDeviceViewController.chargeLevelLabel.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
//        [self.currentDeviceViewController.tempLabel.layer addAnimation:animation forKey:showDecviceDataTransistionKey];
//        self.showingData = true;
//    }
//
//    // Update current time
//    [self updateCurrentTime];
//}
