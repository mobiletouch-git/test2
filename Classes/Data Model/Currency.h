//
//  Currency.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 29.01.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Currency :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * currencyName;
@property (nonatomic, retain) NSDate * currencyDate;
@property (nonatomic, retain) NSString * currencyMultiplier;
@property (nonatomic, retain) NSString * currencyValue;

@end



