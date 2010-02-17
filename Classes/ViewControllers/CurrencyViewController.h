//
//  CurrencyViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 28.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyItem.h"

@interface CurrencyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
	UITableView *myTableView;
	NSMutableArray *previousReferenceDay;
	NSMutableArray *tableDataSource;
	UIView *transparentView;	
	
	UIBarButtonItem *doneButton;
	UIBarButtonItem *cancelButton;
	UIBarButtonItem *editButton;
	
	UIButton *titleButton;
	UIDatePicker *datePicker;
	NSDate *selectedDate;
}

@property (nonatomic, retain)	NSMutableArray *tableDataSource;
@property (nonatomic, retain)	NSDate *selectedDate;

-(UIView *) getHeaderView;

-(void) organizeTableSourceWithPriorities;

@end
