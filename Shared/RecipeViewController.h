//
//  RecipeViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 3/22/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecipeViewControllerDelegate;

@interface RecipeViewController : UIViewController<UIScrollViewDelegate> {
	IBOutlet UIScrollView *recipeScrollView;
	UIImageView *recipeImageView;
	
	NSString *imageName;
	
//	UIButton *backButton;
	
	id delegate;
}

@property (nonatomic, retain) UIScrollView *recipeScrollView;
@property (nonatomic, retain) UIImageView *recipeImageView;
@property (nonatomic, retain) NSString *imageName;
//@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, assign) id delegate;

- (IBAction) handleBack:(id)sender;

@end

/* This function will finally reach the app delegate for rotating all the other view controllers */
@protocol RecipeViewControllerDelegate 
-(void) rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end