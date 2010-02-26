//
//  GraphViewController.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 24.02.2010.
//  Copyright 2010 Mobile Touch SRL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "S7GraphView.h"

@interface GraphViewController : UIViewController <S7GraphViewDataSource>{
	S7GraphView *graphView;
}

@property (nonatomic, retain) S7GraphView *graphView;

@end
