//
//  LightCurrencyTableViewCell.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 18.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyItem.h"

@interface LightCurrencyTableViewCell : UITableViewCell {

	UIImageView *currencyFlagImageView;
	UILabel *currencyShortNameLabel;
	UILabel *multiplierLabel;	
	UILabel *currencyFullNameLabel;	
}

-(void) setCurrencyImageName: (NSString *) imageName
				currencyName: (NSString *) theName
			 multiplierValue: (NSString *) theMValue
					fullName: (NSString *) fullNameValue;

@end