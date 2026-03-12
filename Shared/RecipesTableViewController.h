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

@interface RecipesTableViewController : UITableViewController <RecipeViewControllerDelegate> {

	id <RecipesTableViewControllerDelegate> delegate;
	
//	RecipeViewController *recipeViewController;
	
	NSArray *imagesNames;
	
	UIImageView *navBarRecipesReg;
	UIImageView *navBarRecipesWide;
}

@property (nonatomic, assign) id <RecipesTableViewControllerDelegate> delegate;

//@property (nonatomic, retain) RecipeViewController *recipeViewController;

@property (nonatomic, retain) NSArray *imagesNames;

@property (nonatomic, retain) UIImageView *navBarRecipesReg;
@property (nonatomic, retain) UIImageView *navBarRecipesWide;

- (void)changeNavBarRecipesReg;
- (void)changeNavBarRecipesWide;

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end

@protocol RecipesTableViewControllerDelegate
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end
