//
//  CurrenciesParserDelegate.m
//  CursValutar
//
//  Created by Mobile Touch SRL on 10/29/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import "CurrenciesParserDelegate.h"
#import "Constants.h"
#import "UIFactory.h"
#import "CurrencyItem.h"
#import "Currency.h"
#import "DateFormat.h"
#import "ErrorObject.h"
#import "InfoValutarAPI.h"

@implementation CurrenciesParserDelegate

@synthesize contentofNode, currentDate;

-(void) dealloc{
	[contentofNode release];
	[currentDate release];
	[super dealloc];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		// init code
	}
	return self;
}

#pragma mark LoginParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
	  namespaceURI:(NSString *)namespaceURI 
	 qualifiedName:(NSString *)qName 
		attributes:(NSDictionary *)attributeDict
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	if ([elementName isEqualToString:@"Cube"]) {
/*
		NSString *attribute1 = [attributeDict valueForKey:@"date"];
		if (attribute1)
		{
			NSDate *normalizedDate = [DateFormat dateFromString:attribute1];
			NSDate *utcDate = [InfoValutarAPI getUTCFormateDateFromDate:normalizedDate];
			[self setCurrentDate:utcDate];
		}
*/
		NSString *attribute1 = [attributeDict valueForKey:@"timestamp"];
		//NSLog([attribute1 description]);
		if (attribute1)
		{
			NSDate *normalizedDate = [NSDate dateWithTimeIntervalSince1970:[attribute1 intValue]];
			[appDelegate setGlobalTimeStamp: [attribute1 intValue]];
			NSDate *utcDate = [InfoValutarAPI getUTCFormateDateFromDate:normalizedDate];
			[self setCurrentDate:utcDate];
		}

    }
	else if ([elementName isEqualToString:@"Rate"]) {
		
		currReference = [[CurrencyItem alloc] init];
		NSString *attribute1 = [attributeDict valueForKey:@"currency"];
		if (attribute1)
			[currReference setCurrencyName:attribute1];
		
		NSString *attribute2 = [attributeDict valueForKey:@"multiplier"];
		if (attribute2)
			[currReference setMultiplierValue:[NSNumber numberWithInt:[attribute2 intValue]]];		
		
		self.contentofNode = [NSMutableString string];		
    }
	else if ([elementName isEqualToString:@"eroare"]) {
		errorObject = [[ErrorObject alloc] init];
    }	
	else if ([elementName isEqualToString:@"cod-eroare"]) {
		self.contentofNode = [NSMutableString string];
    }
	else if ([elementName isEqualToString:@"titlu-eroare"]) {
		self.contentofNode = [NSMutableString string];
    }
	else if ([elementName isEqualToString:@"mesaj-eroare"]) {
		self.contentofNode = [NSMutableString string];
    }
	
	else {
		self.contentofNode = nil;
	}
	
	[pool release];
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{  
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	
	if ([elementName isEqualToString:@"cod-eroare"]) {
		[errorObject setErrorCode:self.contentofNode];
    }
	else if ([elementName isEqualToString:@"titlu-eroare"]) {
		[errorObject setErrorTitle:self.contentofNode];		
    }
	else if ([elementName isEqualToString:@"mesaj-eroare"]) {
		[errorObject setErrorMessage:self.contentofNode];
    }
	else if ([elementName isEqualToString:@"eroare"]) {
		[UIFactory showOkAlert:[errorObject errorMessage] title:nil];
		[errorObject release];
    }		
	
	else if ([elementName isEqualToString:@"Rate"]) {
		
		NSDecimalNumber *valueNumber = [NSDecimalNumber decimalNumberWithString:self.contentofNode];
		[currReference setCurrencyValue:valueNumber];
		//insert the object
		
		Currency *newCurrency = [NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:[appDelegate managedObjectContext]];		
		
		[newCurrency setCurrencyName:[currReference currencyName]];
		[newCurrency setCurrencyMultiplier:[currReference multiplierValue]];
		[newCurrency setCurrencyValue:[currReference currencyValue]];
		[newCurrency setCurrencyDate:currentDate];
		
		[appDelegate setDataWasUpdated:YES];
		
/*		NSError *error = nil;
		
		if (![[appDelegate managedObjectContext] save:&error]) {

			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}	
*/
		[currReference release];
		currReference=nil;
    }
	
	[pool release];
}	


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.contentofNode) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        [self.contentofNode appendString:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSError *error = nil;

	if (![[appDelegate managedObjectContext] save:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	else
	{
		//success
		
		NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];		
		[prefs setInteger:[appDelegate globalTimeStamp] forKey:@"globalTimeStamp"];	
		[prefs synchronize];
	}
	
	if ([appDelegate dataWasUpdated]) 
		[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul BNR a fost actualizat."]
						 title:nil];
	else {
		NSDate *dateForUpdate = [DateFormat normalizeDateFromDate:[NSDate date]];
		NSDate *utcDate = [InfoValutarAPI getUTCFormateDateFromDate:dateForUpdate];		

		if ([InfoValutarAPI isSaturdayInRomania])
		{
			NSDate *fridayDate = [DateFormat getDayBeforeDate:utcDate 
												  howManyDays:1];
			dateForUpdate = [InfoValutarAPI getUTCFormateDateFromDate:fridayDate];				
		}
		
		else if ([InfoValutarAPI isSundayInRomania])
		{
			NSDate *fridayDate = [DateFormat getDayBeforeDate:utcDate 
												  howManyDays:2];
			dateForUpdate = [InfoValutarAPI getUTCFormateDateFromDate:fridayDate];				
		}
		
		NSString *dateToShowString = [DateFormat businessStringFromDate:dateForUpdate];
		[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul BNR licitat în data de %@ nu a fost încă publicat.", dateToShowString]
						 title:nil];
		
		
	}
	
	[[appDelegate currencyViewController] updateCurrentDate];
	[[appDelegate converterViewController] updateCurrentDate];

}

@end

