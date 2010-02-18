//
//  LightConverterTableViewCell.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 18.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConverterItem.h"

@interface LightConverterTableViewCell : UITableViewCell {

	ConverterItem *converter;
	UIImageView *converterFlagImageView;
	UILabel *converterNameLabel;
	UILabel *converterAdditionLabel;	
}

@property (nonatomic, retain) ConverterItem *converter;

-(void) setConverterItem: (ConverterItem *) aConverter;


@end
