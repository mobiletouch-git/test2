//
//  DatePickerViewController.m
//  ETCM
//
//  Created by Mobile Touch SRL on 20.11.2009.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import "DatePickerViewController.h"
#import "StatisticsViewController.h"
#import "UIFactory.h"
#import "DateFormat.h"

@implementation DatePickerViewController

@synthesize editingTextField;
@synthesize editingValue;
@synthesize stringForTitle;	
@synthesize stringForTextFieldValue;
@synthesize stringForNotice;
@synthesize parent;


- (void)dealloc {
	
	[editingTextField release];
	
	[editingValue release];
	[stringForTitle release];
	[stringForTextFieldValue release];
	[stringForNotice release];
	[parent release];
	[datePicker release];
	[saveButton release];
	
    [super dealloc];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
	

	editingTextField =[[UITextField alloc] initWithFrame:CGRectMake(20,20,280,35)];
	editingTextField.backgroundColor = [UIColor clearColor];
	editingTextField.borderStyle = UITextBorderStyleRoundedRect;
    editingTextField.textColor = [UIColor blackColor];
	editingTextField.font = [UIFont systemFontOfSize:17.0];
    editingTextField.placeholder = stringForTitle?stringForTitle:@"Value";
	editingTextField.returnKeyType = UIReturnKeyDone;	
	editingTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	editingTextField.userInteractionEnabled=YES;
	[editingTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[editingTextField setTextAlignment:UITextAlignmentCenter];
	editingTextField.clearButtonMode = UITextFieldViewModeAlways;	// has a clear 'x' button to the 
	editingTextField.delegate=self;
	[editingTextField setText:stringForTextFieldValue?stringForTextFieldValue:@""];

	
	[self.view addSubview:editingTextField];
	
	UILabel *noticeLabel = [UIFactory newLabelWithPrimaryColor:[UIColor darkGrayColor] 
												 selectedColor:[UIColor darkGrayColor]
													  fontSize:14 
														  bold:NO];
	[noticeLabel setBackgroundColor:[UIColor clearColor]];
	[noticeLabel setFrame:CGRectMake(20,50,280,100)];
	[noticeLabel setNumberOfLines:0];
	[noticeLabel setText:stringForNotice?stringForNotice:@""];	
	[self.view addSubview:noticeLabel];	
	
	
	saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"")
												  style:UIBarButtonItemStyleDone 
												 target:self 
												 action:@selector(saveAction)];	
	
	[self.navigationItem setRightBarButtonItem:saveButton];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
																	 style:UIBarButtonItemStyleBordered
																	target:self 
																	action:@selector(cancelAction)];	
	
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[cancelButton release];
	
	
	float height = 216.0f; 
	datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0.0, 369.0-height, 320.0, height)];
	datePicker.datePickerMode = UIDatePickerModeDate;
	[datePicker setUserInteractionEnabled:YES];	
	NSDate *dateToSelect = stringForTextFieldValue? [DateFormat dateFromNormalizedString:stringForTextFieldValue]:nil;
	NSDate *todayDate = [DateFormat normalizeDateFromDate:[NSDate date]];
	if (dateToSelect)
		[datePicker setDate:dateToSelect animated:NO];

	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: [((StatisticsViewController *)parent) dateRangeDictionary]];
	
	NSString *sDate = [dict valueForKey:@"startDate"];
	NSString *eDate = [dict valueForKey:@"endDate"];
	if ([editingValue isEqualToString:@"startDate"])
		if (eDate)
		{
			NSDate *maxDate = [DateFormat dateFromNormalizedString:eDate];
			[datePicker setMaximumDate:maxDate];
			if (!dateToSelect)
			{
				if (!([todayDate compare:maxDate] == NSOrderedDescending))
					[datePicker setDate:todayDate animated:NO];
				else
					[datePicker setDate:maxDate animated:NO];				
			}
			else
			{
				if (([dateToSelect compare:maxDate] == NSOrderedDescending) || ([dateToSelect compare:maxDate] == NSOrderedSame))				
					[datePicker setDate:maxDate animated:NO];						
			}
		}
	
	if ([editingValue isEqualToString:@"endDate"])
		if (sDate)
		{
			NSDate *minDate = [DateFormat dateFromNormalizedString:sDate];
			[datePicker setMinimumDate:minDate];
			if (!dateToSelect)
			{
			if (!([todayDate compare:minDate] == NSOrderedAscending))
				[datePicker setDate:todayDate animated:NO];
			else
				[datePicker setDate:minDate animated:NO];
			}
			else
			{
				if (([dateToSelect compare:minDate] == NSOrderedAscending) || ([dateToSelect compare:minDate] == NSOrderedSame))				
					[datePicker setDate:minDate animated:NO];						
			}
			

		}
	
	[datePicker addTarget:self action:@selector(updateTextFieldWithDate) forControlEvents:UIControlEventValueChanged];	
	[self.view addSubview:datePicker];

	
}
-(void) updateTextFieldWithDate{

	NSString *dateString = [DateFormat normalizedStringFromDate: datePicker.date];
	[editingTextField setText:dateString];
}


-(void) saveAction{
	
	NSLog (@"Saving...");
	
	NSString *currentString = nil;
	if ([editingTextField.text length])
		currentString = editingTextField.text;
	
	if ([parent isKindOfClass:[StatisticsViewController class]]) {
		
		[[((StatisticsViewController *)parent) dateRangeDictionary] setValue:currentString forKey:editingValue];
		[[((StatisticsViewController *)parent) dateRangeTableView] reloadData];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) cancelAction{
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self setTitle:stringForTitle?stringForTitle:@"Edit Value"];
	[self updateTextFieldWithDate];
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

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return NO;
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	return YES;
}


@end
