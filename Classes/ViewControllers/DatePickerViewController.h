//
//  DatePickerViewController.h
//  ETCM
//
//  Created by Mobile Touch SRL on 20.11.2009.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatePickerViewController : UIViewController <UITextFieldDelegate>{

	UITextField *editingTextField;
	NSString *editingValue;
	NSString *stringForTitle;	
	NSString *stringForTextFieldValue;
	NSString *stringForNotice;

	UIBarButtonItem *saveButton;
	UIDatePicker *datePicker;	
	UIViewController *parent;
	
}
@property (nonatomic, retain) UITextField *editingTextField;
@property (nonatomic, retain) NSString *editingValue;
@property (nonatomic, retain) NSString *stringForTitle;	
@property (nonatomic, retain) NSString *stringForTextFieldValue;
@property (nonatomic, retain) NSString *stringForNotice;

@property (nonatomic, retain) UIViewController *parent;

@end
