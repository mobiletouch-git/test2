//
//  ConverterViewController.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 28.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "ConverterViewController.h"
#import "CurrenciesParserDelegate.h"
#import "InfoValutarAPI.h"
#import "DateFormat.h"
#import "Constants.h"
#import "UIFactory.h"
#import "ConverterItem.h"
#import "ConverterTableViewCell.h"
#import "CurrencyPickerViewController.h"
#import "AdditionFactorItem.h"
 
@implementation ConverterViewController

@synthesize editButton, addButton;
@synthesize myTableView, tableDataSource, selectedDate, referenceItem, selectedReferenceDay;

- (void)dealloc {

	[editButton release];
	[addButton release];
	
	[myTableView release];
	[addButton release];
	[editButton release];
	[doneButton release];
	[cancelButton release];
	[referenceItem release];
	[tableDataSource release];
	[selectedReferenceDay release];
	
    [super dealloc];
}


- (id)init
{
    if ((self = [super init])) {
		//init code
		
		//set tabbaritem picture
		UIImage *buttonImage = [UIImage imageNamed:@"tabConverter.png"];
		UITabBarItem *tempTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Convertor" image:buttonImage tag:-1];
		self.tabBarItem = tempTabBarItem;
		[tempTabBarItem release];
		
		self.title = @"Convertor";		
	}
    return self;
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
	
	doneButton = [[UIBarButtonItem alloc] initWithTitle:kDone
												  style:UIBarButtonItemStyleDone
												 target:self 
												 action:@selector(doneAction)];
	cancelButton = [[UIBarButtonItem alloc] initWithTitle:kCancel
													style:UIBarButtonItemStyleBordered
												   target:self
												   action:@selector(cancelAction)];	
	
	addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
															   target:self
															   action:@selector(addAction)];
	[self.navigationItem setRightBarButtonItem:addButton];
	
	editButton = [[UIBarButtonItem alloc] initWithTitle:kEdit
																   style:UIBarButtonItemStyleBordered
																  target:self 
																  action:@selector(editAction)];
	[self.navigationItem setLeftBarButtonItem:editButton];
	
	
	NSDate *todayDate = [DateFormat normalizeDateFromDate:[NSDate date]];
	[self setSelectedDate:todayDate];
	NSString *todayString = [DateFormat DBformatDateFromDate:self.selectedDate];

	tableDataSource = [[NSMutableArray alloc] init];	
	selectedReferenceDay = [[NSMutableArray alloc] init];	
	
	
	NSData *data = [[NSUserDefaults standardUserDefaults ] objectForKey:@"converterList"];
	NSMutableArray *savedList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	if ([savedList count])
		[tableDataSource addObjectsFromArray:savedList];
	else
		[self addDefaultConverterValues];
	
	
	NSData *data2 = [[NSUserDefaults standardUserDefaults ] objectForKey:@"converterReferenceItem"];
	ConverterItem *storedReferenceItem = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
	if (storedReferenceItem)
		referenceItem = [storedReferenceItem retain];

	
	NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:[self selectedDate]];
	if (validBankingDate)
	{
		if (![validBankingDate isEqualToDate:[self selectedDate]])
			[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul valutar valid corespondent zilei selectate este de pe data de %@", [DateFormat DBformatDateFromDate:validBankingDate]]
							 title:@"Atentie!"];

		NSMutableArray *selectedCurrencies = [InfoValutarAPI getCurrenciesForDate:validBankingDate];
		if ([selectedCurrencies count])
			[selectedReferenceDay addObjectsFromArray:selectedCurrencies];
	}
	else
		[UIFactory showOkAlert:@"Nu exista informatii in baza de date pentru data selectata" title:@"Atentie!"];	
	
	
	//initialize and place tableView
	CGRect tableViewFrame = CGRectMake(0.0, 0.0, 320, 368);
	myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.autoresizesSubviews = YES;
	myTableView.scrollEnabled=YES;
	myTableView.allowsSelectionDuringEditing= YES; // very important, otherwise cells won't respond to touches
	[self.view addSubview:myTableView];
	
	titleButton = [[UIButton alloc] initWithFrame:CGRectMake(60,10,160,30)];
	titleButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	[titleButton setTitle:todayString forState:UIControlStateNormal];	
	[titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];	
	[titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
	
	UIImage *newImage = [[UIImage imageNamed:@"title_button.png"]  stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[titleButton setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [[UIImage imageNamed:@"title_button.png"]  stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[titleButton setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	[titleButton addTarget:self action:@selector (titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	// in case the parent view draws with a custom color or gradient, use a transparent color
	titleButton.backgroundColor = [UIColor clearColor];
	[titleButton setShowsTouchWhenHighlighted:YES];
	
	
	[self.navigationItem setTitleView:titleButton];	
	
	float height = 216.0f; 
	datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0.0, 369.0-height, 320.0, height)];
	datePicker.datePickerMode = UIDatePickerModeDate;
	[datePicker setUserInteractionEnabled:YES];	
	if (self.selectedDate)
		[datePicker setDate:self.selectedDate animated:YES];
	[datePicker setHidden:YES];
	[datePicker setMaximumDate:[NSDate date]];
	[self.view addSubview:datePicker];
	
}

-(void) addDefaultConverterValues
{
/* ======= RON ======= */	
	CurrencyItem *c1 = [[CurrencyItem alloc] init];
	[c1 setCurrencyName:@"RON"];
	[c1 setCurrencyValue:@"1"];
	
	ConverterItem *co1 = [[ConverterItem alloc] init];
	[co1 setCurrency:c1];
	[c1 release];
	
	[tableDataSource addObject:co1];
	[co1 release];
/* ======= RON ======= */
	
/* ======= RON +19 % ======= */	
	CurrencyItem *c2 = [[CurrencyItem alloc] init];
	[c2 setCurrencyName:@"RON"];
	[c2 setCurrencyValue:@"1"];
	
	ConverterItem *co2 = [[ConverterItem alloc] init];
	[co2 setCurrency:c2];
	
	NSMutableArray *factors = [NSMutableArray array];
	
	AdditionFactorItem *af = [[AdditionFactorItem alloc] init];
	[af setFactorSign:1];
	[af setFactorValue:[NSNumber numberWithDouble:19]];
	[factors addObject:af];
	[af release];
	
	[co2 setAdditionFactors:factors];
	[c2 release];
	
	[tableDataSource addObject:co2];
	[co2 release];
/* ======= RON +19 % ======= */		

/* ======= RON +19 % + 3% ======= */	

	CurrencyItem *c3 = [[CurrencyItem alloc] init];
	[c3 setCurrencyName:@"RON"];
	[c3 setCurrencyValue:@"1"];	
	
	ConverterItem *co3 = [[ConverterItem alloc] init];
	[co3 setCurrency:c3];
	
	NSMutableArray *factorss = [NSMutableArray array];
	
	AdditionFactorItem *af1 = [[AdditionFactorItem alloc] init];
	[af1 setFactorSign:1];
	[af1 setFactorValue:[NSNumber numberWithDouble:19]];
	[factorss addObject:af1];
	[af1 release];
	
	AdditionFactorItem *af2 = [[AdditionFactorItem alloc] init];
	[af2 setFactorSign:1];
	[af2 setFactorValue:[NSNumber numberWithDouble:3]];
	[factorss addObject:af2];
	[af2 release];
	
	[co3 setAdditionFactors:factorss];
	
	[c3 release];
	
	[tableDataSource addObject:co3];
	[co3 release];

/* ======= RON +19 % + 3% ======= */		
	
/* ======= EUR  ======= */	
	CurrencyItem *c4 = [[CurrencyItem alloc] init];
	[c4 setCurrencyName:@"EUR"];
	
	ConverterItem *co4 = [[ConverterItem alloc] init];
	[co4 setCurrency:c4];
	[c4 release];
	
	[tableDataSource addObject:co4];
	[co4 release];
/* ======= EUR  ======= */	
	
/* ======= USD  ======= */	
	CurrencyItem *c5 = [[CurrencyItem alloc] init];
	[c5 setCurrencyName:@"USD"];

	ConverterItem *co5 = [[ConverterItem alloc] init];
	[co5 setCurrency:c5];
	[c5 release];
	
	[tableDataSource addObject:co5];
	[co5 release];
/* ======= EUR  ======= */		
	
}

-(void) addAction
{
	NSLog(@"Add action");
	/*
	AddConverterItemViewController *addView = [[AddConverterItemViewController alloc] init];
	UINavigationController *addNavigation = [[UINavigationController alloc] initWithRootViewController:addView];
	[self.navigationController presentModalViewController:addNavigation animated:YES];
	[addNavigation release];
	[addView release];
	 */
	CurrencyPickerViewController *addView = [[CurrencyPickerViewController alloc] init];
	[addView setIsPushed:NO];
	UINavigationController *addNavigation = [[UINavigationController alloc] initWithRootViewController:addView];
	[self.navigationController presentModalViewController:addNavigation animated:YES];
	[addNavigation release];
	[addView release];
	
}

-(void) editAction
{
	NSLog(@"Edit action");	
	[myTableView setEditing:YES];
	[self.navigationItem setLeftBarButtonItem:doneButton];
	[self.navigationItem setRightBarButtonItem:nil];
	[myTableView reloadData];
}

-(void) cancelAction
{
	NSLog(@"Cancel action");		
	if (!datePicker.hidden)
	{
		[self.navigationItem setLeftBarButtonItem:editButton];
		[self.navigationItem setRightBarButtonItem:addButton];
		[datePicker setHidden:YES];		
	}
}

-(void) doneAction
{
	NSLog(@"Done action");		
	if (!datePicker.hidden)
	{
		NSDate *selDate = [DateFormat normalizeDateFromDate:[datePicker date]];
		[self setSelectedDate:selDate];
		[titleButton setTitle:[DateFormat DBformatDateFromDate:self.selectedDate] forState:UIControlStateNormal];
		
		[self.navigationItem setLeftBarButtonItem:editButton];
		[self.navigationItem setRightBarButtonItem:addButton];
		[datePicker setHidden:YES];		
		
		[selectedReferenceDay removeAllObjects];
		NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:[self selectedDate]];
		if (validBankingDate)
		{
			if (![validBankingDate isEqualToDate:[self selectedDate]])
				[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul valutar valid corespondent zilei selectate este de pe data de %@", [DateFormat DBformatDateFromDate:validBankingDate]]
								 title:@"Atentie!"];
		
			NSMutableArray *selectedCurrencies = [InfoValutarAPI getCurrenciesForDate:validBankingDate];
			if ([selectedCurrencies count])
				[selectedReferenceDay addObjectsFromArray:selectedCurrencies];
		}
		else
			[UIFactory showOkAlert:@"Nu exista informatii in baza de date pentru data selectata" title:@"Atentie!"];	
	}
	if (myTableView.editing)
	{
		[myTableView setEditing:NO];
		[self.navigationItem setLeftBarButtonItem:editButton];
		[self.navigationItem setRightBarButtonItem:addButton];

	}
	[myTableView reloadData];	
}

-(void) titleButtonAction:(id) sender
{
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[self.navigationItem setRightBarButtonItem:doneButton];
	[datePicker setHidden:NO];		
}

-(void) populate
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"database" ofType:@"xml"];
	NSData *xmlData = [NSData dataWithContentsOfFile:path];

	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: xmlData];

	CurrenciesParserDelegate *parserDelegate = [[CurrenciesParserDelegate alloc] init];
	[xmlParser setDelegate:parserDelegate];
	[xmlParser setShouldProcessNamespaces:YES];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
	
	BOOL success = [xmlParser parse];
	
	if(success)
	{
	}
	else {
		NSLog(@"Parsing error");
	}
	
	[xmlParser setDelegate:nil];
	[xmlParser abortParsing];
	[xmlParser release];
	[parserDelegate release];	
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
	return [tableDataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 53.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    ConverterTableViewCell *cell = (ConverterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[ConverterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	ConverterItem *co = [tableDataSource objectAtIndex:indexPath.row];
	CurrencyItem *currencyForConverter = [InfoValutarAPI findCurrencyNamed:[co.currency currencyName] inArray:selectedReferenceDay];
	if (currencyForConverter)
		[co setCurrency:currencyForConverter];
	
	
	if ([[referenceItem.currency currencyName] isEqualToString:@"RON"])
	{
		double normalizedAmount = [InfoValutarAPI getBaseValueForConverterItem:referenceItem];
		
		for (int i=0;i<[co.additionFactors count];i++)
		{
			AdditionFactorItem *af = [co.additionFactors objectAtIndex:i];
			if (af.factorSign>0)
				normalizedAmount = normalizedAmount + ([af.factorValue doubleValue]/100) * normalizedAmount;
			if (af.factorSign<0)
				normalizedAmount = normalizedAmount - ([af.factorValue doubleValue]/100) * normalizedAmount;
		}
		
		normalizedAmount = normalizedAmount / [[co.currency currencyValue] doubleValue];
		[co setConverterValue:[NSNumber numberWithDouble:normalizedAmount]];		
	}
	else
	{
		double normalizedAmount = [InfoValutarAPI getBaseValueForConverterItem:referenceItem];
		normalizedAmount = normalizedAmount * [[referenceItem.currency currencyValue] doubleValue];

		for (int i=0;i<[co.additionFactors count];i++)
		{
			AdditionFactorItem *af = [co.additionFactors objectAtIndex:i];
			if (af.factorSign>0)
				normalizedAmount = normalizedAmount + ([af.factorValue doubleValue]/100) * normalizedAmount;
			if (af.factorSign<0)
				normalizedAmount = normalizedAmount - ([af.factorValue doubleValue]/100) * normalizedAmount;
		}
		
		normalizedAmount = normalizedAmount / [[co.currency currencyValue] doubleValue];
		[co setConverterValue:[NSNumber numberWithDouble:normalizedAmount]];		
	}
	
	[cell setConverterItem:co];
	[cell setEditing:myTableView.editing];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	return cell;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Selected");
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	ConverterItem *movedObject = [[[self tableDataSource] objectAtIndex:sourceIndexPath.row] retain];
	[[self tableDataSource] removeObjectAtIndex:sourceIndexPath.row];
	[[self tableDataSource] insertObject: movedObject atIndex: destinationIndexPath.row];
	[movedObject release];
	movedObject=nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
	return kDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (tableView.editing)
	{
			return UITableViewCellEditingStyleDelete;
	}		
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSLog(@"Delete the cell");
		// Animate the deletion from the table.
		[tableDataSource removeObjectAtIndex:indexPath.row];	
	}
	[myTableView reloadData];
}


@end
