//
//  InfoValutarAppDelegate.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 29.01.2010.
//  Copyright Mobile Touch SRL 2010. All rights reserved.
//

#import "InfoValutarAppDelegate.h"
#import "InfoValutarAPI.h"
#import "DateFormat.h"
#import "UIFactory.h"
#import "Constants.h"
#import "CurrenciesParserDelegate.h"
#import "Reachability.h"

@implementation UINavigationBar (CustomImage)

- (void)setNeedsLayout{
	//self.tintColor = definedColor;
}

@end

@implementation InfoValutarAppDelegate

@synthesize window;
@synthesize currencyViewController, converterViewController, statisticsViewController, taxesViewController, infoViewController;
@synthesize currencyNavigationController, converterNavigationController, statisticsNavigationController, taxesNavigationController, infoNavigationController;
@synthesize tabBarController;
@synthesize currencyFullDictionary;
@synthesize globalTimeStamp, dataWasUpdated;
@synthesize displayValidMode;
@synthesize updateCurrentDateConverter,updateCurrentDateCurrency, tableViewIsInEditMode;

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
	[currencyViewController release];
	[converterViewController release];
	[statisticsViewController release];
	[taxesViewController release];
	[infoViewController release];
	
	[currencyNavigationController release];
	[converterNavigationController release];
	[statisticsNavigationController release];
	[taxesNavigationController release];
	[infoNavigationController release];
	[tabBarController release];
	[currencyFullDictionary release];
	
    [window release];
    [super dealloc];
}


- (void)initDefault{
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"YES", @"Cursul licitat", nil] forKeys:[NSArray arrayWithObjects:@"sAutomaticUpdate", @"currencyModeKey", nil]];
	
	[defaults registerDefaults:appDefaults];
	
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {   
    // Override point for customization after app launch    

//	[self populate];
	
	//delege nsuserdefaults - for testing purposes
	//[[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];

	[self initializeDatabase];
	[self readFromDefaults];
	updateCurrentDateConverter = YES;
	updateCurrentDateCurrency = YES;
	userAction = YES;
	id setting = [[NSUserDefaults standardUserDefaults] objectForKey:@"sAutomaticUpdate"];
	if (!setting)
		[self initDefault];
	
	BOOL settingsUpdate = [[NSUserDefaults standardUserDefaults] boolForKey:@"sAutomaticUpdate"];
	NSString *settingsModeString = [[NSUserDefaults standardUserDefaults] stringForKey:@"currencyModeKey"];
	if ([settingsModeString isEqualToString:@"Cursul licitat"])
		[self setDisplayValidMode:NO];
	else
		[self setDisplayValidMode:YES];
	
	if (settingsUpdate) {
		userAction = NO; 
		[self checkForUpdates];
	}
	

	[self initializeLayout];
	[window addSubview:tabBarController.view];	

	[window makeKeyAndVisible];

}

