//
//  InfoValutarAPI.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 28.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import "InfoValutarAPI.h"
#import "Constants.h"
#import "Currency.h"
#import "ConverterItem.h"
#import "AdditionFactorItem.h"
 
@implementation InfoValutarAPI

+(NSString *) getStringFromDate: (NSDate *) theDate{
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	NSLocale *loc = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale currentLocale] localeIdentifier]];
	[dateFormatter setLocale:loc];
	
	return [dateFormatter stringFromDate:theDate];
}


+(NSMutableArray *) getCurrenciesForDate: (NSDate *) specificDate
{
	NSMutableDictionary *substDictionary = [NSMutableDictionary dictionary];
	[substDictionary setObject:specificDate forKey:@"DATE"];
	
	NSManagedObjectModel *model = [appDelegate managedObjectModel];	 
	NSFetchRequest *fetch = [model fetchRequestFromTemplateWithName:@"getCurrenciesForDate"
											  substitutionVariables:substDictionary];
	NSMutableArray *mutableFetchResults = [[[appDelegate managedObjectContext] executeFetchRequest:fetch error:nil] mutableCopy];
	NSMutableArray *arrayToReturn = [NSMutableArray array];
	
	for (int i=0;i<[mutableFetchResults count];i++)
	{
		CurrencyItem *curr = [[CurrencyItem alloc] init];
		
		Currency *managedObject = [mutableFetchResults objectAtIndex:i];
		[curr setCurrencyName:[managedObject currencyName]];
		[curr setCurrencyValue:[managedObject currencyValue]];
		[curr setMultiplierValue:[managedObject currencyMultiplier]];
		
		[arrayToReturn addObject:curr];
		[curr release];
	}
	
	[mutableFetchResults release];
	
	return arrayToReturn;
}

+(NSDate *) getValidBankingDayForDay: (NSDate *) someDate
{
	
	NSDate *testingDate = nil;
	
	NSMutableDictionary *substDictionary = [NSMutableDictionary dictionary];
	[substDictionary setObject:someDate forKey:@"DATE"];
	
	NSManagedObjectModel *model = [appDelegate managedObjectModel];	 
	NSFetchRequest *fetch = [model fetchRequestFromTemplateWithName:@"getValidBankCurrenciesForDate"
											  substitutionVariables:substDictionary];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"currencyDate" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetch setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
	[fetch setFetchLimit:1];
	NSMutableArray *mutableFetchResults = [[[appDelegate managedObjectContext] executeFetchRequest:fetch error:nil] mutableCopy];
	
	if ([mutableFetchResults count])
	{
		Currency *managedObj = [mutableFetchResults objectAtIndex:0];
		testingDate = [managedObj valueForKey:@"currencyDate"];
	}
	[mutableFetchResults release];
	
	return testingDate;
}

+(double) getBaseValueForConverterItem: (ConverterItem *) converterItem
{
	double converterVal = [converterItem.converterValue doubleValue];
	
	for (int i=0;i<[converterItem.additionFactors count];i++)
	{
		AdditionFactorItem *af = [converterItem.additionFactors objectAtIndex:i];
		if (af.factorSign>0)
			converterVal = (converterVal *100)/(100+[af.factorValue doubleValue]);
		if (af.factorSign<0)
			converterVal = (converterVal *100)/(100-[af.factorValue doubleValue]);
	}
	
	return converterVal;
}

+(CurrencyItem *) findCurrencyNamed: (NSString *)currencyName inArray: (NSArray *) anArray
{
	for (int i=0;i<[anArray count];i++)
	{
		CurrencyItem *ct = [anArray objectAtIndex:i];
		if ([currencyName isEqualToString:ct.currencyName])
			return ct;
	}
	return nil;
}

@end
