//
//  HistoryTableViewCell.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 08.03.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "UIFactory.h"
#import "DateFormat.h"

@implementation HistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		dateLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17 bold:YES];
		[dateLabel setFrame:CGRectMake(10,5,110,20)];
		[dateLabel setTextAlignment:UITextAlignmentLeft];		
		dateLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:dateLabel];
		
		/*
		multiplierLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12 bold:YES];
		[multiplierLabel setFrame:CGRectMake(125,5,30,20)];
		[multiplierLabel setFont:[UIFont systemFontOfSize:12]];
		[multiplierLabel setTextColor:[UIColor lightGrayColor]];
		multiplierLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:multiplierLabel];
		 */
		
		currencyValueLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17 bold:YES];
		[currencyValueLabel setFrame:CGRectMake(162,5,70,20)];
		[currencyValueLabel setTextAlignment:UITextAlignmentLeft];		
		currencyValueLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:currencyValueLabel];
		
		changeLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:15 bold:NO];
		[changeLabel setFrame:CGRectMake(240,5,68,20)];
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

-(void) setCurrencyDate: (NSDate *) currencyDate
		multiplierValue: (NSNumber *) theMValue
		  currencyValue: (NSDecimalNumber *) theValue
				 change: (NSDecimalNumber *) theChange
				   sign: (NSString *) theSign;	

{
	NSLocale *roLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	
	NSNumberFormatter* currencyFormatter = [[NSNumberFormatter alloc] init];
	[currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[currencyFormatter setMinimumFractionDigits:4];
	[currencyFormatter setMaximumFractionDigits:4];
	[currencyFormatter setLocale: roLocale];
	
	if (currencyDate)
		[dateLabel setText:[DateFormat DBformatDateFromDate: currencyDate]];
	/*
	if (theMValue)
		[multiplierLabel setText:[NSString stringWithFormat:@"x%d", [theMValue intValue]]];
	else
		[multiplierLabel setText:@""];
	 */
	
	[currencyValueLabel setText:[currencyFormatter stringFromNumber: theValue]];
	
	if (theChange)
	{
		//NSString *changeString = [NSString stringWithFormat:@"%.4f", [theChange doubleValue]];
		NSString* changeString = [currencyFormatter stringFromNumber: theChange];
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
			[changeLabel setText:@"0"];			
			[changeLabel setTextColor:[UIColor darkGrayColor]];
		}
		
	}
	[currencyFormatter release];
}

- (void)dealloc {
    [super dealloc];
}


@end
