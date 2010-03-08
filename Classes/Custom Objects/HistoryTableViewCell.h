//
//  HistoryTableViewCell.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 08.03.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HistoryTableViewCell : UITableViewCell {

	UILabel *multiplierLabel;	
	UILabel *currencyValueLabel;
	UILabel *changeLabel;
	
}
-(void) setMultiplierValue: (NSNumber *) theMValue
			   currencyValue: (NSDecimalNumber *) theValue
					  change: (NSDecimalNumber *) theChange
						sign: (NSString *) theSign;	
@end
