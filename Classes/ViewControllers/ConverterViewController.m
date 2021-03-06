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
#import "AdWhirlView.h"

@implementation ConverterViewController

@synthesize editButton, addButton, titleSeg, textChanged, referenceConverterValue;
@synthesize myTableView, tableDataSource, selectedDate, referenceItem, selectedReferenceDay;
@synthesize datePicker;
@synthesize converterHasBeenUpdated;



- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter]removeObserver:self name:@"taxChanged" object:nil];
	
	[editButton release];
	[addButton release];
	
	[myTableView release];
	[addButton release];
	[editButton release];
	[doneButton release];
	[cancelButton release];
	
	[titleSeg release];
	
	[referenceItem release];
	[tableDataSource release];
	[selectedReferenceDay release];
	
    [super dealloc];
}

-(void)populateTableSource
{
	NSData *data = [[NSUserDefaults standardUserDefaults ] objectForKey:@"converterList"];
	NSMutableArray *savedList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	converterHasBeenUpdated = [[NSUserDefaults standardUserDefaults]boolForKey:@"converterUpdated"];
	
	if([savedList count] == 0)
	{//there are no values stored in NSUserDefaults load default values
		[self addDefaultConverterValues];
		converterHasBeenUpdated = YES;
	}
	else //There are values stored in NSUserDefaults
	{
		if(converterHasBeenUpdated == NO)
		{
			//loop through all items of the list and select those that have addition factors
			for(int i=0;i<[savedList count];i++)
			{
				if( ((ConverterItem*)[savedList objectAtIndex:i]).additionFactors != nil)
				{
					//get a list of the addition factors
					NSMutableArray* additionArray = ((ConverterItem*)[savedList objectAtIndex:i]).additionFactors;
					//search for addition factors named TVA
					for(int j=0;j<[additionArray count];j++)
					{
						if( [((AdditionFactorItem*)[additionArray objectAtIndex:j]).factorName isEqualToString:@"TVA"] == YES || ((AdditionFactorItem*)[additionArray objectAtIndex:j]).factorName == nil )
						{
							//if found, the TVA addition factor value is changed and then reassigned to the ConverterItem
							((AdditionFactorItem*)[additionArray objectAtIndex:j]).factorValue = [NSDecimalNumber decimalNumberWithString:@"24"];
							[(ConverterItem*)[savedList objectAtIndex:i] setAdditionFactors:additionArray];
						}
					}
				}
				converterHasBeenUpdated = YES;
			}
		}
		//The value for TVA is now correct and can be saved in tableDataSource
		[tableDataSource addObjectsFromArray:savedList];
	}
	
}


-(void)taxHasChanged:(NSNotification *)notification 
{
	NSLog(@"Converter has detected that the tax has changed");
	NSArray *array = [notification object];
	AdditionFactorItem* oldFa = [array objectAtIndex:0];
	AdditionFactorItem* newFa = [array objectAtIndex:1];
	NSLog(@"old: %@, %@ **** new: %@, %@",oldFa.factorName, oldFa.factorValue, newFa.factorName, newFa.factorValue);

	for(int i=0;i<[tableDataSource count];i++)
	{
		if( ((ConverterItem*)[tableDataSource objectAtIndex:i]).additionFactors != nil )
		{
			NSLog(@"Old Converter Item: %@",((ConverterItem*)[tableDataSource objectAtIndex:i]).additionFactors);
			NSMutableArray* addFactors = ((ConverterItem*)[tableDataSource objectAtIndex:i]).additionFactors;
			for(int j=0;j<[addFactors count];j++)
			{
				if( [((AdditionFactorItem*)[addFactors objectAtIndex:j]).factorName isEqualToString:oldFa.factorName] == YES 
				   || ((AdditionFactorItem*)[addFactors objectAtIndex:j]).factorName == nil)
				{
					[addFactors replaceObjectAtIndex:j withObject:newFa];
					((ConverterItem*)[tableDataSource objectAtIndex:i]).additionFactors = addFactors;
				}
			}
			NSLog(@"New Converter Item: %@",((ConverterItem*)[tableDataSource objectAtIndex:i]).additionFactors);
		}
	}
	[myTableView reloadData];
}

