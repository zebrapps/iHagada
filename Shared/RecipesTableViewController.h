//
//  RecipesTableViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 3/20/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"

@protocol RecipesTableViewControllerDelegate;

@interface RecipesTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RecipeViewControllerDelegate> {

	id <RecipesTableViewControllerDelegate> delegate;
	
//	RecipeViewController *recipeViewController;
	
	NSArray *imagesNames;
		
	UIImageView *navBarRecipesReg;
	UIImageView *navBarRecipesWide;
    UITableView *tableView;
    UIImageView *headerImageView;
}

@property (nonatomic, assign) id <RecipesTableViewControllerDelegate> delegate;

//@property (nonatomic, retain) RecipeViewController *recipeViewController;

@property (nonatomic, retain) NSArray *imagesNames;

@property (nonatomic, retain) UIImageView *navBarRecipesReg;
@property (nonatomic, retain) UIImageView *navBarRecipesWide;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIImageView *headerImageView;

- (void)changeNavBarRecipesReg;
- (void)changeNavBarRecipesWide;
- (CGRect)contentLayoutFrame;
- (void)updateHeaderAndTableLayout;
- (void)applyCurrentHeaderImage;

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end

@protocol RecipesTableViewControllerDelegate
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end
