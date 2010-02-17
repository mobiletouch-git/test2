//
//  TaxTableViewCell.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 16.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdditionFactorItem.h"

@interface TaxTableViewCell : UITableViewCell {

	AdditionFactorItem *factor;
	UILabel *taxLabel;
	UIImageView *taxSignImageView;
	UILabel *percentLabel;
	UIImageView *checkMarkView;
	BOOL cellEnabled;

}
@property (nonatomic, assign)	BOOL cellEnabled;

-(void) setEditing: (BOOL) yesOrNo;
-(void) setAdditionFactor: (AdditionFactorItem *) aFactor
				  enabled: (BOOL) yesOrNo;
-(void) setSpecialRow;
@end
