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
#import "InfoValutarAPI.h"
#import "AdWhirlView.h"
#import <QuartzCore/QuartzCore.h>

@implementation TaxesViewController

@synthesize tableDataSource;
@synthesize taxesHaveBeenUpdated;

- (void)dealloc {
	
	[editButton release];
	[doneButton release];
	[addButton release];
	[tableDataSource release];
    [super dealloc];
}
-(void)populateTableSource
{
	NSData *data = [[NSUserDefaults standardUserDefaults ] objectForKey:@"taxesList"];
	NSMutableArray *savedList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	taxesHaveBeenUpdated = [[NSUserDefaults standardUserDefaults]boolForKey:@"taxesUpdated"];
	
	if([savedList count] == 0)
	{//there are no taxes in NSUserDefaults
		[self addDefaultTaxesValues];
		taxesHaveBeenUpdated = YES;
	}
	else
	{
		if(taxesHaveBeenUpdated == NO) //there are taxes saved in NSUserDefaults, but their value wasn't updated
		{
			//search for TVA item in list
			int i;
			for(i=0;i<[savedList count];i++)
				if( [((AdditionFactorItem*)[savedList objectAtIndex:i]).factorName isEqualToString:@"TVA"] == YES)
					break;
			AdditionFactorItem *afTVA = [savedList objectAtIndex:i];
			//The value for TVA isn't 24% && there is a TVA tax in the list
			if(i< [savedList count] && afTVA.factorValue != [NSDecimalNumber decimalNumberWithString:@"24"])
			{
				[afTVA setFactorValue:[NSDecimalNumber decimalNumberWithString:@"24"]];
				[savedList replaceObjectAtIndex:i withObject:afTVA];
				taxesHaveBeenUpdated = YES;
			}
		}
		[tableDataSource addObjectsFromArray:savedList];
	}

}
- (id)init
{
    if ((self = [super init])) {
		//init code
		NSLog(@"apel init");
		//set tabbaritem picture
		UIImage *buttonImage = [UIImage imageNamed:@"procente_icon.png"];
		UITabBarItem *tempTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Procente" image:buttonImage tag:0];
		self.tabBarItem = tempTabBarItem;
		[tempTabBarItem release];
		
		self.title = @"Procente";		
		[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
		
		tableDataSource = [[NSMutableArray alloc] init];	
		
		[self populateTableSource];
		/*
		if ([savedList count])
			[tableDataSource addObjectsFromArray:savedList];
		else
			[self addDefaultTaxesValues];
		*/
	}
	return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
/*
-(void)viewWillAppear:(BOOL)animated
{
	AdditionFactorItem *afTVA = [tableDataSource objectAtIndex:2];
	if(afTVA.factorValue != [NSDecimalNumber decimalNumberWithString:@"24"])
	{
		[afTVA setFactorValue:[NSDecimalNumber decimalNumberWithString:@"24"]];
		[tableDataSource replaceObjectAtIndex:2 withObject:afTVA];

	}
}
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	doneButton = [[UIBarButtonItem alloc] initWithTitle:kOk
												  style:UIBarButtonItemStyleDone
												 target:self 
												 action:@selector(doneAction)];
	
	editButton = [[UIBarButtonItem alloc] initWithTitle:kEdit
												  style:UIBarButtonItemStyleBordered
												 target:self 
												 action:@selector(editAction)];
	
	addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
															  target:self
															  action:@selector(addAction)];
	[self.navigationItem setRightBarButtonItem:addButton];
	
	[self.navigationItem setLeftBarButtonItem:editButton];
	
	
	//initialize and place tableView
	CGRect tableViewFrame = CGRectMake(0.0, kTopPadding, 320, 368-kTopPadding);
	myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.autoresizesSubviews = YES;
	myTableView.scrollEnabled=YES;
	//myTableView.allowsSelectionDuringEditing= YES; // very important, otherwise cells won't respond to touches
	[self.view addSubview:myTableView];

#if defined(CONVERTOR)	
	[self.view addSubview:[InfoValutarAPI displayCompanyLogo]];
	[self.view addSubview:[AdWhirlView requestAdWhirlViewWithDelegate:self]];	
#else
	
#endif	
}

-(void) addAction
{
	[self addNewTaxAction];		
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

-(void) editAction
{
	[myTableView setEditing:YES animated:YES];
	[self.navigationItem setLeftBarButtonItem:doneButton];
	[self.navigationItem setRightBarButtonItem:nil];
	
	[myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];			
	[myTableView reloadData];
}

-(void) doneAction
{
	[myTableView setEditing:NO];	
	[self.navigationItem setLeftBarButtonItem:editButton];	
	[self.navigationItem setRightBarButtonItem:addButton];		
	[myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];		
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
	[af3 setFactorValue:[NSDecimalNumber decimalNumberWithString:@"24"]];
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
	return [tableDataSource count];
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
	
	AdditionFactorItem *addF;
	addF = [tableDataSource objectAtIndex:indexPath.row];
	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];		

	[cell setAdditionFactor:addF enabled:NO];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	[cell setEditing:myTableView.editing];
	
	return cell;	
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{

	if (tableView.editing)
	{
		return UITableViewCellEditingStyleDelete;
	}		
	return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Selected");
	if (!tableView.editing)
	{
		AdditionFactorItem *factor = [tableDataSource objectAtIndex:indexPath.row];
		[self editExistingTaxAction:factor];
	}
	
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
	return kDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSLog(@"Delete the cell");
		// Animate the deletion from the table.
		[tableDataSource removeObjectAtIndex:indexPath.row];	
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
	return proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
		
	AdditionFactorItem *movedObject = [[[self tableDataSource] objectAtIndex:sourceIndexPath.row] retain];
	[[self tableDataSource] removeObjectAtIndex:sourceIndexPath.row];
	[[self tableDataSource] insertObject: movedObject atIndex: destinationIndexPath.row];
	[movedObject release];
	movedObject=nil;
}

-(void) addNewTaxAction
{
	[myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
	
	AddNewTaxViewController *newTaxView = [[AddNewTaxViewController alloc] initWithAdditionFactor:nil];
	
	CATransition *transition = [CATransition animation];
	transition.duration = 0.5;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionMoveIn;
	transition.subtype = kCATransitionFromTop;
	transition.delegate = self;
	[self.navigationController.view.layer addAnimation:transition forKey:nil];
	
	[self.navigationController pushViewController:newTaxView animated:NO];
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
