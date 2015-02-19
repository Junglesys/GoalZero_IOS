//
//  BluetoothService.m
//  GoalZero
//
//  Created by Seth Burch on 10/3/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//// 2C5B1573-0DCD-7D4C-0447-A5F13BA0447D

#import "BluetoothService.h"
#import "AppDelegate.h"

//typedef enum
//{
//    IDLE = 0,
//    SCANNING,
//    CONNECTED,
//} ConnectionState;

@interface BluetoothService()
@property (readwrite, assign) bool isScanning;
@property (strong, nonatomic) NSMutableArray * delegates;
@property (strong, nonatomic) NSMutableArray * foundPeripherals;

@property CBService *uartService;
@property CBCharacteristic *rxCharacteristic;
@property CBCharacteristic *txCharacteristic;
@property(nonatomic,strong) NSMutableString *receivedData;

@property CBPeripheral *connectedDevice;
@property(nonatomic,strong) NSMutableArray *peripherals; // CBPeripheral
@property (nonatomic,strong) CBCentralManager *centralManager;

@end

@implementation BluetoothService

static NSString* uartServiceUUID = @"6e400001-b5a3-f393-e0a9-e50e24dcca9e";
static NSString* txCharacteristicUUID = @"6e400002-b5a3-f393-e0a9-e50e24dcca9e";
static NSString* rxCharacteristicUUID = @"6e400003-b5a3-f393-e0a9-e50e24dcca9e";


-(CBCentralManager*)centralManager
{
    if(!_centralManager){
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        [_centralManager stopScan];
    }
    return _centralManager;
}

-(NSMutableArray*)delegates
{
    if(!_delegates){
        _delegates = [NSMutableArray array];
    }
    return _delegates;
}

+ (void)addDelegate: (id<BluetoothServiceDelegate>)delegate
{
    if(![[self instance].delegates containsObject:delegate]){
        [[self instance].delegates addObject:delegate];
    }
}

+ (void)removeDelegate: (id<BluetoothServiceDelegate>)delegate
{
    if([[self instance].delegates containsObject:delegate]){
        [[self instance].delegates removeObject:delegate];
    }
}

// Discovered BLE device with our special ServiceUUID
-(void)addDiscoveredPeripheral:(CBPeripheral *)peripheral
{
    if(DebugMode){
        NSLog(@"Did discover peripheral %@", peripheral.name);
    }
    
    [self.peripherals addObject:peripheral];
    
    // Call delegates didDiscoverDevice
    dispatch_async(dispatch_get_main_queue(), ^{
        for(id del in self.delegates){
            if(del && [del respondsToSelector:@selector(didDiscoverDevice:)])
                [del didDiscoverDevice:peripheral];
        }
    });
}

+ (bool)isScanningForDevices
{
    return [self instance].isScanning;
}

+ (void)startScanningForDevices
{
    [[self instance].centralManager scanForPeripheralsWithServices:nil
                                                           options:@{CBCentralManagerScanOptionAllowDuplicatesKey:
                                                                         [NSNumber numberWithBool:YES]}];
    [self instance].isScanning = true;
}

+ (void)stopScanningForDevices
{
    if([self instance].centralManager){
        [[self instance].centralManager stopScan];
        [[self instance].peripherals removeAllObjects];
    }
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        [BluetoothService startScanningForDevices];
    }
    
}


- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // Save found peripheral once
    if([self.peripherals containsObject:peripheral]){
        return;
    }
    
    // Get peripherals' services
    if(![advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"])
        return;
    
    // Only get services with our special UUID
    NSArray * services = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
    if(![services containsObject:[CBUUID UUIDWithString:uartServiceUUID]]){
        return;
    }
    
    [self addDiscoveredPeripheral:peripheral];
}

+ (void)connectToDevice:(CBPeripheral *)peripheral
{
    NSNumber* notifyOnDisconnect = [NSNumber numberWithBool:YES];
    [[self instance].centralManager connectPeripheral:peripheral
                                              options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey:notifyOnDisconnect}];
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if(DebugMode){
        NSLog(@"Did connect peripheral %@", peripheral.name);
    }
    
    // Call delegates didConnectToPeripheral
    dispatch_async(dispatch_get_main_queue(), ^{
        for(id del in self.delegates){
            if(del && [del respondsToSelector:@selector(didConnectToPeripheral:)])
                [del didConnectToPeripheral:peripheral];
        }
    });
    
    self.connectedDevice = peripheral;
    self.connectedDevice.delegate = self;
    [self.connectedDevice discoverServices:@[[CBUUID UUIDWithString:uartServiceUUID]]];
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if(DebugMode){
        NSLog(@"Did disconnect peripheral %@", peripheral.name);
    }
    
    // Todo
    [BluetoothService connectToDevice:peripheral];
    
    if ([self.connectedDevice isEqual:peripheral])
    {
        //[self didDisconnect];
    }
}

