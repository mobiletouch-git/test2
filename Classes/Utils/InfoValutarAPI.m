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
#import "AsyncronousResponse.h"
#import "CurrenciesParserDelegate.h"
#import "CurrencyViewController.h"

static InfoValutarAPI* INSTANCE;

@implementation InfoValutarAPI

+ (InfoValutarAPI*) sharedInstance
{
	if (!INSTANCE)
	{
		INSTANCE = [[InfoValutarAPI alloc] init];
	}
	return INSTANCE;
}

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

	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"currencyName" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetch setSortDescriptors:sortDescriptors];
	
	[sortDescriptor release];
	[sortDescriptors release];
	
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

+(NSMutableArray *) getDataForInterval: (NSDate *) startDate
							   endDate:(NSDate *) endDate
						  currencyName: (NSString *) currencyName
{
	NSMutableDictionary *substDictionary = [NSMutableDictionary dictionary];
	[substDictionary setObject:startDate forKey:@"STARTDATE"];
	[substDictionary setObject:endDate forKey:@"ENDDATE"];
	[substDictionary setObject:currencyName forKey:@"CURRENCYNAME"];	
	
	
	NSManagedObjectModel *model = [appDelegate managedObjectModel];	 
	NSFetchRequest *fetch = [model fetchRequestFromTemplateWithName:@"getIntervalData"
											  substitutionVariables:substDictionary];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"currencyDate" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetch setSortDescriptors:sortDescriptors];
	
	[sortDescriptor release];
	[sortDescriptors release];
	
	NSMutableArray *mutableFetchResults = [[[appDelegate managedObjectContext] executeFetchRequest:fetch error:nil] mutableCopy];
	NSMutableArray *arrayToReturn = [NSMutableArray array];
	[arrayToReturn addObjectsFromArray:mutableFetchResults];
	
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

+(NSDecimalNumber *) getBaseValueForConverterItem: (ConverterItem *) converterItem
{
//	double converterVal = [converterItem.converterValue doubleValue];
	NSDecimalNumber *converterVal = [converterItem converterValue];
	NSDecimalNumber *decimal100 = [NSDecimalNumber decimalNumberWithString:@"100"];

	for (int i=0;i<[converterItem.additionFactors count];i++)
	{
		AdditionFactorItem *af = [converterItem.additionFactors objectAtIndex:i];
		if (af.factorSign>0)
		{
			NSDecimalNumber *deimp = [converterVal decimalNumberByMultiplyingBy:decimal100];
			NSDecimalNumber *impar = [af.factorValue decimalNumberByAdding:decimal100];
			converterVal = [deimp decimalNumberByDividingBy:impar];
//			converterVal = (converterVal *100)/(100+[af.factorValue doubleValue]);
		}
		else if (af.factorSign<0)
		{
			NSDecimalNumber *deimp = [converterVal decimalNumberByMultiplyingBy:decimal100];
			NSDecimalNumber *impar = [decimal100 decimalNumberBySubtracting:af.factorValue];
			converterVal = [deimp decimalNumberByDividingBy:impar];
//			converterVal = (converterVal *100)/(100-[af.factorValue doubleValue]);
		}
	}
	
	return converterVal;
}

