//
//  CurrencyItem.m
//  CursValutar
//
//  Created by Mobile Touch SRL on 10/27/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import "CurrencyItem.h"
#import "Constants.h"

@implementation CurrencyItem

@synthesize currencyName, currencyValue, multiplierValue, change, sign, priority;

-(void) dealloc{
	[currencyName release];
	[multiplierValue release];
	[currencyValue release];
	[change release];
	[sign release];
	
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
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"currencyName %@ \n", self.currencyName]];
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"multiplierValue %@ \n", self.multiplierValue]];	
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"currencyValue %@ \n", self.currencyValue]];
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"change %@ \n", self.change]];
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"sign %@ \n", self.sign]];
	theDescription =  [theDescription stringByAppendingString:[NSString stringWithFormat:@"priority %d \n", self.priority]];	
	return theDescription;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:currencyName forKey:@"currencyName"];	
	[coder encodeObject:currencyValue forKey:@"currencyValue"];
	[coder encodeObject:multiplierValue forKey:@"multiplierValue"];
	[coder encodeObject:change forKey:@"change"];
	[coder encodeObject:sign forKey:@"sign"];	
    [coder encodeObject:[NSString stringWithFormat:@"%d", priority] forKey:@"priority"];
	
	return;
}

- (id)initWithCoder:(NSCoder *)coder
{	
	currencyName	= [[coder decodeObjectForKey:@"currencyName"] retain];	
	currencyValue	= [[coder decodeObjectForKey:@"currencyValue"] retain];	
	multiplierValue	= [[coder decodeObjectForKey:@"multiplierValue"] retain];
	change	= [[coder decodeObjectForKey:@"change"] retain];	
	sign	= [[coder decodeObjectForKey:@"sign"] retain];		
	priority	= [[coder decodeObjectForKey:@"priority"] intValue];
	
	return self;
}


@end
