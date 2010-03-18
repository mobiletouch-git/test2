//
//  TaxesViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 16.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdditionFactorItem.h"
#import "AdWhirlView.h"
#import "AdWhirlDelegateProtocol.h"

@interface TaxesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AdWhirlDelegate>{

	UITableView *myTableView;
	NSMutableArray *tableDataSource;	
	
	UIBarButtonItem *editButton;
	UIBarButtonItem *doneButton;
}
@property (nonatomic, retain)	NSMutableArray *tableDataSource;	

-(void) addDefaultTaxesValues;
-(void) refresh;
-(void) addNewTaxAction;
-(void) editExistingTaxAction: (AdditionFactorItem *) existingTax;

@end
