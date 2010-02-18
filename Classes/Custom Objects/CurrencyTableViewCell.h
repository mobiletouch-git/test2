//
//  CurrencyTableViewCell.h
//  CursValutar
//
//  Created by Mobile Touch SRL on 10/27/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyItem.h"

@interface CurrencyTableViewCell : UITableViewCell {

	UIImageView *currencyFlagImageView;
	UILabel *currencyNameLabel;
	UILabel *multiplierLabel;	
	UILabel *currencyValueLabel;
	UILabel *changeLabel;
}

-(void) setCurrencyImageName: (NSString *) imageName
				currencyName: (NSString *) theName
			 multiplierValue: (NSString *) theMValue
			   currencyValue: (NSString *) theValue
					  change: (NSString *) theChange
						sign: (NSString *) theSign;	

-(void) enterEditMode: (BOOL) yesOrNo;

@property (nonatomic, retain) 	UILabel *changeLabel;
@property (nonatomic, retain)	UILabel *currencyValueLabel;   


@end
