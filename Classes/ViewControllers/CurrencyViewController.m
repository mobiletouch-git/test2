//
//  CurrencyViewController.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 28.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "CurrencyViewController.h"
#import "CurrencyTableViewCell.h"
#import "CurrencyItem.h"
#import "Currency.h"
#import "UIFactory.h"
#import "DateFormat.h"
#import "Constants.h"
#import "InfoValutarAPI.h"
#import "HistoryViewController.h"

#import "AdWhirlView.h"
#import "AdWhirlDelegateProtocol.h"

@implementation CurrencyViewController

@synthesize tableDataSource, selectedDate;

- (void)dealloc {
	[titleSeg release];
	[previousReferenceDay release];
	[tableDataSource release];
	[myTableView release];
	[selectedDate release];
	
	[doneButton release];
	[editButton release];
	[cancelButton release];
	[updateButton release];
	
    [super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
		//init code
		
		//set tabbaritem picture
		UIImage *buttonImage = [UIImage imageNamed:@"icon_tab_1.png"];
		UITabBarItem *tempTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Curs BNR" image:buttonImage tag:0];
		self.tabBarItem = tempTabBarItem;
		[tempTabBarItem release];
		
		self.title = @"Curs BNR";
		
		NSDate *todayDate = [DateFormat normalizeDateFromDate:[NSDate date]];
		NSDate *utcDate = [InfoValutarAPI getUTCFormateDateFromDate:todayDate];
		[self setSelectedDate:utcDate];
		
		NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:selectedDate];
		
		[self setSelectedDate:validBankingDate];	
		
		float height = 216.0f; 
		datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0.0, 369.0-height, 320.0, height)];
		datePicker.datePickerMode = UIDatePickerModeDate;
		[datePicker setUserInteractionEnabled:YES];	
		if (self.selectedDate)
			[datePicker setDate:self.selectedDate animated:YES];
		[datePicker setHidden:YES];
		//	[datePicker setMaximumDate:[NSDate date]];
		[datePicker setMaximumDate:selectedDate];
		[self.view addSubview:datePicker];
		
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


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	doneButton = [[UIBarButtonItem alloc] initWithTitle:kSave
												  style:UIBarButtonItemStyleDone
												 target:self 
												 action:@selector(doneAction)];
	cancelButton = [[UIBarButtonItem alloc] initWithTitle:kCancel
													style:UIBarButtonItemStyleBordered
												   target:self
												   action:@selector(cancelAction)];	
	editButton = [[UIBarButtonItem alloc] initWithTitle:kOrder
													style:UIBarButtonItemStyleBordered
												   target:self
												   action:@selector(editAction)];	

	[self.navigationItem setLeftBarButtonItem:editButton];


//	NSString *todayString = [DateFormat DBformatDateFromDate:self.selectedDate];	
	NSString *todayString = [DateFormat businessStringFromDate:self.selectedDate];	

	
	
	// initialization side for the current day
	
	previousReferenceDay = [[NSMutableArray alloc] init];	
	tableDataSource = [[NSMutableArray alloc] init];	
	
	[tableDataSource removeAllObjects];
	[previousReferenceDay removeAllObjects];	

	/*
	updateButton = [[UIBarButtonItem alloc] initWithTitle:kUpdate
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(updateAction)];	
	 */
	updateButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																 target:self 
																 action:@selector(updateAction)];
	[self.navigationItem setRightBarButtonItem:updateButton];
	[self pageUpdate];		



#if defined(CONVERTOR)	
	[self.view addSubview:[InfoValutarAPI displayCompanyLogo]];
	[self.view addSubview:[AdWhirlView requestAdWhirlViewWithDelegate:self]];	
#else
	
#endif	
	
	transparentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 22.0)];
	[transparentView setBackgroundColor:[UIColor clearColor]];	

	CGRect tableViewFrame = CGRectMake(0.0, kTopPadding, 320, 368-kTopPadding);
	//initialize and place tableView
	myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.autoresizesSubviews = YES;
	myTableView.scrollEnabled=YES;
	myTableView.allowsSelectionDuringEditing= YES; // very important, otherwise cells won't respond to touches
	[self.view addSubview:myTableView];
	
	[self.view addSubview:[self getHeaderView]];	
	
	titleSeg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:todayString]];
	[titleSeg setFrame:CGRectMake(0, 0, 100, 30)];
	[titleSeg addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventValueChanged];
	[titleSeg setSegmentedControlStyle:UISegmentedControlStyleBar];

	[self.navigationItem setTitleView:titleSeg];	
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

