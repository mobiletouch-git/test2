//
//  HistoryViewController.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 08.03.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "HistoryViewController.h"
#import "DateFormat.h"
#import "InfoValutarAPI.h"
#import "CurrencyItem.h" 
#import "Constants.h"
#import "Currency.h"
#import "HistoryTableViewCell.h"

@implementation HistoryViewController

@synthesize selectedCurrency;

- (void)dealloc {

	[myTableView release];
	[tableDataSourceDict release];
	[tableDataSource release];
	[yearButton release];
	[doneButton release];
	[cancelButton release];
	[yearArray release];
	[selectedCurrency release];
	
	
    [super dealloc];
}



- (id)init
{
    if ((self = [super init])) {
		//init code
		
		tableDataSourceDict = [[NSMutableDictionary alloc] init];
		tableDataSource = [[NSMutableArray alloc] init];
		yearArray = [[NSMutableArray alloc] init];
		
	}
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
	NSString *currentYear = [NSString stringWithFormat:@"%d", [DateFormat currentYear]];
	
	yearButton = [[UIBarButtonItem alloc] initWithTitle:currentYear
												  style:UIBarButtonItemStyleBordered
												 target:self
												 action:@selector(selectYearAction)];
	[self.navigationItem setRightBarButtonItem:yearButton];
	
	doneButton = [[UIBarButtonItem alloc] initWithTitle:kSave
												  style:UIBarButtonItemStyleDone
												 target:self 
												 action:@selector(doneAction)];
	cancelButton = [[UIBarButtonItem alloc] initWithTitle:kCancel
													style:UIBarButtonItemStyleBordered
												   target:self
												   action:@selector(cancelAction)];	
	
	//initialize and place tableView
	CGRect tableViewFrame = CGRectMake(0.0, 0.0, 320, 417);
	myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.autoresizesSubviews = YES;
	myTableView.scrollEnabled=YES;
	myTableView.allowsSelectionDuringEditing= YES; // very important, otherwise cells won't respond to touches
	[self.view addSubview:myTableView];
	
	NSDate *firstEntryDate = [InfoValutarAPI getExtremityDateForCurrencyNamed:selectedCurrency.currencyName first:YES];
	NSDate *lastEntryDate = [InfoValutarAPI getExtremityDateForCurrencyNamed:selectedCurrency.currencyName first:NO];		
	
	NSInteger minYear = [[DateFormat yearFromDate:firstEntryDate] intValue];
	NSInteger maxYear = [[DateFormat yearFromDate:lastEntryDate] intValue];
	
	NSLog(@"First %d last %d", minYear, maxYear);	
	
	for (int i=maxYear;i>=minYear;i--)
	{
		NSString *currentYearString = [NSString stringWithFormat:@"%d", i];
		[yearArray addObject:currentYearString];
	}
	
	//adding the dictionary picker
	float height = 216.0f; 
	yearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 417.0-height, 320.0, height)];
	yearPicker.delegate=self;
	yearPicker.hidden= YES;
	yearPicker.showsSelectionIndicator = YES;
	yearPicker.backgroundColor=[UIColor whiteColor];
	[self.view addSubview:yearPicker];
	
	if (selectedCurrency.multiplierValue) {
		self.title = [[selectedCurrency.multiplierValue stringValue] stringByAppendingFormat:@" %@",selectedCurrency.currencyName];
	}else
		self.title = selectedCurrency.currencyName;
	[self refreshDataSource];
}


-(void) addOverlay
{
	UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 430)];
	[overlayView setBackgroundColor:[UIColor blackColor]];
	[overlayView setAlpha:0.65];
	[overlayView setTag:100];
	
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(135,150.0,50.0,50.0);
	activityView.hidesWhenStopped = YES;
	[activityView startAnimating];
	
	[overlayView addSubview:activityView];
	[activityView release];
	[self.view addSubview:overlayView];
	[overlayView release];	
}

