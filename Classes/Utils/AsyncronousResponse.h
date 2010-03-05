//
//  AsyncronousResponse.h
//  iGoomzeeAdmin
//
//  Created by Mobile Touch SRL on 7/8/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AsyncronousResponse;
@protocol AsyncDelegate <NSObject>
@optional
-(void) freeMemory:(AsyncronousResponse *)response;
-(void) refreshDataSource: (UIViewController *) parentViewController;
@end;

@interface AsyncronousResponse : NSObject{
	
	id <AsyncDelegate> delegates;
	
	UIViewController *parentViewController;
	NSURLRequest *request;
	NSMutableData *responseFromRequest;
	NSObject *parserDelegate;
	BOOL connectionDidFinish;
	NSURLConnection *connectionVar;
	UIActivityIndicatorView *activityView;
	UIAlertView *updateAlert;
	int count;
}

@property (readwrite, retain) UIViewController *parentViewController;
@property (readwrite, retain) NSURLRequest *request;
@property (readwrite, retain) NSMutableData *responseFromRequest;
@property (readwrite, retain) NSObject *parserDelegate;
@property (assign) 	id <AsyncDelegate> delegates;
@property (readwrite, retain) UIActivityIndicatorView *activityView;
@property (nonatomic,retain) UIAlertView *updateAlert;


-(id) initWithRequest: (NSURLRequest *) theRequest 
andParentViewController:(UIViewController *) theParentViewController
	andParserDelegate: (NSObject *) theParserDelegate;

-(void) parseReceivedData;
-(void) startSpinning;
-(void) stopSpinning;
-(void) start;

-(void) checkDefaultTimeOut;

@end
