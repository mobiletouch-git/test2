//
//  LightConverterTableViewCell.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 18.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "LightConverterTableViewCell.h"
#import "UIFactory.h"
#import "ConverterViewController.h"
#import "Constants.h"
#import "AdditionFactorItem.h"

@implementation LightConverterTableViewCell

@synthesize converter;


- (void)dealloc {
	[converter release];
	[converterFlagImageView release];
	
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		converterFlagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,6,32,32)];
		[self addSubview:converterFlagImageView];
		
		converterNameLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:16 bold:YES];
		[converterNameLabel setFrame:CGRectMake(60,12,175,20)];
		[converterNameLabel setTextAlignment:UITextAlignmentLeft];		
		converterNameLabel.adjustsFontSizeToFitWidth=YES;	
		[self addSubview:converterNameLabel];	
		
		converterAdditionLabel = [UIFactory newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:15 bold:YES];
//		[converterAdditionLabel setFrame:CGRectMake(70,30,175,20)];
		[converterAdditionLabel setFrame:CGRectMake(100,15,175,15)];
		[converterAdditionLabel setTextAlignment:UITextAlignmentLeft];		
		converterAdditionLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:converterAdditionLabel];		
		
		UIImageView *disclosureView = [[UIImageView alloc] initWithFrame:CGRectMake(290,16,10,13)];
		[disclosureView setImage:[UIImage imageNamed:@"accessory_disclosure.png"]];
		[disclosureView setTag:1];
		[self addSubview:disclosureView];
		[disclosureView release];		
		
    }
    return self;
}


-(void) setConverterItem: (ConverterItem *) aConverter
{
	[self setConverter:aConverter];
	
	CurrencyItem *ci = [aConverter currency];
	
	NSLocale *roLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	
	NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
	[formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[formatter setMinimumFractionDigits:0];
	[formatter setMaximumFractionDigits:2];
	[formatter setLocale: roLocale];
	
	
	if (ci)
	{
		NSString *imageName = [NSString stringWithFormat:@"%@.png", [ci currencyName]];
		UIImage *flagImage = [UIImage imageNamed:imageName];
		[converterFlagImageView setImage:flagImage?flagImage:nil];		
		
		NSString *labelString = [NSString stringWithString: [ci currencyName]];
		[converterNameLabel setText:labelString];		
	}
	
	NSString *additionString = @"";
	for (int i=0;i<[aConverter.additionFactors count];i++)
	{
		AdditionFactorItem *af = [aConverter.additionFactors objectAtIndex:i];
		if (af.factorSign>0)
			additionString = [additionString stringByAppendingFormat:@" + %@",[[formatter stringFromNumber:af.factorValue]stringByAppendingString:@"%"]];
			//additionString = [additionString stringByAppendingFormat:@" + %.2f%%", [af.factorValue doubleValue]];
		if (af.factorSign<0)
			additionString = [additionString stringByAppendingFormat:@" - %@",[[formatter stringFromNumber:af.factorValue]stringByAppendingString:@"%"]];
			//additionString = [additionString stringByAppendingFormat:@" - %.2f%%", [af.factorValue doubleValue]];
	}
	
	if ([additionString length])
	{
		[converterAdditionLabel setHidden:NO];		
		[converterAdditionLabel setText:additionString];
	}
	else
	{
		[converterAdditionLabel setHidden:YES];
	}
	[formatter release];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
