//
//  ConverterTableViewCell.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
// emy

#import "ConverterTableViewCell.h"
#import "UIFactory.h"
#import "ConverterViewController.h"
#import "Constants.h"
#import "AdditionFactorItem.h"
#import "ConverterViewController.h"
#import "SensitiveTableView.h"

@implementation ConverterTableViewCell

@synthesize converter, oldValue;


- (void)dealloc {
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	
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
		
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelAction) name:@"UIApplicationDidEnterBackgroundNotification" object:nil];
		
		 converterFlagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,6,32,32)];
		[self addSubview:converterFlagImageView];
		
		converterNameLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:17 bold:YES];
		[converterNameLabel setFrame:CGRectMake(40,11,75,23)];
		[converterNameLabel setTextAlignment:UITextAlignmentLeft];		
		converterNameLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:converterNameLabel];	
		
		//multiplierLabel = [UIFactory newLabelWithPrimaryColor:[UIColor blackColor] selectedColor:[UIColor whiteColor] fontSize:12 bold:YES];
		//[multiplierLabel setFrame:CGRectMake(92,15,30,20)];
		//[multiplierLabel setFont:[UIFont systemFontOfSize:12]];
		//[multiplierLabel setTextColor:[UIColor lightGrayColor]];
		//[multiplierLabel setBackgroundColor:[UIColor blackColor]];
		//multiplierLabel.adjustsFontSizeToFitWidth=YES;			
		//[self addSubview:multiplierLabel];		
		
		converterAdditionLabel = [UIFactory newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:12 bold:YES];
		[converterAdditionLabel setBackgroundColor:[UIColor clearColor]];
		[converterAdditionLabel setFrame:CGRectMake(8,40,304,15)];
		[converterAdditionLabel setTextAlignment:UITextAlignmentLeft];		
		converterAdditionLabel.adjustsFontSizeToFitWidth=YES;			
		[self addSubview:converterAdditionLabel];		
		
		converterValueTextField = [[UITextField alloc] init];
		[converterValueTextField setFrame:CGRectMake(110, 8, 200,30)];
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
		
		NSLocale *roLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
		
		currencyFormatter = [[NSNumberFormatter alloc] init];
		[currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[currencyFormatter setMinimumFractionDigits:2];
		[currencyFormatter setMaximumFractionDigits:2];
		[currencyFormatter setLocale: roLocale];
		
		selectionFormatter = [[NSNumberFormatter alloc] init];
		[selectionFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[selectionFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[selectionFormatter setMinimumFractionDigits:2];
		[selectionFormatter setMaximumFractionDigits:2];
		[selectionFormatter setRoundingMode:NSNumberFormatterRoundDown];
		[selectionFormatter setLocale: roLocale];
		
    }
    return self;
}

-(void) setConverterItem: (ConverterItem *) aConverter
{
	[self setConverter:aConverter];
	
	CurrencyItem *ci = [aConverter currency];
	NSString *labelString=nil;
	
	if (ci)
	{
		NSString *imageName = [NSString stringWithFormat:@"%@.png", [ci currencyName]];
		UIImage *flagImage = [UIImage imageNamed:imageName];
		[converterFlagImageView setImage:flagImage?flagImage:nil];	
	
		if ([ci.multiplierValue intValue]){
			labelString=[NSString stringWithFormat:@"%d%@",[ci.multiplierValue intValue],[ci currencyName]];
//			[multiplierLabel setText:[NSString stringWithFormat:@"x%d", [ci.multiplierValue intValue]]];
		}
		else{
//			[multiplierLabel setText:@""];	
			labelString=[ci currencyName];
		}
				
	}
	
	//NSString *labelString = [NSString stringWithString: [ci currencyName]];
	[converterNameLabel setText:labelString];
	
	NSString *additionString = @"";
	for (int i=0;i<[aConverter.additionFactors count];i++)
	{
		AdditionFactorItem *af = [aConverter.additionFactors objectAtIndex:i];
		if (af.factorSign>0)
			additionString = [additionString stringByAppendingFormat:@" + %@",[[currencyFormatter stringFromNumber:af.factorValue]stringByAppendingString:@"%"]];
			//additionString = [additionString stringByAppendingFormat:@" + %.2f%%", [af.factorValue doubleValue]];
		if (af.factorSign<0)
			additionString = [additionString stringByAppendingFormat:@" - %@",[[currencyFormatter stringFromNumber:af.factorValue]stringByAppendingString:@"%"]];
			//additionString = [additionString stringByAppendingFormat:@" - %.2f%%", [af.factorValue doubleValue]];
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
	const int k = 40;
	if (yesOrNo)
	{
		[converterFlagImageView setFrame:CGRectMake(5+k,6,32,32)];
		//[multiplierLabel setFrame:CGRectMake(82+k,13,30,20)];		
		[converterNameLabel setFrame:CGRectMake(40+k,11,75,23)];
		[converterAdditionLabel setFrame:CGRectMake(8+k,40,304,15)];					
		[converterValueTextField setHidden:YES]; 
	}
	else
	{
		[converterFlagImageView setFrame:CGRectMake(5,6,32,32)];
		//[multiplierLabel setFrame:CGRectMake(82,13,30,20)];		
		[converterNameLabel setFrame:CGRectMake(40,11,75,23)];
		[converterAdditionLabel setFrame:CGRectMake(8,40,304,15)];	
		[converterValueTextField setHidden:NO]; 
	}

	
}


#pragma mark UITextFieldDelegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

	[[appDelegate converterViewController].navigationItem setLeftBarButtonItem:cancelButton];
	[[appDelegate converterViewController].navigationItem setRightBarButtonItem:doneButton];
	
	[self setOldValue:textField.text];
	[textField setText:@"0,00"];
	[[[appDelegate converterViewController] datePicker] setHidden:YES];
	[[[appDelegate converterViewController] titleSeg] setSelectedSegmentIndex:-1];			
	[[[appDelegate converterViewController] titleSeg] setEnabled:NO];		
	
	CGRect textFieldFrame = [self.superview convertRect:textField.frame fromView:self];	
	[(SensitiveTableView *)self.superview setRelativeTextFieldFrame:textFieldFrame];
	[(SensitiveTableView *)self.superview setCallBackObject:self];
	[(SensitiveTableView *)self.superview setCallBackSelector:@selector (textFieldShouldReturn:)];
	[(SensitiveTableView *)self.superview setTextField:textField];
	
	
	[NSTimer scheduledTimerWithTimeInterval:0.3 
									 target:self
								   selector:@selector (shrinkTable) 
								   userInfo:nil 
									repeats:NO];
	return YES;
}

-(void) shrinkTable
{
	
	if (!((SensitiveTableView *)self.superview).isShrinked)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.1];
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

#if defined(CONVERTOR)	
	[(SensitiveTableView *)self.superview setFrame:CGRectMake(0, kTopPadding, 320, [[self superview] superview].frame.size.height - ((216-kTopPadding)+50))];
#else
	[(SensitiveTableView *)self.superview setFrame:CGRectMake(0, 0, 320, [[self superview] superview].frame.size.height - (216-50))];
#endif		
		

		[UIView commitAnimations];	
	}
	
}

