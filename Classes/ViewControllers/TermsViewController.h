//
//  HelpViewController.h
//  iDex Lite
//
//  Created by Mobile Touch SRL on 9/1/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TermsViewController : UIViewController <UIWebViewDelegate> {
	
	UIWebView *helpView;
	BOOL isLoadingPage;
}

@end