- (id)init
{
    if ((self = [super init])) {
		//init code
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAction) name:@"Resign date picker" object:nil];

		
		//set tabbaritem picture
		UIImage *buttonImage = [UIImage imageNamed:@"icon_tab_1.png"];
		UITabBarItem *tempTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Convertor" image:buttonImage tag:-1];
		self.tabBarItem = tempTabBarItem;
		[tempTabBarItem release];
		
		self.title = @"Convertor";		
		
		NSDate *todayDate = [DateFormat normalizeDateFromDate:[NSDate date]];
		NSDate *utcDate = [InfoValutarAPI getUTCFormateDateFromDate:todayDate];
		[self setSelectedDate:utcDate];
		
		NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:[self selectedDate]];
		
		[self setSelectedDate:validBankingDate];
		
	
		tableDataSource = [[NSMutableArray alloc] init];	
		selectedReferenceDay = [[NSMutableArray alloc] init];	
		
	
		[self populateTableSource];
		
		NSData *data2 = [[NSUserDefaults standardUserDefaults ] objectForKey:@"converterReferenceItem"];
		ConverterItem *storedReferenceItem = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
		if (storedReferenceItem)
			referenceItem = [storedReferenceItem retain];
		
		
		//NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:[self selectedDate]];
		if (validBankingDate)
		{
			NSMutableArray *selectedCurrencies;
			if ([appDelegate displayValidMode])
				selectedCurrencies = [InfoValutarAPI getValidCurrenciesForDate:validBankingDate];
			else
				selectedCurrencies = [InfoValutarAPI getCurrenciesForDate:validBankingDate];
			
			if ([selectedCurrencies count])
			{
				[selectedReferenceDay removeAllObjects];
				[selectedReferenceDay addObjectsFromArray:selectedCurrencies];
			}
		}
		else
			[UIFactory showOkAlert:@"Aplicaţia conţine informaţii începând cu 05/01/2009." title:nil];	

		CurrencyItem *updatedCurrency = [InfoValutarAPI findCurrencyNamed:[referenceItem.currency currencyName] inArray:selectedReferenceDay];
		if (updatedCurrency)
			[referenceItem setCurrency:updatedCurrency];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(taxHasChanged:) 
													 name:@"taxChanged" 
												   object:nil];
		 
		
	}
    return self;
}



-(void) updateCurrentDate {
	
	NSDate *todayDate = [DateFormat normalizeDateFromDate:[NSDate date]];
	NSDate *utcDate = [InfoValutarAPI getUTCFormateDateFromDate:todayDate];
	[self setSelectedDate:utcDate];
	
	NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:[self selectedDate]];
	
	[self setSelectedDate:validBankingDate];
	
	[titleSeg setTitle:[DateFormat businessStringFromDate:self.selectedDate] forSegmentAtIndex:0];
	
	[datePicker setDate:self.selectedDate animated:NO];
	[datePicker setMinimumDate:[DateFormat dateFromNormalizedString:@"05-01-2009"]];
	[datePicker setMaximumDate:selectedDate];

	if (validBankingDate)
	{
		NSMutableArray *selectedCurrencies;
		if ([appDelegate displayValidMode]){
			//NSLog(@"valabil");
			selectedCurrencies = [InfoValutarAPI getValidCurrenciesForDate:validBankingDate];
		}
		else{
			//NSLog(@"licitat");
			selectedCurrencies = [InfoValutarAPI getCurrenciesForDate:validBankingDate];
		}
		if ([selectedCurrencies count])
		{
			[selectedReferenceDay removeAllObjects];			
			[selectedReferenceDay addObjectsFromArray:selectedCurrencies];
		}
	}
	else
		[UIFactory showOkAlert:@"Aplicaţia conţine informaţii începând cu 05/01/2009." title:nil];	
	
	CurrencyItem *updatedCurrency = [InfoValutarAPI findCurrencyNamed:[referenceItem.currency currencyName] inArray:selectedReferenceDay];
	if (updatedCurrency)
		[referenceItem setCurrency:updatedCurrency];
	
	[myTableView reloadData];
		
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


-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	NSLog(@"view will appear");
	if (appDelegate.updateCurrentDateConverter) {
		[self updateCurrentDate];
		appDelegate.updateCurrentDateConverter = NO;
	}
	
	
}

