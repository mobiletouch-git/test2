//
//  SensitiveTableView.h
//  CustomURLScheme
//
//  Created by Mobile Touch SRL on 6/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SensitiveTableView : UITableView {

	CGRect relativeTextFieldFrame;
	
	id callBackObject;
	UITextField *textField;
	SEL callBackSelector;
	BOOL isShrinked;
}

@property (nonatomic, retain) id callBackObject;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, assign) SEL callBackSelector;
@property (nonatomic, assign) CGRect relativeTextFieldFrame;
@property (nonatomic, assign) BOOL isShrinked;

-(void) resignAction;

@end
