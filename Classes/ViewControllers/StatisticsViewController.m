//
//  StatisticsViewController.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 28.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "StatisticsViewController.h"
#import "UIFactory.h"
#import "GraphViewController.h"
#import "DatePickerViewController.h"
#import "Constants.h"
#import "LightCurrencyTableViewCell.h"
#import "CurrencyPickerViewController.h" 
#import "DateFormat.h"

@implementation StatisticsViewController

@synthesize dateRangeTableView, currenciesTableView;
@synthesize dateRangeDictionary, currenciesList;

- (void)dealloc {
	
	[dateRangeDictionary release];
	[currenciesList release];
	[dateRangeTableView release];
	[currenciesTableView release];
	
	[editButton release];
	[doneButton release];
	
    [super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
		//init code
		
		//set tabbaritem picture
		UIImage *buttonImage = [UIImage imageNamed:@"tabStatistics.png"];
		UITabBarItem *tempTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Statistici" image:buttonImage tag:0];
		self.tabBarItem = tempTabBarItem;
		[tempTabBarItem release];
		
		self.title = @"Statistici";		
		
		NSData *data = [[NSUserDefaults standardUserDefaults ] objectForKey:@"dateRangeDictionary"];
		NSMutableDictionary *savedRanges = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		if (savedRanges)
			dateRangeDictionary = [savedRanges retain];
		else
		{
			dateRangeDictionary = [[NSMutableDictionary alloc] init];			
		}
		
		NSData *data2 = [[NSUserDefaults standardUserDefaults ] objectForKey:@"statisticsCurrenciesList"];
		NSMutableDictionary *savedCurrencies = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
		if (savedCurrencies)
			currenciesList = [savedCurrencies retain];
		else
		{
			currenciesList = [[NSMutableArray alloc] init];
			[self addDefaultCurrencies];
		}
		
		
	}
    return self;
}

-(void) addDefaultCurrencies
{
	CurrencyItem *c1 = [[CurrencyItem alloc] init];
	[c1 setCurrencyName:@"EUR"];
	[currenciesList addObject:c1];
	[c1 release];
	
	CurrencyItem *c2 = [[CurrencyItem alloc] init];
	[c2 setCurrencyName:@"USD"];
	[currenciesList addObject:c2];
	[c2 release];
	
	[currenciesTableView reloadData];
	
}