-(void)viewWillDisappear:(BOOL)animated{
	if (myTableView.editing) {
		[self doneAction];
	}else if (!datePicker.hidden){
		return;
	}else if (datePicker.hidden&&[tableDataSource count]) {
		[self.navigationItem setLeftBarButtonItem:editButton];
	}else {
		[self.navigationItem setLeftBarButtonItem:nil];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0]; 
	NSLog(@"%@",path);


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
	if ([tableDataSource count]) {
		[self.navigationItem setLeftBarButtonItem:editButton];
	}else {
		[self.navigationItem setLeftBarButtonItem:nil];
	}
	
	
	
	//initialize and place tableView
	CGRect tableViewFrame = CGRectMake(0.0, kTopPadding, 320, 368-kTopPadding);
	myTableView = [[SensitiveTableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.autoresizesSubviews = YES;
	myTableView.scrollEnabled=YES;
	myTableView.allowsSelectionDuringEditing= YES; // very important, otherwise cells won't respond to touches
	//adds separator space between table cells and keyboard
	myTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 20, 0);
	myTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);

	[self.view addSubview:myTableView];
	
	NSString *todayString = [DateFormat businessStringFromDate:self.selectedDate];	
	
	titleSeg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:todayString]];
	[titleSeg setFrame:CGRectMake(0, 0, 100, 30)];
	[titleSeg addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventValueChanged];
	[titleSeg setSegmentedControlStyle:UISegmentedControlStyleBar];
	
	[self.navigationItem setTitleView:titleSeg];	
	
	float height = 216.0f; 
	datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0.0, 369.0-height, 320.0, height)];
	datePicker.datePickerMode = UIDatePickerModeDate;
	[datePicker setUserInteractionEnabled:YES];	
	if (self.selectedDate)
		[datePicker setDate:self.selectedDate animated:YES];
	[datePicker setHidden:YES];
	[datePicker setMaximumDate:selectedDate];

	[self.view addSubview:datePicker];
	
#ifdef CONVERTOR
	[self.view addSubview:[InfoValutarAPI displayCompanyLogo]];
	[self.view addSubview:[AdWhirlView requestAdWhirlViewWithDelegate:self]];	
#endif		
	
}

#pragma mark ARRollerDelegate required delegate method implementation
- (NSString *)adWhirlApplicationKey
{
	return kAdWhirlApplicationKey;
}

- (void)adWhirlDidReceiveAd:(AdWhirlView *)adWhirlView
{
	NSLog(@"Did receive add");
	[[self.view viewWithTag:111] removeFromSuperview];
}

- (void)adWhirlDidReceiveConfig:(AdWhirlView *)adWhirlView {
	NSLog(@"Received config");
}

- (UIViewController *)viewControllerForPresentingModalView {
	
	return self.navigationController;
}

- (NSURL *)adWhirlConfigURL {
	return [NSURL URLWithString:kSampleConfigURL];
}


