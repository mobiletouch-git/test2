//
//  AddNewTaxViewController.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 16.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "AddNewTaxViewController.h"
#import "AdditionFactorItem.h"
#import "Constants.h"
#import "UIFactory.h"
#import "TaxTableViewCell.h"
#import "TaxesViewController.h"

@implementation AddNewTaxViewController

@synthesize additionFactor;
@synthesize taxNameTextField;
@synthesize taxValueTextField;

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:taxNameTextField];	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:taxValueTextField];		
	
	[currencyFormatter release];
	
	[additionFactor release];
	[editedAdditionFactor release];
	
	[taxNameTextField release];
	[taxValueTextField release];
	[saveButton release];
	
	[oldAdditionFactor release];
	[newAdditionFactor release];
	[factorsArray release];
    [super dealloc];
}


- (id)initWithAdditionFactor: (AdditionFactorItem *) addFactor
{
    if ((self = [super init])) {
		//init code
		
		if (addFactor)
		{
			self.title = [NSString stringWithFormat:@"%@", addFactor.factorName];
			editedAdditionFactor = [addFactor retain];
			
			additionFactor = [[AdditionFactorItem alloc] init];
			[additionFactor setFactorName:addFactor.factorName];
			[additionFactor setFactorSign:addFactor.factorSign];
			[additionFactor setFactorValue:addFactor.factorValue];
			
			saveButton = [[UIBarButtonItem alloc] initWithTitle:kSave
														  style:UIBarButtonItemStyleDone 
														 target:self 
														 action:@selector(saveAction)];	
			
		}
		else
		{
			self.title = kAddNewTax;					
			additionFactor = [[AdditionFactorItem alloc] init];
			[additionFactor setFactorValue:[NSDecimalNumber decimalNumberWithString:@"0"]];
			[additionFactor setFactorSign:1];
			
			saveButton = [[UIBarButtonItem alloc] initWithTitle:kAdd
														  style:UIBarButtonItemStyleDone 
														 target:self 
														 action:@selector(saveAction)];				
		}
		[self.navigationItem setRightBarButtonItem:saveButton];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(text1DidChange:) 
													 name:@"UITextFieldTextDidChangeNotification" 
												   object:taxNameTextField];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(text2DidChange:) 
													 name:@"UITextFieldTextDidChangeNotification" 
												   object:taxValueTextField];	
	
	}
    return self;
}

