//
//  AsyncronousResponse.m
//  iGoomzeeAdmin
//
//  Created by Mobile Touch SRL on 7/8/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import "AsyncronousResponse.h"
#import "UIFactory.h"
#import "Constants.h"


@implementation AsyncronousResponse

@synthesize parentViewController, request, responseFromRequest, parserDelegate, delegates, activityView, updateAlert ;

- (void) dealloc
{
	[parentViewController release];
	[responseFromRequest release];
	[request release];
	[activityView release];
	[updateAlert release];
	[super dealloc];
}

-(id) initWithRequest: (NSURLRequest *) theRequest 
		andParentViewController:(UIViewController *) theParentViewController
			andParserDelegate: (NSObject *) theParserDelegate
{
	if (theParentViewController)
		[self setParentViewController:theParentViewController];
	if (theParserDelegate)
		[self setParserDelegate:theParserDelegate];
	if (theRequest)
		[self setRequest:theRequest];
	
	
	
	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(120.0,55.0,50.0,50.0);
	activityView.hidesWhenStopped = YES;
	[activityView setTag:33];
	
	updateAlert = [[UIAlertView alloc] initWithTitle:@""
											 message:@"Actualizare curs BNR\n" 
											delegate:nil
								   cancelButtonTitle:nil 
								   otherButtonTitles:nil];
	[updateAlert setTag:44];
	[updateAlert addSubview:activityView];
	
	count=0;
	return self;
}

-(void) start{
	[self startSpinning];
	if (request)
	{
		connectionVar =[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
		[NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(checkDefaultTimeOut) userInfo:nil repeats:NO];

		if(connectionVar)
		{
			NSLog(@"Starts receiveing data");
		}	
		else
		{
			NSLog(@"Failed");
		}
	}
	else
		[UIFactory showOkAlert:@"Cererea trimisă către server nu este validă" title:nil];
	
}

-(void) checkDefaultTimeOut
{
	if (![responseFromRequest length] && connectionDidFinish==NO)
	{
		[connectionVar cancel];
		connectionDidFinish=YES;
		[connectionVar release];
		connectionVar = nil;
		[self stopSpinning];
		
		[UIFactory showOkAlert:@"Vă rugăm verificați conexiunea la Internet și reveniți mai târziu." title:nil];	
		
	}

}


#pragma mark NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{	
	NSLog(@"Response");
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (count==0)
	{
		responseFromRequest = [[NSMutableData alloc] initWithData:data];
	}
	else
	{
		[responseFromRequest appendData:data];
	}
	count+=1;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection did fail");
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//NSLog([[NSString stringWithFormat:@"%@ - %@",[error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]] description]);
	
	[UIFactory showOkAlert:@"Vă rugăm verificați conexiunea la Internet și reveniți mai târziu." title:nil];	
	
	count=0;
	
	connectionDidFinish=YES;	
	[connectionVar release];


	[parserDelegate release];	
	
	
	if([delegates respondsToSelector:@selector(freeMemory:)]) {
		[delegates freeMemory:self];
	}
	
	if([delegates respondsToSelector:@selector(refreshDataSource:)]) {
		[delegates refreshDataSource:parentViewController];
	}
	
	[self stopSpinning];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    // do something with the data
    NSLog(@"Finish loading in %d trunks", count);
	count=0;
    [connectionVar release];
	connectionDidFinish=YES;
	if ([responseFromRequest length])
		[self parseReceivedData];
}

-(void) parseReceivedData{

//	[responseFromRequest writeToFile:@"/Users/imac20/Desktop/answer.xml" atomically:YES];	

	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: responseFromRequest];
if (parserDelegate)	
	[xmlParser setDelegate:parserDelegate];
	[xmlParser setShouldProcessNamespaces:YES];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
	
	BOOL success = [xmlParser parse];
	
	if(success)
	{
	}
	
	[xmlParser setDelegate:nil];
	[xmlParser abortParsing];
	
	[self stopSpinning];
	[xmlParser release];
	[parserDelegate release];	

	
	if([delegates respondsToSelector:@selector(freeMemory:)]) {
		[delegates freeMemory:self];
	}
	
	if([delegates respondsToSelector:@selector(refreshDataSource:)]) {
		[delegates refreshDataSource:parentViewController];
	}
	
}

-(void) startSpinning
{	
	[updateAlert show];
//	[[appDelegate window] addSubview:updateAlert];
//	[(UIActivityIndicatorView *)([[appDelegate window] viewWithTag:33]) startAnimating];	
	
	[activityView startAnimating];
}

-(void) stopSpinning
{
	[activityView stopAnimating];
//	[(UIActivityIndicatorView *)([[appDelegate window] viewWithTag:33]) stopAnimating];	
//	[[[appDelegate window] viewWithTag:33] removeFromSuperview];
	[updateAlert dismissWithClickedButtonIndex:0 animated:YES];

//	[[[appDelegate window] viewWithTag:44] removeFromSuperview];			
	


}


@end
