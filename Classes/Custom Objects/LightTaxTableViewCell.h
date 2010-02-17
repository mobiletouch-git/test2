//
//  LightTaxTableViewCell.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 16.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdditionFactorItem.h"

@interface LightTaxTableViewCell : UITableViewCell {

	AdditionFactorItem *factor;
	UILabel *taxLabel;
	UIImageView *taxSignImageView;
	UILabel *percentLabel;
	UIImageView *checkMarkView;
	
}

-(void) setAdditionFactor: (AdditionFactorItem *) aFactor
				  enabled: (BOOL) yesOrNo;
-(void) setChecked: (BOOL) yesOrNo;
-(void) setActive: (BOOL) yesOrNo;
@end