-(void) populate
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"database" ofType:@"xml"];
	NSData *xmlData = [NSData dataWithContentsOfFile:path];
	
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: xmlData];
	
	CurrenciesParserDelegate *parserDelegate = [[CurrenciesParserDelegate alloc] init];
	[xmlParser setDelegate:parserDelegate];
	[xmlParser setShouldProcessNamespaces:YES];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
	
	BOOL success = [xmlParser parse];
	
	if(success)
	{
	}
	else {
		NSLog(@"Parsing error");
	}
	
	[xmlParser setDelegate:nil];
	[xmlParser abortParsing];
	[xmlParser release];
	[parserDelegate release];	
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
	NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
	//write tabbar position
	
	NSMutableArray *converterList = [converterViewController tableDataSource];
	NSData *converterListData = [NSKeyedArchiver archivedDataWithRootObject:converterList];
	[prefs setObject:converterListData forKey:@"converterList"];
	
	ConverterItem *item = [[self converterViewController] referenceItem];
	NSData *converterReferenceData = [NSKeyedArchiver archivedDataWithRootObject: item];
	[prefs setObject:converterReferenceData forKey:@"converterReferenceItem"];
	[prefs setBool:[converterViewController converterHasBeenUpdated] forKey:@"converterUpdated"];
	
	NSMutableArray *taxesList = [taxesViewController tableDataSource];
	NSData *taxesListData = [NSKeyedArchiver archivedDataWithRootObject:taxesList];
	[prefs setObject:taxesListData forKey:@"taxesList"];
	[prefs setBool:[taxesViewController taxesHaveBeenUpdated] forKey:@"taxesUpdated"];
	
	NSMutableDictionary *dateRangeDictionary = [statisticsViewController dateRangeDictionary];
	NSData *dateRangeDictionaryData = [NSKeyedArchiver archivedDataWithRootObject:dateRangeDictionary];
	[prefs setObject:dateRangeDictionaryData forKey:@"dateRangeDictionary"];
	
	NSMutableArray *currenciesList = [statisticsViewController currenciesList];
	NSData *currenciesListData = [NSKeyedArchiver archivedDataWithRootObject:currenciesList];
	[prefs setObject:currenciesListData forKey:@"statisticsCurrenciesList"];
	
	[prefs synchronize];
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }	
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
	//write tabbar position
	
	NSMutableArray *converterList = [converterViewController tableDataSource];
	NSData *converterListData = [NSKeyedArchiver archivedDataWithRootObject:converterList];
	[prefs setObject:converterListData forKey:@"converterList"];
	
	ConverterItem *item = [[self converterViewController] referenceItem];
	NSData *converterReferenceData = [NSKeyedArchiver archivedDataWithRootObject: item];
	[prefs setObject:converterReferenceData forKey:@"converterReferenceItem"];
	[prefs setBool:[converterViewController converterHasBeenUpdated] forKey:@"converterUpdated"];
	
	NSMutableArray *taxesList = [taxesViewController tableDataSource];
	NSData *taxesListData = [NSKeyedArchiver archivedDataWithRootObject:taxesList];
	[prefs setObject:taxesListData forKey:@"taxesList"];
	[prefs setBool:[taxesViewController taxesHaveBeenUpdated] forKey:@"taxesUpdated"];
	
	NSMutableDictionary *dateRangeDictionary = [statisticsViewController dateRangeDictionary];
	NSData *dateRangeDictionaryData = [NSKeyedArchiver archivedDataWithRootObject:dateRangeDictionary];
	[prefs setObject:dateRangeDictionaryData forKey:@"dateRangeDictionary"];
	
	NSMutableArray *currenciesList = [statisticsViewController currenciesList];
	NSData *currenciesListData = [NSKeyedArchiver archivedDataWithRootObject:currenciesList];
	[prefs setObject:currenciesListData forKey:@"statisticsCurrenciesList"];
	
	[prefs synchronize];
	
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        } 
    }
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	[[NSUserDefaults standardUserDefaults] synchronize];
	BOOL settingsUpdate = [[NSUserDefaults standardUserDefaults] boolForKey:@"sAutomaticUpdate"];
	NSString *settingsModeString = [[NSUserDefaults standardUserDefaults] stringForKey:@"currencyModeKey"];
	if ([settingsModeString isEqualToString:@"Cursul licitat"]){
		[self setDisplayValidMode:NO];
	}
	else{
		[self setDisplayValidMode:YES];
	}
	if (settingsUpdate) {
		userAction = NO; 
		[self checkForUpdates];
	}
	updateCurrentDateConverter = YES;
	updateCurrentDateCurrency = YES;
	[converterViewController viewWillAppear:NO];
	[currencyViewController viewWillAppear:NO];
	
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}



-(void) initializeDatabase
{
    BOOL updateDetected = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *updateVersion = [userDefaults objectForKey:@"CurrentApplicationVersion"];
    NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if ([bundleVersion isEqualToString:updateVersion] == NO) {
        updateDetected = YES;
        [userDefaults setObject:bundleVersion forKey:@"CurrentApplicationVersion"];
    }
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"InfoValutar.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success && updateDetected == NO) return;
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"InfoValutar.sqlite"];
    [fileManager removeItemAtPath:writableDBPath error:nil];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
	//NSLog(@"path for file: %@",writableDBPath);
}

-(void) readFromDefaults
{
	int savedTimeStamp = [[NSUserDefaults standardUserDefaults] integerForKey:@"globalTimeStamp"];
	if (savedTimeStamp)
		[self setGlobalTimeStamp:savedTimeStamp];
	else
	{
		NSString *path = [[NSBundle mainBundle] pathForResource:@"UpdateSettings" ofType:@"plist"];
		NSDictionary *source = [NSDictionary dictionaryWithContentsOfFile:path];
		NSString *savedTmpStamp = [source valueForKey:@"timeStamp"];
		[self setGlobalTimeStamp:[savedTmpStamp intValue]];
	}
	
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"CurrencyNames" ofType:@"plist"];
	NSDictionary *fullList = [NSDictionary dictionaryWithContentsOfFile:path];
	if (fullList)
		currencyFullDictionary = [fullList retain];
	
}

-(void) initializeLayout
{
	currencyViewController = [[CurrencyViewController alloc] init];
	converterViewController = [[ConverterViewController alloc] init];
	statisticsViewController = [[StatisticsViewController alloc] init];
	taxesViewController = [[TaxesViewController alloc] init];
	infoViewController = [[InfoViewController alloc] initWithStyle:UITableViewStyleGrouped];	
	
	// create a navigation controller using the new controller
	currencyNavigationController = [[UINavigationController alloc] initWithRootViewController:currencyViewController];
	converterNavigationController = [[UINavigationController alloc] initWithRootViewController:converterViewController];
	statisticsNavigationController = [[UINavigationController alloc] initWithRootViewController:statisticsViewController];
	taxesNavigationController = [[UINavigationController alloc] initWithRootViewController:taxesViewController];
	infoNavigationController = [[UINavigationController alloc] initWithRootViewController:infoViewController];	
	
	//initiating the tabbar controller	
	self.tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers = [NSArray arrayWithObjects:	converterNavigationController,
										currencyNavigationController, 
										statisticsNavigationController,
										taxesNavigationController,
										infoNavigationController,
										nil];
	
	//read tabbar Index from NSUserDefauls	
}


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"InfoValutar.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark UpdateDatabase

