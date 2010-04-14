//
//  CurrencyViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 28.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyItem.h"
#import "AdWhirlDelegateProtocol.h"

@interface CurrencyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AdWhirlDelegate> {
	
	UITableView *myTableView;
	NSMutableArray *previousReferenceDay;
	NSMutableArray *tableDataSource;
	UIView *transparentView;	
	
	UIBarButtonItem *doneButton;
	UIBarButtonItem *saveButton;	
	UIBarButtonItem *cancelButton;
	UIBarButtonItem *editButton;
	UIBarButtonItem *updateButton;
	
//	UIButton *titleButton;
	UISegmentedControl *titleSeg;
	UIDatePicker *datePicker;
	NSDate *selectedDate;
}

@property (nonatomic, retain)	NSMutableArray *tableDataSource;
@property (nonatomic, retain)	NSDate *selectedDate;

-(UIView *) getHeaderView;
-(void) pageUpdate;
-(void) organizeTableSourceWithPriorities;
-(void) setDefaultPriorities;
-(void) updateCurrentDate;
-(void) doneAction;

@end
