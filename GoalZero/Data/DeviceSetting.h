//
//  DeviceSetting.h
//  GoalZero
//
//  Created by Seth Burch on 12/10/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Device;

@interface DeviceSetting : NSManagedObject

@property (nonatomic, retain) NSDate * lastChangedOnUtc;
@property (nonatomic, retain) id otherAttributes;
@property (nonatomic, retain) NSNumber * showBatteryPercentage;
@property (nonatomic, retain) NSNumber * showTemp;
@property (nonatomic, retain) NSNumber * showVoltage;
@property (nonatomic, retain) Device *device;

@end
