//
//  CurrencyPickerViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrencyPickerViewController : UITableViewController {

	NSMutableArray *tableDataSource;
	UIBarButtonItem *cancelButton;	
	id parent;
	BOOL isPushed;
	NSDictionary *currencyFullDictionary;
}

@property (nonatomic, retain)	id parent;
@property (nonatomic, assign)	BOOL isPushed;

@end
