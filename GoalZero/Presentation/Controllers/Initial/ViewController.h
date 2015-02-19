//
//  ViewController.h
//  Goal Zero
//
//  Created by Seth Burch on 10/2/14.
//  Copyright (c) 2014 GoalZero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *blePicker;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