+(CurrencyItem *) getCurrencyForPriority: (NSInteger) priority inDictionary: (NSDictionary *) aDictionary
{
	CurrencyItem *ct = nil;
	while (!ct && priority < [aDictionary count]){
		ct = [aDictionary objectForKey:[NSString stringWithFormat:@"%d", priority]];
		priority+=1;
	}
	
	return ct;
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

+(NSDate *)getUTCFormateDateFromDate: (NSDate *) theDate
{
	NSString *dateString = [NSString stringWithFormat:@"%@", theDate];

	NSRange yearRange = {0, 4};		
	NSRange monthRange = {5, 2};			
	NSRange dayRange =  {8, 2};			
	
	NSString *yearString = [dateString substringWithRange:yearRange];
	NSString *monthString = [dateString substringWithRange:monthRange];
	NSString *dayString = [dateString substringWithRange:dayRange];			
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	
	[comps setYear:[yearString intValue]];
	[comps setMonth:[monthString intValue]];
	[comps setDay:[dayString intValue]];
	
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	
	NSDate *date = [gregorian dateFromComponents:comps];
	
	[comps release];
	[gregorian release];
	
	return date;

}

+(NSDate *)getUpdateDateForDate: (NSDate *) theDate
{
	NSString *dateString = [NSString stringWithFormat:@"%@", theDate];
	
	NSRange yearRange = {0, 4};		
	NSRange monthRange = {5, 2};			
	NSRange dayRange =  {8, 2};			
	
	NSString *yearString = [dateString substringWithRange:yearRange];
	NSString *monthString = [dateString substringWithRange:monthRange];
	NSString *dayString = [dateString substringWithRange:dayRange];			
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	
	[comps setYear:[yearString intValue]];
	[comps setMonth:[monthString intValue]];
	[comps setDay:[dayString intValue]];
	
	[comps setHour:11];
	[comps setMinute:0];
	[comps setSecond:0];
	
	NSDate *date = [gregorian dateFromComponents:comps];
	
	[comps release];
	[gregorian release];
	
	return date;
	
}

- (void) updateDatabaseWithTimeStamp: (NSInteger) timeStmp
					inViewController: (UIViewController *)theParentViewController
{
	[appDelegate setDataWasUpdated:NO];
	NSString *updateURL = [NSString stringWithFormat:@"http://api.mobiletouch.ro/0.2/curs-valutar/update.php?timestamp=%d", timeStmp];
	NSLog([updateURL description]);
	NSURL *defaultURL = [NSURL URLWithString:updateURL];
	
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:defaultURL 
												cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
											timeoutInterval:10];

	//Initialize the delegate.
	CurrenciesParserDelegate *parserDelegate = [[CurrenciesParserDelegate alloc] init];
	
	AsyncronousResponse *getCurrency = [[AsyncronousResponse alloc] initWithRequest:theRequest
															andParentViewController:theParentViewController 
																  andParserDelegate:parserDelegate];
	getCurrency.delegates=self;
	[getCurrency start];
	[parserDelegate release];
}

+(NSDate *) getExtremityDateForCurrencyNamed: (NSString *)currencyName
								   first: (BOOL) yesOrNo
{
	NSMutableDictionary *substDictionary = [NSMutableDictionary dictionary];
	[substDictionary setObject:currencyName forKey:@"CURRENCYNAME"];
	
	NSManagedObjectModel *model = [appDelegate managedObjectModel];	 
	NSFetchRequest *fetch = [model fetchRequestFromTemplateWithName:@"getTotalYearsInDatabaseForCurrency"
											  substitutionVariables:substDictionary];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"currencyDate" ascending:yesOrNo];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetch setSortDescriptors:sortDescriptors];
	
	[sortDescriptor release];
	[sortDescriptors release];
	
	[fetch setFetchLimit:1];
	NSMutableArray *mutableFetchResults = [[[appDelegate managedObjectContext] executeFetchRequest:fetch error:nil] mutableCopy];

	NSDate *dateToReturn = nil;
	if ([mutableFetchResults count])
	{
		Currency *managed = [mutableFetchResults objectAtIndex:0];
		dateToReturn = [managed valueForKey:@"currencyDate"];
	}
	
	[mutableFetchResults release];

	return dateToReturn;
}


#pragma mark AsyncronousResponse delegates
-(void) freeMemory:(AsyncronousResponse *)response
{
	[response release];	
}

-(void) refreshDataSource: (UIViewController *) parent{

	if ([parent isKindOfClass:[CurrencyViewController class]]) {
		if([parent respondsToSelector:@selector(pageUpdate)])
		{
			[(CurrencyViewController *)parent pageUpdate];
		}
	}

}


@end
