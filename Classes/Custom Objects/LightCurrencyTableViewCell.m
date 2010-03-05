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
		
		currencyShortNameLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17 bold:YES];
		[currencyShortNameLabel setFrame:CGRectMake(50,12,240,20)];
		[currencyShortNameLabel setTextAlignment:UITextAlignmentLeft];	
		[currencyShortNameLabel setBackgroundColor:[UIColor clearColor]];
//		currencyShortNameLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:currencyShortNameLabel];
		
		multiplierLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12 bold:YES];
		[multiplierLabel setFrame:CGRectMake(95,15,30,20)];
		[multiplierLabel setFont:[UIFont systemFontOfSize:12]];
		[multiplierLabel setTextColor:[UIColor lightGrayColor]];
		multiplierLabel.adjustsFontSizeToFitWidth=YES;			
		[multiplierLabel setHidden:YES]; //!!!!
		[self addSubview:multiplierLabel];
		
		currencyFullNameLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17 bold:YES];
		[currencyFullNameLabel setFrame:CGRectMake(100,12,175,20)];
		[currencyFullNameLabel setTextAlignment:UITextAlignmentLeft];		
		[currencyFullNameLabel setBackgroundColor:[UIColor clearColor]];
		currencyFullNameLabel.adjustsFontSizeToFitWidth=YES;			
		[currencyFullNameLabel setHidden:YES]; //!!!!
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
			 multiplierValue: (NSNumber *) theMValue
					fullName: (NSString *) fullNameValue
{
	if (imageName)
		[currencyFlagImageView setImage:[UIImage imageNamed:imageName]];
	NSString *txt = [NSString stringWithString:theName];
	if ([fullNameValue length]) {
		txt = [NSString stringWithFormat:@"%@ (%@)",txt, fullNameValue];
	}
	[currencyShortNameLabel setText:txt];
	
	if (theMValue)
		[multiplierLabel setText:[NSString stringWithFormat:@"x%d", [theMValue intValue]]];
	else
		[multiplierLabel setText:@""];
//	[currencyFullNameLabel	setText:fullNameValue?[NSString stringWithFormat:@"(%@)",fullNameValue]:@""];
	
}

-(void) enterGroupEditState
{
	[currencyFlagImageView setFrame:CGRectMake(20,6,32,32)];
	[currencyShortNameLabel setFrame:CGRectMake(70,12,225,20)];	
	[multiplierLabel setFrame:CGRectMake(115,15,30,20)];	
	[currencyFullNameLabel setFrame:CGRectMake(135,14,155,20)];	
}

-(void) enterEditMode: (BOOL) yesOrNo
{
	if (yesOrNo)
	{
		[currencyFlagImageView setFrame:CGRectMake(50,6,32,32)];
		[currencyShortNameLabel setFrame:CGRectMake(90,12,225,20)];	
		[multiplierLabel setFrame:CGRectMake(135,15,30,20)];	
		[currencyFullNameLabel setHidden:YES];
	}
	else
	{
		[currencyFlagImageView setFrame:CGRectMake(20,6,32,32)];
		[currencyShortNameLabel setFrame:CGRectMake(60,12,225,20)];	
		[multiplierLabel setFrame:CGRectMake(115,15,30,20)];	
		[currencyFullNameLabel setHidden:NO];
	}
}



@end

