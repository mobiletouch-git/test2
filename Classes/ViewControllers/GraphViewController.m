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
	[plotsValues release];
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
	
	NSDate *nextDay = [NSDate dateWithTimeIntervalSinceReferenceDate:[startDate timeIntervalSinceReferenceDate]];
	//[totalDays addObject:startDate];
	//int counter = 0;
	while ([endDate compare:nextDay] != NSOrderedSame || [endDate compare:nextDay] == NSOrderedDescending) {
		{
			nextDay = [DateFormat getNextDayForDay:nextDay];
			nextDay = [InfoValutarAPI getUTCFormateDateFromDate:nextDay];
			//counter++;
			//[totalDays addObject:nextDay];
		}
	}
	
	for (int i=0;i<[plots count];i++)
	{
		CurrencyItem *ci = [plots objectAtIndex:i];
		NSMutableArray *results = [InfoValutarAPI getDataForInterval:startDate endDate:endDate currencyName:ci.currencyName];
		if (i==0) {
			totalDays=[[results valueForKey:@"currencyDate"] retain];
		}
		[plotsValues addObject:results];
	}
/*
	NSArray *valuesForPlot = [plotsValues objectAtIndex:0];
	for (int j=0;j<[valuesForPlot count];j++)	
	{
		Currency *managed = [valuesForPlot objectAtIndex:j];
		NSDate *dateForEntry = [managed valueForKey:@"currencyDate"];
		NSLog(@"Date for entry %@", dateForEntry);
	}
*/	NSLocale *romaniaLocale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	NSNumberFormatter *ynumberFormatter = [NSNumberFormatter new];
	[ynumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[ynumberFormatter setMinimumFractionDigits:2];
	[ynumberFormatter setMaximumFractionDigits:2];
	[ynumberFormatter setLocale:romaniaLocale];
	
	self.graphView.yValuesFormatter = ynumberFormatter;
	
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	//[dateFormatter setTimeStyle:NSDateFormatterNoStyle];	
	//[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateFormatter setDateFormat:@"dd/MM/yy"];
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
	
	
	NSLog(@"Finished loading");	
	[[self.view viewWithTag:100] removeFromSuperview];	

	self.graphView.dataSource = self;	
//	[self.graphView reloadData];
	
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
//	self.graphView.dataSource = self;
	
	plotsValues = [[NSMutableArray alloc] initWithCapacity:[plots count]];
	//totalDays = [[NSMutableArray alloc] init];
	
	NSLog(@"Start loading");	

	UIView *overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 300)];
	[overlayView setBackgroundColor:[UIColor blackColor]];
	[overlayView setAlpha:0.85];
	[overlayView setTag:100];
	
	UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(215,105.0,50.0,50.0);
	activityView.hidesWhenStopped = YES;
	[activityView startAnimating];
	
	UILabel *noticeLabel = [UIFactory newLabelWithPrimaryColor:[UIColor whiteColor] 
												 selectedColor:[UIColor whiteColor]  
													  fontSize:16
														  bold:NO];
	[noticeLabel setText:@"Vă rugăm așteptați. Generarea unui grafic necesită o procesare mai îndelungată, în funcție de perioada selectată."];
	[noticeLabel setFrame:CGRectMake(90,175.0,300,70.0)];
	[noticeLabel setNumberOfLines:0];
	[noticeLabel setBackgroundColor:[UIColor clearColor]];
	[noticeLabel setTextAlignment:UITextAlignmentCenter];
	[overlayView addSubview:noticeLabel];
	
	
	[overlayView addSubview:activityView];
	[activityView release];
	
	[self.view addSubview:overlayView];
	[overlayView release];	
	
	[self performSelectorInBackground:(@selector(initializeLayout)) withObject:nil];	
	
	UIButton *closeButton = [UIFactory newButtonWithTitle:nil 
												   target:self
												 selector:@selector (dismissView)
													frame:CGRectMake(440,10,40,40)
													image:[UIImage imageNamed:@"close.png"]
											 imagePressed:[UIImage imageNamed:@"close_touch.png"]
											darkTextColor:NO];
	[self.view addSubview:closeButton];
	[closeButton release];	
}



 - (void)viewWillAppear:(BOOL)animated {
	 [super viewWillAppear:animated];
 }

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
	NSMutableArray *array = [NSMutableArray array];
	NSArray *valuesForPlot = [plotsValues objectAtIndex:plotIndex];
	
	//int counter = 0;
	//NSNumber *lastValidNumber = [NSNumber numberWithFloat:-1.0];
	 
	for (int i=0;  i<[totalDays count];i++)
	{
		Currency *managed = [valuesForPlot objectAtIndex:i];

	//	NSDate *dateForEntry = [managed valueForKey:@"currencyDate"];
	//	NSDate *dateInCalendar = [totalDays objectAtIndex:i];
		
		NSString *valueString = [managed valueForKey:@"currencyValue"];
		float dblValue = [valueString floatValue];
		NSNumber *numberToAdd = [NSNumber numberWithFloat:dblValue*1000];
	
		[array addObject:numberToAdd];	
		
		//if ([dateForEntry compare:dateInCalendar] == NSOrderedSame)
//		{
//			[array addObject:numberToAdd];	
//			lastValidNumber = [NSNumber numberWithFloat:[numberToAdd floatValue]];
//			counter+=1;
//		}
//		else if ([dateForEntry compare:dateInCalendar] == NSOrderedDescending)
//		{
//
//			if (![array count] || ([[array lastObject] compare:[NSNumber numberWithFloat:0.0]] == NSOrderedSame))
//			{
//				NSNumber *numberToAdd = [NSNumber numberWithFloat:-1.0];
//				[array addObject:numberToAdd];
//			}
//			else {
//				[array addObject:lastValidNumber];							
//			}
//
//			
//		}		
	}

	NSLog(@"First object %f last object %f", [[array objectAtIndex:0] floatValue], [[array lastObject] floatValue]);
	
	for (int j=0; j <[array count];j++)
	{
//		NSNumber *nr = [array objectAtIndex:j];
//		NSLog(@"Value %f", [nr floatValue]);
	}
	
	return array;
}

@end
