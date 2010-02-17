//
//  CurrencyPickerViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrencyPickerViewController : UITableViewController {

	NSArray *tableDataSource;
	id parent;
}

@property (nonatomic, retain)	id parent;

@end