-(void) checkForUpdates
{	
	Reachability *isNetworkAvailable=[Reachability reachabilityForInternetConnection];
	if (![isNetworkAvailable isReachable]) {
		[UIFactory showOkAlert:@"Conectare imposibila. \n Aplicatia necesita conexiune la internet pentru actualizare." title:@"No Internet Connection"];
		return;
	}
		 
	//Test if update is needed and initiate update
	
	NSDate *now = [NSDate date];
	
	NSDate *nTodayDate = [DateFormat normalizeDateFromDate:[NSDate date]];
	NSString *todayDateStr = [DateFormat DBformatDateFromDate:nTodayDate];

	NSDate *utcDate = [InfoValutarAPI getUTCFormateDateFromDate:nTodayDate];
	NSDate *validBankingDate = [InfoValutarAPI getValidBankingDayForDay:utcDate];
	NSString *validBankingDateStr = [DateFormat DBformatDateFromDate:validBankingDate];

	NSDate *updateDate = [InfoValutarAPI getUpdateDateForDate:utcDate];
	
	NSDate *yesterdayDate = [DateFormat getPreviousDayForDay:nTodayDate]; 
	yesterdayDate = [InfoValutarAPI getUTCFormateDateFromDate:yesterdayDate];
	
	BOOL mustUpdate = NO;
	
	if ([todayDateStr compare:validBankingDateStr]==1)  { // Latest valid banking date is older than today
		
		if (![yesterdayDate compare:validBankingDate] || [InfoValutarAPI isMondayInRomania] || [InfoValutarAPI isSaturdayInRomania] || [InfoValutarAPI isSundayInRomania]) { //Latest update is yesterdays
			
			if ([now compare:updateDate]==1) {	//It's past 11GMT
					mustUpdate = YES;
			}
			else  {								//Not 11GTM yes

				if (userAction)  { // manual update
					NSDate *today = [NSDate date];
					NSString *todayStr = [DateFormat businessStringFromDate:today];
					[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul BNR licitat în data de %@ nu a fost încă publicat.",todayStr]
									 title:nil];
				}
				mustUpdate = YES;	
				
				if ([InfoValutarAPI isMondayInRomania])
				{
					NSDate *fridayDate = [DateFormat getDayBeforeDate:utcDate 
														  howManyDays:3];
					NSDate *fridayUTCDate = [InfoValutarAPI getUTCFormateDateFromDate:fridayDate];				
					if (![fridayUTCDate compare:validBankingDate]) // is monday and we have the friday currency
						mustUpdate = NO;
					else
						mustUpdate =YES;
				}				
			}
			
			if ([InfoValutarAPI isSaturdayInRomania])
			{
				NSDate *fridayDate = [DateFormat getDayBeforeDate:utcDate 
													  howManyDays:1];
				NSDate *fridayUTCDate = [InfoValutarAPI getUTCFormateDateFromDate:fridayDate];				
				if (![fridayUTCDate compare:validBankingDate]) // is saturday and we have the friday currency
				{
					mustUpdate = NO;
					if (userAction) {
						[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul BNR este la zi."]title:nil];					
					}
				}
				else
					mustUpdate =YES;
				
			}
		
			if ([InfoValutarAPI isSundayInRomania])
			{
				NSDate *fridayDate = [DateFormat getDayBeforeDate:utcDate 
													  howManyDays:2];
				NSDate *fridayUTCDate = [InfoValutarAPI getUTCFormateDateFromDate:fridayDate];				
				if (![fridayUTCDate compare:validBankingDate]) // is saturday and we have the friday currency
				{
					mustUpdate = NO;
					if (userAction) {
						[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul BNR este la zi."]title:nil];					
					}
				}
				else
					mustUpdate =YES;
				
			}
			
		}
		else {		//Latest update is older than yesterday
			mustUpdate = YES;
		}

		
	}
	else {												// Latest valid banking date is up to date
		if (userAction) {
			[UIFactory showOkAlert:[NSString stringWithFormat:@"Cursul BNR este la zi."]title:nil];
		}
	}
	
	userAction = YES;

	if (mustUpdate)
	{
		[[InfoValutarAPI sharedInstance] updateDatabaseWithTimeStamp:self.globalTimeStamp
											inViewController:currencyViewController];
	}
	
}

-(void)removeAllStores
{
    NSArray *stores = [persistentStoreCoordinator persistentStores];
    
    for(NSPersistentStore *store in stores) {
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
        [persistentStoreCoordinator removePersistentStore:store error:nil];
    }
    
    [managedObjectContext release];
    managedObjectContext = nil;
    
    [persistentStoreCoordinator release], 
    persistentStoreCoordinator = nil;
}

@end