- (void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	
	((SensitiveTableView *)self.superview).isShrinked=YES;
	CGRect textFieldFrame = ((SensitiveTableView *)self.superview).relativeTextFieldFrame;	
	[(SensitiveTableView *)self.superview scrollRectToVisible:textFieldFrame animated:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[[appDelegate converterViewController] setTextChanged:NO];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	NSLog(@"textFieldDidEndEditing in ConverterTableViewCell");
	if (![[appDelegate converterViewController] textChanged])
	{
		[converterValueTextField setText:oldValue];
	}else {
		[self textFieldShouldReturn:textField];
	}
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	NSLog(@"called");
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
	//[[[appDelegate converterViewController] myTableView] setContentOffset:CGPointMake(0, 0) animated:YES];	
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[(SensitiveTableView *)self.superview setFrame:CGRectMake(0.0, kTopPadding, 320, 368-kTopPadding)];
	[UIView commitAnimations];
	((SensitiveTableView *)self.superview).isShrinked=NO;
	
	[[[appDelegate converterViewController] myTableView] reloadData];
	
	if(!appDelegate.tableViewIsInEditMode){
		[[appDelegate converterViewController].navigationItem setLeftBarButtonItem:[appDelegate converterViewController].editButton];
		[[appDelegate converterViewController].navigationItem setRightBarButtonItem:[appDelegate converterViewController].addButton];	
	}

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
	
	//lenght <= 18
	if ([textField.text length]>17)
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
	if (!converterValueTextField.editing) {
		return;
	}
	NSLog(@"cancel Action: convertorTableViewCell");
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[(SensitiveTableView *)self.superview setFrame:CGRectMake(0.0, kTopPadding, 320, 368-kTopPadding)];
	[UIView commitAnimations];
	((SensitiveTableView *)self.superview).isShrinked=NO;	
	
	[[[appDelegate converterViewController] titleSeg] setEnabled:YES];		
	[[appDelegate converterViewController].navigationItem setLeftBarButtonItem:[appDelegate converterViewController].editButton];
	[[appDelegate converterViewController].navigationItem setRightBarButtonItem:[appDelegate converterViewController].addButton];
	[converterValueTextField setText:oldValue];
	[converterValueTextField resignFirstResponder];
}

@end
