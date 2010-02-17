//
//  CurrencyItem.h
//  CursValutar
//
//  Created by Mobile Touch SRL on 10/27/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrencyItem : NSObject {

	NSString *currencyName;
	NSString *multiplierValue;
	NSString *currencyValue;
	NSString *change;
	NSString *sign;	
	NSInteger priority;
}

@property (nonatomic, retain) NSString *currencyName;
@property (nonatomic, retain) NSString *multiplierValue;
@property (nonatomic, retain) NSString *currencyValue;
@property (nonatomic, retain) NSString *change;
@property (nonatomic, retain) NSString *sign;	
@property (nonatomic, assign) NSInteger priority;

-(NSString *) description;

@end
