//
//  AddNewTaxViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 16.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdditionFactorItem.h"

@interface AddNewTaxViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{

	AdditionFactorItem *editedAdditionFactor;
	AdditionFactorItem *additionFactor;
	
	UITextField *taxNameTextField;
	UITextField *taxValueTextField;
	UIButton *plusSignButton;
	UIButton *minusSignButton;	
	UIBarButtonItem *saveButton;		
	UITableView *oneRowTableView;
	
	NSNumberFormatter *currencyFormatter;

}

@property (nonatomic, retain) AdditionFactorItem *additionFactor;

- (id)initWithAdditionFactor: (AdditionFactorItem *) addFactor;

@end
