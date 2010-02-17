//
//  ErrorObject.m
//  CursValutar
//
//  Created by Mobile Touch SRL on 10/29/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import "ErrorObject.h"


@implementation ErrorObject


@synthesize errorCode, errorTitle, errorMessage;

-(void) dealloc{

	[errorCode release];
	[errorTitle release];
	[errorMessage release];
	
	[super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
		//init code
	}
    return self;
}


-(NSString *) description{
	
	NSString *theDescription = @"";
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"errorCode %@ \n", self.errorCode]];
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"errorTitle %@ \n", self.errorTitle]];	
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"errorMessage %@ \n", self.errorMessage]];
	return theDescription;
}


@end
