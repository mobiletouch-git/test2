//
//  LightCurrencyTableViewCell.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 18.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "LightCurrencyTableViewCell.h"
#import "UIFactory.h"

@implementation LightCurrencyTableViewCell


- (void)dealloc {
	
	[currencyFlagImageView release];
	
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		currencyFlagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,5,32,32)];
		[self addSubview:currencyFlagImageView];
		
		currencyShortNameLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:18 bold:YES];
		[currencyShortNameLabel setFrame:CGRectMake(50,12,40,20)];
		[currencyShortNameLabel setTextAlignment:UITextAlignmentLeft];		
		currencyShortNameLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:currencyShortNameLabel];
		
		multiplierLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12 bold:YES];
		[multiplierLabel setFrame:CGRectMake(95,15,30,20)];
		[multiplierLabel setFont:[UIFont systemFontOfSize:12]];
		[multiplierLabel setTextColor:[UIColor lightGrayColor]];
		multiplierLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:multiplierLabel];
		
		currencyFullNameLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:15 bold:YES];
		[currencyFullNameLabel setFrame:CGRectMake(135,14,175,20)];
		[currencyFullNameLabel setTextAlignment:UITextAlignmentLeft];		
		currencyFullNameLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:currencyFullNameLabel];
		
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
					fullName: (NSString *) fullNameValue
{
	if (imageName)
		[currencyFlagImageView setImage:[UIImage imageNamed:imageName]];
	[currencyShortNameLabel setText:theName?theName:@""];
	
	if (theMValue)
		[multiplierLabel setText:[NSString stringWithFormat:@"x%@", theMValue]];
	else
		[multiplierLabel setText:@""];
	[currencyFullNameLabel	setText:fullNameValue?fullNameValue:@""];
	
}

-(void) enterGroupEditState
{
	[currencyFlagImageView setFrame:CGRectMake(30,5,32,32)];
	[currencyShortNameLabel setFrame:CGRectMake(70,12,40,20)];	
	[multiplierLabel setFrame:CGRectMake(115,15,30,20)];	
	[currencyFullNameLabel setFrame:CGRectMake(155,14,155,20)];	
}

-(void) enterEditMode: (BOOL) yesOrNo
{
	if (yesOrNo)
	{
		[currencyFlagImageView setFrame:CGRectMake(50,5,32,32)];
		[currencyShortNameLabel setFrame:CGRectMake(90,12,40,20)];	
		[multiplierLabel setFrame:CGRectMake(135,15,30,20)];	
		[currencyFullNameLabel setHidden:YES];
	}
	else
	{
		[currencyFlagImageView setFrame:CGRectMake(30,5,32,32)];
		[currencyShortNameLabel setFrame:CGRectMake(70,12,40,20)];	
		[multiplierLabel setFrame:CGRectMake(115,15,30,20)];	
		[currencyFullNameLabel setHidden:NO];
	}
}

@end

