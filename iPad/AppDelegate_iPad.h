//
//  AppDelegate_iPad.h
//  iHagada
//
//  Created by Yuval Tessone on 3/1/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HagadaChaptersViewController.h"
#import "SongsIpadViewController.h"
#import "AboutUsViewController.h"
#import "FourSonsViewController.h"

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate, HagadaChaptersViewControllerDelegate, SongsIpadViewControllerDelegate, FourSonsViewControllerDelegate, AboutUsViewControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
- (void)changeLanguage;
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void) alertWithTitle:(NSString*)title messageForAlert:(NSString *)message titleForButton:(NSString *)buttonTitle;

@end
