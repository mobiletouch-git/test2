//
//  ErrorObject.h
//  CursValutar
//
//  Created by Mobile Touch SRL on 10/29/09.
//  Copyright 2009 Mobile Touch SRL. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ErrorObject : NSObject {

	NSString *errorCode;
	NSString *errorTitle;	
	NSString *errorMessage;		
	
}

@property (nonatomic, retain) NSString *errorCode;
@property (nonatomic, retain) NSString *errorTitle;	
@property (nonatomic, retain) NSString *errorMessage;		


@end
