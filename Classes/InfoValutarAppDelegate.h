//
//  InfoValutarAppDelegate.h
//  InfoValutar
//
//  Created by Mobile Touch SRL on 29.01.2010.
//  Copyright Mobile Touch SRL 2010. All rights reserved.
//

#import "CurrencyViewController.h"
#import "ConverterViewController.h"
#import "TaxesViewController.h"
#import "StatisticsViewController.h"
#import "InfoViewController.h"
#import <CoreData/CoreData.h>

@interface InfoValutarAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
	
	CurrencyViewController *currencyViewController;
	ConverterViewController *converterViewController;
	TaxesViewController *taxesViewController;
	StatisticsViewController *statisticsViewController;
	InfoViewController *infoViewController;
	
	UINavigationController *currencyNavigationController;
	UINavigationController *converterNavigationController;
	UINavigationController *statisticsNavigationController;
	UINavigationController *taxesNavigationController;
	UINavigationController *infoNavigationController;	
	
	UITabBarController *tabBarController;
	
	NSDictionary *currencyFullDictionary;	
	
	
	NSInteger globalTimeStamp;
	BOOL userAction, dataWasUpdated;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) CurrencyViewController *currencyViewController;
@property (nonatomic, retain) ConverterViewController *converterViewController;
@property (nonatomic, retain) TaxesViewController *taxesViewController;
@property (nonatomic, retain) StatisticsViewController *statisticsViewController;
@property (nonatomic, retain) InfoViewController *infoViewController;

@property (nonatomic, retain) UINavigationController *currencyNavigationController;
@property (nonatomic, retain) UINavigationController *converterNavigationController;
@property (nonatomic, retain) UINavigationController *statisticsNavigationController;
@property (nonatomic, retain) UINavigationController *taxesNavigationController;
@property (nonatomic, retain) UINavigationController *infoNavigationController;	

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) NSDictionary *currencyFullDictionary;	

@property (nonatomic, assign) NSInteger globalTimeStamp;
@property (nonatomic, assign) BOOL dataWasUpdated;

- (NSString *)applicationDocumentsDirectory;
-(void) initializeDatabase;
-(void) initializeLayout;
-(void) checkForUpdates;
-(void) populate;
@end

