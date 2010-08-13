//
//  ConverterViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 28.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyItem.h"
#import "ConverterItem.h"
#import "AdWhirlDelegateProtocol.h"
#import "AddNewTaxViewController.h"
#import "SensitiveTableView.h"

@interface ConverterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AdWhirlDelegate>{
	
	SensitiveTableView *myTableView;
	NSMutableArray *tableDataSource;
	NSMutableArray *selectedReferenceDay;
	
	UIBarButtonItem *editButton;
	UIBarButtonItem *addButton;	
	UIBarButtonItem *doneButton;
	UIBarButtonItem *cancelButton;
	
//	UIButton *titleButton;
	UISegmentedControl *titleSeg;

	UIDatePicker *datePicker;
	NSDate *selectedDate;
	
	ConverterItem *referenceItem;
	
	BOOL textChanged;
	
	NSDecimalNumber *referenceConverterValue;
	
	BOOL converterHasBeenUpdated;
	
	
	BOOL keyboardVisible;
	CGPoint offset;
	CGRect oldFrame;
}
@property (nonatomic, retain)	UIBarButtonItem *editButton;
@property (nonatomic, retain)	UIBarButtonItem *addButton;	
@property (nonatomic, retain)   UISegmentedControl *titleSeg;
@property (nonatomic, retain)	NSDecimalNumber *referenceConverterValue;
@property (nonatomic, retain)	UIDatePicker *datePicker;

@property (nonatomic, assign) BOOL textChanged;

//@property (nonatomic, retain)	UIButton *titleButton;

@property (nonatomic, retain)	UITableView *myTableView;
@property (nonatomic, retain)	NSMutableArray *tableDataSource;
@property (nonatomic, retain)	NSMutableArray *selectedReferenceDay;
@property (nonatomic, retain)	NSDate *selectedDate;
@property (nonatomic, retain)	ConverterItem *referenceItem;
@property (nonatomic, assign) BOOL converterHasBeenUpdated;



-(void) addDefaultConverterValues;
-(void) textEditEnded;
-(void) updateCurrentDate;

@end
