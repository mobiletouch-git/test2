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
#import "CurrencyTableViewCell.h"
#import "ConverterViewController.h"
#import "AddConverterItemViewController.h"

@implementation CurrencyPickerViewController

@synthesize parent;

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

	tableDataSource = [[NSArray alloc]	initWithArray:[[appDelegate converterViewController] selectedReferenceDay]];
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
		
	static NSString *CellIdentifier = @"CurrencyTableViewCell";
	
	CurrencyTableViewCell *cell = (CurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CurrencyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}	
	
	// Set up the cell...
	
	CurrencyItem *currencyObject=nil;	
	currencyObject = [tableDataSource objectAtIndex:indexPath.row];
	

	if (currencyObject)
		[((CurrencyTableViewCell *)cell) setLightCurrencyImageName:[NSString stringWithFormat:@"%@.png",[currencyObject currencyName] ] 
												 currencyName:[currencyObject currencyName] 
											  multiplierValue:[currencyObject multiplierValue]?[currencyObject multiplierValue]:nil
													 currencyValue:[currencyObject currencyValue]];
	
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;			
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([parent isKindOfClass:[AddConverterItemViewController class]])
	{
		CurrencyItem *selected = [tableDataSource objectAtIndex:indexPath.row];
		[((AddConverterItemViewController *)parent) setSelectedCurrency:selected];
		[((AddConverterItemViewController *)parent) refresh];
		[self.navigationController popViewControllerAnimated:YES];
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

