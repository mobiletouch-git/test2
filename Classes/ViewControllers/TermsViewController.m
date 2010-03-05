//
//  HelpViewController.m
//  iDex Lite
//
//  Created by Mobile Touch SRL on 9/1/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import "TermsViewController.h"
#import "WebViewController.h"
#import "Constants.h"

@implementation TermsViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewWillDisappear:(BOOL)animated {

}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	CGRect webviewFrame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height);
	helpView = [[UIWebView alloc] initWithFrame:webviewFrame];
	[helpView setDelegate:self];
	//helpView.backgroundColor = definedColor;
	[helpView setScalesPageToFit:NO];
	
	NSString *aboutFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"terms.html"];
	NSData *dataToLoad = [NSData dataWithContentsOfFile:aboutFilePath];
	[helpView loadData:dataToLoad MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
	
	
	[self.view addSubview:helpView];
	

}


- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	isLoadingPage = NO;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

}



// Override to allow orientations other than the default portrait orientation.
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
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


- (void)dealloc {
    [super dealloc];
}


#pragma mark WebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"Test");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSLog(@"%@",[[[request URL] host] description]);
	
	if ([[request URL] host])
	{
	//	if ([appDelegate connectedToNetwork])
	//	{
		/*	WebViewController *webPage = [[WebViewController alloc] init];
			[webPage setUrlVar:[request URL]];
			webPage.hidesBottomBarWhenPushed=YES;
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.8];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationTransition: UIViewAnimationTransitionCurlDown forView:self.navigationController.view cache:NO];
			[UIView commitAnimations];
			[self.navigationController  pushViewController:webPage animated:NO];
			[webPage release];
		*/
		WebViewController *contactWeb = [[WebViewController alloc] init];
		UINavigationController *webNavigation = [[UINavigationController alloc] initWithRootViewController:contactWeb];
		[contactWeb setUrlVar:[request URL]]; //
		[self.navigationController presentModalViewController:webNavigation animated:YES];
		[contactWeb release];
		[webNavigation release];
		
			isLoadingPage=YES;
			return NO;
	//	}
	//	else
	//	{
	//		[appDelegate displayNoInternetConnectionAlert];
	//		return NO;
	//	}
		
	}
	return YES;
}

@end
