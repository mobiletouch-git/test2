//
//  AddConverterItemViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyItem.h"

@interface AddConverterItemViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

	CurrencyItem *selectedCurrency;

	UITableView *oneRowTableView;	
	UITableView *myTableView;
	NSMutableArray *taxesArray;

	UIBarButtonItem *addButton;	
	UIBarButtonItem *doneButton;
	UIBarButtonItem *cancelButton;
	
	NSMutableArray *additionList;
	
}

@property (nonatomic, retain)	CurrencyItem *selectedCurrency;
@property (nonatomic, retain)	NSMutableArray *additionList;

-(void) refresh;

@end
