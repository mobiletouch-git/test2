//
//  InfoValutarAPI.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 28.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConverterItem.h"
#import "AsyncronousResponse.h"

@interface InfoValutarAPI : NSObject <AsyncDelegate> {

}

+ (InfoValutarAPI*) sharedInstance;
+(UIImageView *) displayCompanyLogo;
+(NSString *) getStringFromDate: (NSDate *) theDate;
+(NSMutableArray *) getCurrenciesForDate: (NSDate *) specificDate;

+(NSMutableArray *) getValidCurrenciesForDate: (NSDate *) specificDate;


+(NSMutableArray *) getDataForInterval: (NSDate *) startDate endDate:(NSDate *) endDate currencyName: (NSString *) currencyName;
+(NSDate *) getValidBankingDayForDay: (NSDate *) someDate;
+(NSDecimalNumber *) getBaseValueForConverterItem: (ConverterItem *) converterItem; 
+(CurrencyItem *) findCurrencyNamed: (NSString *)currencyName inArray: (NSArray *) anArray;
+(CurrencyItem *) findCurrencyNamed: (NSString *)currencyName inDictionary: (NSDictionary *) aDictionary;
+(CurrencyItem *) getCurrencyForPriority: (NSInteger) priority inDictionary: (NSDictionary *) aDictionary;
+(NSDate *)getUTCFormateDateFromDate: (NSDate *) theDate;
+(NSDate *)getUpdateDateForDate: (NSDate *) theDate;
+(BOOL) isWeekendInRomania;
+(NSDate *) getExtremityDateForCurrencyNamed: (NSString *)currencyName
									   first: (BOOL) yesOrNo;

- (void) updateDatabaseWithTimeStamp: (NSInteger) timeStmp
					inViewController: (UIViewController *)theParentViewController;



@end
