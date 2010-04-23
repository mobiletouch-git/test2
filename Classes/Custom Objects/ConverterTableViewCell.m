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
#import "ConverterViewController.h"

@implementation ConverterTableViewCell

@synthesize converter, oldValue;


- (void)dealloc {
	[doneButton release];
	[cancelButton release];
	[converter release];
	[converterFlagImageView release];
	[converterValueTextField release];
	
	[currencyFormatter release];
	[selectionFormatter release];
	
    [super dealloc];
}




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		
		converterFlagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,6,32,32)];
		[self addSubview:converterFlagImageView];
		
		converterNameLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17 bold:YES];
		[converterNameLabel setFrame:CGRectMake(48,11,42,23)];
		[converterNameLabel setTextAlignment:UITextAlignmentLeft];		
		converterNameLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:converterNameLabel];	
		
		multiplierLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12 bold:YES];
		[multiplierLabel setFrame:CGRectMake(92,15,30,20)];
		[multiplierLabel setFont:[UIFont systemFontOfSize:12]];
		[multiplierLabel setTextColor:[UIColor lightGrayColor]];
		multiplierLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:multiplierLabel];		
		
		converterAdditionLabel = [UIFactory newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12 bold:YES];
		[converterAdditionLabel setBackgroundColor:[UIColor clearColor]];
		[converterAdditionLabel setFrame:CGRectMake(8,40,304,15)];
		[converterAdditionLabel setTextAlignment:UITextAlignmentLeft];		
		converterAdditionLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:converterAdditionLabel];		
		
		converterValueTextField = [[UITextField alloc] init];
		[converterValueTextField setFrame:CGRectMake(150, 8, 160,30)];
		converterValueTextField.borderStyle = UITextBorderStyleRoundedRect;
		converterValueTextField.textColor = [UIColor blackColor];
		converterValueTextField.font = [UIFont systemFontOfSize:18.0];
		converterValueTextField.delegate=self;
		converterValueTextField.textAlignment = UITextAlignmentRight;
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
		[currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[currencyFormatter setMinimumFractionDigits:2];
		[currencyFormatter setMaximumFractionDigits:2];
		
		selectionFormatter = [[NSNumberFormatter alloc] init];
		[selectionFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[selectionFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[selectionFormatter setMinimumFractionDigits:2];
		[selectionFormatter setMaximumFractionDigits:2];
		[selectionFormatter setRoundingMode:NSNumberFormatterRoundDown];
		
		
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
	
		if ([ci.multiplierValue intValue])
			[multiplierLabel setText:[NSString stringWithFormat:@"x%d", [ci.multiplierValue intValue]]];
		else
			[multiplierLabel setText:@""];		
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
	
	
	[converterAdditionLabel setHidden:NO];		
	[converterAdditionLabel setText:additionString];

	
	if ([self.converter converterValue]) {
	
		[converterValueTextField setText:[currencyFormatter stringFromNumber:[self.converter converterValue]]];
		//[converterValueTextField setText:[NSString stringWithFormat:@"%.2f", [ doubleValue]]];

	}
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}

-(void) setEditing: (BOOL) yesOrNo
{
 
	const int k = 30;
	if (yesOrNo)
	{
		[converterFlagImageView setFrame:CGRectMake(10+k,6,32,32)];
		[multiplierLabel setFrame:CGRectMake(92+k,13,30,20)];		
		[converterNameLabel setFrame:CGRectMake(48+k,11,42,23)];
		[converterAdditionLabel setFrame:CGRectMake(8+k,40,304,15)];					
		[converterValueTextField setHidden:YES]; 
	}
	else
	{
		[converterFlagImageView setFrame:CGRectMake(10,6,32,32)];
		[multiplierLabel setFrame:CGRectMake(92,13,30,20)];		
		[converterNameLabel setFrame:CGRectMake(48,11,42,23)];
		[converterAdditionLabel setFrame:CGRectMake(8,40,304,15)];	
		[converterValueTextField setHidden:NO]; 
	}

	
}

-(void) moveView:(UIView *) viewP x:(float) pixP {
	CGRect fr = [viewP frame];
	fr.origin.x += pixP;
	[viewP setFrame:fr];
}

- (void)scrollCellToCenterOfScreen:(UIView *)theView {
	
	UITableView *myTable = [[appDelegate converterViewController] myTableView];
	UITableViewCell *myCell = (UITableViewCell *) [theView superview];
	
	int index = [myTable indexPathForCell:myCell].row;
	
	int summ = 0;
	for (int i=0;i<index;i++) {
		ConverterItem *co = [[appDelegate converterViewController].tableDataSource objectAtIndex:i];
		if ([co.additionFactors count]) 
			summ += 60;
		else 
			summ += 45;
		
	}
	
	float cellHeight = myCell.frame.size.height;
	CGFloat viewCenterY = summ + cellHeight / 2;
	
	CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
	
	CGFloat availableHeight = applicationFrame.size.height - 266;	// Remove area covered by keyboard 216 || 80
	
	CGFloat y = viewCenterY - availableHeight / 2.0;
	if (y < 0) {
		y = 0;
	}
	[[[appDelegate converterViewController] myTableView] setContentOffset:CGPointMake(0, y) animated:YES];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[[appDelegate converterViewController].navigationItem setLeftBarButtonItem:cancelButton];
	[[appDelegate converterViewController].navigationItem setRightBarButtonItem:doneButton];
	
	[self setOldValue:textField.text];
	[textField setText:@"0.00"];
	[[[appDelegate converterViewController] datePicker] setHidden:YES];
	[[[appDelegate converterViewController] titleSeg] setSelectedSegmentIndex:-1];			
	[[[appDelegate converterViewController] titleSeg] setEnabled:NO];		
//	[[[appDelegate converterViewController] myTableView] setScrollEnabled:NO];
	
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
	[[appDelegate converterViewController] setTextChanged:NO];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if (![[appDelegate converterViewController] textChanged])
	{
		[converterValueTextField setText:oldValue];
	}

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//	[[appDelegate converterViewController] textEditEnded];
	[textField resignFirstResponder];	
	 
	NSDecimalNumber *nrFromString;
	if (![textField.text length])
		nrFromString = [NSDecimalNumber decimalNumberWithString:@"0"];
	else {
		NSNumber *currentNSNumber = [currencyFormatter numberFromString:textField.text];
		NSString *currentNSString = [currentNSNumber stringValue];
		nrFromString = [NSDecimalNumber decimalNumberWithString:currentNSString];
	}
	
	[self.converter setConverterValue:nrFromString];
		
	[[appDelegate converterViewController] setReferenceItem:self.converter];
	[[[appDelegate converterViewController] myTableView] setContentOffset:CGPointMake(0, 0) animated:YES];	
	[[[appDelegate converterViewController] myTableView] reloadData];
	[[appDelegate converterViewController].navigationItem setLeftBarButtonItem:[appDelegate converterViewController].editButton];
	[[appDelegate converterViewController].navigationItem setRightBarButtonItem:[appDelegate converterViewController].addButton];	

    return YES;
}

- (void) textDidChange:(NSNotification *)note {
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
			
	int currencyScale = 2;
	
	NSLog(@"%d",currencyScale);
	
	NSLog(@"|%@| %d %d %@",string, range.length, range.location, textField.text);
	
	NSNumber *currentNSNumber = [currencyFormatter numberFromString:textField.text];
	NSString *currentNSString = [currentNSNumber stringValue];
	
	if (![string length]) { //Backspace pressed
		NSDecimalNumber *currentNumber = [NSDecimalNumber decimalNumberWithString:currentNSString];
		currentNumber = [currentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10"]];
		NSString *currentNumberString = [selectionFormatter stringFromNumber:currentNumber];
		textField.text = currentNumberString;
		return NO;
	}
	
	//other unallowed char pressed
	NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
	unichar c = [string characterAtIndex:0];
	if (![myCharSet characterIsMember:c]) 
		return NO;
	
	//lenght <= 13
	if ([textField.text length]>12)
		return NO;
	
	NSDecimalNumber *currentNumber = [NSDecimalNumber decimalNumberWithString:currentNSString];
	currentNumber = [currentNumber decimalNumberByMultiplyingByPowerOf10:currencyScale+1];
	currentNumber = [currentNumber decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:string]];
	currentNumber = [currentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, currencyScale)]]];
	
	
	NSString *currentNumberString = [currencyFormatter stringFromNumber:currentNumber];
	
	[textField setText:currentNumberString];
	[[appDelegate converterViewController] setTextChanged:YES];
	
	return NO;
}

- (void)doneAction {

	[[[appDelegate converterViewController] titleSeg] setEnabled:YES];		
	[self textFieldShouldReturn:converterValueTextField];
}

- (void)cancelAction {
	
	[[[appDelegate converterViewController] titleSeg] setEnabled:YES];		
	[[[appDelegate converterViewController] myTableView] setContentOffset:CGPointMake(0, 0) animated:YES];		
	[[appDelegate converterViewController].navigationItem setLeftBarButtonItem:[appDelegate converterViewController].editButton];
	[[appDelegate converterViewController].navigationItem setRightBarButtonItem:[appDelegate converterViewController].addButton];
	[converterValueTextField setText:oldValue];
	[converterValueTextField resignFirstResponder];
//	[self textFieldShouldReturn:converterValueTextField];
}

@end
