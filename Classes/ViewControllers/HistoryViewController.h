//
//  HistoryViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 08.03.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyItem.h" 

@interface HistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate>{

	UITableView *myTableView;
	
	NSMutableDictionary *tableDataSourceDict;
	NSMutableArray *tableDataSource;
	NSMutableArray *yearArray;
	
	UIBarButtonItem *doneButton;
	UIBarButtonItem *cancelButton;
	UIBarButtonItem *yearButton;
	
	UIPickerView *yearPicker;	
	CurrencyItem *selectedCurrency;
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, retain) CurrencyItem *selectedCurrency;

-(void) refreshDataSource;
-(void) processBruteData: (NSArray *) dataArray;

@end
