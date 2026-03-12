//
//  AppDelegate_iPhone.m
//  iHagada
//
//  Created by Yuval Tessone on 3/1/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "ImageViewController.h"
#import "MainTableViewController.h"
#import "RootViewController.h"
#import "RecipesTableViewController.h"
#import "AboutUsViewController.h"
#import "SongsTableViewController.h"
#import "FourSonsViewController.h"
#import "CustomAlertView.h"

@implementation AppDelegate_iPhone

@synthesize window, tabBarController;

@synthesize fbGraph;
@synthesize feedPostId;

//static languageType chosenLanguageType;

BOOL isHebrew;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	[NSThread sleepForTimeInterval:1];
	[window setBackgroundColor:[UIColor blackColor]];
	
	isHebrew = YES;
	
	NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:5];
	
	MainTableViewController *mainTableViewController;
	mainTableViewController = [[MainTableViewController alloc] initWithNibName:@"MainTableViewController" bundle:nil];
	mainTableViewController.delegate = self;
	RootViewController *rootViewController = [[RootViewController alloc] initWithRootViewController:mainTableViewController];	
	
	rootViewController.tabBarItem.title = @"פרקי ההגדה";
    rootViewController.tabBarItem.image = [UIImage imageNamed:@"bookmarks.png"];
	
	[localViewControllersArray addObject:rootViewController];
	
	SongsTableViewController *songsTableViewController;
	songsTableViewController = [[SongsTableViewController alloc] initWithNibName:@"SongsTableViewController" bundle:nil];
	songsTableViewController.delegate = self;	
	RootViewController *songsRootViewController = [[RootViewController alloc] initWithRootViewController:songsTableViewController];	
	
	songsRootViewController.tabBarItem.title = @"שירים";
    songsRootViewController.tabBarItem.image = [UIImage imageNamed:@"note_icon.png"];
	
	[localViewControllersArray addObject:songsRootViewController];
	
	
	RecipesTableViewController *recipesTableViewController;
	recipesTableViewController = [[RecipesTableViewController alloc] initWithNibName:@"RecipesTableViewController" bundle:nil];
    recipesTableViewController.delegate = self;
	RootViewController *recipesRootViewController = [[RootViewController alloc] initWithRootViewController:recipesTableViewController];	

	recipesRootViewController.tabBarItem.title = @"מתכונים לחג";
    recipesRootViewController.tabBarItem.image = [UIImage imageNamed:@"recipes_icon.png"];
		
	[localViewControllersArray addObject:recipesRootViewController];
	
	FourSonsViewController *fourSonsViewController = [[FourSonsViewController alloc] initWithNibName:@"FourSonsViewController" bundle:nil];
    
	fourSonsViewController.delegate = self;
    
    RootViewController *fourSonsRootViewController = [[RootViewController alloc] initWithRootViewController:fourSonsViewController];	
    
	fourSonsRootViewController.tabBarItem.title = @"ארבעה בנים";
    fourSonsRootViewController.tabBarItem.image = [UIImage imageNamed:@"mask_icon.png"];
    
	[localViewControllersArray addObject:fourSonsRootViewController];
    
	AboutUsViewController *aboutUsViewController;
	
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            aboutUsViewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewControllerHD" bundle:nil];
		else
			aboutUsViewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
	#endif
	

	RootViewController *aboutRootViewController = [[RootViewController alloc] initWithRootViewController:aboutUsViewController];
	
	aboutUsViewController.delegate = self;
	
	aboutRootViewController.tabBarItem.title = @"אודות";
    aboutRootViewController.tabBarItem.image = [UIImage imageNamed:@"about_icon.png"];
	
	[localViewControllersArray addObject:aboutRootViewController];
	

		tabBarController.viewControllers = localViewControllersArray;
		if (@available(iOS 18.0, *)) {
			tabBarController.mode = UITabBarControllerModeTabBar;
		}
		tabBarController.tabBar.barStyle = UIBarStyleBlack;
		tabBarController.tabBar.translucent = NO;
		tabBarController.tabBar.backgroundColor = [UIColor blackColor];
		if ([tabBarController.tabBar respondsToSelector:@selector(setBarTintColor:)]) {
			tabBarController.tabBar.barTintColor = [UIColor blackColor];
		}
		if (@available(iOS 13.0, *)) {
			UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
			[appearance configureWithOpaqueBackground];
			appearance.backgroundColor = [UIColor blackColor];
			tabBarController.tabBar.standardAppearance = appearance;
			if (@available(iOS 15.0, *)) {
				tabBarController.tabBar.scrollEdgeAppearance = appearance;
			}
			[appearance release];
		}
		[localViewControllersArray release];
