//
//  GraphViewController.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 24.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "GraphViewController.h"
#import "UIFactory.h"

@implementation GraphViewController

@synthesize graphView;

- (void)dealloc {
	[graphView release];
	graphView = nil;
	
    [super dealloc];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	self.graphView = [[S7GraphView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.view = self.graphView;
	self.graphView.dataSource = self;

	
	UIButton *closeButton = [UIFactory newButtonWithTitle:nil 
												   target:self
												 selector:@selector (dismissView)
													frame:CGRectMake(445,20,25,26)
													image:[UIImage imageNamed:@"close.png"]
											 imagePressed:[UIImage imageNamed:@"close_touch.png"]
											darkTextColor:NO];
	[self.view addSubview:closeButton];
	[closeButton release];
}

-(void) dismissView
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	NSNumberFormatter *ynumberFormatter = [NSNumberFormatter new];
	[ynumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[ynumberFormatter setMinimumFractionDigits:0];
	[ynumberFormatter setMaximumFractionDigits:0];
	
	self.graphView.yValuesFormatter = ynumberFormatter;
	
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	self.graphView.xValuesFormatter = dateFormatter;
	
	[dateFormatter release];        
	[ynumberFormatter release];

	
	self.graphView.backgroundColor = [UIColor blackColor];
	
	self.graphView.drawAxisX = YES;
	self.graphView.drawAxisY = YES;
	self.graphView.drawGridX = YES;
	self.graphView.drawGridY = YES;
	
	self.graphView.xValuesColor = [UIColor yellowColor];
	self.graphView.yValuesColor = [UIColor yellowColor];
	
	self.graphView.gridXColor = [UIColor magentaColor];
	self.graphView.gridYColor = [UIColor magentaColor];
	
	self.graphView.drawInfo = NO;
	self.graphView.info = @"Load";
	self.graphView.infoColor = [UIColor magentaColor];
	
	//When you need to update the data, make this call:
	
	[self.graphView reloadData];
	
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


 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
 }


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark protocol S7GraphViewDataSource

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
	/* Return the number of plots you are going to have in the view. 1+ */
	return 3;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:5];
	for ( int i = 0 ; i < 50 ; i ++ ) {
		NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:0+i*100000];
		[array addObject:date];	
	}
	return array;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
	/* Return the values for a specific graph. Each plot is meant to have equal number of points.
	 And this amount should be equal to the amount of elements you return from graphViewXValues: method. */
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:101];
	switch (plotIndex) {
		default:
		case 0:
			for ( int i = 0 ; i < 50 ; i ++ ) {
				[array addObject:[NSNumber numberWithInt:i*i]];	// y = x*x		
			}
			break;
		case 1:
			for ( int i = 0 ; i < 50 ; i ++ ) {
				[array addObject:[NSNumber numberWithInt:i*i+i*i]];	// y = x*x+x*x				
			}
			break;
		case 2:
			for ( int i = 0 ; i < 50 ; i ++ ) {
				[array addObject:[NSNumber numberWithInt:i*i+i*i+i*i]];	// y = x*x*x				
			}
			break;			
	}
	
	return array;
}

@end
