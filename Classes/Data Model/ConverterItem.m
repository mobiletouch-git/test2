//
//  ConverterItem.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "ConverterItem.h"


@implementation ConverterItem

@synthesize currency, converterValue, additionFactors;


-(void) dealloc{
	[currency release];
	[additionFactors release];
	[converterValue release];
	
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
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"currency %@ \n", self.currency]];
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"additionFactors %@ \n", self.additionFactors]];
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"converterValue %@ \n", self.converterValue]];	

	return theDescription;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:currency forKey:@"currency"];	
	[coder encodeObject:additionFactors forKey:@"additionFactors"];	
	[coder encodeObject:converterValue forKey:@"converterValue"];		

	
	return;
}

- (id)initWithCoder:(NSCoder *)coder
{	
	currency	= [[coder decodeObjectForKey:@"currency"] retain];	
	additionFactors	= [[coder decodeObjectForKey:@"additionFactors"] retain];		
	converterValue	= [[coder decodeObjectForKey:@"converterValue"] retain];		
	
	return self;
}


@end