- (void)adWhirlDidFailToReceiveAd:(AdWhirlView *)adWhirlView usingBackup:(BOOL)yesOrNo
{
	NSLog(@"Did fail add");	
}



-(void) updateAction
{
	[appDelegate checkForUpdates];
}


-(void) updateCurrentDate {
	
	NSDate *todayDate = [DateFormat normalizeDateFromDate:[NSDate date]];
	NSDate *utcDate = [InfoValutarAPI getUTCFormateDateFromDate:todayDate];
	[self setSelectedDate:utcDate];
	
	NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:[self selectedDate]];
	
	[self setSelectedDate:validBankingDate];
	
	[titleSeg setTitle:[DateFormat businessStringFromDate:self.selectedDate] forSegmentAtIndex:0];

	[datePicker setDate:self.selectedDate animated:NO];
	[datePicker setMaximumDate:selectedDate];

	[self pageUpdate];
	
	[self doneAction];

	
}

-(void) titleButtonAction:(id) sender
{
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[self.navigationItem setRightBarButtonItem:doneButton];
	[datePicker setHidden:NO];		
	[titleSeg setSelectedSegmentIndex:-1];
}

-(void) pageUpdate
{
	[tableDataSource removeAllObjects];
	[previousReferenceDay removeAllObjects];	
	
	NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:selectedDate];
	
	if (validBankingDate)
	{
		if (![validBankingDate isEqualToDate:[self selectedDate]])
			[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul valutar valid corespondent zilei selectate este de pe data de %@", [DateFormat DBformatDateFromDate:validBankingDate]]
							 title:@"Atenție!"];
		
		[tableDataSource removeAllObjects];		
		[tableDataSource addObjectsFromArray:[InfoValutarAPI getCurrenciesForDate:validBankingDate]];
		
		NSDate *prevValidBankingDate = [DateFormat getPreviousDayForDay:validBankingDate];
		NSDate *validBankingDate2 = [InfoValutarAPI getValidBankingDayForDay:prevValidBankingDate];

		[previousReferenceDay removeAllObjects];		
		if (validBankingDate2)
			[previousReferenceDay addObjectsFromArray:[InfoValutarAPI getCurrenciesForDate:validBankingDate2]];	
		else
			[previousReferenceDay addObjectsFromArray:[InfoValutarAPI getCurrenciesForDate:validBankingDate]];	
		
		[self organizeTableSourceWithPriorities];
		[myTableView reloadData];
	}
	else
		[UIFactory showOkAlert:@"Nu exista informatii in baza de date pentru data selectata" title:@"Atenție!"];
}

