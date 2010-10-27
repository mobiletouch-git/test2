//
//  LightTaxTableViewCell.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 16.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "LightTaxTableViewCell.h"
#import "UIFactory.h"

@implementation LightTaxTableViewCell

- (void)dealloc {
	
	[taxSignImageView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		

		
		taxLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:16 bold:YES];
		[taxLabel setFrame:CGRectMake(20,7,120,30)];
		[taxLabel setTextAlignment:UITextAlignmentLeft];		
		taxLabel.adjustsFontSizeToFitWidth=YES;			
		[taxLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:taxLabel];		
		
		taxSignImageView = [[UIImageView alloc] initWithFrame:CGRectMake(170,9,26,26)];
		[self addSubview:taxSignImageView];
		
		percentLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:18 bold:NO];
		[percentLabel setFrame:CGRectMake(205,7,75,30)];
		[percentLabel setTextAlignment:UITextAlignmentLeft];	
		[percentLabel setBackgroundColor:[UIColor clearColor]];		
		[self addSubview:percentLabel];		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

-(void) setActive: (BOOL) yesOrNo
{
	if (yesOrNo)
		[self setBackgroundColor:[UIColor whiteColor]];
	else
		[self setBackgroundColor:[UIColor grayColor]];
}

-(void) setAdditionFactor: (AdditionFactorItem *) aFactor
				  enabled: (BOOL) yesOrNo
{
	NSLocale *roLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	
	NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
	[formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[formatter setMinimumFractionDigits:0];
	[formatter setMaximumFractionDigits:2];
	[formatter setLocale: roLocale];
	
	[taxLabel setText:aFactor.factorName?aFactor.factorName:@""];
	
	if (aFactor.factorSign>0)	
		[taxSignImageView setImage:[UIImage imageNamed:@"edit_add.png"]];
	if (aFactor.factorSign<0)	
		[taxSignImageView setImage:[UIImage imageNamed:@"edit_remove.png"]];
	
	if (aFactor.factorValue)
		[percentLabel setText:[[formatter stringFromNumber:aFactor.factorValue]stringByAppendingString:@"%"]];
	
	[formatter release];
	//	[percentLabel setText:[NSString stringWithFormat:@"%.2f%%", [aFactor.factorValue doubleValue]]];
	
}


@end