-(void) refreshDataSource
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int selectedRow = [yearPicker selectedRowInComponent:0];
	NSString *yearString = [yearArray objectAtIndex:selectedRow];
	

	NSString *startDateString = [NSString stringWithFormat:@"01-01-%@ 00:00:01 +0000", yearString];
	NSString *endDateString = [NSString stringWithFormat:@"31-12-%@ 00:00:01 +0000", yearString];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss Z"];
	
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];

	NSDate *startDate = [dateFormatter dateFromString:startDateString];
	NSDate *endDate = [dateFormatter dateFromString:endDateString];
	
	[dateFormatter release];
	
	NSLog(@"Start string %@ end string %@ start date %@ end date %@", startDateString,endDateString,startDate, endDate);
	
	NSMutableArray *bruteData = [InfoValutarAPI getDataForInterval:startDate 
														   endDate:endDate
													  currencyName:selectedCurrency.currencyName];
	
	[self processBruteData:bruteData];
	[pool release];
} 

-(void) processBruteData: (NSArray *) dataArray
{
	[tableDataSource removeAllObjects];
	[tableDataSourceDict removeAllObjects];

	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd-MM-yyyy"];

	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];
	
	for (int i=1;i<=12;i++)
	{
		NSMutableDictionary *dictionaryForMonth = [NSMutableDictionary dictionary];
		
		int selectedRow = [yearPicker selectedRowInComponent:0];
		NSString *yearString = [yearArray objectAtIndex:selectedRow];
		
		NSString *monthDateString = [NSString stringWithFormat:@"01-%d-%@", i, yearString];		
		NSDate *monthDate = [dateFormatter dateFromString:monthDateString];
		
		NSString *monthTitle = [DateFormat monthYearDateString:monthDate];
		NSMutableArray *days = [NSMutableArray array];
		
		[dictionaryForMonth setValue:monthTitle forKey:@"monthName"];
		[dictionaryForMonth setObject:days forKey:@"monthData"];
		
		NSLog(@"Month %d", i);
		[tableDataSourceDict setObject:dictionaryForMonth forKey:[NSString stringWithFormat:@"%d", i]];
	}
	[dateFormatter release];
	
	for (int i=0;i<[dataArray count];i++)
	{
		Currency *managedObject = [dataArray objectAtIndex:i];
		NSDate *currencyDate = [managedObject valueForKey:@"currencyDate"];
		NSString *monthString = [DateFormat monthFromDate:currencyDate];
		NSInteger month = [monthString intValue];

		NSMutableDictionary *dictForMonth = [tableDataSourceDict objectForKey:[NSString stringWithFormat:@"%d", month]];
		NSMutableArray *days = [dictForMonth objectForKey:@"monthData"];
		[days addObject:managedObject];
		[dictForMonth setObject:days forKey:@"monthData"];
	}

	// trim empty months
	for (int i=1;i<=12;i++)
	{
		NSMutableDictionary *dictionaryForMonth = [tableDataSourceDict objectForKey:[NSString stringWithFormat:@"%d", i]];
		NSMutableArray *days = [dictionaryForMonth objectForKey:@"monthData"];	
		if (![days count])
			[tableDataSourceDict removeObjectForKey:[NSString stringWithFormat:@"%d", i]];
		else
		{
			NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"currencyDate" ascending:NO];
			NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
			
			[days sortUsingDescriptors:sortDescriptors];
			
			[sortDescriptor release];
			[sortDescriptors release];
		}
	}
	
	for (int i=12;i>=1;i--)
	{
		NSMutableDictionary *dictForMonth = [tableDataSourceDict objectForKey:[NSString stringWithFormat:@"%d", i]];
		if (dictForMonth)
			[tableDataSource addObject:dictForMonth];
	}
	
	[[self.view viewWithTag:100] removeFromSuperview];
	[self performSelectorOnMainThread:@selector (refreshTable) withObject:nil waitUntilDone:YES];
}

