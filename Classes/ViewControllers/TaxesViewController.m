//
//  TaxesViewController.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 16.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "TaxesViewController.h"
#import "TaxTableViewCell.h"
#import "AdditionFactorItem.h"
#import "Constants.h"
#import "AddNewTaxViewController.h"

@implementation TaxesViewController

@synthesize tableDataSource;

- (void)dealloc {
	
	[editButton release];
	[doneButton release];
	[tableDataSource release];
    [super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
		//init code
		
		//set tabbaritem picture
		UIImage *buttonImage = [UIImage imageNamed:@"icon_tab_4.png"];
		UITabBarItem *tempTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Taxe" image:buttonImage tag:0];
		self.tabBarItem = tempTabBarItem;
		[tempTabBarItem release];
		
		self.title = @"Taxe";		
		
		tableDataSource = [[NSMutableArray alloc] init];	
		
		NSData *data = [[NSUserDefaults standardUserDefaults ] objectForKey:@"taxesList"];
		NSMutableArray *savedList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		if ([savedList count])
			[tableDataSource addObjectsFromArray:savedList];
		else
			[self addDefaultTaxesValues];
		
		
	}
    return self;
}

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
	
	doneButton = [[UIBarButtonItem alloc] initWithTitle:kDone
												  style:UIBarButtonItemStyleDone
												 target:self 
												 action:@selector(doneAction)];
	
	editButton = [[UIBarButtonItem alloc] initWithTitle:kEdit
												  style:UIBarButtonItemStyleBordered
												 target:self 
												 action:@selector(editAction)];
	[self.navigationItem setLeftBarButtonItem:editButton];
	
	
	//initialize and place tableView
	CGRect tableViewFrame = CGRectMake(0.0, 0.0, 320, 368);
	myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.autoresizesSubviews = YES;
	myTableView.scrollEnabled=YES;
	myTableView.allowsSelectionDuringEditing= YES; // very important, otherwise cells won't respond to touches
	[self.view addSubview:myTableView];
	
}

-(void) editAction
{
	[myTableView setEditing:YES];
	[self.navigationItem setLeftBarButtonItem:doneButton];
	[myTableView reloadData];
}

-(void) doneAction
{
	[myTableView setEditing:NO];	
	[self.navigationItem setLeftBarButtonItem:editButton];	
	[myTableView reloadData];	
}

-(void) addDefaultTaxesValues
{
	
	AdditionFactorItem *af1 = [[AdditionFactorItem alloc] init];
	[af1 setFactorName:@"Discount"];
	[af1 setFactorSign:-1];
	[af1 setFactorValue:[NSDecimalNumber decimalNumberWithString:@"5"]];
	[tableDataSource addObject:af1];
	[af1 release];
	
	AdditionFactorItem *af2 = [[AdditionFactorItem alloc] init];
	[af2 setFactorName:@"Comision"];
	[af2 setFactorSign:1];
	[af2 setFactorValue:[NSDecimalNumber decimalNumberWithString:@"3"]];
	[tableDataSource addObject:af2];
	[af2 release];
	
	AdditionFactorItem *af3 = [[AdditionFactorItem alloc] init];
	[af3 setFactorName:@"TVA"];
	[af3 setFactorSign:1];
	[af3 setFactorValue:[NSDecimalNumber decimalNumberWithString:@"19"]];
	[tableDataSource addObject:af3];
	[af3 release];	
	
	AdditionFactorItem *af4 = [[AdditionFactorItem alloc] init];
	[af4 setFactorName:@"Impozit"];
	[af4 setFactorSign:1];
	[af4 setFactorValue:[NSDecimalNumber decimalNumberWithString:@"16"]];
	[tableDataSource addObject:af4];
	[af4 release];		
	
	AdditionFactorItem *af5 = [[AdditionFactorItem alloc] init];
	[af5 setFactorName:@"CNAS"];
	[af5 setFactorSign:1];
	[af5 setFactorValue:[NSDecimalNumber decimalNumberWithString:@"5.5"]];
	[tableDataSource addObject:af5];
	[af5 release];		
	
	[myTableView reloadData];
}


