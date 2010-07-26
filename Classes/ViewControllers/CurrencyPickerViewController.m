//
//  CurrencyPickerViewController.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "CurrencyPickerViewController.h"
#import "Constants.h"
#import "CurrencyItem.h"
#import "LightCurrencyTableViewCell.h"
#import "ConverterViewController.h"
#import "AddConverterItemViewController.h"
#import "InfoValutarAPI.h"
#import "UIFactory.h"

@implementation CurrencyPickerViewController

@synthesize parent, isPushed;

- (void)dealloc {
	
	[tableDataSource release];
	[parent release];
	
    [super dealloc];
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Alegeți";
	
	tableDataSource = [[NSMutableArray alloc] initWithArray:[[appDelegate converterViewController] selectedReferenceDay]];
	
	if (![parent isKindOfClass:[StatisticsViewController class]])
	{
		CurrencyItem *c1 = [[CurrencyItem alloc] init];
		[c1 setCurrencyName:@"RON"];
		[tableDataSource addObject:c1];
		[c1 release];
	}
	
	NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc] initWithKey:@"currencyName" ascending:YES];
	[tableDataSource sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]];	
	[nameSorter release];
	
	cancelButton = [[UIBarButtonItem alloc] initWithTitle:kCancel
													style:UIBarButtonItemStyleBordered
												   target:self
												   action:@selector(cancelAction)];
	[self.navigationItem setRightBarButtonItem:cancelButton];

	self.navigationItem.hidesBackButton = YES;


}

-(void) cancelAction
{
	if (isPushed)
		[self.navigationController popViewControllerAnimated:YES];
	else
		[self.navigationController dismissModalViewControllerAnimated:YES];	
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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableDataSource count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set up the cell...
		
	static NSString *CellIdentifier = @"LightCurrencyTableViewCell";
	
	LightCurrencyTableViewCell *cell = (LightCurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[LightCurrencyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}	
	
	// Set up the cell...
	
	CurrencyItem *currencyObject=nil;	
	currencyObject = [tableDataSource objectAtIndex:indexPath.row];


	if (currencyObject)
	{
		NSString *fullNameCurrency = [[appDelegate currencyFullDictionary] valueForKey:[currencyObject currencyName]];		
		
		[cell setCurrencyImageName:[NSString stringWithFormat:@"%@.png",[currencyObject currencyName] ]  
					  currencyName:[currencyObject currencyName] 
				   multiplierValue:[currencyObject multiplierValue]?[currencyObject multiplierValue]:nil 
						  fullName:fullNameCurrency];
	}
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;			
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([parent isKindOfClass:[StatisticsViewController class]])
	{
		CurrencyItem *selected = [tableDataSource objectAtIndex:indexPath.row];		
		id foundCurrency = [InfoValutarAPI findCurrencyNamed:selected.currencyName inArray:[((StatisticsViewController *) parent) currenciesList]];
		if (!foundCurrency)
		{
			[[((StatisticsViewController *) parent) currenciesList] addObject:selected];
			[[((StatisticsViewController *) parent) currenciesTableView] reloadData];
			[self.navigationController popViewControllerAnimated:YES];			
		}
		else {
			[UIFactory showOkAlert:@"Moneda selectată se află deja în listă" title:nil];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}

	}
	else {
		if (isPushed)
		{
			CurrencyItem *selected = [tableDataSource objectAtIndex:indexPath.row];			
			[((AddConverterItemViewController *) parent) setSelectedCurrency:selected];
			[((AddConverterItemViewController *) parent) refresh];
			
			[self.navigationController popViewControllerAnimated:YES];
		}
		else
		{
			AddConverterItemViewController *addView = [[AddConverterItemViewController alloc] init];
			CurrencyItem *selected = [tableDataSource objectAtIndex:indexPath.row];	
			[addView setSelectedCurrency:selected];
			[self.navigationController pushViewController:addView animated:YES];
			[addView release];
		}
	}

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