-(void) refreshTable
{
	[myTableView reloadData];	
	[myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


-(void) selectYearAction
{
	yearPicker.hidden=NO;
	[self.navigationItem setLeftBarButtonItem:cancelButton];
	[self.navigationItem setRightBarButtonItem:doneButton];
}


-(void) doneAction{
	yearPicker.hidden=YES;
	[self.navigationItem setLeftBarButtonItem:self.navigationItem.backBarButtonItem];
	[self.navigationItem setRightBarButtonItem:yearButton];
	
	int selectedRow = [yearPicker selectedRowInComponent:0];
	NSString *yearString = [yearArray objectAtIndex:selectedRow];
	[yearButton setTitle:yearString];

	//get new data.
	[self addOverlay];
	[self performSelectorInBackground:(@selector(refreshDataSource)) withObject:nil];		
}

-(void) cancelAction{
	yearPicker.hidden=YES;
	[self.navigationItem setLeftBarButtonItem:self.navigationItem.backBarButtonItem];
	[self.navigationItem setRightBarButtonItem:yearButton];
}

#pragma mark pickerView methods

// Number of wheels 
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{ 
	return 1; 
} 


// Number of rows per wheel
- (NSInteger)pickerView: (UIPickerView *)pView numberOfRowsInComponent: (NSInteger) component  
{
	return [yearArray count]; 
} 

-(void)pickerViewLoaded: (id)blah 
{
//	 [yearPicker selectedRowInComponent:0];
	NSString *currentYear = yearButton.title;
	for (int i=0;i<[yearArray count];i++)
	{
		NSString *currentYearString = [yearArray objectAtIndex:i];
		if ([currentYear isEqualToString:currentYearString])
		{
			[yearPicker selectRow:i inComponent:0 animated:NO];
		}
	}
	[self addOverlay];
	[self performSelectorInBackground:(@selector(refreshDataSource)) withObject:nil];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//	int currentPositionOfPicker = [yearPicker selectedRowInComponent:0];
//	[self pickerViewLoaded:nil];
}

// Return the title of each cell by row and component 
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{ 
	NSString *textToDisplay = [NSString stringWithFormat:@"                    %@",[yearArray objectAtIndex:row]];
	return textToDisplay;
} 

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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
    NSLog(@"number of sections = %i", [tableDataSource count]);
    return [tableDataSource count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSDictionary *dictForMonth = [tableDataSource objectAtIndex:section];
	NSString *monthName = [[dictForMonth valueForKey:@"monthName"] capitalizedString];
	
    return monthName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 30.0;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *dictForMonth = [tableDataSource objectAtIndex:section];	
	NSArray *monthData = [dictForMonth objectForKey:@"monthData"];
	NSLog(@"number of rows = %i", [monthData count]);
    return [monthData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSDictionary *sectionSource = [tableDataSource objectAtIndex:indexPath.section];
	
	NSArray *sectionData = [sectionSource objectForKey:@"monthData"];

    Currency *managedObject = [sectionData objectAtIndex:indexPath.row];
	Currency *previousManagedObject = managedObject;
	

	if (indexPath.row==([sectionData count]-1) && indexPath.section== ([tableDataSource count]-1))
	{
		previousManagedObject = managedObject;
	}
	else if (indexPath.row== ([sectionData count]-1) && (indexPath.section<[tableDataSource count]))
	{
		NSDictionary *sectionSource = [tableDataSource objectAtIndex:indexPath.section+1];
		NSArray *sectionData = [sectionSource objectForKey:@"monthData"];
		if (sectionData)
			previousManagedObject = [sectionData objectAtIndex:0];
	}
	else
	{
		if (indexPath.row+1<[sectionData count])
			previousManagedObject = [sectionData objectAtIndex:indexPath.row+1];
	}
	
	NSDecimalNumber *currentValue = [managedObject valueForKey:@"currencyValue"];
	NSDecimalNumber *previousValue = [previousManagedObject valueForKey:@"currencyValue"];	
	
	NSString *sign;
	NSDecimalNumber *change = [currentValue decimalNumberBySubtracting:previousValue];
	
	if ([change doubleValue]>0)
		sign=@"+";
	else if ([change doubleValue]<0)
		sign=@"-";
	else
		sign=@"=";
	
    // Set up the cell...
	
	[cell setCurrencyDate:[managedObject valueForKey:@"currencyDate"] 
		  multiplierValue:[managedObject valueForKey:@"currencyMultiplier"] 
			currencyValue:[managedObject valueForKey:@"currencyValue"] 
				   change:change 
					 sign:sign];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end

