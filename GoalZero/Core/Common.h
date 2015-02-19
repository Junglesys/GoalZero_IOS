//
//  Common.h
//  GoalZero
//
//  Created by Seth Burch on 12/2/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <Foundation/Foundation.h>

enum iPhoneModel
{
    NotSet,
    BelowiPhone4,
    iPhone4,
    iPhone4s,
    iPhone5,
    iPhone5s,
    iPhone6,
    iPhone6Plus,
    AboveiPhone6
};

@interface Common : NSObject

+ (void)setButtonToMainDesign: (UIButton*)btn;
+ (BOOL)validateEmail: (NSString *) candidate;
+ (void)addMaskToView: (UIView *)view Message:(NSString*)message;
+ (void)removeMaskFromView: (UIView *)view;

+(void)makeEdgesRound: (UIView*)view;

+(void)makeEdgesFaded: (UIView*)view;
+(void)makeBottomEdgeFaded: (UIView*)view;


+ (NSDate *) dateFromUtcToLocalTime:(NSDate *)UtcDate;
+ (NSDate *) dateFromLocalToUtcTime:(NSDate *)localDate;

// Coredata
+(NSArray *)getObjectsFromDatabase: (NSString *)entityName Filter:(NSPredicate *)filter;
+(id)getObjectFromDatabase: (NSString *)entityName Filter:(NSPredicate *)filter;
+(void)saveAllChanges;
+(id)addNewCoreDataObject :(NSString*)entityName;
+(void)removeCoreDataObject: (id)objToRemove;

+(NSArray *)getSortedObjectsFromDatabase: (NSString *)entityName Filter:(NSPredicate *)filter sorter:(NSSortDescriptor*)descriptor;

@end
