//
//  TaxTableViewCell.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 16.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "TaxTableViewCell.h"
#import "UIFactory.h"

@implementation TaxTableViewCell

@synthesize cellEnabled;

- (void)dealloc {
	
	[taxSignImageView release];
	[checkMarkView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		

		taxLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:16 bold:YES];
		[taxLabel setFrame:CGRectMake(20,7,140,30)];
		[taxLabel setTextAlignment:UITextAlignmentLeft];		
		taxLabel.adjustsFontSizeToFitWidth=YES;			
		[taxLabel setBackgroundColor:[UIColor clearColor]];
		[self addSubview:taxLabel];		
		
		taxSignImageView = [[UIImageView alloc] initWithFrame:CGRectMake(170,9,26,26)];
		[self addSubview:taxSignImageView];
		
		checkMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(15,20,16,16)];
		[checkMarkView setImage:[UIImage imageNamed:@"checkmarkYES.png"]];
		[checkMarkView setHidden:YES];		
		[self addSubview:checkMarkView];		

		percentLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:18 bold:NO];
		[percentLabel setFrame:CGRectMake(205,7,80,30)];
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

-(void) setEditing: (BOOL) yesOrNo
{
	if (yesOrNo)
	{
		[taxLabel setFrame:CGRectMake(52,7,200,30)];
		[percentLabel setHidden:YES];
		[taxSignImageView setHidden:YES];
	}
	else
	{
		[taxLabel setFrame:CGRectMake(20,7,140,30)];
		[percentLabel setHidden:NO];		
		[taxSignImageView setHidden:NO];		
	}
}

-(void) setSpecialRow
{
	[taxLabel setFrame:CGRectMake(20,7,130,30)];	
	[taxSignImageView setFrame:CGRectMake(155,9,26,26)];
	[percentLabel setFrame:CGRectMake(205,7,75,30)];
}

-(void) setAdditionFactor: (AdditionFactorItem *) aFactor
				  enabled: (BOOL) yesOrNo
{

	NSLocale *roLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	
	NSNumberFormatter* currencyFormatter = [[NSNumberFormatter alloc] init];
	[currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[currencyFormatter setMinimumFractionDigits:2];
	[currencyFormatter setMaximumFractionDigits:2];
	[currencyFormatter setLocale: roLocale];

	
	[self setCellEnabled:yesOrNo];

	if ([aFactor.factorName length])
	{
		[taxLabel setTextColor:[UIColor blackColor]];
		[taxLabel setText:aFactor.factorName];
	}
	else
	{
		[taxLabel setTextColor:[UIColor lightGrayColor]];
		[taxLabel setText:@"Nume"];
	}
	
	
	if (aFactor.factorSign>0)	
		[taxSignImageView setImage:[UIImage imageNamed:@"edit_add.png"]];
	if (aFactor.factorSign<0)	
		[taxSignImageView setImage:[UIImage imageNamed:@"edit_remove.png"]];
	
	if (aFactor.factorValue)
		[percentLabel setText:[currencyFormatter stringFromNumber:aFactor.factorValue]];
	
	[currencyFormatter release];
	
}

@end