-(void) doneAction
{
	if (!datePicker.hidden)
	{
		NSDate *selDate = [DateFormat normalizeDateFromDate:[datePicker date]];
		NSDate *utcDate = [InfoValutarAPI getUTCFormateDateFromDate:selDate];
		[self setSelectedDate:utcDate];
	//	[titleButton setTitle:[DateFormat DBformatDateFromDate:self.selectedDate] forState:UIControlStateNormal];
		[titleSeg setTitle:[DateFormat businessStringFromDate:self.selectedDate] forSegmentAtIndex:0];
		
		[self.navigationItem setLeftBarButtonItem:editButton];
		[self.navigationItem setRightBarButtonItem:updateButton];
		[datePicker setHidden:YES];		

		
		// =========== table Data Source =========== //
		[tableDataSource removeAllObjects];
		[previousReferenceDay removeAllObjects];
		
		NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:[self selectedDate]];
		
		if (validBankingDate)
		{
			if (![validBankingDate isEqualToDate:[self selectedDate]]) {
				[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul valutar valid corespondent zilei selectate este de pe data de %@", [DateFormat businessStringFromDate:validBankingDate]]
								 title:@"Atenție!"];
				[self setSelectedDate:validBankingDate];
				[titleSeg setTitle:[DateFormat businessStringFromDate:self.selectedDate] forSegmentAtIndex:0];


			}
			[tableDataSource addObjectsFromArray:[InfoValutarAPI getCurrenciesForDate:validBankingDate]];
			
			NSDate *prevValidBankingDate = [DateFormat getPreviousDayForDay:validBankingDate];
			NSDate *validBankingDate2 = [InfoValutarAPI getValidBankingDayForDay:prevValidBankingDate];
			if (validBankingDate2)
				[previousReferenceDay addObjectsFromArray:[InfoValutarAPI getCurrenciesForDate:validBankingDate2]];	
			else
				[previousReferenceDay addObjectsFromArray:[InfoValutarAPI getCurrenciesForDate:validBankingDate]];	
			
			[self organizeTableSourceWithPriorities];			
		}
		else
			[UIFactory showOkAlert:@"Nu exista informatii in baza de date pentru data selectata" title:@"Atenție!"];	

	}
	else if (myTableView.editing)
	{
		
		NSMutableDictionary *priorities = [NSMutableDictionary dictionary];
		for (int i=0;i<[tableDataSource count];i++)
		{
			CurrencyItem *cur = [tableDataSource objectAtIndex:i];
			[priorities setObject:cur forKey:[NSString stringWithFormat:@"%d", i]];
		}
		
		NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
		//write tabbar position
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:priorities];
		[prefs setObject:data forKey:@"priorityList"];
		[prefs synchronize];
		
		[self.navigationItem setLeftBarButtonItem:editButton];
		[self.navigationItem setRightBarButtonItem:updateButton];
		[myTableView setEditing:NO];	
		[self organizeTableSourceWithPriorities];
		
		[self.navigationItem setRightBarButtonItem:updateButton];
	}	
	[titleSeg setHidden:NO];	
	[myTableView reloadData];	
}


-(void) organizeTableSourceWithPriorities
{

	NSLog(@"Total currencies before processing %d", [tableDataSource count]);
	NSLog(@"Total previous before processing %d", [previousReferenceDay count]);		
	
	NSData *data = [[NSUserDefaults standardUserDefaults ] objectForKey:@"priorityList"];
	NSMutableDictionary *priorities = [NSKeyedUnarchiver unarchiveObjectWithData:data];

	if (priorities)
	{
		NSMutableArray *organizedDay = [NSMutableArray array];
		NSMutableArray *organizedPrevious = [NSMutableArray array];

		for (int i=0;i<[tableDataSource count];i++)
		{
			CurrencyItem *ci1 = [InfoValutarAPI getCurrencyForPriority:i inDictionary:priorities];				
			if (ci1)
			{
				CurrencyItem *valid =  [InfoValutarAPI findCurrencyNamed:ci1.currencyName inArray:tableDataSource];
				if (valid)
				{
					[organizedDay addObject:valid];
				
					CurrencyItem *ci2 = [InfoValutarAPI findCurrencyNamed:valid.currencyName inArray:previousReferenceDay];
					if (ci2)
						[organizedPrevious addObject:ci2];
					else 
						[organizedPrevious addObject:valid];
				}
			}
			
		}
		
		for (int j=0;j<[tableDataSource count];j++)
		{
			CurrencyItem *retrieved = [tableDataSource objectAtIndex:j];
			CurrencyItem *toFind = [InfoValutarAPI findCurrencyNamed:retrieved.currencyName inArray:organizedDay];
			if (!toFind)
				[organizedDay addObject:retrieved];
		}	
		
		for (int k=0;k<[previousReferenceDay count];k++)
		{
			CurrencyItem *retrieved = [previousReferenceDay objectAtIndex:k];
			CurrencyItem *toFind = [InfoValutarAPI findCurrencyNamed:retrieved.currencyName inArray:organizedPrevious];
			if (!toFind)
				[organizedPrevious addObject:retrieved];
		}		
		
		[tableDataSource removeAllObjects];
		[tableDataSource addObjectsFromArray:organizedDay];
		
		[previousReferenceDay removeAllObjects];
		[previousReferenceDay addObjectsFromArray:organizedPrevious];

		NSLog(@"Total currencies after processing %d", [tableDataSource count]);
		NSLog(@"Total previous after processing %d", [previousReferenceDay count]);	
	}
}
		
