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
	UILabel *converterAdditionLabel;	
	UITextField *converterValueTextField;	
}

@property (nonatomic, retain) ConverterItem *converter;

-(void) setConverterItem: (ConverterItem *) aConverter;
-(void) setLightConverter: (ConverterItem *) aConverter;
-(void) setEditing: (BOOL) yesOrNo;

@end
