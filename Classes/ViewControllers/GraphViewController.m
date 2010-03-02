//
//  GraphViewController.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 24.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "GraphViewController.h"
#import "UIFactory.h"
#import "InfoValutarAPI.h"
#import "Currency.h"
#import "DateFormat.h"
#import "CurrencyItem.h"

@implementation GraphViewController

@synthesize graphView;
@synthesize plots, startDate, endDate;

- (void)dealloc {
	[graphView release];
	graphView = nil;
	
	[plots release];
	[startDate release];
	[endDate release];
	[totalDays release];
	
    [super dealloc];
}


- (id)init
{
    if ((self = [super init])) {
		//init code
		
	}
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void) initializeLayout
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	for (int i=0;i<[plots count];i++)
	{
		CurrencyItem *ci = [plots objectAtIndex:i];
		NSMutableArray *results = [InfoValutarAPI getDataForInterval:startDate endDate:endDate currencyName:ci.currencyName];
		[plotsValues addObject:results];
	}

	NSNumberFormatter *ynumberFormatter = [NSNumberFormatter new];
	[ynumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[ynumberFormatter setMinimumFractionDigits:2];
	[ynumberFormatter setMaximumFractionDigits:2];
	
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
	
	self.graphView.gridXColor = [UIColor greenColor];
	self.graphView.gridYColor = [UIColor greenColor];
	
	self.graphView.drawInfo = NO;
	self.graphView.info = @"Load";
	self.graphView.infoColor = [UIColor magentaColor];
	
	self.graphView.plotsArray = [NSArray arrayWithArray:self.plots];
	//When you need to update the data, make this call:
	
	[self.graphView reloadData];
	
	[pool drain];
}

-(void) dismissView
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"Plots %d, startDate %@, endDate %@", [plots count], startDate, endDate);
	
	self.graphView = [[S7GraphView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	self.view = self.graphView;
	self.graphView.dataSource = self;
	
	plotsValues = [[NSMutableArray alloc] initWithCapacity:[plots count]];
	totalDays = [[NSMutableArray alloc] init];
	
	NSDate *nextDay = [NSDate dateWithTimeIntervalSinceReferenceDate:[startDate timeIntervalSinceReferenceDate]];
	[totalDays addObject:startDate];
	
	while ((![endDate compare:nextDay] == NSOrderedSame) || [endDate compare:nextDay] == NSOrderedDescending) {
		{
			nextDay = [DateFormat getNextDayForDay:nextDay];
			nextDay = [InfoValutarAPI getUTCFormateDateFromDate:nextDay];
			[totalDays addObject:nextDay];
		}
	}
	
	UIButton *closeButton = [UIFactory newButtonWithTitle:nil 
												   target:self
												 selector:@selector (dismissView)
													frame:CGRectMake(445,20,25,26)
													image:[UIImage imageNamed:@"close.png"]
											 imagePressed:[UIImage imageNamed:@"close_touch.png"]
											darkTextColor:NO];
	[self.view addSubview:closeButton];
	[closeButton release];
	
//	[self performSelectorInBackground:(@selector(initializeLayout)) withObject:nil];
	
	[self performSelectorOnMainThread:@selector(initializeLayout) withObject:nil waitUntilDone:YES];		
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
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

 - (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];	 
 }

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
	return [plots count];
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
	return totalDays;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
	/* Return the values for a specific graph. Each plot is meant to have equal number of points.
	 And this amount should be equal to the amount of elements you return from graphViewXValues: method. */
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSArray *valuesForPlot = [plotsValues objectAtIndex:plotIndex];
	
	int counter = 0;
	
	for (int i=0; i <[totalDays count] && counter<[valuesForPlot count];i++)
	{
		Currency *managed = [valuesForPlot objectAtIndex:counter];

		NSDate *dateForEntry = [managed valueForKey:@"currencyDate"];
		NSDate *dateInCalendar = [totalDays objectAtIndex:i];
		
		NSString *valueString = [managed valueForKey:@"currencyValue"];
		float dblValue = [valueString floatValue];
		NSNumber *numberToAdd = [NSNumber numberWithFloat:dblValue*1000];
		
		if ([dateForEntry compare:dateInCalendar] == NSOrderedSame)
		{
			[array addObject:numberToAdd];		
			counter+=1;
		}
		else if ([dateForEntry compare:dateInCalendar] == NSOrderedDescending)
		{

			if (![array count] || ([[array lastObject] compare:[NSNumber numberWithFloat:0.0]] == NSOrderedSame))
			{
				NSNumber *numberToAdd = [NSNumber numberWithFloat:0.0];
				[array addObject:numberToAdd];							
			}
			else {
				[array addObject:numberToAdd];							
			}

			
		}		
	}

	NSLog(@"First object %f last object %f", [[array objectAtIndex:0] floatValue], [[array lastObject] floatValue]);
	
	return array;
}

@end
