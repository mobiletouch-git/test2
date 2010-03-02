//
//  InfoValutarAPI.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 28.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConverterItem.h"

@interface InfoValutarAPI : NSObject {

}

+(NSString *) getStringFromDate: (NSDate *) theDate;
+(NSMutableArray *) getCurrenciesForDate: (NSDate *) specificDate;
+(NSMutableArray *) getDataForInterval: (NSDate *) startDate endDate:(NSDate *) endDate currencyName: (NSString *) currencyName;
+(NSDate *) getValidBankingDayForDay: (NSDate *) someDate;
+(NSDecimalNumber *) getBaseValueForConverterItem: (ConverterItem *) converterItem; 
+(CurrencyItem *) findCurrencyNamed: (NSString *)currencyName inArray: (NSArray *) anArray;
+(CurrencyItem *) getCurrencyForPriority: (NSInteger) priority inDictionary: (NSDictionary *) aDictionary;
+(NSDate *)getUTCFormateDate:(NSDate *)theDate;
@end
