//
//  AppDelegate_iPhone.h
//  iHagada
//
//  Created by Yuval Tessone on 3/1/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"
#import "SongsTableViewController.h"
#import "RecipesTableViewController.h"
#import "AboutUsViewController.h"
#import "FourSonsViewController.h"

#import "FbGraph.h"

typedef enum {
    languageHeb,
    languageEng
} languageType;

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, MainTableViewControllerDelegate, SongsTableViewControllerDelegate, RecipesTableViewControllerDelegate ,FourSonsViewControllerDelegate,AboutUsViewControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    
    //Facebook Integration
    FbGraph *fbGraph;
    
    //we'll use this to store a feed post (when you press 'post me/feed').
    //when you press delete me/feed this is the post that's deleted
    NSString *feedPostId;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

//Facebook
@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, retain) NSString *feedPostId;

/*
+ (languageType) chosenLanguageType;
+ (void) setChosenLanguageType:(languageType)chosenLanguageTypeParam;
*/

- (void)changeLanguage;
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void) alertWithTitle:(NSString*)title messageForAlert:(NSString *)message titleForButton:(NSString *)buttonTitle;
- (BOOL)shouldAutorotate;
- (void)refreshTabBarButtonAppearance;
- (void)scheduleTabBarButtonAppearanceRefresh;

@end
