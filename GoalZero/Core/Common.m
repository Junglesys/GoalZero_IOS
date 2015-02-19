//
//  Common.m
//  RunningSafe
//
//  Created by Seth Burch on 3/27/14.
//  Copyright (c) 2014 Junglesys. All rights reserved.
//

#import "Common.h"
#import "AppDelegate.h"


@interface Common ()
@property (nonatomic,strong) NSMutableDictionary* masks;
@end

@implementation Common
@synthesize masks = _masks;
static Common * _instance;
static enum iPhoneModel _iphoneMode;

+(Common*)sharedInstance
{
    if(!_instance){
        _instance = [[Common alloc] init];
        _iphoneMode = NotSet;
    }
    return _instance;
}


+ (NSDate *) dateFromUtcToLocalTime:(NSDate *)UtcDate
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: UtcDate];
    return [NSDate dateWithTimeInterval: seconds sinceDate: UtcDate];
}

+ (NSDate *) dateFromLocalToUtcTime:(NSDate *)localDate
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: localDate];
    return [NSDate dateWithTimeInterval: seconds sinceDate: localDate];
}


- (NSString *) platformType:(NSString *)platform
{
    
    
    
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

-(NSDictionary*)masks
{
    if(!_masks){
        _masks = [NSMutableDictionary dictionary];
    }
    return _masks;
}

+(void)makeEdgesFaded: (UIView*)view
{
//    CALayer *viewLayer = [view layer];
//    CALayer* maskCompoudLayer = [CALayer layer];
//
//    CALayer* maskLayer = [CALayer layer];
//    
//    maskLayer.bounds = viewLayer.bounds;
//    
//    [maskLayer setPosition:CGPointMake(160, CGRectGetHeight(maskCompoudLayer.frame)/2.0)];
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate (NULL, 320, 480, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
//    
//    CGFloat colors[] = {
//        0.5, 0.5, 0.5, 0.0, //BLACK
//        0.0, 0.0, 0.0, 1.0, //BLACK
//    };
//    
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
//    CGColorSpaceRelease(colorSpace);
//    
//    NSUInteger gradientH = 20;
//    NSUInteger gradientHPos = 0;
//    
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor);
//    CGContextFillRect(context, CGRectMake(0, gradientHPos + gradientH, CGRectGetWidth(maskLayer.frame), CGRectGetHeight(maskLayer.frame)));
//    
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.0].CGColor);
//    CGContextFillRect(context, CGRectMake(0, 0, 320, gradientHPos));
//    
//    CGContextDrawLinearGradient(context, gradient, CGPointMake(160, gradientHPos), CGPointMake(160, gradientHPos + gradientH), 0);
//    CGGradientRelease(gradient);
//    
//    CGImageRef contextImage = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    
//    [maskLayer setContents:(id)CFBridgingRelease(contextImage)];
//    
//    CGImageRelease (contextImage);
//    
//    viewLayer.masksToBounds = YES;
//    viewLayer.mask = maskCompoudLayer;
    
    
    
    
    
    
    
    
//    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
//    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
//    
//    // first, define a horizontal gradient (left/right edges)
//    CAGradientLayer* hMaskLayer = [CAGradientLayer layer];
//    hMaskLayer.opacity = .7;
//    
//    hMaskLayer.colors = [NSArray arrayWithObjects:(id)CFBridgingRelease(outerColor),
//                         (id)CFBridgingRelease(innerColor), (id)CFBridgingRelease(innerColor),
//                         (id)CFBridgingRelease(outerColor),
//                         nil];
//    
//    hMaskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
//                            [NSNumber numberWithFloat:0.15],
//                            [NSNumber numberWithFloat:0.85],
//                            [NSNumber numberWithFloat:1.0], nil];
//    
//    hMaskLayer.startPoint = CGPointMake(0, 0.5);
//    hMaskLayer.endPoint = CGPointMake(1.0, 0.5);
//    hMaskLayer.bounds = view.bounds;
//    hMaskLayer.anchorPoint = CGPointZero;
//    
//    CAGradientLayer* vMaskLayer = [CAGradientLayer layer];
//    // without specifying startPoint and endPoint, we get a vertical gradient
//    vMaskLayer.opacity = hMaskLayer.opacity;
//    vMaskLayer.colors = hMaskLayer.colors;
//    vMaskLayer.locations = hMaskLayer.locations;
//    vMaskLayer.bounds = view.bounds;
//    vMaskLayer.anchorPoint = CGPointZero;
//    
//    // you must add the masks to the root view, not the scrollView, otherwise
//    //  the masks will move as the user scrolls!
//    [view.layer addSublayer: hMaskLayer];
//    [view.layer addSublayer: vMaskLayer];
}

