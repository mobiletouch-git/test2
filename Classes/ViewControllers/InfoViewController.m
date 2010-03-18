//
//  InfoViewController.m
//  ETCM
//
//  Created by Mobile Touch SRL on 07.12.2009.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import "InfoViewController.h"
#import "Constants.h"
#import "UIFactory.h"
#import "WebViewController.h"
#import "TermsViewController.h"

@implementation InfoViewController

- (void)dealloc {
    [super dealloc];
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

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
		
		//set tabbaritem picture
		UIImage *buttonImage = [UIImage imageNamed:@"tabInfo.png"];
		UITabBarItem *tempTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Info" image:buttonImage tag:0];
		self.tabBarItem = tempTabBarItem;
		[tempTabBarItem release];
		
		self.title = @"Info";		
    }
    return self;
}

- (void)viewDidLoad {
	[self.tableView setScrollEnabled:NO];
    [super viewDidLoad];
	
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section)
	{
		case 1:
		{
			switch (indexPath.row)
			{
				case 0:
				{
					return 80;
				}
					break;
				default:
					break;
			}
		}
			break;
	}
	return 44;
}


- (NSString*) tableView:(UITableView*) tableView titleForHeaderInSection:(NSInteger) section 
{
	switch (section) {
		case 0:
			return @"\n";
			break;
		case 1:
			return @"\n";
			break;
		case 2:
			return @"\n";
			break;
	}
	return @"";
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	
	switch (section) {
		case 1:
			return 40;
			break;
		case 2:
			return 30;
			break;			
		default:
			break;
	}
	return 20;
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	
	UIView *headerView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	
	UILabel *headerLabel = [UIFactory newLabelWithPrimaryColor:[UIColor whiteColor]
												 selectedColor:[UIColor whiteColor]
													  fontSize:16
														  bold:NO];
	[headerLabel setFrame:CGRectZero];
	[headerLabel setBackgroundColor:[UIColor clearColor]];
	
	
	switch (section) {
		case 0:
			return headerLabel;
			break;

		case 1:
		{
			[headerLabel setFont:[UIFont boldSystemFontOfSize:16]];
			//#333333
			[headerLabel setTextColor:[UIColor colorWithRed:(CGFloat)0x33/255.0 green:(CGFloat)0x33/255.0 blue:(CGFloat)0x33/255.0 alpha:1.0]];
			NSString *textToSet = [@"   " stringByAppendingString:@"Dezvoltator"];
			[headerLabel setText:textToSet];
			[headerLabel setFrame:CGRectMake(0,10,320,20)];
			
			[headerView setFrame:CGRectMake(0,0,320,40)];
			[headerView addSubview:headerLabel];
			
			return headerView;
		}
			break;
		case 2:
		{
			[headerLabel setFrame:CGRectMake(0,10,320,40)];
			[headerLabel setFont:[UIFont boldSystemFontOfSize:16]];
			//#333333
			[headerLabel setTextColor:[UIColor colorWithRed:(CGFloat)0x33/255.0 green:(CGFloat)0x33/255.0 blue:(CGFloat)0x33/255.0 alpha:1.0]];
			[headerLabel setTextAlignment:UITextAlignmentCenter];
			headerLabel.numberOfLines=0;
			[headerLabel setText:@"www.mobiletouch.ro"];
			
			return headerLabel;
		}
			break;
			
	}
	return nil;
	
	
}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
		case 0:
			return 3;
			break;
		case 1:
			return 1;
			break;
		case 2:
			return 0;
			break;
	}
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case 0:
				{
					[cell.textLabel setText:@"Versiune"];
					NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
					[cell.detailTextLabel setText:appVersion];					

					cell.selectionStyle = UITableViewCellSelectionStyleNone;					
				}
					break;
				case 1:
				{
					[cell.textLabel setText:@"Trimite impresii"];
					[cell.detailTextLabel setText:@""];					
					[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];	
				}
					break;
				case 2:
				{
					[cell.textLabel setText:@"Termeni și condiții"];
					[cell.detailTextLabel setText:@""];					
					[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];	
				}
					break;
			}
			break;

		case 1:
			switch (indexPath.row) {
				case 0:
				{
					UIImageView *companyLogo = [[UIImageView alloc]	initWithFrame:CGRectMake(20,20,272,43)];
					[companyLogo setImage:[UIImage imageNamed:@"logo_transparent.png"]];
					[cell addSubview:companyLogo];
					[companyLogo release];
					cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				}
					break;
			}
			break;
			
	}
	
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	if( indexPath.row == 1 && indexPath.section == 0 ){
		[self displayApplicationFeedBackPage];
		return;
	}
	
	if( indexPath.row == 2 && indexPath.section == 0 ){
		[self displayTermsAndConditionsPage];
		return;
	}
	
	
	if( indexPath.row == 0 && indexPath.section == 1 ){
		[self displayCompanyWebSite];
		return;
	}
	

	
	
	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0:
		{
			switch (indexPath.row) {
				case 1:
				{
					[self displayApplicationFeedBackPage];				
				}
					break;
					
				case 2:
				{
					[self displayTermsAndConditionsPage];				
				}
					break;
					
				default:
					break;
			}
		}
			break;
		case 1:
		{
				[self displayInstructions];				
		}
			break;
		default:
			break;
	}
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
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


-(void) displayApplicationFeedBackPage
{
	WebViewController *contactWeb = [[WebViewController alloc] init];
	UINavigationController *webNavigation = [[UINavigationController alloc] initWithRootViewController:contactWeb];
#if defined(CONVERTOR)	
	[contactWeb setUrlVar:[NSURL URLWithString:@"http://www.mobiletouch.ro/feedback/27/"]];			
#else
	[contactWeb setUrlVar:[NSURL URLWithString:@"http://www.mobiletouch.ro/feedback/26/"]];			
#endif		

	[self.navigationController presentModalViewController:webNavigation animated:YES];
	[contactWeb release];
	[webNavigation release];
}

-(void) displayCompanyWebSite{

	WebViewController *contactWeb = [[WebViewController alloc] init];
	[contactWeb setUrlVar:[NSURL URLWithString:@"http://www.mobiletouch.ro"]];	
	UINavigationController *webNavigation = [[UINavigationController alloc] initWithRootViewController:contactWeb];
	[self.navigationController presentModalViewController:webNavigation animated:YES];
	[contactWeb release];
	[webNavigation release];
}

-(void) displayInstructions{
	/*
	InstructionsViewController *instructionsView = [[InstructionsViewController alloc] init];
	[self.navigationController pushViewController:instructionsView animated:YES];
	[instructionsView release];
	 */
}

-(void) displayTermsAndConditionsPage
{	
	TermsViewController *termsController = 	[[TermsViewController alloc] init];
	[termsController setTitle:@"Termeni și condiții"];
	[termsController setHidesBottomBarWhenPushed:YES];
	[self.navigationController pushViewController:termsController animated:YES];
	[termsController release];
	
}


@end
