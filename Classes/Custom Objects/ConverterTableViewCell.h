//
//  ConverterTableViewCell.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConverterItem.h"

@interface ConverterTableViewCell : UITableViewCell <UITextFieldDelegate>{
	
	ConverterItem *converter;
	UIImageView *converterFlagImageView;
	UILabel *converterNameLabel;
	UILabel *multiplierLabel;		
	UILabel *converterAdditionLabel;	
	UITextField *converterValueTextField;	
	
	UIBarButtonItem *doneButton;
	UIBarButtonItem *cancelButton;
	
	NSString *oldValue;
	
	NSNumberFormatter *currencyFormatter;
	NSNumberFormatter *selectionFormatter;	
}

@property (nonatomic, retain) ConverterItem *converter;
@property (nonatomic, retain) NSString *oldValue;


-(void) setConverterItem: (ConverterItem *) aConverter;
-(void) setEditing: (BOOL) yesOrNo;
-(float) computeOffsetForCellInArray: (NSArray *) cells
						  dataSource: (NSArray *) tableDataSource;

-(void) moveView:(UIView *) viewP x:(float) pixP;
- (void)cancelAction;

@end