- (void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo
{
	NSLog(@"Did fail add");	
}

-(void) addDefaultConverterValues
{
	/* ======= RON ======= */	
	CurrencyItem *c1 = [[CurrencyItem alloc] init];
	[c1 setCurrencyName:@"RON"];
	NSDecimalNumber *c1Value = [NSDecimalNumber decimalNumberWithString:@"1"];
	[c1 setCurrencyValue:c1Value];
	
	ConverterItem *co1 = [[ConverterItem alloc] init];
	[co1 setCurrency:c1];
	[co1 setConverterValue:[NSDecimalNumber decimalNumberWithString:@"0"]];
	[c1 release];
	
	[tableDataSource addObject:co1];
	[self setReferenceItem:co1];	
	[co1 release];
	/* ======= RON ======= */
	
	/* ======= RON +24 % ======= */	
	CurrencyItem *c2 = [[CurrencyItem alloc] init];
	[c2 setCurrencyName:@"RON"];
	NSDecimalNumber *c2Value = [NSDecimalNumber decimalNumberWithString:@"1"];	
	[c2 setCurrencyValue:c2Value];
	
	ConverterItem *co2 = [[ConverterItem alloc] init];
	[co2 setCurrency:c2];
	[co2 setConverterValue:[NSDecimalNumber decimalNumberWithString:@"0"]];	
	NSMutableArray *factors = [NSMutableArray array];
	
	AdditionFactorItem *af = [[AdditionFactorItem alloc] init];
	[af setFactorName:@"TVA"];
	[af setFactorSign:1];
	[af setFactorValue:[NSDecimalNumber decimalNumberWithString:@"24"]];	
	[factors addObject:af];
	[af release];
	
	[co2 setAdditionFactors:factors];
	[c2 release];
	
	[tableDataSource addObject:co2];
	[co2 release];
	/* ======= RON +24 % ======= */		

	/* ======= EUR  ======= */	
	CurrencyItem *c4 = [[CurrencyItem alloc] init];
	[c4 setCurrencyName:@"EUR"];
	
	ConverterItem *co4 = [[ConverterItem alloc] init];
	[co4 setCurrency:c4];
	[co4 setConverterValue:[NSDecimalNumber decimalNumberWithString:@"0"]];	
	[c4 release];
	
	[tableDataSource addObject:co4];
	[co4 release];
	/* ======= EUR  ======= */	
	
	/* ======= USD  ======= */	
	CurrencyItem *c5 = [[CurrencyItem alloc] init];
	[c5 setCurrencyName:@"USD"];
	
	ConverterItem *co5 = [[ConverterItem alloc] init];
	[co5 setCurrency:c5];
	[co5 setConverterValue:[NSDecimalNumber decimalNumberWithString:@"0"]];		
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
	[appDelegate setTableViewIsInEditMode:YES];
	[self.navigationItem setLeftBarButtonItem:doneButton];
	[self.navigationItem setRightBarButtonItem:nil];
	[titleSeg setHidden:YES];
	[datePicker setHidden:YES];
	[myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];	
	[myTableView reloadData];	
}


-(void) cancelAction
{
	NSLog(@"Cancel action");
	NSLog(@"is table editing:%d",myTableView.editing);
	if(myTableView.editing == NO){
		if (!datePicker.hidden)
		{
			if ([tableDataSource count]) {
				[self.navigationItem setLeftBarButtonItem:editButton];
			}else {
				[self.navigationItem setLeftBarButtonItem:nil];
			}
			[self.navigationItem setRightBarButtonItem:addButton];
			[datePicker setHidden:YES];		
		}
		[titleSeg setSelectedSegmentIndex:-1];		
		[titleSeg setHidden:NO];		
	}
}

-(void) doneAction
{
	NSLog(@"Done action");		
	if (!datePicker.hidden)
	{
		NSDate *selDate = [DateFormat normalizeDateFromDate:[datePicker date]];
		NSDate *utcDate = [InfoValutarAPI getUTCFormateDateFromDate:selDate];
		[self setSelectedDate:utcDate];
//		[titleButton setTitle:[DateFormat DBformatDateFromDate:self.selectedDate] forState:UIControlStateNormal];
		[titleSeg setTitle:[DateFormat businessStringFromDate:self.selectedDate] forSegmentAtIndex:0];
		
		if ([tableDataSource count]) {
			[self.navigationItem setLeftBarButtonItem:editButton];
		}else {
			[self.navigationItem setLeftBarButtonItem:nil];
		}
		
		[self.navigationItem setRightBarButtonItem:addButton];
		
		[datePicker setHidden:YES];		
		
		NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:[self selectedDate]];
		if (validBankingDate)
		{
			/*
			if (![validBankingDate isEqualToDate:[self selectedDate]]) {
				[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul valutar BNR licitat pentru %@ a fost stabilit în data de %@", [DateFormat businessStringFromDate:[self selectedDate]], [DateFormat businessStringFromDate:validBankingDate]]
								 title:nil];
			 */
				[self setSelectedDate:validBankingDate];
				[titleSeg setTitle:[DateFormat businessStringFromDate:self.selectedDate] forSegmentAtIndex:0];

			NSMutableArray *selectedCurrencies;
			if ([appDelegate displayValidMode])
				selectedCurrencies = [InfoValutarAPI getValidCurrenciesForDate:validBankingDate];				
			else
				selectedCurrencies = [InfoValutarAPI getCurrenciesForDate:validBankingDate];
			if ([selectedCurrencies count])
			{
				[selectedReferenceDay removeAllObjects];				
				[selectedReferenceDay addObjectsFromArray:selectedCurrencies];
			}

			CurrencyItem *updatedCurrency = [InfoValutarAPI findCurrencyNamed:[referenceItem.currency currencyName] inArray:selectedReferenceDay];
			if (updatedCurrency)
				[referenceItem setCurrency:updatedCurrency];			
		}
		else
			[UIFactory showOkAlert:@"Aplicaţia conţine informaţii începând cu 05/01/2009." title:nil];		
	}
	if (myTableView.editing)
	{
		[myTableView setEditing:NO];
		[appDelegate setTableViewIsInEditMode:NO];
		if ([tableDataSource count]) {
			[self.navigationItem setLeftBarButtonItem:editButton];
		}else {
			[self.navigationItem setLeftBarButtonItem:nil];
		}
		[self.navigationItem setRightBarButtonItem:addButton];
		
	}

	[titleSeg setSelectedSegmentIndex:-1];	
	[titleSeg setHidden:NO];	
	
	[myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];		
	[myTableView reloadData];	
}