-(void) presentModalGraphView
{
	GraphViewController *graphView = [[GraphViewController alloc] init];
	
	UINavigationController *graphNavigation = [[UINavigationController alloc] initWithRootViewController:graphView];
	[graphNavigation setNavigationBarHidden:YES];
	
	if (![currenciesList count]) 
	{
		[UIFactory showOkAlert:@"Pentru a genera un grafic, trebuie sa aveti macar o moneda de referinta" title:@"Atentie"];
		return;
	}
	NSString *startDateString = [dateRangeDictionary objectForKey:@"startDate"];				
	if (![startDateString length])
	{
		[UIFactory showOkAlert:@"Pentru a genera un grafic, trebuie sa selectati o data de start" title:@"Atentie"];		
		return;		
	}
	NSString *endDateString = [dateRangeDictionary objectForKey:@"endDate"];	
	if (![endDateString length])
	{
		[UIFactory showOkAlert:@"Pentru a genera un grafic, trebuie sa selectati o data de final" title:@"Atentie"];		
		return;	
	}

	[graphView setPlots:currenciesList];
	[graphView setStartDate:[DateFormat dateFromNormalizedString:startDateString]];
	[graphView setEndDate:[DateFormat dateFromNormalizedString:endDateString]];	
	
	[self.navigationController presentModalViewController:graphNavigation animated:YES];
	
	[graphNavigation release];
	[graphView release];
}



 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	 
	 //initialize and place tableView
	 CGRect f1 = CGRectMake(0.0, 10.0, 320, 100);
	 dateRangeTableView = [[UITableView alloc] initWithFrame:f1 style:UITableViewStyleGrouped];
	 dateRangeTableView.delegate = self;
	 dateRangeTableView.dataSource = self;
	 dateRangeTableView.autoresizesSubviews = YES;
	 dateRangeTableView.scrollEnabled=NO;
	 dateRangeTableView.allowsSelectionDuringEditing= YES; // very important, otherwise cells won't respond to touches
	 [self.view addSubview:dateRangeTableView];
	 
	 CGRect f2 = CGRectMake(0.0, 115.0, 320, 187);
	 currenciesTableView = [[UITableView alloc] initWithFrame:f2 style:UITableViewStyleGrouped];
	 currenciesTableView.delegate = self;
	 currenciesTableView.dataSource = self;
	 currenciesTableView.autoresizesSubviews = YES;
	 currenciesTableView.scrollEnabled=YES;
	 currenciesTableView.allowsSelectionDuringEditing= YES; // very important, otherwise cells won't respond to touches
	 [self.view addSubview:currenciesTableView];	 
	 
	 UIButton *showGraphButton = [UIFactory newButtonWithTitle:@"Genereaza" 
														target:self
													  selector:@selector (presentModalGraphView) 
														 frame:CGRectMake(60, 320, 200, 44) 
														 image:[UIImage imageNamed:@"whiteButton.png"] 
												  imagePressed:[UIImage imageNamed:@"blueButton.png"]  
												 darkTextColor:YES];
	 [self.view addSubview:showGraphButton];	 
	 
	 doneButton = [[UIBarButtonItem alloc] initWithTitle:kDone
												   style:UIBarButtonItemStyleDone
												  target:self 
												  action:@selector(doneAction)];

	 editButton = [[UIBarButtonItem alloc] initWithTitle:kEdit
												   style:UIBarButtonItemStyleBordered
												  target:self 
												  action:@selector(editAction)];
	 [self.navigationItem setLeftBarButtonItem:editButton];
}

-(void) editAction
{
	[currenciesTableView setEditing:YES];
	[self.navigationItem setLeftBarButtonItem:doneButton];
	[currenciesTableView reloadData];
}

