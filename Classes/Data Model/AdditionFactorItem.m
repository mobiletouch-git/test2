//
//  AdditionFactorItem.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "AdditionFactorItem.h"


@implementation AdditionFactorItem
@synthesize factorName, factorSign, factorValue, checked;

-(void) dealloc{
	[factorName release];
	[factorValue release];
	[super dealloc];
}

- (id)init
{
    if ((self = [super init])) {
	}
    return self;
}


-(NSString *) description{
	
	NSString *theDescription = @"";

	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"factorName %@ \n", self.factorName]];
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"factorSign %d \n", self.factorSign]];	
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"factorValue %@ \n", self.factorValue]];
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"checked %d \n", self.checked]];
	
	return theDescription;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:factorName forKey:@"factorName"];	
    [coder encodeObject:[NSString stringWithFormat:@"%d", factorSign] forKey:@"factorSign"];
	[coder encodeObject:factorValue forKey:@"factorValue"];
    [coder encodeObject:[NSString stringWithFormat:@"%d", checked] forKey:@"checked"];
	return;
}

- (id)initWithCoder:(NSCoder *)coder
{
	factorName	= [[coder decodeObjectForKey:@"factorName"] retain];	
	factorSign	= [[coder decodeObjectForKey:@"factorSign"] intValue];
	factorValue	= [[coder decodeObjectForKey:@"factorValue"] retain];
	checked	= [[coder decodeObjectForKey:@"checked"] boolValue];	
	return self;
}


@end
