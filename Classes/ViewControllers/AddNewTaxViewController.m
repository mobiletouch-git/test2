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


- (void)dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:taxNameTextField];	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:taxValueTextField];		

	[additionFactor release];
	[editedAdditionFactor release];
	
	[taxNameTextField release];
	[taxValueTextField release];
	[saveButton release];

	
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
		[editedAdditionFactor setFactorValue:additionFactor.factorValue];
	}
	else
	{
		[[[appDelegate taxesViewController] tableDataSource] addObject:additionFactor];		
	}
	[[appDelegate taxesViewController] refresh];
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
	taxValueTextField.placeholder = @"Nume";	
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
	taxValueTextField.textAlignment = UITextAlignmentLeft;
	taxValueTextField.backgroundColor = [UIColor clearColor];
	taxValueTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
	taxValueTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	taxValueTextField.returnKeyType = UIReturnKeyDefault;	
	taxValueTextField.placeholder = @"Valoare";
	taxValueTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	[taxValueTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	taxValueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	[self.view addSubview:taxValueTextField];
	
	if ([self.additionFactor factorValue])
		[taxValueTextField setText:[NSString stringWithFormat:@"%.2f", [[self.additionFactor factorValue] doubleValue]]];

	[taxValueTextField becomeFirstResponder];
	
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
	[self.view addSubview:oneRowTableView];
	
	[saveButton setEnabled:NO];	
}


-(void) plusAction
{
	[saveButton setEnabled:YES];
	signSelected = YES;
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
	[saveButton setEnabled:YES];	
	signSelected = YES;	
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
	
	[cell setAdditionFactor:self.additionFactor enabled:NO];
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
		NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
		BOOL shouldChange = YES;
		
		for (int i = 0; i < [textEntered length]; i++) {
			unichar c = [textEntered characterAtIndex:i];
			if (![myCharSet characterIsMember:c]) {
				shouldChange = NO;	
			}
		}
		
		NSUInteger newLength = [textField.text length] + [textEntered length] - range.length;
		if (shouldChange)
			return (newLength > 5) ? NO : YES;
	}
	return NO;
}


- (void) text1DidChange:(NSNotification *)note {
	if ([[taxNameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] && [[taxValueTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] && signSelected)
		[saveButton  setEnabled:YES];
	else
		[saveButton  setEnabled:NO];
	
	[self.additionFactor setFactorName:taxNameTextField.text];
	[oneRowTableView reloadData];	
}
- (void) text2DidChange:(NSNotification *)note {
	if ([[taxNameTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] && [[taxValueTextField.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]] length] && signSelected)
		[saveButton  setEnabled:YES];
	else
		[saveButton  setEnabled:NO];


	[self.additionFactor setFactorValue: [NSNumber numberWithDouble:[taxValueTextField.text doubleValue]]];
	[oneRowTableView reloadData];	
}


@end
