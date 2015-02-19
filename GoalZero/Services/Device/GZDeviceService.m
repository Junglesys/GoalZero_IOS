//
//  GZDeviceService.m
//  GoalZero
//
//  Created by Seth Burch on 12/9/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import "GZDeviceService.h"


@interface GZDeviceDetails : NSObject
@property(strong, nonatomic) Device* device;
@property(strong, nonatomic) NSMutableString* rawData;
-(bool)setDeviceByUuid: (NSUUID*)uuid;
@end

@implementation GZDeviceDetails
-(bool)setDeviceByUuid: (NSUUID*)uuid
{
    self.device = [GZDeviceService getDeviceByUuid:uuid];
    return self.device != nil;
}
@end


/* GZDeviceService */

@interface GZDeviceService ()
@property(strong,nonatomic) NSMutableArray* delegates;
@property(strong,nonatomic) NSMutableDictionary* deviceRawTextData; // (UUID / GZDeviceDetails)
@end


@implementation GZDeviceService

+ (void)addDelegate: (id<GZDeviceServiceDelegate>)delegate
{
    if(![[self instance].delegates containsObject:delegate]){
        [[self instance].delegates addObject:delegate];
    }
}

+ (void)removeDelegate: (id<GZDeviceServiceDelegate>)delegate
{
    if([[self instance].delegates containsObject:delegate]){
        [[self instance].delegates removeObject:delegate];
    }
}

+ (void)connectToKnownDevices
{
    [BluetoothService addDelegate:[self instance]];
    [BluetoothService startScanningForDevices];
}

+ (bool)isKnownDevice:(NSUUID*)deviceUuid
{
    return [self getDeviceByUuid:deviceUuid] != nil;
}

+ (Device*)getDeviceByUuid:(CBUUID*)uuid
{
    NSString* filter = @"%K MATCHES %@";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, @"uuid", [uuid UUIDString]];
    return [Common getObjectFromDatabase:@"Device" Filter:predicate];
}

+ (void)addNewDevice:(NSUUID*)uuid Name:(NSString*)name
{
    if(![self isKnownDevice:uuid]){
        NSDate * createdDataUtc = [Common dateFromLocalToUtcTime:[NSDate date]];
        
        // Add new device
        Device* device = [Common addNewCoreDataObject:@"Device"];
        device.name = name;
        device.uuid = [uuid UUIDString];
        device.displayOrder = [NSNumber numberWithInt:0];
        device.createdOnUtc = createdDataUtc;
        device.lastConnectedOnUtc = createdDataUtc;
        
        // Add device settings
        DeviceSetting* settings = [Common addNewCoreDataObject:@"DeviceSetting"];
        settings.device = device;
        settings.lastChangedOnUtc = createdDataUtc;
        settings.showBatteryPercentage = [NSNumber numberWithBool:YES];
        settings.showVoltage = [NSNumber numberWithBool:YES];
        settings.showTemp = [NSNumber numberWithBool:YES];
        
        // Save device
        [Common saveAllChanges];
    }
}

#pragma mark - BluetoothServiceDelegate Methods

- (void) didDiscoverDevice:(CBPeripheral *)peripheral
{
    // Only catch non-connected known devices
    if(![GZDeviceService isKnownDevice:peripheral.identifier] ||
       [self.deviceRawTextData objectForKey:@""] != nil){
        return;
    }
    
    // Connect to known device
    [BluetoothService connectToDevice:peripheral];
}

- (void) didReceiveDataForPeripheral:(NSString *)data
                          Peripheral:(CBPeripheral *)peripheral
{
    Device * device = [GZDeviceService getDeviceByUuid:peripheral.identifier];
    
    // Make sure it's a known device
    if(!device)
        return;
    
    // Add NSMutableString for 'Raw' device data
    if(![self.deviceRawTextData objectForKey:peripheral.identifier]){
        [self.deviceRawTextData setObject:[NSMutableString new] forKey:peripheral.identifier];
    }
    
    // Append new data
    NSMutableString* receivedData = [self.deviceRawTextData objectForKey:peripheral.identifier];
    [receivedData appendString:data];
    
    
    //
    // Data Example: YETI150 z 1404  1267v 0000i 0557tb 0567ti 0000p 0000a pre1 chg100 dsg1
    NSError  *error = nil;
    NSString *pattern = @".*([0-9]{4}).+([0-9]{4})v.+([0-9]{4})i.+([0-9]{4})tb.+([0-9]{4})ti.+chg([0-9]{1,3}).*dsg.*";
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    
    NSString* dataStr = receivedData;
    NSArray* matches = [regex matchesInString:dataStr options:0 range: NSMakeRange(0, [dataStr length])];
    
    if(matches.count >= 1)
    {
        DeviceData* data = [Common addNewCoreDataObject:@"DeviceData"];
        if(!data)
        {
            if(DebugMode)
                NSLog(@"Unable to create DeviceData object");
            return;
        }
        
        if(DebugMode){
            NSLog(@"Received data: %@", dataStr);
        }
        
        NSTextCheckingResult* match = [matches objectAtIndex:0];
        
        int dataIdx = [[dataStr substringWithRange:[match rangeAtIndex:1]] intValue];
        double voltage = [[dataStr substringWithRange:[match rangeAtIndex:2]] doubleValue] / 100;
        double ampDraw = [[dataStr substringWithRange:[match rangeAtIndex:3]] doubleValue];
        double boardTemp = [[dataStr substringWithRange:[match rangeAtIndex:4]] doubleValue] / 10;
        double mcuTemp = [[dataStr substringWithRange:[match rangeAtIndex:5]] doubleValue] / 10;
        double batteryPercentage = [[dataStr substringWithRange:[match rangeAtIndex:6]] doubleValue];
        
        // Update device
        if(!device.isCharging.boolValue && [dataStr containsString:@"+"]){
            device.isCharging = [NSNumber numberWithBool:YES];
        }
        else if(device.isCharging.boolValue && [dataStr containsString:@"-"]){
            device.isCharging = [NSNumber numberWithBool:NO];
        }
        device.isIdle = [NSNumber numberWithBool:[dataStr containsString:@"z"]];
        
        // Set new data
        data.device = device;
        data.isPluggedIn = device.isCharging;
        data.dataIndexId = [NSNumber numberWithInt:dataIdx];
        data.batteryPercent = [NSNumber numberWithDouble:batteryPercentage];
        data.voltage = [NSNumber numberWithDouble:voltage];
        data.amperageDraw = [NSNumber numberWithDouble:ampDraw];
        data.boardTemp = [NSNumber numberWithDouble:boardTemp];
        data.mcuTemp = [NSNumber numberWithDouble:mcuTemp];
        data.dateAddedUtc = [Common dateFromLocalToUtcTime:[NSDate date]];
        [device addCurrentDataObject:data];
        
        // Save data
        [Common saveAllChanges];
        
        // Clear raw string
        [receivedData setString:@""];
        
        // Call delegates didReceiveDeviceData
        dispatch_async(dispatch_get_main_queue(), ^{
            for(id del in self.delegates){
                if(del && [del respondsToSelector:@selector(didReceiveDeviceData:ReceivedData:)])
                    [del didReceiveDeviceData:device ReceivedData:data];
            }
        });
    }
}

+ (void)init
{
    [self instance];
}

+(GZDeviceService*) instance
{
    static GZDeviceService *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GZDeviceService alloc]init];
        instance.delegates = [NSMutableArray array];
        instance.deviceRawTextData = [NSMutableDictionary dictionary];
    });
    
    return instance;
}

@end