+(void)makeBottomEdgeFaded: (UIView*)view
{
    CGColorRef innerColor = [UIColor colorWithWhite:1.0 alpha:0.4].CGColor;
    CGColorRef outerColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    
    // first, define a horizontal gradient (left/right edges)
    CAGradientLayer* hMaskLayer = [CAGradientLayer layer];
    hMaskLayer.opacity = .7;
    
    hMaskLayer.colors = [NSArray arrayWithObjects:
                         (id)CFBridgingRelease(innerColor),
                         (id)CFBridgingRelease(outerColor), nil];
    
//    hMaskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
//                            [NSNumber numberWithFloat:0.15],
//                            [NSNumber numberWithFloat:0.85],
//                            [NSNumber numberWithFloat:1.0], nil];
    
    hMaskLayer.startPoint = CGPointMake(0, 0.2);
    //hMaskLayer.endPoint = CGPointMake(1.0, 0.5);
    hMaskLayer.endPoint = CGPointMake(1.0, 0.2);
    hMaskLayer.bounds = view.bounds;
    hMaskLayer.anchorPoint = CGPointZero;
    
    CAGradientLayer* vMaskLayer = [CAGradientLayer layer];
    // without specifying startPoint and endPoint, we get a vertical gradient
    vMaskLayer.opacity = hMaskLayer.opacity;
    vMaskLayer.colors = hMaskLayer.colors;
    vMaskLayer.locations = hMaskLayer.locations;
    vMaskLayer.bounds = view.bounds;
    vMaskLayer.anchorPoint = CGPointZero;
    
    // you must add the masks to the root view, not the scrollView, otherwise
    //  the masks will move as the user scrolls!
    //[view.layer addSublayer: hMaskLayer];
    [view.layer addSublayer: vMaskLayer];
}


+(void)setButtonToMainDesign: (UIButton*)btn
{
    //CGColorRef mainColor = btn.tintColor.CGColor;
    CGFloat red = 255.0;
    CGFloat green = 255.0;
    CGFloat blue = 255.0;
    
    UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    btn.layer.cornerRadius = 2.3;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = color.CGColor;
    btn.layer.masksToBounds = YES;
    
    [btn setBackgroundColor:[UIColor blackColor]];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:.3] forState:UIControlStateSelected];
    
}

+(BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+(void)makeEdgesRound: (UIView*)view
{
    if(view){
        view.layer.cornerRadius = 3.5;
    }
}

+ (void) addMaskToView: (UIView *)view Message:(NSString*)message
{
    NSString * key = [NSString stringWithFormat:@"%i",view.hash];
    
    if([[Common sharedInstance].masks objectForKey:key]){
        return;
    }
    
    CALayer * layer = [CALayer layer];
    CGColorRef color = [UIColor colorWithRed:0.0
                                       green:0.0
                                        blue:0.0
                                       alpha:0.6].CGColor;
    [layer setBackgroundColor:color];
    layer.frame = view.bounds;
    
    UIView * subview = [[UIView alloc] initWithFrame:view.window.bounds];
    [subview.layer insertSublayer:layer atIndex:0];
    
    if(message != nil){
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width-30, 28)];
        [label setBackgroundColor: [UIColor whiteColor]];
        [label setTextColor:[UIColor blackColor]];
        [label setTintColor:[UIColor whiteColor]];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setFont:[UIFont fontWithName:@"Futura" size:17]];
        [label setNumberOfLines: 1];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:message];
        [label setCenter:CGPointMake(view.frame.size.width / 2, view.frame.size.height / 3)];
        [subview addSubview:label];
    }
    [view addSubview:subview];
    [view setUserInteractionEnabled:NO];
    
    [[Common sharedInstance].masks setObject:subview forKey:key];
}

+ (void) removeMaskFromView: (UIView *)view
{
    NSString * key = [NSString stringWithFormat:@"%i",view.hash];
    UIView * viewToRemove = [[Common sharedInstance].masks objectForKey:key];
    [viewToRemove removeFromSuperview];
    [[Common sharedInstance].masks removeObjectForKey:key];
    viewToRemove = nil;
    [view setUserInteractionEnabled:YES];
}



+(AppDelegate *)delegate
{
    return (AppDelegate *)[UIApplication  sharedApplication].delegate;
}

+(NSArray *)getObjectsFromDatabase: (NSString *)entityName Filter:(NSPredicate *)filter
{
    NSManagedObjectContext *context = [self delegate].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    request.predicate = filter;
    NSError *error = nil;
    return [context executeFetchRequest:request error:&error];
}

+(NSArray *)getSortedObjectsFromDatabase: (NSString *)entityName Filter:(NSPredicate *)filter sorter:(NSSortDescriptor*)descriptor
{
    NSManagedObjectContext *context = [self delegate].managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [request setEntity:entity];
    request.predicate = filter;
    request.sortDescriptors = @[descriptor];
    NSError *error = nil;
    return [context executeFetchRequest:request error:&error];
}

+(id)getObjectFromDatabase: (NSString *)entityName Filter:(NSPredicate *)filter
{
    return [[self getObjectsFromDatabase:entityName Filter:filter]lastObject];
}

+(id)addNewCoreDataObject :(NSString*)entityName
{
    id obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:[self delegate].managedObjectContext];
    [[self delegate].managedObjectContext insertObject:obj];
    return obj;
}

+(void)removeCoreDataObject: (id)objToRemove
{
    [[[self delegate] managedObjectContext] deleteObject:objToRemove];
}

+(void)saveAllChanges
{
    [[self delegate] saveContext];
}


@end