- (NSMutableArray *) peripherals
{
    if(!_peripherals){
        _peripherals = [NSMutableArray array];
    }
    return _peripherals;
}


#pragma mark - Publicly exposed methods

-(NSMutableString *)receivedData
{
    if (!_receivedData) {
        _receivedData = [NSMutableString new];
    }
    return _receivedData;
}

- (void) writeString:(NSString *) string
{
    NSData *data = [NSData dataWithBytes:string.UTF8String length:string.length];
    if ((self.txCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0)
    {
        [self.connectedDevice writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
    else if ((self.txCharacteristic.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [self.connectedDevice writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
    }
    else
    {
        NSLog(@"No write property on TX characteristic, %d.", self.txCharacteristic.properties);
    }
}

- (void) writeRawData:(NSData *) data
{
    
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error){
        NSLog(@"Error discovering services: %@", error);
        return;
    }
    
    for (CBService *s in [peripheral services]){
        if ([s.UUID isEqual:[CBUUID UUIDWithString:uartServiceUUID]]){
            if(DebugMode){
                NSLog(@"Found correct service");
            }
            
            self.uartService = s;
            
            [self.connectedDevice discoverCharacteristics:@[[CBUUID UUIDWithString:txCharacteristicUUID], [CBUUID UUIDWithString:rxCharacteristicUUID]] forService:self.uartService];
        }
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error){
        NSLog(@"Error discovering characteristics: %@", error);
        return;
    }
    
    for (CBCharacteristic *c in [service characteristics])
    {
        if ([c.UUID isEqual:[CBUUID UUIDWithString:rxCharacteristicUUID]])
        {
            if(DebugMode){
                NSLog(@"Found RX characteristic");
            }
            
            self.rxCharacteristic = c;
            
            [self.connectedDevice setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
        }
        else if ([c.UUID isEqual:[CBUUID UUIDWithString:txCharacteristicUUID]])
        {
            if(DebugMode){
                NSLog(@"Found TX characteristic");
            }
            self.txCharacteristic = c;
        }
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error){
        NSLog(@"Error receiving notification for characteristic %@: %@", characteristic, error);
        return;
    }
    
    if(DebugMode){
        NSLog(@"Received data on a characteristic.");
    }
    
    if (characteristic == self.rxCharacteristic)
    {
        NSString *data = [NSString stringWithUTF8String:[[characteristic value] bytes]];
        
        if(data){
            dispatch_async(dispatch_get_main_queue(), ^{
                // Call delegates didConnectToPeripheral
                for(id del in self.delegates){
                    if(del && [del respondsToSelector:@selector(didReceiveDataForPeripheral:Peripheral:)])
                        [del didReceiveDataForPeripheral:data Peripheral:peripheral];
                }
            });
        }
    }
}

+ (void)init
{
    [self instance];
}

+(BluetoothService*) instance
{
    static BluetoothService *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BluetoothService alloc]init];
    });
    
    return instance;
}

//        [self.receivedData appendString:string];
//
//        NSLog(self.receivedData);
//
//        // z 1404  1267v 0000i 0557tb 0567ti 0000p 0000a pre1 chg100 dsg1
//
//        NSString *searchedString = self.receivedData;
//        NSRange searchedRange = NSMakeRange(0, [searchedString length]);
//
//        NSString *pattern = @".*([0-9]{4})v.+([0-9]{4})i.+([0-9]{4})tb.+([0-9]{4})ti.+chg([0-9]{1,3}).*dsg.*";
//        NSError  *error = nil;
//
//        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
//        NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];


//        if(matches.count >= 1){
//            for(id del in self.delegates){
//                if(del != nil)
//                {
//                    if(del &&  [del respondsToSelector:@selector(didReceiveDeviceData:Voltage:AmperageDraw:BoardTemp:McuTemp:BatteryPercentage:)])
//                    {
//                        NSTextCheckingResult* match = [matches objectAtIndex:0];
//                        NSString * name = peripheral.name;
//
//                        double voltage = [[searchedString substringWithRange:[match rangeAtIndex:1]] doubleValue] / 100;
//                        double ampDraw = [[searchedString substringWithRange:[match rangeAtIndex:2]] doubleValue];
//                        double boardTemp = [[searchedString substringWithRange:[match rangeAtIndex:3]] doubleValue] / 10;
//                        double mcuTemp = [[searchedString substringWithRange:[match rangeAtIndex:4]] doubleValue] / 10;
//                        int batteryPercentage = [[searchedString substringWithRange:[match rangeAtIndex:5]] doubleValue];
//
//
//                        [del didReceiveDeviceData:name
//                                          Voltage:voltage
//                                     AmperageDraw:ampDraw
//                                        BoardTemp:boardTemp
//                                          McuTemp:mcuTemp
//                                BatteryPercentage:batteryPercentage];
//
//                    }
//                }
//            }
//
//
//
//            [self.receivedData setString:@""];
//        }

// }
//}


@end


