//
//  Currency.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 01.03.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Currency :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * currencyName;
@property (nonatomic, retain) NSDate * currencyDate;
@property (nonatomic, retain) NSNumber * currencyMultiplier;
@property (nonatomic, retain) NSDecimalNumber * currencyValue;

@end



