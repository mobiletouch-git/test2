//
//  AdditionFactorItem.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 15.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AdditionFactorItem : NSObject {
	NSString *factorName;
	int factorSign;
	NSNumber *factorValue;
	BOOL checked;
}

@property (nonatomic, retain) NSString *factorName;
@property (nonatomic, assign) int factorSign;
@property (nonatomic, retain) NSNumber *factorValue;
@property (nonatomic, assign) BOOL checked;

@end
