//
//  DateFormat
//  Created by Ovidiu Sarbanescu, 2009
//  Utility for NSDate to NSString conversions;  
//


#import "DateFormat.h"


@implementation DateFormat

+(NSString *) stringValueForDictionaryKeyFromValue: (NSDate *) theDate{
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMM"];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:theDate];
	[dateFormatter release];
	return formattedDateString;
}


+(NSString *)businessStringFromDate:(NSDate *)date 
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
	return formattedDateString;
}

+(NSString *)simpleDateFormatString:(NSDate *)date 
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"LLLL dd, yyyy"];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
	return formattedDateString;
}


+(NSString *)DBformatDateFromDate:(NSDate *)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return formattedDateString;
}

+(NSString *)normalizedStringFromDate:(NSDate *)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd-MM-yyyy"];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return formattedDateString;
}

+(NSString *) reportStringFromDate:(NSDate *)date
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd.MM.yyyy"];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return formattedDateString;
}

+(NSDate *)dateFromNormalizedString:(NSString *)string {    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //#define kDEFAULT_DATE_TIME_FORMAT (@"yyyy-MM-dd’T'HH:mm:ss’Z'")
    [formatter setDateFormat:@"dd-MM-yyyy"];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[formatter setLocale:locale];
    NSDate *date = [formatter dateFromString:string];
    [formatter release];
    return date;
}

+(NSDate *) dateFromNormalizedStringOld:(NSString *)dateString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd-mm-yyyy"];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];
	NSDate *newDate = [dateFormatter dateFromString:dateString];
	[dateFormatter release];
	return newDate;
}

+(NSDate *) normalizeDateFromDate: (NSDate *) date
{
	NSString *stringForDate = [DateFormat normalizedStringFromDate:date];
	NSDate *newDate = [DateFormat dateFromNormalizedString:stringForDate];
	return newDate;
}

+(NSString *)monthYearDateString:(NSDate *)date
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"LLLL yyyy"];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];
	NSString *formattedDateString = [dateFormatter stringFromDate:date];
	return formattedDateString;
}

+(NSString *)monthYearFromDictionaryKey: (NSString *) dictionaryKey
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyyMM"];
	NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"ro_RO"] autorelease];
	[dateFormatter setLocale:locale];
	NSDate *theDate= [dateFormatter dateFromString:dictionaryKey];
	
	[dateFormatter setDateFormat:@"LLLL yyyy"];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:theDate];
	
	return formattedDateString;
}

+(NSDate *)dateFromString:(NSString *)dateString 
{
	NSRange yearRange = {0, 4};
	NSRange monthRange = {5, 2};
	NSRange dayRange = {8, 2};
	
	NSString *yearString = [[NSString alloc] initWithFormat:@"%@", [dateString substringWithRange:yearRange]];
	NSString *monthString = [[NSString alloc] initWithFormat:@"%@", [dateString substringWithRange:monthRange]];
	NSString *dayString = [[NSString alloc] initWithFormat:@"%@", [dateString substringWithRange:dayRange]];
	
	int year = [yearString intValue];
	int month = [monthString intValue];
	int day = [dayString intValue];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:year];
	[comps setMonth:month];
	[comps setDay:day];
	NSDate *date = [gregorian dateFromComponents:comps];
	
	// Clean up
	[yearString release];
	[monthString release];
	[dayString release];
	[gregorian release];
	[comps release];
	
	return date;
}


+(NSDate *)newDateWithCurrentYear:(int)month day:(int)day
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:[self currentYear]];
	[comps setMonth:month];
	[comps setDay:day];
	[comps setHour:23];
	[comps setMinute:59];
	[comps setSecond:59];
	NSDate *date = [gregorian dateFromComponents:comps];
	
	[comps release];
	[gregorian release];
	
	return date;
}


+(int)currentYear
{
	NSRange yearRange = {0, 4};
	NSDate *date = [[NSDate alloc] init];
	NSString *dateString = [[NSString alloc] initWithFormat:@"%@", date];
	NSString *yearString = [[[NSString alloc] initWithFormat:@"%@", [dateString substringWithRange:yearRange]] autorelease];
	[date release];
	[dateString release];
	return [yearString intValue];
}


+(NSString *)currentYearString
{
	NSRange yearRange = {0, 4};
	NSDate *date = [[NSDate alloc] init];
	NSString *dateString = [[[NSString alloc] initWithFormat:@"%@", date] autorelease];
	[date release];
	return [dateString substringWithRange:yearRange];
}


+(NSString *)yearFromDate:(NSDate *)date
{
	NSRange yearRange = {0, 4};
	NSString *dateString = [[[NSString alloc] initWithFormat:@"%@", date] autorelease];
	return [dateString substringWithRange:yearRange];
}


+(int)currentMonth
{
	NSRange monthRange = {5, 2};
	NSDate *date = [[NSDate alloc] init];
	NSString *dateString = [[NSString alloc] initWithFormat:@"%@", date];
	NSString *monthString = [[[NSString alloc] initWithFormat:@"%@", [dateString substringWithRange:monthRange]] autorelease];
	[date release];
	[dateString release];
	return [monthString intValue];
}