#pragma mark Table view methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (myTableView.editing)
		return [tableDataSource count]+1;

	return [tableDataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	if (indexPath.row==0 && tableView.editing)
	{
		static NSString *AddCellIdentifier = @"AddCell";
		
		UITableViewCell *addcell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];
		if (addcell == nil) {
			addcell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddCellIdentifier] autorelease];
		}	
		
		// Set up the cell...
		
		[addcell.textLabel setText:kAddNewTax];
		[addcell.textLabel setTextColor:[UIColor darkGrayColor]];
		addcell.textLabel.textAlignment = UITextAlignmentLeft;
		[addcell setAccessoryType:UITableViewCellAccessoryNone];			
		addcell.selectionStyle = UITableViewCellSelectionStyleBlue;
		[addcell.textLabel setFont:[UIFont boldSystemFontOfSize:18]];
		return addcell;
		
	}
	
	static NSString *CellIdentifier = @"Cell";
    
    TaxTableViewCell *cell = (TaxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TaxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	AdditionFactorItem *addF;
	if (tableView.editing)
	{
		addF = [tableDataSource objectAtIndex:indexPath.row-1];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];				
	}
	else
	{
		addF = [tableDataSource objectAtIndex:indexPath.row];
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];		
	}
	[cell setAdditionFactor:addF enabled:NO];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	[cell setEditing:myTableView.editing];
	
	return cell;	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

	if (tableView.editing)
	{
		if (indexPath.row==0)
			return UITableViewCellEditingStyleInsert;
		else
			return UITableViewCellEditingStyleDelete;
	}		
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Selected");
	if (indexPath.row==0 && tableView.editing)
	{
		NSLog(@"Add new tax action");
		[self addNewTaxAction];		
	}
	else if (!tableView.editing)
	{
		AdditionFactorItem *factor = [tableDataSource objectAtIndex:indexPath.row];
		[self editExistingTaxAction:factor];
	}
	
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
	return kDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleInsert)
	{
		NSLog(@"Add new tax action");		
		[self addNewTaxAction];
	}
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSLog(@"Delete the cell");
		// Animate the deletion from the table.
		[tableDataSource removeObjectAtIndex:indexPath.row-1];	
	}
	[myTableView reloadData];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Edit existing tax action");		
	AdditionFactorItem *factor = [tableDataSource objectAtIndex:indexPath.row];
	[self editExistingTaxAction:factor];
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView.editing)
	{
		if (indexPath.row==0)
			return NO;
		return YES;
	}
	return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
	targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath 
	   toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	
	if (proposedDestinationIndexPath.section==0 && proposedDestinationIndexPath.row==0) // if user wants to move to first row in table, return next row.
		return [NSIndexPath indexPathForRow:1 inSection:0];
	
	return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
		
	AdditionFactorItem *movedObject = [[[self tableDataSource] objectAtIndex:sourceIndexPath.row-1] retain];
	[[self tableDataSource] removeObjectAtIndex:sourceIndexPath.row-1];
	[[self tableDataSource] insertObject: movedObject atIndex: destinationIndexPath.row-1];
	[movedObject release];
	movedObject=nil;
}

-(void) addNewTaxAction
{
	[myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
	
	AddNewTaxViewController *newTaxView = [[AddNewTaxViewController alloc] initWithAdditionFactor:nil];
	[self.navigationController pushViewController:newTaxView animated:YES];
	[newTaxView release];
}

-(void) editExistingTaxAction: (AdditionFactorItem *) existingTax
{
	AddNewTaxViewController *newTaxView = [[AddNewTaxViewController alloc] initWithAdditionFactor:existingTax];
	[self.navigationController pushViewController:newTaxView animated:YES];
	[newTaxView release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void) refresh
{
	[myTableView reloadData];
}

@end
