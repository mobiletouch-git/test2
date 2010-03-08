//
//  HistoryTableViewCell.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 08.03.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "HistoryTableViewCell.h"


@implementation HistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		currencyNameLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17 bold:YES];
		[currencyNameLabel setFrame:CGRectMake(50,12,40,20)];
		[currencyNameLabel setTextAlignment:UITextAlignmentLeft];		
		currencyNameLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:currencyNameLabel];
		
		multiplierLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12 bold:YES];
		[multiplierLabel setFrame:CGRectMake(95,13,30,20)];
		[multiplierLabel setFont:[UIFont systemFontOfSize:12]];
		[multiplierLabel setTextColor:[UIColor lightGrayColor]];
		multiplierLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:multiplierLabel];
		
		currencyValueLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17 bold:YES];
		[currencyValueLabel setFrame:CGRectMake(152,11,70,20)];
		[currencyValueLabel setTextAlignment:UITextAlignmentRight];		
		currencyValueLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:currencyValueLabel];
		
		changeLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17 bold:NO];
		[changeLabel setFrame:CGRectMake(248,11,60,20)];
		[changeLabel setTextAlignment:UITextAlignmentRight];
		changeLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:changeLabel];
		
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setMultiplierValue: (NSNumber *) theMValue
		  currencyValue: (NSDecimalNumber *) theValue
				 change: (NSDecimalNumber *) theChange
				   sign: (NSString *) theSign	
{
	
	if (theMValue)
		[multiplierLabel setText:[NSString stringWithFormat:@"x%d", [theMValue intValue]]];
	else
		[multiplierLabel setText:@""];
	
	[currencyValueLabel setText:[NSString stringWithFormat:@"%.4f", [theValue doubleValue]]];
	
	if (theChange)
	{
		NSString *changeString = [NSString stringWithFormat:@"%.4f", [theChange doubleValue]];
		[changeLabel setText:changeString];
		
		// verde: #0C9D00
		// rosu: #FF0404
		
		if ([theSign isEqualToString:@"+"])
		{
			[changeLabel setTextColor:[UIColor colorWithRed:(CGFloat)0x0C/255.0 green:(CGFloat)0x9D/255.0 blue:(CGFloat)0x00/255.0 alpha:1.0]];
			[changeLabel setText:[NSString stringWithFormat:@"+%@",changeString]];
		}
		else if ([theSign isEqualToString:@"-"])
		{
			[changeLabel setTextColor:[UIColor colorWithRed:(CGFloat)0xFF/255.0 green:(CGFloat)0x04/255.0 blue:(CGFloat)0x04/255.0 alpha:1.0]];
		}
		else if ([theSign isEqualToString:@"="])
		{
			[changeLabel setTextColor:[UIColor darkGrayColor]];
		}
		
	}
}

- (void)dealloc {
    [super dealloc];
}


@end
