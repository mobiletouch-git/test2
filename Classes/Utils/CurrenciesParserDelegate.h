//
//  CurrenciesParserDelegate.h
//  CursValutar
//
//  Created by Mobile Touch SRL on 10/29/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrencyItem.h"
#import "ErrorObject.h"

@interface CurrenciesParserDelegate : NSObject {

@private	
	NSMutableString *contentofNode;
	CurrencyItem *currReference;
	ErrorObject *errorObject;
	NSDate *currentDate;
}

@property (nonatomic, retain) NSMutableString *contentofNode;
@property (nonatomic, retain) NSDate *currentDate;

@end