-(void) saveAction
{
	if (editedAdditionFactor) // edited value
	{
		[editedAdditionFactor setFactorName:additionFactor.factorName];
		[editedAdditionFactor setFactorSign:additionFactor.factorSign];
		[editedAdditionFactor setFactorValue:(NSDecimalNumber*)additionFactor.factorValue];
	}
	else
	{
		[[[appDelegate taxesViewController] tableDataSource] addObject:additionFactor];		
	}
	[[appDelegate taxesViewController] refresh];
	
	//Retain new addition factor
	[newAdditionFactor setFactorName:self.additionFactor.factorName];
	[newAdditionFactor setFactorSign:self.additionFactor.factorSign];
	[newAdditionFactor setFactorValue:self.additionFactor.factorValue];
	[newAdditionFactor setChecked:self.additionFactor.checked];
	//Create an array of factors
	if([factorsArray count]==0) //if the array is empty place the factors
	{
		[factorsArray addObject:oldAdditionFactor];
		[factorsArray addObject:newAdditionFactor];
	}
	else //replace the old ones with the current ones
	{
		[factorsArray replaceObjectAtIndex:0 withObject:oldAdditionFactor];
		[factorsArray replaceObjectAtIndex:1 withObject:newAdditionFactor];
	}
	//post the notification and transmit the array to the observer
	[[NSNotificationCenter defaultCenter] postNotificationName:@"taxChanged" object:factorsArray]; 
	//editing is done
	oldHasChanged = NO;
	[self.navigationController popViewControllerAnimated:YES];
	
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	currencyFormatter = [[NSNumberFormatter alloc] init];
	
	[currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[currencyFormatter setMinimumFractionDigits:2];
	[currencyFormatter setMaximumFractionDigits:2];
	[currencyFormatter setRoundingMode:NSNumberFormatterRoundDown];
	//[currencyFormatter setDecimalSeparator:@"."];
	//[currencyFormatter setGroupingSeparator:@","];
	NSLocale* roLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[currencyFormatter setLocale:roLocale];
	
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
	taxNameTextField = [[UITextField alloc] init];
	[taxNameTextField setFrame:CGRectMake(10, 16, 300, 44)];
	taxNameTextField.borderStyle = UITextBorderStyleRoundedRect;
	taxNameTextField.textColor = [UIColor blackColor];
	taxNameTextField.font = [UIFont boldSystemFontOfSize:16.0];
	taxNameTextField.delegate=self;
	taxNameTextField.textAlignment = UITextAlignmentCenter;
	taxNameTextField.backgroundColor = [UIColor clearColor];
	taxNameTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
	taxNameTextField.keyboardType = UIReturnKeyDefault;
	taxNameTextField.placeholder = @"Nume";	
	taxNameTextField.returnKeyType = UIReturnKeyDefault;	
	taxNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	[taxNameTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	taxNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	[self.view addSubview:taxNameTextField];
	
	if ([[self.additionFactor factorName] length])
		[taxNameTextField setText:[self.additionFactor factorName]];
	
	
	taxValueTextField = [[UITextField alloc] init];
	[taxValueTextField setFrame:CGRectMake(205, 76, 105, 44)];
	taxValueTextField.borderStyle = UITextBorderStyleRoundedRect;
	taxValueTextField.textColor = [UIColor blackColor];
	taxValueTextField.font = [UIFont systemFontOfSize:18.0];
	taxValueTextField.delegate=self;
	taxValueTextField.textAlignment = UITextAlignmentRight;
	taxValueTextField.backgroundColor = [UIColor clearColor];
	taxValueTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
	taxValueTextField.keyboardType = UIKeyboardTypeNumberPad;
	
	taxValueTextField.returnKeyType = UIReturnKeyDefault;	
	taxValueTextField.placeholder = @"Valoare";
	taxValueTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	[taxValueTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	//	taxValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	[self.view addSubview:taxValueTextField];
	
	if ([self.additionFactor factorValue])
		[taxValueTextField setText:[currencyFormatter stringFromNumber:[self.additionFactor factorValue]]];
		//[taxValueTextField setText:[NSString stringWithFormat:@"%.2f", [[self.additionFactor factorValue] doubleValue]]];
	
	if ([[self.additionFactor factorName] length])
		[taxValueTextField becomeFirstResponder];
	else
		[taxNameTextField becomeFirstResponder];
	
	minusSignButton = [UIFactory newButtonWithTitle:nil 
											 target:self 
										   selector:@selector (minusAction) 
											  frame:CGRectMake(90,82,32,32)
											  image:[UIImage imageNamed:@"edit_remove.png"] 
									   imagePressed:nil
									  darkTextColor:NO];
	[minusSignButton retain];
	[self.view addSubview:minusSignButton];
	
	plusSignButton = [UIFactory newButtonWithTitle:nil 
											target:self 
										  selector:@selector (plusAction) 
											 frame:CGRectMake(150,82,32,32)
											 image:[UIImage imageNamed:@"edit_add.png"] 
									  imagePressed:nil
									 darkTextColor:NO];
	[plusSignButton retain];
	[self.view addSubview:plusSignButton];
	
	if ([self.additionFactor factorSign] > 0)
		[plusSignButton sendActionsForControlEvents:UIControlEventTouchUpInside];
	if ([self.additionFactor factorSign] < 0)
		[minusSignButton sendActionsForControlEvents:UIControlEventTouchUpInside];
	
	
	
	//initialize and place tableView
	CGRect tableViewFrame = CGRectMake(0.0, 126, 320, 60);
	oneRowTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
	oneRowTableView.delegate = self;
	oneRowTableView.dataSource = self;
	oneRowTableView.autoresizesSubviews = YES;
	oneRowTableView.scrollEnabled=NO;
	[oneRowTableView setBackgroundColor:[UIColor clearColor]];
	oneRowTableView.allowsSelectionDuringEditing= NO; // very important, otherwise cells won't respond to touches
	//[self.view addSubview:oneRowTableView];
	
	[saveButton setEnabled:NO];	
	
	oldAdditionFactor = [[AdditionFactorItem alloc]init];
	newAdditionFactor = [[AdditionFactorItem alloc]init];
	factorsArray = [[NSMutableArray alloc]init];
	oldHasChanged = NO;
}


-(void) plusAction
{
	if (editedAdditionFactor)
	{
		if ([taxNameTextField.text length])
			[saveButton setEnabled:YES];
		
	}
	NSLog(@"Plus selected");
	[plusSignButton removeFromSuperview];
	[plusSignButton setBackgroundImage:[UIImage imageNamed:@"edit_add_pressed.png"]  forState:UIControlStateNormal];
	[self.additionFactor setFactorSign:1];
	
	[minusSignButton removeFromSuperview];
	[minusSignButton setBackgroundImage:[UIImage imageNamed:@"edit_remove.png"]  forState:UIControlStateNormal];
	
	[self.view addSubview:plusSignButton];	
	[self.view addSubview:minusSignButton];		
	[oneRowTableView reloadData];	
}

-(void) minusAction
{
	if (editedAdditionFactor)
	{
		if ([taxNameTextField.text length])		
			[saveButton setEnabled:YES];
	}
	NSLog(@"Minus selected");	
	[minusSignButton removeFromSuperview];
	[minusSignButton setBackgroundImage:[UIImage imageNamed:@"edit_remove_pressed.png"]  forState:UIControlStateNormal];
	[self.additionFactor setFactorSign:-1];	
	
	[plusSignButton removeFromSuperview];
	[plusSignButton setBackgroundImage:[UIImage imageNamed:@"edit_add.png"]  forState:UIControlStateNormal];
	
	[self.view addSubview:minusSignButton];	
	[self.view addSubview:plusSignButton];		
	
	[oneRowTableView reloadData];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Table view methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	static NSString *CellIdentifier = @"Cell";
    
    TaxTableViewCell *cell = (TaxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TaxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	[cell setAdditionFactor:self.additionFactor
					enabled:NO];
	[cell setSpecialRow];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return cell;	
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	//Retain the initial value of the addition factor
	if(oldHasChanged == NO)
	{
		[oldAdditionFactor setFactorName:self.additionFactor.factorName];
		[oldAdditionFactor setFactorSign:self.additionFactor.factorSign];
		[oldAdditionFactor setFactorValue:self.additionFactor.factorValue];
		[oldAdditionFactor setChecked:self.additionFactor.checked];
		oldHasChanged = YES;
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return NO;
}




- (BOOL) textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered {
	
	if (textField == taxNameTextField)
	{
		NSUInteger newLength = [textField.text length] + [textEntered length] - range.length;
		return (newLength > 20) ? NO : YES;
	}
	if (textField == taxValueTextField)
	{
		/*NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
		 BOOL shouldChange = YES;
		 
		 for (int i = 0; i < [textEntered length]; i++) {
		 unichar c = [textEntered characterAtIndex:i];
		 if (![myCharSet characterIsMember:c]) {
		 shouldChange = NO;	
		 }
		 }
		 
		 NSUInteger newLength = [textField.text length] + [textEntered length] - range.length;
		 if (shouldChange)
		 return (newLength > 5) ? NO : YES;*/
		//-----------------------------------------
		int currencyScale = 2;
		
		NSLog(@"%d",currencyScale);
		
		NSLog(@"|%@| %d %d %@",textEntered, range.length, range.location, textField.text);
		
		
		NSNumber *currentNSNumber = [currencyFormatter numberFromString:textField.text ];
		NSString *currentNSString = [currentNSNumber stringValue];
		if (![textEntered length]) { //Backspace pressed
			NSDecimalNumber *currentNumber = [NSDecimalNumber decimalNumberWithString:currentNSString];
			currentNumber = [currentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10"]];
			NSString *currentNumberString = [currencyFormatter stringFromNumber:currentNumber];
			textField.text = currentNumberString;
			return NO;
		}
		
		//other unallowed char pressed
		NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
		unichar c = [textEntered characterAtIndex:0];
		if (![myCharSet characterIsMember:c]) 
			return NO;
		
		//lenght <= 13
		if ([textField.text length]>5)
			return NO;
		
		NSDecimalNumber *currentNumber = [NSDecimalNumber decimalNumberWithString:currentNSString];
		currentNumber = [currentNumber decimalNumberByMultiplyingByPowerOf10:currencyScale+1];
		currentNumber = [currentNumber decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:textEntered]];
		currentNumber = [currentNumber decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",pow(10, currencyScale)]]];
		
		NSString *currentNumberString = [currencyFormatter stringFromNumber:currentNumber];
		
		[textField setText:currentNumberString];
		//		[[appDelegate converterViewController] setTextChanged:YES];
		
		
		return NO;
		//-----------------------------------------
		
	}
	return NO;
}


- (void) text1DidChange:(NSNotification *)note {
	if ([[taxNameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] && [[taxValueTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
		[saveButton  setEnabled:YES];
	else
		[saveButton  setEnabled:NO];
	[self.additionFactor setFactorName:taxNameTextField.text];
	
	[oneRowTableView reloadData];	
}
- (void) text2DidChange:(NSNotification *)note {
	if ([[taxNameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] && [[taxValueTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
		[saveButton  setEnabled:YES];
	else
		[saveButton  setEnabled:NO];
		
	NSNumber* number = [currencyFormatter numberFromString:taxValueTextField.text];
	NSString* string = [NSString stringWithFormat:@"%@",number];
	[self.additionFactor setFactorValue: [NSDecimalNumber decimalNumberWithString:string]];
	
	//[self.additionFactor setFactorValue: [NSDecimalNumber decimalNumberWithString:taxValueTextField.text]];
	[oneRowTableView reloadData];	
}


@end
