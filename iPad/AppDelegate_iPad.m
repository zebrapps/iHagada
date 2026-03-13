//
//  AppDelegate_iPad.m
//  iHagada
//
//  Created by Yuval Tessone on 3/1/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import "AppDelegate_iPad.h"
#import "ImageViewController.h"
#import "HagadaChaptersViewController.h"
#import "RootViewController.h"
#import "AboutUsViewController.h"
#import "SongsIpadViewController.h"
#import "RecipesIpadViewController.h"

static UIImage *TintedTabBarImageNamed(NSString *imageName, UIColor *tintColor) {
    UIImage *sourceImage = [UIImage imageNamed:imageName];
    if (sourceImage == nil) {
        return nil;
    }

    UIGraphicsBeginImageContextWithOptions(sourceImage.size, NO, sourceImage.scale);
    CGRect imageRect = CGRectMake(0.0f, 0.0f, sourceImage.size.width, sourceImage.size.height);
    [tintColor setFill];
    UIRectFill(imageRect);
    [sourceImage drawInRect:imageRect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [tintedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

static UIImage *WhiteTabBarImageNamed(NSString *imageName) {
    return TintedTabBarImageNamed(imageName, [UIColor whiteColor]);
}

static UIImage *BlueTabBarImageNamed(NSString *imageName) {
    return TintedTabBarImageNamed(imageName, [UIColor colorWithRed:0.0f green:0.478f blue:1.0f alpha:1.0f]);
}

static void ConfigureTabBarItemTitleColors(UITabBarItem *tabBarItem) {
    NSDictionary *normalTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                     forKey:NSForegroundColorAttributeName];
    NSDictionary *selectedTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                       forKey:NSForegroundColorAttributeName];
    [tabBarItem setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
}

@implementation AppDelegate_iPad

@synthesize window, tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
/*
	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Default.png"]];
	[NSThread sleepForTimeInterval:1];
	window.backgroundColor = background;
	[background release];
	
	UIViewController *rootViewController = [[[ImageViewController alloc] init] autorelease];
	viewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	[window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
*/

	/*
	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Default.png"]];
	[NSThread sleepForTimeInterval:1];
	window.backgroundColor = background;
	[background release];
	*/
	
	[NSThread sleepForTimeInterval:1];
	[window setBackgroundColor:[UIColor blackColor]];
	
	isHebrew = YES;
	
	NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:5];
	
		
	HagadaChaptersViewController *hagadaChaptersViewController;
	hagadaChaptersViewController = [[HagadaChaptersViewController alloc] initWithNibName:@"HagadaChaptersViewController" bundle:nil];
	hagadaChaptersViewController.delegate = self;
		RootViewController *rootViewController = [[RootViewController alloc] initWithRootViewController:hagadaChaptersViewController];	
		
		rootViewController.tabBarItem.title = @"פרקי ההגדה";
    rootViewController.tabBarItem.image = WhiteTabBarImageNamed(@"bookmarks.png");
    rootViewController.tabBarItem.selectedImage = BlueTabBarImageNamed(@"bookmarks.png");
    ConfigureTabBarItemTitleColors(rootViewController.tabBarItem);
		
		[localViewControllersArray addObject:rootViewController];	
	
	SongsIpadViewController *songsIpadViewController;
	songsIpadViewController = [[SongsIpadViewController alloc] initWithNibName:@"SongsIpadViewController" bundle:nil];
	songsIpadViewController.delegate = self;	
		RootViewController *songsRootViewController = [[RootViewController alloc] initWithRootViewController:songsIpadViewController];	
		
		songsRootViewController.tabBarItem.title = @"שירים";
		songsRootViewController.tabBarItem.image = WhiteTabBarImageNamed(@"note_icon.png");
        songsRootViewController.tabBarItem.selectedImage = BlueTabBarImageNamed(@"note_icon.png");
        ConfigureTabBarItemTitleColors(songsRootViewController.tabBarItem);
		
		[localViewControllersArray addObject:songsRootViewController];
	
	/*
	RecipesTableViewController *recipesTableViewController;
	recipesTableViewController = [[RecipesTableViewController alloc] initWithNibName:@"RecipesTableViewController" bundle:nil];
	*/
	RecipesIpadViewController *recipesIpadViewController;
	recipesIpadViewController = [[RecipesIpadViewController alloc] initWithNibName:@"RecipesIpadViewController" bundle:nil];
	recipesIpadViewController.delegate = self;
		RootViewController *recipesRootViewController = [[RootViewController alloc] initWithRootViewController:recipesIpadViewController];	
		
		recipesRootViewController.tabBarItem.title = @"מתכונים לחג";
    recipesRootViewController.tabBarItem.image = WhiteTabBarImageNamed(@"recipes_icon.png");
    recipesRootViewController.tabBarItem.selectedImage = BlueTabBarImageNamed(@"recipes_icon.png");
    ConfigureTabBarItemTitleColors(recipesRootViewController.tabBarItem);
		
		[localViewControllersArray addObject:recipesRootViewController];
	
	FourSonsViewController *fourSonsViewController = [[FourSonsViewController alloc] initWithNibName:@"FourSonsViewControllerHD" bundle:nil];
    
	fourSonsViewController.delegate = self;
    
    RootViewController *fourSonsRootViewController = [[RootViewController alloc] initWithRootViewController:fourSonsViewController];	
    
		fourSonsRootViewController.tabBarItem.title = @"ארבעה בנים";
    fourSonsRootViewController.tabBarItem.image = WhiteTabBarImageNamed(@"mask_icon.png");
    fourSonsRootViewController.tabBarItem.selectedImage = BlueTabBarImageNamed(@"mask_icon.png");
    ConfigureTabBarItemTitleColors(fourSonsRootViewController.tabBarItem);
    
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
    aboutRootViewController.tabBarItem.image = WhiteTabBarImageNamed(@"about_icon.png");
    aboutRootViewController.tabBarItem.selectedImage = BlueTabBarImageNamed(@"about_icon.png");
    ConfigureTabBarItemTitleColors(aboutRootViewController.tabBarItem);

	
	[localViewControllersArray addObject:aboutRootViewController];
	
	
			tabBarController.viewControllers = localViewControllersArray;
			if (@available(iOS 18.0, *)) {
				tabBarController.mode = UITabBarControllerModeTabBar;
				tabBarController.traitOverrides.horizontalSizeClass = UIUserInterfaceSizeClassCompact;
			}
			tabBarController.tabBar.barStyle = UIBarStyleBlack;
			tabBarController.tabBar.translucent = NO;
			tabBarController.tabBar.backgroundColor = [UIColor blackColor];
            tabBarController.tabBar.itemPositioning = UITabBarItemPositioningFill;
            tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.0f green:0.478f blue:1.0f alpha:1.0f];
            if ([tabBarController.tabBar respondsToSelector:@selector(setUnselectedItemTintColor:)]) {
                tabBarController.tabBar.unselectedItemTintColor = [UIColor whiteColor];
            }
			if ([tabBarController.tabBar respondsToSelector:@selector(setBarTintColor:)]) {
				tabBarController.tabBar.barTintColor = [UIColor blackColor];
			}
			if (@available(iOS 13.0, *)) {
				UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
				[appearance configureWithOpaqueBackground];
				appearance.backgroundColor = [UIColor blackColor];
                UIColor *normalTitleColor = [UIColor whiteColor];
                UIColor *selectedTitleColor = [UIColor whiteColor];
                UIColor *normalIconColor = [UIColor whiteColor];
                UIColor *selectedIconColor = [UIColor whiteColor];
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: normalTitleColor};
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName: selectedTitleColor};
                appearance.stackedLayoutAppearance.normal.iconColor = normalIconColor;
                appearance.stackedLayoutAppearance.selected.iconColor = selectedIconColor;
                appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffsetZero;
                appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffsetZero;
                appearance.inlineLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: normalTitleColor};
                appearance.inlineLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName: selectedTitleColor};
                appearance.inlineLayoutAppearance.normal.iconColor = normalIconColor;
                appearance.inlineLayoutAppearance.selected.iconColor = selectedIconColor;
                appearance.inlineLayoutAppearance.normal.titlePositionAdjustment = UIOffsetZero;
                appearance.inlineLayoutAppearance.selected.titlePositionAdjustment = UIOffsetZero;
                appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName: normalTitleColor};
                appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName: selectedTitleColor};
                appearance.compactInlineLayoutAppearance.normal.iconColor = normalIconColor;
                appearance.compactInlineLayoutAppearance.selected.iconColor = selectedIconColor;
                appearance.compactInlineLayoutAppearance.normal.titlePositionAdjustment = UIOffsetZero;
                appearance.compactInlineLayoutAppearance.selected.titlePositionAdjustment = UIOffsetZero;
				tabBarController.tabBar.standardAppearance = appearance;
				if (@available(iOS 15.0, *)) {
					tabBarController.tabBar.scrollEdgeAppearance = appearance;
				}
				[appearance release];
			}

            for (UIViewController *viewController in tabBarController.viewControllers) {
                ConfigureTabBarItemTitleColors(viewController.tabBarItem);
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
        [topViewControllerClassName isEqualToString:@"RecipesIpadViewController"] ||
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
	if ([sender isKindOfClass:[HagadaChaptersViewController class]]) {		
		/* Rotating SongsIpadViewController */
		[[[[tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
	} else if ([sender isKindOfClass:[SongsIpadViewController class]]) {
		/* Rotating HagadaChaptersViewController */
		[[[[tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
	} else if ([sender isKindOfClass:[RecipesIpadViewController class]]) {
		/* Rotating HagadaChaptersViewController */
		[[[[tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
		/* Rotating SongsIpadViewController */
		[[[[tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];		
	} else if ([sender isKindOfClass:[FourSonsViewController class]]) {
		/* Rotating MainTableViewController */
		[[[[tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
		/* Rotating SongsTableViewController */
		[[[[tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
	} else if ([sender isKindOfClass:[AboutUsViewController class]]) {
		/* Rotating HagadaChaptersViewController */
		[[[[tabBarController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
		/* Rotating SongsIpadViewController */
		[[[[tabBarController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] rotateViewFromAppDelegate:toInterfaceOrientation duration:0];		
	}
}

#pragma Alert
- (void) alertWithTitle:(NSString*)title messageForAlert:(NSString *)message titleForButton:(NSString *)buttonTitle {
    [self performSelectorOnMainThread:@selector(alertOnMainThread:) withObject:[NSArray arrayWithObjects:title, message, buttonTitle, nil] waitUntilDone:NO];
    
}
-(void)alertOnMainThread:(NSArray *)arr {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[arr objectAtIndex:0]
                                                                   message:[arr objectAtIndex:1]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:[arr objectAtIndex:2]
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil];
    [alert addAction:dismissAction];
    [tabBarController presentViewController:alert animated:YES completion:nil];
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
    [super dealloc];
}


@end
