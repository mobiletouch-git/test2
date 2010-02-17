//
//  ConverterItem.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyItem.h"

@interface ConverterItem : NSObject {
		
	CurrencyItem *currency;
	NSMutableArray *additionFactors;
	NSNumber *converterValue;
}

@property (nonatomic, retain) CurrencyItem *currency;
@property (nonatomic, retain) NSMutableArray *additionFactors;
@property (nonatomic, retain) NSNumber *converterValue;

@end
