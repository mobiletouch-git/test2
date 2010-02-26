//
//  InfoValutarAppDelegate.m
//  InfoValutar
//
//  Created by Mobile Touch SRL on 29.01.2010.
//  Copyright Mobile Touch SRL 2010. All rights reserved.
//

#import "InfoValutarAppDelegate.h"


@implementation InfoValutarAppDelegate

@synthesize window;
@synthesize currencyViewController, converterViewController, statisticsViewController, taxesViewController, infoViewController;
@synthesize currencyNavigationController, converterNavigationController, statisticsNavigationController, taxesNavigationController, infoNavigationController;
@synthesize tabBarController;
@synthesize currencyFullDictionary;

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

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[self initializeDatabase];
	[self initializeLayout];
	
	[window addSubview:tabBarController.view];	
	[window makeKeyAndVisible];
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
	NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
	//write tabbar position
	[prefs setInteger:[self.tabBarController selectedIndex] forKey:@"selectedTabIndex"];	
	
	NSMutableArray *converterList = [converterViewController tableDataSource];
	NSData *converterListData = [NSKeyedArchiver archivedDataWithRootObject:converterList];
	[prefs setObject:converterListData forKey:@"converterList"];

	NSData *converterReferenceData = [NSKeyedArchiver archivedDataWithRootObject:[[self converterViewController] referenceItem]];
	[prefs setObject:converterReferenceData forKey:@"converterReferenceItem"];
	
	
	NSMutableArray *taxesList = [taxesViewController tableDataSource];
	NSData *taxesListData = [NSKeyedArchiver archivedDataWithRootObject:taxesList];
	[prefs setObject:taxesListData forKey:@"taxesList"];
	
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

-(void) initializeDatabase
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"InfoValutar.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"InfoValutar.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
	
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
	tabBarController.viewControllers = [NSArray arrayWithObjects:	currencyNavigationController, 
										converterNavigationController, 
										statisticsNavigationController,
										taxesNavigationController,
										infoNavigationController,
										nil];
	
	//read tabbar Index from NSUserDefauls	
	int selectedTabIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedTabIndex"];
	[tabBarController setSelectedIndex:selectedTabIndex];
	
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"CurrencyNames" ofType:@"plist"];
	NSDictionary *fullList = [NSDictionary dictionaryWithContentsOfFile:path];
	
	if (fullList)
		currencyFullDictionary = [fullList retain];
	
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

@end

