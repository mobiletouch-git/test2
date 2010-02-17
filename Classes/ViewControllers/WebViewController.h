//
//  WebViewController.h
//  iTrafic
//
//  Created by Mobile Touch SRL on 9/30/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {

	UIWebView *navigationBrowser;
	UIToolbar *browserPanel;
	NSURL *urlVar;
	UIActivityIndicatorView *loadingIndicator;
	
}

@property (nonatomic, retain)	UIWebView *navigationBrowser;
@property (nonatomic, retain)	NSURL *urlVar;

- (void) loadURL: (NSURL *) urlToGo;

-(void) closeBrowser;
-(void) previousAction;
-(void) nextAction;
-(void) refreshAction;

@end
