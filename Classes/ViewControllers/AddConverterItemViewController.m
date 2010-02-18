//
//  AddConverterItemViewController.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "AddConverterItemViewController.h"
#import "Constants.h"
#import "CurrencyItem.h"
#import "ConverterItem.h"
#import "UIFactory.h"
#import "CurrencyPickerViewController.h"
#import "LightConverterTableViewCell.h"
#import "LightTaxTableViewCell.h"
#import "AdditionFactorItem.h" 

@implementation AddConverterItemViewController

@synthesize selectedCurrency, additionList;

- (void)dealloc {
	[doneButton release];
	[cancelButton release];
	[addButton release];
	
	[selectedCurrency release];
	[taxesArray release];
	[additionList release];
	
    [super dealloc];	
}

- (id)init
{
    if ((self = [super init])) {
		//init code
		
		self.title = kAddNewCurrency;
		
		cancelButton = [[UIBarButtonItem alloc] initWithTitle:kCancel
														style:UIBarButtonItemStyleBordered
													   target:self
													   action:@selector(cancelAction)];
		addButton = [[UIBarButtonItem alloc] initWithTitle:kAdd 
													  style:UIBarButtonItemStyleBordered
													 target:self 
													 action:@selector(selectAction)];

		doneButton = [[UIBarButtonItem alloc] initWithTitle:kOk
													  style:UIBarButtonItemStyleDone
													 target:self 
													 action:@selector(doneAction)];

		[self.navigationItem setLeftBarButtonItem:cancelButton];		
		[self.navigationItem setRightBarButtonItem:doneButton];
		[doneButton setEnabled:NO];
		
	}
    return self;
}


-(void) cancelAction
{
	[self.navigationController dismissModalViewControllerAnimated:YES];	
}

-(void) doneAction
{
	// adding a new converter Item.

	ConverterItem *newConverter = [[ConverterItem alloc] init];
	[newConverter setCurrency:selectedCurrency];
	[newConverter setAdditionFactors:additionList];

	[[[appDelegate converterViewController] tableDataSource] addObject:newConverter];
	[[[appDelegate converterViewController] myTableView] reloadData];
	[newConverter release];
	[self.navigationController dismissModalViewControllerAnimated:YES];	
}


/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[myTableView deselectRowAtIndexPath:[myTableView indexPathForSelectedRow] animated:YES];
	if (self.selectedCurrency)
		[doneButton setEnabled:YES];
}

-(void) refresh
{
	[myTableView reloadData];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
	additionList = [[NSMutableArray alloc] init];
	
	//initialize and place tableView
	CGRect tableViewFrame = CGRectMake(0.0, 0.0, 320, 368);
	myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.autoresizesSubviews = YES;
	myTableView.scrollEnabled=YES;
	myTableView.allowsSelectionDuringEditing= YES; // very important, otherwise cells won't respond to touches
	[self.view addSubview:myTableView];
	[myTableView setEditing:YES];
	
	taxesArray = [[NSMutableArray alloc] init];
	NSMutableArray *originalArray = [[appDelegate taxesViewController] tableDataSource];
	
	for (int i=0;i<[originalArray count];i++)
	{
		AdditionFactorItem *ad = [originalArray objectAtIndex:i];
		AdditionFactorItem *newItem = [[AdditionFactorItem alloc] init];
		[newItem setFactorName: ad.factorName];
		[newItem setFactorSign:ad.factorSign];
		[newItem setFactorValue:ad.factorValue];
		[taxesArray addObject:newItem];
		[newItem release];
		newItem = nil;
	}
	
	NSLog(@"taxes array %@", taxesArray);
}


#pragma mark Table view methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
			break;
		case 1:
			return [taxesArray count];
			break;
			
		default:
			break;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0:
			return 53;
			break;
		default:
			return 44.0;			
			break;
	}
	return 44.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section==0)
	{
		static NSString *CellIdentifier2 = @"LightConverterTableViewCell";
		
		LightConverterTableViewCell *cell2 = (LightConverterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell2 == nil) {
			cell2 = [[[LightConverterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
		}
		
		ConverterItem *co = [[[ConverterItem alloc] init] autorelease];
		CurrencyItem *currencyForConverter = [self selectedCurrency];
		if (currencyForConverter)
			[co setCurrency:currencyForConverter];
		
		[co setAdditionFactors:additionList];
		[cell2 setConverterItem:co];
		[cell2 setSelectionStyle:UITableViewCellSelectionStyleBlue];
		return cell2;
	}

	else if (indexPath.section==1)
	{
		static NSString *CellIdentifier = @"Cell";
		
		LightTaxTableViewCell *cell = (LightTaxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[LightTaxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		AdditionFactorItem *addF = [taxesArray objectAtIndex:indexPath.row];
		
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];		
		[cell setAdditionFactor:addF enabled:NO];
		
		if (addF.checked)
		{
			[cell setChecked:YES];
			[cell setActive:YES];	
		}
		else
		{
			[cell setChecked:NO];
			[cell setActive:NO];	
		}
		
		if ([additionList count]!=3)
		{
			[cell setActive:YES];				
		}

	
		return cell;
	}
	return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
		{
			CurrencyPickerViewController *pickerView = [[CurrencyPickerViewController alloc] initWithStyle:UITableViewStylePlain];
			[pickerView setIsPushed:YES];			
			[pickerView setParent:self];
			[self.navigationController pushViewController:pickerView animated:YES];
			[pickerView release];
		}
			break;
		case 1:
		{
			if ([additionList count]<=3)
			{
				AdditionFactorItem *addF = [taxesArray objectAtIndex:indexPath.row];
				
				if (addF.checked)
				{
					[addF setChecked:NO];
					[additionList removeObject:addF];
					[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
					
					[tableView reloadData];
					[self rearangePriorities];					
					return;
				}
				
				if ([additionList count]<=2)									
				{
					if (!addF.checked)
					{
						[addF setChecked:YES];
						[additionList addObject:addF];
						[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];						
						
						[tableView reloadData];
						[self rearangePriorities];						
						return;
					}
				}
			}
		}
			break;
			
		default:
			break;
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

	AdditionFactorItem *movedObject = [[taxesArray objectAtIndex:sourceIndexPath.row] retain];
	[taxesArray removeObjectAtIndex:sourceIndexPath.row];
	[taxesArray insertObject: movedObject atIndex: destinationIndexPath.row];
	[movedObject release];
	movedObject=nil;
//	[self rearangePriorities];	
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return NO;
			break;
		case 1:
			return YES;
			break;
			
		default:
			break;
	}
	return YES;
}


-(void) rearangePriorities
{
	NSMutableArray *arangedList = [NSMutableArray array];
	for (int i=0;i<[taxesArray count];i++)
	{
		AdditionFactorItem *addF = [taxesArray objectAtIndex:i];	
		if (addF.checked)
			[arangedList addObject:addF];
	}
	[self setAdditionList:arangedList];
	
	[myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
					   withRowAnimation:UITableViewRowAnimationFade];						
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



@end
