//
//  DeviceData.h
//  GoalZero
//
//  Created by Seth Burch on 12/10/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Device;

@interface DeviceData : NSManagedObject

@property (nonatomic, retain) NSNumber * amperageDraw;
@property (nonatomic, retain) NSNumber * batteryPercent;
@property (nonatomic, retain) NSNumber * boardTemp;
@property (nonatomic, retain) NSNumber * dataIndexId;
@property (nonatomic, retain) NSDate * dateAddedUtc;
@property (nonatomic, retain) NSNumber * isPluggedIn;
@property (nonatomic, retain) NSNumber * mcuTemp;
@property (nonatomic, retain) NSNumber * voltage;
@property (nonatomic, retain) Device *device;

@end
