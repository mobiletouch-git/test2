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

@synthesize converter, oldValue;


- (void)dealloc {
	[currencyFormatter release];
	[doneButton release];
	[cancelButton release];
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
		[converterAdditionLabel setFrame:CGRectMake(50,30,125,15)];
		[converterAdditionLabel setTextAlignment:UITextAlignmentLeft];		
		converterAdditionLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:converterAdditionLabel];		
		
		converterValueTextField = [[UITextField alloc] init];
		[converterValueTextField setFrame:CGRectMake(200, 10, 110,35)];
		converterValueTextField.borderStyle = UITextBorderStyleRoundedRect;
		converterValueTextField.textColor = [UIColor blackColor];
		converterValueTextField.font = [UIFont systemFontOfSize:18.0];
		converterValueTextField.delegate=self;
		converterValueTextField.textAlignment = UITextAlignmentCenter;
		converterValueTextField.backgroundColor = [UIColor whiteColor];
		converterValueTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
		converterValueTextField.keyboardType = UIKeyboardTypeNumberPad;
		converterValueTextField.returnKeyType = UIReturnKeyDone;	
		converterValueTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		[converterValueTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//		converterValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
		[self addSubview:converterValueTextField];
		
		
		
		doneButton = [[UIBarButtonItem alloc] initWithTitle:kDone
														  style:UIBarButtonItemStyleDone
														 target:self 
														 action:@selector(doneAction)];
		cancelButton = [[UIBarButtonItem alloc] initWithTitle:kCancel
															style:UIBarButtonItemStyleBordered
														   target:self
														   action:@selector(cancelAction)];
		
		currencyFormatter = [[NSNumberFormatter alloc] init];
		[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[currencyFormatter setCurrencySymbol:@""];
		[currencyFormatter setMinimumFractionDigits:2];
		[currencyFormatter setMaximumFractionDigits:2];
		
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
		[converterNameLabel setFrame:CGRectMake(50,5,125,30)];		
	}
	else
	{
		[converterAdditionLabel setHidden:YES];
		[converterNameLabel setFrame:CGRectMake(50,12,125,30)];				
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
		[converterAdditionLabel setFrame:CGRectMake(100,converterAdditionLabel.frame.origin.y,125,20)];				
		[converterValueTextField setHidden:YES]; 
	}
	else
	{
		[converterFlagImageView	setFrame:CGRectMake(10,converterFlagImageView.frame.origin.y,32,32)];
		[converterNameLabel setFrame:CGRectMake(50,converterNameLabel.frame.origin.y,175,30)];
		[converterAdditionLabel setFrame:CGRectMake(50,converterAdditionLabel.frame.origin.y,125,20)];		
		[converterValueTextField setHidden:NO]; 
	}

}

- (void)scrollCellToCenterOfScreen:(UIView *)theView {
	
	UITableView *myTable = [[appDelegate converterViewController] myTableView];
	UITableViewCell *myCell = (UITableViewCell *) [theView superview];
	
	int index = [myTable indexPathForCell:myCell].row;
	
	float cellHeight = myCell.frame.size.height;
	
	
	CGFloat viewCenterY = index * cellHeight + cellHeight / 2;
	
	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
	
	CGFloat availableHeight = applicationFrame.size.height - 216;	// Remove area covered by keyboard 216 || 80
	
	CGFloat y = viewCenterY - availableHeight / 2.0;
	if (y < 0) {
		y = 0;
	}
	[[[appDelegate converterViewController] myTableView] setContentOffset:CGPointMake(0, y) animated:YES];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	//[[appDelegate converterViewController] editMode:YES]
	[[appDelegate converterViewController].navigationItem setLeftBarButtonItem:cancelButton];
	[[appDelegate converterViewController].navigationItem setRightBarButtonItem:doneButton];
	
	[self setOldValue:textField.text];
	[textField setText:@"0.00"];
	


	[[[appDelegate converterViewController] editButton] setEnabled:NO];
	[[[appDelegate converterViewController] addButton] setEnabled:NO];	
	[[[appDelegate converterViewController] titleButton] setEnabled:NO];		
	

	[self scrollCellToCenterOfScreen:textField];
	

	
	return YES;
}

// Deprecated
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
	NSDecimalNumber *nrFromString;
	if (![textField.text length])
		nrFromString = [NSDecimalNumber decimalNumberWithString:@"0"];
	else {
		NSNumber *currentNSNumber = [currencyFormatter numberFromString:textField.text];
		NSString *currentNSString = [currentNSNumber stringValue];
		nrFromString = [NSDecimalNumber decimalNumberWithString:currentNSString];
		}
	
	[self.converter setConverterValue:nrFromString];
	[textField resignFirstResponder];
	
	[[[appDelegate converterViewController] editButton] setEnabled:YES];	
	[[[appDelegate converterViewController] addButton] setEnabled:YES];	
	[[[appDelegate converterViewController] titleButton] setEnabled:YES];		
	
	[[appDelegate converterViewController] setReferenceItem:converter];
	[[[appDelegate converterViewController] myTableView] setContentOffset:CGPointMake(0, 0) animated:YES];	
	[[[appDelegate converterViewController] myTableView] reloadData];

    return YES;
}

- (void) textDidChange:(NSNotification *)note {
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	
	//int currencyScale = [currencyFormatter maximumFractionDigits];
	int currencyScale = 2;
	
	NSLog(@"%d",currencyScale);
	
	NSLog(@"|%@| %d %d %@",string, range.length, range.location, textField.text);
	
	NSNumber *currentNSNumber = [currencyFormatter numberFromString:textField.text];
	NSString *currentNSString = [currentNSNumber stringValue];
	
	if (![string length]) { //Backspace pressed
		NSDecimalNumber *currentNumber = [NSDecimalNumber decimalNumberWithString:currentNSString];
		currentNumber = [currentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10"]];
		NSString *currentNumberString = [currencyFormatter stringFromNumber:currentNumber];
		textField.text = currentNumberString;
		return NO;
	}
	
	NSDecimalNumber *currentNumber = [NSDecimalNumber decimalNumberWithString:currentNSString];
	currentNumber = [currentNumber decimalNumberByMultiplyingByPowerOf10:currencyScale+1];
	currentNumber = [currentNumber decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:string]];
	currentNumber = [currentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, currencyScale)]]];
	
	
	NSString *currentNumberString = [currencyFormatter stringFromNumber:currentNumber];
	
	[textField setText:currentNumberString];
	return NO;
}

- (void)doneAction {
	[converterValueTextField resignFirstResponder];
	[self textFieldShouldReturn:converterValueTextField];
	[[appDelegate converterViewController] textEditEnded];
}

- (void)cancelAction {
	[converterValueTextField setText:oldValue];
	[converterValueTextField resignFirstResponder];
	[self textFieldShouldReturn:converterValueTextField];
	[[appDelegate converterViewController] textEditEnded];
}

@end
