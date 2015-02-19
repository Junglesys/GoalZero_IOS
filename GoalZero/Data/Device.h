//
//  Device.h
//  GoalZero
//
//  Created by Seth Burch on 12/10/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DeviceData, DeviceSetting;

@interface Device : NSManagedObject

@property (nonatomic, retain) NSDate * createdOnUtc;
@property (nonatomic, retain) NSNumber * displayOrder;
@property (nonatomic, retain) NSDate * lastConnectedOnUtc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSNumber * isCharging;
@property (nonatomic, retain) NSNumber * isIdle;
@property (nonatomic, retain) NSSet *currentData;
@property (nonatomic, retain) DeviceSetting *settings;
@end

@interface Device (CoreDataGeneratedAccessors)

- (void)addCurrentDataObject:(DeviceData *)value;
- (void)removeCurrentDataObject:(DeviceData *)value;
- (void)addCurrentData:(NSSet *)values;
- (void)removeCurrentData:(NSSet *)values;

@end
