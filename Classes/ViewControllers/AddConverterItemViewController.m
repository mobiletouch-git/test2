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
	
	[oneRowTableView release];
	[myTableView release];
	
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
	[oneRowTableView deselectRowAtIndexPath:[oneRowTableView indexPathForSelectedRow] animated:YES];
	if (self.selectedCurrency)
		[doneButton setEnabled:YES];
}

-(void) refresh
{
	[oneRowTableView reloadData];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
	
	additionList = [[NSMutableArray alloc] init];
	
	CGRect tableView1Frame = CGRectMake(0.0, 0.0, 320, 130);
	oneRowTableView = [[UITableView alloc] initWithFrame:tableView1Frame style:UITableViewStyleGrouped];
	oneRowTableView.delegate = self;
	oneRowTableView.dataSource = self;
	oneRowTableView.autoresizesSubviews = YES;
	oneRowTableView.scrollEnabled=YES;
	[oneRowTableView setBounces:NO];
	oneRowTableView.allowsSelectionDuringEditing= YES; // very important, otherwise cells won't respond to touches
	[self.view addSubview:oneRowTableView];
	
	
	//initialize and place tableView
	CGRect tableView2Frame = CGRectMake(0.0, 115.0, 320, 285);
	myTableView = [[UITableView alloc] initWithFrame:tableView2Frame style:UITableViewStyleGrouped];
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
	return 1;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if (tableView == oneRowTableView)
		return 60;
	else if (tableView == myTableView)
		return 0;
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (tableView == myTableView)
		return nil;
	else if (tableView == oneRowTableView)
	{
		UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
		[transparentView setBackgroundColor:[UIColor clearColor]];
		
		UILabel *noticeLabel = [UIFactory newLabelWithPrimaryColor:[UIColor darkGrayColor] 
													 selectedColor:[UIColor darkGrayColor] 
														  fontSize:14 
															  bold:NO];
		[noticeLabel setFrame:CGRectMake(20, 7, 280, 55)];
		[noticeLabel setBackgroundColor:[UIColor clearColor]];
		[noticeLabel setNumberOfLines:3];
		[noticeLabel setText:@"Opțional puteți adăuga procente, ele sunt aplicate la bază în ordinea lor din listă."];
		
		[transparentView addSubview:noticeLabel];
		
		return [transparentView autorelease];			
	}
	return nil;
	
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (tableView == oneRowTableView)
		return 1;
	else if (tableView == myTableView)
		return [taxesArray count];
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == oneRowTableView)
		return 44;
	else if (tableView == myTableView)
		return 44;
	return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (tableView == oneRowTableView)
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

	else if (tableView == myTableView)
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
	if (tableView == oneRowTableView)
		{
			CurrencyPickerViewController *pickerView = [[CurrencyPickerViewController alloc] initWithStyle:UITableViewStylePlain];
			[pickerView setIsPushed:YES];			
			[pickerView setParent:self];
			[self.navigationController pushViewController:pickerView animated:YES];
			[pickerView release];
		}
	else if (tableView == myTableView)
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

	[NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(rearangePriorities) userInfo:nil repeats:NO];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == oneRowTableView)
		return NO;
	else if (tableView == myTableView)
		return YES;
	return NO;
	
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

	[oneRowTableView reloadData];
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