-(void) textEditEnded {
	//end edit
	NSLog(@"textEditEnded");
	if ([tableDataSource count]) {
		[self.navigationItem setLeftBarButtonItem:editButton];
	}else {
		[self.navigationItem setLeftBarButtonItem:nil];
	}
	[self.navigationItem setRightBarButtonItem:addButton];	
}


-(void) titleButtonAction:(id) sender
{
	if ([titleSeg selectedSegmentIndex]>-1)
	{
		[self.navigationItem setLeftBarButtonItem:cancelButton];
		[self.navigationItem setRightBarButtonItem:doneButton];
		[datePicker setHidden:NO];	
	}
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
	//return 56.0;
	ConverterItem *co = [tableDataSource objectAtIndex:indexPath.row];
	if ([co.additionFactors count])
		return 60;
	else 
		return 45;
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
	
	NSDecimalNumber *decimal100 = [NSDecimalNumber decimalNumberWithString:@"100"];
	
	if ([[referenceItem.currency currencyName] isEqualToString:@"RON"])
	{
		NSDecimalNumber *normalizedAmount = [InfoValutarAPI getBaseValueForConverterItem:referenceItem];
		
		for (int i=0;i<[co.additionFactors count];i++)
		{
			AdditionFactorItem *af = [co.additionFactors objectAtIndex:i];
			if (af.factorSign>0)
			{
				//				normalizedAmount = normalizedAmount + ([af.factorValue doubleValue]/100) * normalizedAmount;
				NSDecimalNumber *rez = [[af.factorValue decimalNumberByDividingBy:decimal100] decimalNumberByMultiplyingBy:normalizedAmount];
				normalizedAmount = [normalizedAmount decimalNumberByAdding:rez];
			}
			if (af.factorSign<0)
			{
				//				normalizedAmount = normalizedAmount - ([af.factorValue doubleValue]/100) * normalizedAmount;
				NSDecimalNumber *rez = [[af.factorValue decimalNumberByDividingBy:decimal100] decimalNumberByMultiplyingBy:normalizedAmount];
				normalizedAmount = [normalizedAmount decimalNumberBySubtracting:rez];
			}
		}
		
		//		normalizedAmount = normalizedAmount / [[co.currency currencyValue] doubleValue];
		if ([co.currency currencyValue])
			normalizedAmount = [normalizedAmount decimalNumberByDividingBy:[co.currency currencyValue]];
		[co setConverterValue:normalizedAmount];		
	}
	else
	{
		NSDecimalNumber *normalizedAmount = [InfoValutarAPI getBaseValueForConverterItem:referenceItem];
		//		normalizedAmount = normalizedAmount * [[referenceItem.currency currencyValue] doubleValue];
		if (referenceItem)
		{
			normalizedAmount = [normalizedAmount decimalNumberByMultiplyingBy:[referenceItem.currency currencyValue]];
			
			for (int i=0;i<[co.additionFactors count];i++)
			{
				AdditionFactorItem *af = [co.additionFactors objectAtIndex:i];
				if (af.factorSign>0)
				{
					//				normalizedAmount = normalizedAmount + ([af.factorValue doubleValue]/100) * normalizedAmount;
					NSDecimalNumber *rez = [[af.factorValue decimalNumberByDividingBy:decimal100] decimalNumberByMultiplyingBy:normalizedAmount];
					normalizedAmount = [normalizedAmount decimalNumberByAdding:rez];
				}
				if (af.factorSign<0)
				{
					//				normalizedAmount = normalizedAmount - ([af.factorValue doubleValue]/100) * normalizedAmount;
					NSDecimalNumber *rez = [[af.factorValue decimalNumberByDividingBy:decimal100] decimalNumberByMultiplyingBy:normalizedAmount];
					normalizedAmount = [normalizedAmount decimalNumberBySubtracting:rez];				
				}
			}
			//		normalizedAmount = normalizedAmount / [[co.currency currencyValue] doubleValue];
			if ([co.currency currencyValue])
				normalizedAmount = [normalizedAmount decimalNumberByDividingBy:[co.currency currencyValue]];
			
		}
		else
			[normalizedAmount decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0"]];
		
		[co setConverterValue:normalizedAmount];		
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