-(void) cancelAction
{

	if (!datePicker.hidden)
	{
	[self.navigationItem setLeftBarButtonItem:editButton];
	[self.navigationItem setRightBarButtonItem:updateButton];
	[datePicker setHidden:YES];	
	}
	[titleSeg setHidden:NO];	
}

-(void) editAction
{
	[myTableView setEditing:YES];
	
	[titleSeg setHidden:YES];
	[self.navigationItem setRightBarButtonItem:nil];
	
	[myTableView reloadData];
	[self.navigationItem setLeftBarButtonItem:doneButton];
}


-(UIView *) getHeaderView
{
	UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_transparent.png"]];
	[headerView setFrame:CGRectMake(0.0, kTopPadding, 320.0, 22.0)];
	
	UILabel *l1 = [UIFactory newLabelWithPrimaryColor:[UIColor whiteColor]
										selectedColor:[UIColor whiteColor] 
											 fontSize:14 
												 bold:YES];
	[l1 setBackgroundColor:[UIColor clearColor]];
	[l1 setFrame:CGRectMake(10,3,70,16)];
	[l1 setText:@"Moneda"];
	[headerView addSubview:l1];
	
	UILabel *l2 = [UIFactory newLabelWithPrimaryColor:[UIColor whiteColor]
										selectedColor:[UIColor whiteColor] 
											 fontSize:14 
												 bold:YES];
	[l2 setBackgroundColor:[UIColor clearColor]];
	[l2 setFrame:CGRectMake(110,3,90,16)];
	[l2 setText:@"Cotație RON"];
	[headerView addSubview:l2];
	
	UILabel *l3 = [UIFactory newLabelWithPrimaryColor:[UIColor whiteColor]
										selectedColor:[UIColor whiteColor] 
											 fontSize:14 
												 bold:YES];
	[l3 setBackgroundColor:[UIColor clearColor]];
	[l3 setFrame:CGRectMake(225,3,70,16)];
	[l3 setText:@"Variație"];
	[headerView addSubview:l3];		
	
	return headerView;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	return transparentView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 22;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [tableDataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 42;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"CurrencyTableViewCell";
	
	CurrencyTableViewCell *cell = (CurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CurrencyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}	
	
    // Set up the cell...
	
	CurrencyItem *currencyObject=nil;	
	currencyObject = [tableDataSource objectAtIndex:indexPath.row];
	
	CurrencyItem *prevCurrency = nil;
	prevCurrency = [previousReferenceDay objectAtIndex:indexPath.row];
	
	NSString *sign;
	NSDecimalNumber *change = [currencyObject.currencyValue decimalNumberBySubtracting:prevCurrency.currencyValue];

	if ([change doubleValue]>0)
		sign=@"+";
	else if ([change doubleValue]<0)
		sign=@"-";
	else
		sign=@"=";

	
	if (currencyObject)
		[((CurrencyTableViewCell *)cell) setCurrencyImageName:[NSString stringWithFormat:@"%@.png",[currencyObject currencyName] ] 
												 currencyName:[currencyObject currencyName] 
											  multiplierValue:[currencyObject multiplierValue]?[currencyObject multiplierValue]:nil
												currencyValue:[currencyObject currencyValue]
													   change:change
														 sign:sign];

	cell.selectionStyle = UITableViewCellSelectionStyleBlue;			
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[cell enterEditMode:myTableView.editing];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	HistoryViewController *historyView = [[HistoryViewController alloc] init];

	CurrencyItem *currencyObject = [tableDataSource objectAtIndex:indexPath.row];
	[historyView setSelectedCurrency:currencyObject];
	
	[historyView setHidesBottomBarWhenPushed:YES];
	[self.navigationController pushViewController:historyView animated:YES];
	[historyView release];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

	Currency *movedObject = [[tableDataSource objectAtIndex:sourceIndexPath.row] retain];	
	[tableDataSource removeObjectAtIndex:sourceIndexPath.row];
	[tableDataSource insertObject:movedObject atIndex:destinationIndexPath.row];
	[movedObject release];
	movedObject=nil;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

@end