//	[window addSubview:tabBarController.view];
	[window setRootViewController:tabBarController];  // Fix for iOS6 shouldAutorotateToInterfaceOrientation deprecated method
    
	/*
	UIViewController *rootViewController = [[[ImageViewController alloc] init] autorelease];
	viewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	[window addSubview:viewController.view];
	 */
	
    [window makeKeyAndVisible];
	
	return YES;
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
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    UIViewController *selectedViewController = self.tabBarController.selectedViewController;
    UIViewController *topViewController = selectedViewController;

    if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
        topViewController = [(UINavigationController *)selectedViewController topViewController];
    }

    NSString *topViewControllerClassName = NSStringFromClass([topViewController class]);
    BOOL requiresPortraitOnly =
        [topViewControllerClassName isEqualToString:@"FourSonsViewController"] ||
        [topViewControllerClassName isEqualToString:@"FourSonsChooseThemeViewController"] ||
        [topViewControllerClassName isEqualToString:@"RecipesTableViewController"] ||
        [topViewControllerClassName isEqualToString:@"RecipeViewController"];

    if (requiresPortraitOnly) {
        return UIInterfaceOrientationMaskPortrait;
    }

    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)changeLanguage {
	if (isHebrew) {
		//NSLog(@"to english");
		isHebrew = NO;		
		[[[tabBarController.viewControllers objectAtIndex:0] tabBarItem] setTitle:@"Chapters"];
		[[[tabBarController.viewControllers objectAtIndex:1] tabBarItem] setTitle:@"Songs"];				
		[[[tabBarController.viewControllers objectAtIndex:2] tabBarItem] setTitle:@"Recipes"];	
        [[[tabBarController.viewControllers objectAtIndex:3] tabBarItem] setTitle:@"Four Sons"];			
		[[[tabBarController.viewControllers objectAtIndex:4] tabBarItem] setTitle:@"About"];				
	} else {
		//NSLog(@"to hebrew");		
		isHebrew = YES;		
		[[[tabBarController.viewControllers objectAtIndex:0] tabBarItem] setTitle:@"פרקי ההגדה"];
		[[[tabBarController.viewControllers objectAtIndex:1] tabBarItem] setTitle:@"שירים"];		
		[[[tabBarController.viewControllers objectAtIndex:2] tabBarItem] setTitle:@"מתכונים לחג"];
        [[[tabBarController.viewControllers objectAtIndex:3] tabBarItem] setTitle:@"ארבעה בנים"];
		[[[tabBarController.viewControllers objectAtIndex:4] tabBarItem] setTitle:@"אודות"];				
	}
}

/* This Method is being called from willRotateToInterfaceOrientation inside the viewControllers.
 Its purpose is to rotate manually all the other view controllers except the one which invoke this method */
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{	
	if ([sender isKindOfClass:[MainTableViewController class]]) {		
		
		/* Rotating SongsTableViewController */
		[[[[tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
		
	} else if ([sender isKindOfClass:[SongsTableViewController class]]) {
		
		/* Rotating MainTableViewController */
		[[[[tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
		
	} else if ([sender isKindOfClass:[RecipesTableViewController class]]) {

		/* Rotating MainTableViewController */
		[[[[tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];

		/* Rotating SongsTableViewController */
		[[[[tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
		
	} else if ([sender isKindOfClass:[FourSonsViewController class]]) {
		
		/* Rotating MainTableViewController */
		[[[[tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
		
		/* Rotating SongsTableViewController */
		[[[[tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
		
	} else if ([sender isKindOfClass:[AboutUsViewController class]]) {
		
		/* Rotating MainTableViewController */
		[[[[tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
		
		/* Rotating SongsTableViewController */
		[[[[tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
		
	}
}

/*
+ (void) setChosenLanguageType:(languageType)chosenLanguageTypeParam {
	chosenLanguageType = chosenLanguageTypeParam;
	//	[self.navigationController pushViewController:self.RootViewController animated:NO];
}


+ (languageType) chosenLanguageType {
	return chosenLanguageType;
}*/

#pragma Alert
- (void) alertWithTitle:(NSString*)title messageForAlert:(NSString *)message titleForButton:(NSString *)buttonTitle {
    [self performSelectorOnMainThread:@selector(alertOnMainThread:) withObject:[NSArray arrayWithObjects:title, message, buttonTitle, nil] waitUntilDone:NO];
    
}
-(void)alertOnMainThread:(NSArray *)arr {
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:[arr objectAtIndex:0] message:[arr objectAtIndex:1] delegate:self cancelButtonTitle: [arr objectAtIndex:2] otherButtonTitles:nil];
	[alert show];
	[alert release];
}
#pragma -

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
	[tabBarController release];
    [window release];
    
    if (feedPostId != nil) {
		[feedPostId release];
	}
	[fbGraph release];
    
    [super dealloc];
}


@end
