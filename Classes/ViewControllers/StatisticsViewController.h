//
//  StatisticsViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 28.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatisticsViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>{

	UITableView *dateRangeTableView;
	UITableView *currenciesTableView;
	
	NSMutableDictionary *dateRangeDictionary;
	NSMutableArray *currenciesList;
	
	UIBarButtonItem *doneButton;
	UIBarButtonItem *editButton;	
}
@property (nonatomic, retain) UITableView *dateRangeTableView;
@property (nonatomic, retain) UITableView *currenciesTableView;
@property (nonatomic, retain) NSMutableDictionary *dateRangeDictionary;
@property (nonatomic, retain) NSMutableArray *currenciesList;

-(void) addDefaultCurrencies;
-(void) addNewCurrencyAction;

@end
