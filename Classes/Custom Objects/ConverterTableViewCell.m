//
//  ConverterTableViewCell.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "ConverterTableViewCell.h"
#import "UIFactory.h"
#import "ConverterViewController.h"
#import "Constants.h"
#import "AdditionFactorItem.h"

@implementation ConverterTableViewCell

@synthesize converter;


- (void)dealloc {
	[converter release];
	[converterFlagImageView release];
	[converterValueTextField release];

	
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		converterFlagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,32,32)];
		[self addSubview:converterFlagImageView];
		
		converterNameLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:16 bold:YES];
		[converterNameLabel setFrame:CGRectMake(50,12,175,20)];
		[converterNameLabel setTextAlignment:UITextAlignmentLeft];		
		converterNameLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:converterNameLabel];	
		
		converterAdditionLabel = [UIFactory newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:15 bold:YES];
		[converterAdditionLabel setFrame:CGRectMake(50,30,175,20)];
		[converterAdditionLabel setTextAlignment:UITextAlignmentLeft];		
		converterAdditionLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:converterAdditionLabel];		
		
		converterValueTextField = [[UITextField alloc] init];
		[converterValueTextField setFrame:CGRectMake(230, 10, 80,35)];
		converterValueTextField.borderStyle = UITextBorderStyleRoundedRect;
		converterValueTextField.textColor = [UIColor blackColor];
		converterValueTextField.font = [UIFont systemFontOfSize:18.0];
		converterValueTextField.delegate=self;
		converterValueTextField.textAlignment = UITextAlignmentCenter;
		converterValueTextField.backgroundColor = [UIColor whiteColor];
		converterValueTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
		converterValueTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
		converterValueTextField.returnKeyType = UIReturnKeyDone;	
		converterValueTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		[converterValueTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//		converterValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		[self addSubview:converterValueTextField];
		
    }
    return self;
}

-(void) setConverterItem: (ConverterItem *) aConverter
{
	[self setConverter:aConverter];
	
	CurrencyItem *ci = [aConverter currency];
	
	if (ci)
	{
		NSString *imageName = [NSString stringWithFormat:@"%@.png", [ci currencyName]];
		UIImage *flagImage = [UIImage imageNamed:imageName];
		[converterFlagImageView setImage:flagImage?flagImage:nil];		
	}
	
	NSString *labelString = [NSString stringWithString: [ci currencyName]];
	[converterNameLabel setText:labelString];
	
	NSString *additionString = @"";
	for (int i=0;i<[aConverter.additionFactors count];i++)
	{
		AdditionFactorItem *af = [aConverter.additionFactors objectAtIndex:i];
		if (af.factorSign>0)
			additionString = [additionString stringByAppendingFormat:@" + %.2f%%", [af.factorValue doubleValue]];
		if (af.factorSign<0)
			additionString = [additionString stringByAppendingFormat:@" - %.2f%%", [af.factorValue doubleValue]];
	}

	if ([additionString length])
	{
		[converterAdditionLabel setHidden:NO];		
		[converterAdditionLabel setText:additionString];
		[converterNameLabel setFrame:CGRectMake(50,5,175,30)];		
	}
	else
	{
		[converterAdditionLabel setHidden:YES];
		[converterNameLabel setFrame:CGRectMake(50,12,175,30)];				
	}

	if ([self.converter converterValue])
		[converterValueTextField setText:[NSString stringWithFormat:@"%.2f", [[self.converter converterValue] doubleValue]]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setEditing: (BOOL) yesOrNo
{

	if (yesOrNo)
	{
		[converterFlagImageView	setFrame:CGRectMake(60,converterFlagImageView.frame.origin.y,32,32)];
		[converterNameLabel setFrame:CGRectMake(100,converterNameLabel.frame.origin.y,175,30)];
		[converterAdditionLabel setFrame:CGRectMake(100,converterAdditionLabel.frame.origin.y,175,20)];				
		[converterValueTextField setHidden:YES]; 
	}
	else
	{
		[converterFlagImageView	setFrame:CGRectMake(10,converterFlagImageView.frame.origin.y,32,32)];
		[converterNameLabel setFrame:CGRectMake(50,converterNameLabel.frame.origin.y,175,30)];
		[converterAdditionLabel setFrame:CGRectMake(50,converterAdditionLabel.frame.origin.y,175,20)];		
		[converterValueTextField setHidden:NO]; 
	}

}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[textField setText:@""];
	
	NSArray *visCells = [NSArray arrayWithArray:[[[appDelegate converterViewController] myTableView] visibleCells]];
	float yOffSet =	[self computeOffsetForCellInArray:visCells dataSource:[[appDelegate converterViewController] tableDataSource]];
	[[[appDelegate converterViewController] editButton] setEnabled:NO];
	[[[appDelegate converterViewController] addButton] setEnabled:NO];	
	
	[[[appDelegate converterViewController] myTableView] setContentOffset:CGPointMake(0, yOffSet) animated:YES];
	
	return YES;
}

-(float) computeOffsetForCellInArray: (NSArray *) cells
						  dataSource: (NSArray *) tableDataSource
{
	float computed = 0;
	for (int i=0; i <[cells count]; i++)
	{
		id cellAtIndex = [cells objectAtIndex:i];
		if (cellAtIndex == self)
		{
			if (i==0)
				computed = 0-2*self.bounds.size.height;
			else if (i==1)
				computed = 0-self.bounds.size.height;
			else if (i>=3)
			{
				int foundAtIndex = 0;
				for (int j=0; j<[tableDataSource count];j++)
				{
					ConverterItem *current = [tableDataSource objectAtIndex:j];
					if (current == self.converter)
						foundAtIndex = j;
				}

				if (foundAtIndex>=6 && [cells count]==7)
					computed = ((foundAtIndex-6)+(-2+i))*self.bounds.size.height;				
				else
					computed = (i-2)*self.bounds.size.height;
			}
		}
	}
	
	
	return computed;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.converter setConverterValue:[NSNumber numberWithDouble:[textField.text doubleValue]]];
	[textField resignFirstResponder];
	
	[[[appDelegate converterViewController] editButton] setEnabled:YES];	
	[[[appDelegate converterViewController] addButton] setEnabled:YES];		
	[[appDelegate converterViewController] setReferenceItem:self.converter];
	[[[appDelegate converterViewController] myTableView] setContentOffset:CGPointMake(0, 0) animated:YES];	
	[[[appDelegate converterViewController] myTableView] reloadData];

    return YES;
}

- (void) textDidChange:(NSNotification *)note {

}


@end
