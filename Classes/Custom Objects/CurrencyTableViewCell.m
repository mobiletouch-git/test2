//
//  CurrencyTableViewCell.m
//  CursValutar
//
//  Created by Mobile Touch SRL on 10/27/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import "CurrencyTableViewCell.h"
#import "UIFactory.h"

@implementation CurrencyTableViewCell

@synthesize changeLabel, currencyValueLabel;

- (void)dealloc {
	
	[currencyFlagImageView release];
	
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		currencyFlagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,5,32,32)];
		[self addSubview:currencyFlagImageView];
		
		currencyNameLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:18 bold:YES];
		[currencyNameLabel setFrame:CGRectMake(50,12,40,20)];
		[currencyNameLabel setTextAlignment:UITextAlignmentLeft];		
		currencyNameLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:currencyNameLabel];
		
		multiplierLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12 bold:YES];
		[multiplierLabel setFrame:CGRectMake(95,15,30,20)];
		[multiplierLabel setFont:[UIFont systemFontOfSize:12]];
		[multiplierLabel setTextColor:[UIColor lightGrayColor]];
		multiplierLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:multiplierLabel];
		
		currencyValueLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17 bold:YES];
		[currencyValueLabel setFrame:CGRectMake(152,11,70,20)];
		[currencyValueLabel setTextAlignment:UITextAlignmentRight];		
		currencyValueLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:currencyValueLabel];
		
		changeLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:13 bold:NO];
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

-(void) setCurrencyImageName: (NSString *) imageName
				currencyName: (NSString *) theName
			 multiplierValue: (NSString *) theMValue
			   currencyValue: (NSString *) theValue
					  change: (NSString *) theChange
						sign: (NSString *) theSign
{
	
	if (imageName)
		[currencyFlagImageView setImage:[UIImage imageNamed:imageName]];
	[currencyNameLabel setText:theName];
	if (theMValue)
		[multiplierLabel setText:[NSString stringWithFormat:@"x%@", theMValue]];
	else
		[multiplierLabel setText:@""];
	[currencyValueLabel setText:theValue];

	if (theChange)
	{
		[changeLabel setText:theChange];
		
		// verde: #0C9D00
		// rosu: #FF0404
		
		if ([theSign isEqualToString:@"+"])
		{
			[changeLabel setTextColor:[UIColor colorWithRed:(CGFloat)0x0C/255.0 green:(CGFloat)0x9D/255.0 blue:(CGFloat)0x00/255.0 alpha:1.0]];
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

-(void) setLightCurrencyImageName: (NSString *) imageName
					 currencyName: (NSString *) theName
				  multiplierValue: (NSString *) theMValue
					currencyValue: (NSString *) theValue
{
	if (imageName)
		[currencyFlagImageView setImage:[UIImage imageNamed:imageName]];
	[currencyNameLabel setText:theName];
	if (theMValue)
		[multiplierLabel setText:[NSString stringWithFormat:@"x%@", theMValue]];
	else
		[multiplierLabel setText:@""];
	[currencyValueLabel setText:theValue];
	[currencyValueLabel	setFrame:CGRectMake(220,11,70,20)];
	[changeLabel setHidden:YES];
	
}

-(void) enterEditMode: (BOOL) yesOrNo
{
	[currencyValueLabel setHidden:yesOrNo];
	[changeLabel setHidden:yesOrNo];
}


@end
