//
//  RecipesIpadViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 4/2/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"
#import "BrowserViewController.h"

@protocol RecipesIpadViewControllerDelegate;

@interface RecipesIpadViewController : UIViewController <RecipeViewControllerDelegate> {

	id <RecipesIpadViewControllerDelegate> delegate;
	
//	RecipeViewController *recipeViewController;
	
	IBOutlet UIImageView *recipesImageView;
	
	NSArray *imagesNames;	
	
	BrowserViewController *browserViewController;
}

@property (nonatomic, assign) id delegate;

//@property (nonatomic, retain) RecipeViewController *recipeViewController;

@property (nonatomic, retain) IBOutlet UIImageView *recipesImageView;

@property (nonatomic, retain) NSArray *imagesNames;

@property (nonatomic, retain) BrowserViewController *browserViewController;

- (IBAction) selectRecipe:(id)sender;
- (IBAction) sirimWebSite;

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end

@protocol RecipesIpadViewControllerDelegate
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end