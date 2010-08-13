//
//  SensitiveTableView.m
//  CustomURLScheme
//
//  Created by Mobile Touch SRL on 6/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SensitiveTableView.h"


@implementation SensitiveTableView

@synthesize relativeTextFieldFrame;
@synthesize callBackObject, callBackSelector;
@synthesize textField;
@synthesize isShrinked;

- (void)dealloc {
	[callBackObject release];
	[textField release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
		[self setBackgroundColor:[UIColor clearColor]];
	}
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"Sensitive view touched");
	
	UITouch *aTouch = [touches anyObject];
	CGPoint location = [aTouch locationInView:self];
	
	NSLog(@"CGPoint %@", NSStringFromCGPoint(location));	
	
	relativeTextFieldFrame.size.width = textField.frame.size.width;
	
	NSLog(@"Textfield %@", NSStringFromCGRect(self.relativeTextFieldFrame));	
	
	if (location.x<relativeTextFieldFrame.origin.x ||
		location.x>relativeTextFieldFrame.origin.x+relativeTextFieldFrame.size.width  ||
		location.y<relativeTextFieldFrame.origin.y ||
		location.y>relativeTextFieldFrame.origin.y + relativeTextFieldFrame.size.height)
	{
		[self resignAction];			
	}
	[super touchesBegan:touches withEvent:event];
}

-(void) resignAction
{
	[callBackObject performSelector:callBackSelector withObject:self.textField];
//	[self.textField resignFirstResponder];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesEnded:touches withEvent:event];
	
} 

@end
