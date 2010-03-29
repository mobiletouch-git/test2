//
//  DateFormat
//  Created by Ovidiu Sarbanescu, 2009
//  Utility for NSDate to NSString conversions;  
//

#import <Foundation/Foundation.h>


@interface DateFormat : NSObject 
{
	
}
+(NSString *) stringValueForDictionaryKeyFromValue: (NSDate *) theDate;

+(NSString *)businessStringFromDate:(NSDate *)date;

+(NSString *)simpleDateFormatString:(NSDate *)date;

+(NSString *)DBformatDateFromDate:(NSDate *)date;

+(NSString *) reportStringFromDate:(NSDate *)date;

+(NSString *)normalizedStringFromDate:(NSDate *)date;

+(NSDate *) dateFromNormalizedString:(NSString *)dateString;

+(NSDate *) normalizeDateFromDate: (NSDate *) date;

+(NSString *)monthYearDateString:(NSDate *)date;

+(NSString *)monthYearFromDictionaryKey: (NSString *) dictionaryKey;

+(NSDate *)dateFromString:(NSString *)dateString;

+(NSDate *)newDateWithCurrentYear:(int)month day:(int)day;

+(int)currentYear;
+(NSString *)currentYearString;
+(NSString *)yearFromDate:(NSDate *)date;

+(int)currentMonth;
+(NSString *)currentMonthString;
+(NSString *)monthFromDate:(NSDate *)date;

+(int)currentDay;
+(NSString *)currentDayString;
+(int) intDayFromDate:(NSDate *)date;
+(NSString *)dayFromDate:(NSDate *)date;

+(NSDate *) getNextDayForDay: (NSDate *) date;
+(NSDate *) getPreviousDayForDay: (NSDate *) date;
+(NSDate *) getDayBeforeDate: (NSDate *) date
				 howManyDays: (NSInteger) daysBefore;

+(NSMutableDictionary *) getDaysForInterval: (NSDate *) intervalStartDate
								endInterval: (NSDate *) intervalEndDate;
@end
