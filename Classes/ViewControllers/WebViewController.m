//
//  WebViewController.m
//  iTrafic
//
//  Created by Mobile Touch SRL on 9/30/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import "WebViewController.h"
#import "Constants.h"
#import "UIFactory.h"

@implementation WebViewController

@synthesize navigationBrowser, urlVar;

- (void)dealloc {
	[navigationBrowser release];
	[urlVar release];
	[loadingIndicator release];
//	[browserPanel release];
    [super dealloc];
}


- (void) loadURL: (NSURL *) urlToGo
{
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self setUrlVar:urlToGo];
	
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:urlVar cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20];	

	[navigationBrowser setScalesPageToFit:YES];
	[navigationBrowser loadRequest:theRequest];	
}


-(void) closeBrowser{
	[self dismissModalViewControllerAnimated:YES];
/*
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition: UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
	[UIView commitAnimations];
 	[self.navigationController popViewControllerAnimated:YES];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
 */
	
}

-(void) previousAction{
		[navigationBrowser goBack];
}

-(void) nextAction{
		[navigationBrowser goForward];
}

-(void) refreshAction{
		[navigationBrowser reload];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];  
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification"
											   object:nil]; 
	
	//Initialize and place the close button
	UIBarButtonItem* closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
																				 target:self
																				 action:@selector(closeBrowser) ];
	
	//Initialize the flexible button
	UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			   target:nil
																			   action:nil] autorelease];
	
	UIBarButtonItem* previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left.png"]
																	   style:UIBarButtonItemStylePlain
																	  target:self
																	  action:@selector(previousAction)	];
	
	
	
	//Initialize and place the next button
	UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
																				target:self
																				action:@selector(nextAction) ];
	
	
	//Initialize and place the refresh button
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																				   target:self
																				   action:@selector(refreshAction) ];
	
	
	browserPanel = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 410, 320, 50.0)];
	[browserPanel setBarStyle:UIBarStyleBlackOpaque];
	[browserPanel setItems:[NSArray arrayWithObjects:previousButton, flexItem, nextButton, flexItem, refreshButton, flexItem, flexItem, closeButton, nil]];
	
	[closeButton release];
	[previousButton release];
	[nextButton release];
	[refreshButton release];
	
	//Initialize and place loading indicator	
	loadingIndicator =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[loadingIndicator setFrame:CGRectMake(225, 10, 30,30)];
	[loadingIndicator setTag:35];
	loadingIndicator.hidesWhenStopped = YES;
	[browserPanel addSubview:loadingIndicator];	
	
	[self.view addSubview:browserPanel];
	
	navigationBrowser = [[UIWebView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
	[navigationBrowser setBackgroundColor:[UIColor blackColor]];
	[navigationBrowser setDelegate:self];
	[self.view addSubview:navigationBrowser];
	
	NSLog(@"Device orientation :: Portrait");
	[browserPanel setFrame:CGRectMake(0.0, 410, 320, 50.0)];		
	[navigationBrowser setFrame:CGRectMake(0.0, 0.0, 320, 410)];
	[loadingIndicator setFrame:CGRectMake(225, 10, 30,30)];
	
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
  [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];  
  [[NSNotificationCenter defaultCenter] removeObserver:self 
													name:@"UIDeviceOrientationDidChangeNotification"
												  object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	if (urlVar)
		[self loadURL:urlVar];	
}

- (void)viewWillDisappear:(BOOL)animated {

	if ([UIApplication sharedApplication].networkActivityIndicatorVisible==YES)
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	[super viewWillDisappear:animated];	
	
}


-(void) deviceOrientationDidChange: (NSNotification*)notification
{
	UIDeviceOrientation currentOrientation;
	currentOrientation = [UIDevice currentDevice].orientation;
	
	if (currentOrientation == UIDeviceOrientationPortrait){
		NSLog(@"Device orientation :: Portrait");
		[browserPanel setFrame:CGRectMake(0.0, 410, 320, 50.0)];		
		[navigationBrowser setFrame:CGRectMake(0.0, 0.0, 320, 410)];
		[loadingIndicator setFrame:CGRectMake(225, 10, 30,30)];

	}
	if (currentOrientation == UIDeviceOrientationPortraitUpsideDown){
		NSLog(@"Device orientation :: Portrait Upside Down");
		[browserPanel setFrame:CGRectMake(0.0, 410, 320, 50.0)];		
		[navigationBrowser setFrame:CGRectMake(0.0, 0.0, 320, 410)];
		[loadingIndicator setFrame:CGRectMake(225, 10, 30,30)];		
		
	}
	if (currentOrientation == UIDeviceOrientationLandscapeLeft){
		NSLog(@"Device orientation :: Landscape Left");
		[browserPanel setFrame:CGRectMake(0.0, 250, 480, 50.0)];		
		[navigationBrowser setFrame:CGRectMake(0.0, 0.0, 480, 250)];
		[loadingIndicator setFrame:CGRectMake(350, 10, 30,30)];

	}
	if (currentOrientation == UIDeviceOrientationLandscapeRight){
		NSLog(@"Device orientation :: Landscape Right");
		[browserPanel setFrame:CGRectMake(0.0, 250, 480, 50.0)];		
		[navigationBrowser setFrame:CGRectMake(0.0, 0.0, 480, 250)];
		[loadingIndicator setFrame:CGRectMake(350, 10, 30,30)];
	}
	
	
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}	


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}



- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[browserPanel viewWithTag:35];
	[spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
	UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[browserPanel viewWithTag:35];
	[spinner stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithnError:(NSError *)error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
	UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[browserPanel viewWithTag:35];
	[spinner stopAnimating];
	

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NoConnectionTitle", @"")
													message:NSLocalizedString(@"NoConnectionMessage", @"")
												   delegate:nil 
										  cancelButtonTitle:NSLocalizedString(@"OK", @"") 
										  otherButtonTitles: nil];
	[alert show];	
	[alert release];

	
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

	return YES;
}


@end