-(void) doneAction
{
	[currenciesTableView setEditing:NO];	
	[self.navigationItem setLeftBarButtonItem:editButton];	
	[currenciesTableView reloadData];	
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[dateRangeTableView deselectRowAtIndexPath:[dateRangeTableView indexPathForSelectedRow] animated:YES];
	[currenciesTableView deselectRowAtIndexPath:[currenciesTableView indexPathForSelectedRow] animated:YES];	
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
	if (tableView == dateRangeTableView)
		return 2;
	else
	{
		if (currenciesTableView.editing)
			return [currenciesList count]+1;
		else
			return [currenciesList count];
		
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = nil;
	if (tableView == dateRangeTableView)
	{
	static NSString *CellIdentifier = @"Cell";
	
	cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}	
	
    // Set up the cell...
	
		switch (indexPath.row) {
			case 0:
			{
				NSString *startDateString = [dateRangeDictionary objectForKey:@"startDate"];				
				[cell.textLabel setText:@"De la:"];
				[cell.detailTextLabel setText:startDateString];
			}
				break;
			case 1:
			{
				NSString *endDateString = [dateRangeDictionary objectForKey:@"endDate"];	
				[cell.textLabel setText:@"Pana la:"];
				[cell.detailTextLabel setText:endDateString];			
			}
				break;
				
			default:
				break;
		}	
		
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	}
	else
	{
		
		if (indexPath.row==0 && tableView.editing)
		{
			static NSString *AddCellIdentifier = @"AddCell";
			
			UITableViewCell *addcell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];
			if (addcell == nil) {
				addcell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCellIdentifier] autorelease];
			}	
			
			// Set up the cell...
			
			[addcell.textLabel setText:kAddNewCurrency];
			[addcell.textLabel setTextColor:[UIColor darkGrayColor]];
			addcell.textLabel.textAlignment = UITextAlignmentCenter;
			[addcell setAccessoryType:UITableViewCellAccessoryNone];			
			addcell.selectionStyle = UITableViewCellSelectionStyleBlue;
			[addcell.textLabel setFont:[UIFont boldSystemFontOfSize:18]];
			return addcell;
			
		}
		else
		{

			static NSString *CellIdentifier = @"LightCurrencyTableViewCell";
			
			LightCurrencyTableViewCell *cell = (LightCurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[LightCurrencyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
			}	
			
			// Set up the cell...
			
			CurrencyItem *currencyObject=nil;	
			if (tableView.editing)
			{
				currencyObject = [currenciesList objectAtIndex:indexPath.row-1];
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];				
			}
			else
			{
				currencyObject = [currenciesList objectAtIndex:indexPath.row];
				[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];		
			}		
			
			if ([currencyObject currencyName])
			{
				NSString *fullNameCurrency = [[appDelegate currencyFullDictionary] valueForKey:[currencyObject currencyName]];		
				
				[cell setCurrencyImageName:[NSString stringWithFormat:@"%@.png",[currencyObject currencyName] ]  
							  currencyName:[currencyObject currencyName] 
						   multiplierValue:[currencyObject multiplierValue]?[currencyObject multiplierValue]:nil 
								  fullName:fullNameCurrency];
				[cell enterGroupEditState];
				[cell enterEditMode:tableView.editing];
			}
			
			[cell setAccessoryType:UITableViewCellAccessoryNone];		
			return cell;
		}
	}
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == dateRangeTableView)
	{
		NSString *startDateString = [dateRangeDictionary objectForKey:@"startDate"];	
		NSString *endDateString = [dateRangeDictionary objectForKey:@"endDate"];	
		
		switch (indexPath.row) {
			case 0:
			{
				DatePickerViewController *editView = [[DatePickerViewController alloc] init];
				[editView setEditingValue:@"startDate"];
				[editView setStringForTitle:kStartDateTitle];
				[editView setStringForTextFieldValue:startDateString];
				[editView setStringForNotice:kStartDateNotice];					
				[editView setParent:self];					
				[self.navigationController pushViewController:editView animated:YES];
				[editView release];
			}
				break;
			case 1:
			{
				DatePickerViewController *editView = [[DatePickerViewController alloc] init];
				[editView setEditingValue:@"endDate"];
				[editView setStringForTitle:kEndDateTitle];
				[editView setStringForTextFieldValue:endDateString];
				[editView setStringForNotice:kEndDateNotice];					
				[editView setParent:self];					
				[self.navigationController pushViewController:editView animated:YES];
				[editView release];				
			}
				break;
				
			default:
				break;
		}
	}
	else if (tableView == currenciesTableView)
	{
		if (currenciesTableView.editing && indexPath.row==0)
		{
			[self addNewCurrencyAction];
		}
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (currenciesTableView.editing)
	{
		if (indexPath.row==0)
			return UITableViewCellEditingStyleInsert;
		else
			return UITableViewCellEditingStyleDelete;
	}		
	return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
	return kDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleInsert)
	{
		NSLog(@"Add new tax action");		
		[self addNewCurrencyAction];
	}
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSLog(@"Delete the cell");
		// Animate the deletion from the table.
		[currenciesList removeObjectAtIndex:indexPath.row-1];	
	}
	[currenciesTableView reloadData];
}


-(void) addNewCurrencyAction
{
	CurrencyPickerViewController *pickerView = [[CurrencyPickerViewController alloc] initWithStyle:UITableViewStylePlain];
	[pickerView setIsPushed:YES];			
	[pickerView setParent:self];
	[self.navigationController pushViewController:pickerView animated:YES];
	[pickerView release];
}

@end