+(NSString *)currentMonthString
{
	NSRange monthRange = {5, 2};
	NSDate *date = [[NSDate alloc] init];
	NSString *dateString = [[[NSString alloc] initWithFormat:@"%@", date] autorelease];
	[date release];
	return [dateString substringWithRange:monthRange];
}


+(NSString *)monthFromDate:(NSDate *)date
{
	NSRange monthRange = {5, 2};
	NSString *dateString = [[[NSString alloc] initWithFormat:@"%@", date] autorelease];
	return [dateString substringWithRange:monthRange];
}


+(int)currentDay
{
	NSRange dayRange =  {8, 2};
	NSDate *date = [[NSDate alloc] init];
	NSString *dateString = [[NSString alloc] initWithFormat:@"%@", date];
	NSString *dayString = [[[NSString alloc] initWithFormat:@"%@", [dateString substringWithRange:dayRange]] autorelease];
	[date release];
	[dateString release];
	return [dayString intValue];
}


+(NSString *)currentDayString
{
	NSRange dayRange =  {8, 2};
	NSDate *date = [[NSDate alloc] init];
	NSString *dateString = [[[NSString alloc] initWithFormat:@"%@", date] autorelease];
	[date release];
	return [dateString substringWithRange:dayRange];
}


+(NSString *)dayFromDate:(NSDate *)date
{
	NSRange dayRange =  {8, 2};
	NSString *dateString = [[[NSString alloc] initWithFormat:@"%@", date] autorelease];
	return [dateString substringWithRange:dayRange];
}

+(int) intDayFromDate:(NSDate *)date
{
	NSRange dayRange =  {8, 2};
	NSString *dateString = [[[NSString alloc] initWithFormat:@"%@", date] autorelease];
	return [[dateString substringWithRange:dayRange] intValue];
}

+(NSDate *) getNextDayForDay: (NSDate *) date
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];	
	[comps setHour:24];
	NSDate *newDate = [gregorian dateByAddingComponents:comps toDate:date options:0];
	[comps release];
	[gregorian release];
	return newDate;
}

+(NSDate *) getPreviousDayForDay: (NSDate *) date
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];	
	[comps setDay:-1];
	NSDate *newDate = [gregorian dateByAddingComponents:comps toDate:date options:0];
	[comps release];
	[gregorian release];
	return newDate;
}

+(NSDate *) getDayBeforeDate: (NSDate *) date
				 howManyDays: (NSInteger) daysBefore
{
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];	
	[comps setDay:-daysBefore];
	NSDate *newDate = [gregorian dateByAddingComponents:comps toDate:date options:0];
	[comps release];
	[gregorian release];
	return newDate;
}

+(NSMutableDictionary *) getDaysForInterval: (NSDate *) intervalStartDate
								endInterval: (NSDate *) intervalEndDate{
	
	
	NSDate *nextDay = [NSDate dateWithTimeIntervalSince1970:[intervalStartDate timeIntervalSince1970]];
	
	NSMutableDictionary *dictWithDays = [NSMutableDictionary dictionary];
	
	
	while (![[DateFormat monthFromDate: nextDay] isEqualToString:[DateFormat monthFromDate: intervalEndDate]])
	{
		NSMutableArray *monthDays = [NSMutableArray array];
		NSDate *normalizedDate = [DateFormat normalizeDateFromDate:nextDay];
		[monthDays addObject:normalizedDate];		
		NSDate *temp = [DateFormat getNextDayForDay:nextDay];
		
		while ([[DateFormat monthFromDate: nextDay] isEqualToString:[DateFormat monthFromDate: temp]])
		{
			nextDay = [DateFormat getNextDayForDay:nextDay];
			NSDate *normalizedDate = [DateFormat normalizeDateFromDate:nextDay];			
			[monthDays addObject:normalizedDate];
			
			temp = [DateFormat getNextDayForDay:temp];
		}
		[dictWithDays setValue:monthDays forKey:[DateFormat stringValueForDictionaryKeyFromValue:nextDay]];
		nextDay = [NSDate dateWithTimeIntervalSince1970:[temp timeIntervalSince1970]];
	}
	
	NSMutableArray *currentMonth = [NSMutableArray array];
	NSDate *normalizedDate = [DateFormat normalizeDateFromDate:nextDay];
	[currentMonth addObject:normalizedDate];		
	NSDate *temp = [DateFormat getNextDayForDay:nextDay];
	
	while ([[DateFormat normalizeDateFromDate: nextDay] compare:[DateFormat normalizeDateFromDate: intervalEndDate]] == NSOrderedAscending)
	{
		nextDay = [DateFormat getNextDayForDay:nextDay];
		NSDate *normalizedDate = [DateFormat normalizeDateFromDate:nextDay];			
		[currentMonth addObject:normalizedDate];
		
		temp = [DateFormat getNextDayForDay:temp];
	}
	[dictWithDays setValue:currentMonth forKey:[DateFormat stringValueForDictionaryKeyFromValue:nextDay]];
	nextDay = [NSDate dateWithTimeIntervalSince1970:[temp timeIntervalSince1970]];
	
	
	return dictWithDays;
	
}


@end
