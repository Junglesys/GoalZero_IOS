//
//  BluetoothService.h
//  GoalZero
//
//  Created by Seth Burch on 10/3/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@protocol BluetoothServiceDelegate
@optional
- (void) didDiscoverDevice:(CBPeripheral *)peripheral;
- (void) didConnectToPeripheral:(CBPeripheral *)peripheral;
- (void) didReceiveDataForPeripheral:(NSString *)data
                      Peripheral:(CBPeripheral *)peripheral;
@end


@interface BluetoothService : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

// Used to initilize singleton
+ (void)init;

// Is currently looking for GZ BLE Devices
+ (bool)isScanningForDevices;

// Start looking for GZ BLE Devices
+ (void)startScanningForDevices;

// Stop looking for GZ BLE Devices
+ (void)stopScanningForDevices;

// Connect to peripheral
+ (void)connectToDevice:(CBPeripheral *)peripheral;

+ (void)addDelegate: (id<BluetoothServiceDelegate>)delegate;
+ (void)removeDelegate: (id<BluetoothServiceDelegate>)delegate;

@end
