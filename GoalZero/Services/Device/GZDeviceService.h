//
//  GZDeviceService.h
//  GoalZero
//
//  Created by Seth Burch on 12/9/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BluetoothService.h"
#import "Device.h"
#import "DeviceSetting.h"
#import "DeviceData.h"


@protocol GZDeviceServiceDelegate
@optional
- (void) didReceiveDeviceData:(Device *)device
                     ReceivedData:(DeviceData *)data;
@end


@interface GZDeviceService : NSObject<BluetoothServiceDelegate>

// Used to initilize singleton
+ (void)init;

+ (void)connectToKnownDevices;

+ (bool)isKnownDevice:(NSUUID*)deviceUuid;
+ (Device*)getDeviceByUuid:(NSUUID*)uuid;
+ (void)addNewDevice:(NSUUID*)uuid Name:(NSString*)name;

+ (void)addDelegate: (id<GZDeviceServiceDelegate>)delegate;
+ (void)removeDelegate: (id<GZDeviceServiceDelegate>)delegate;

@end
