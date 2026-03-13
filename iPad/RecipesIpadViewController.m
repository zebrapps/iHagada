    //
//  RecipesIpadViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 4/2/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import "RecipesIpadViewController.h"
#import "RecipeViewController.h"
#import "Utilities.h"


@implementation RecipesIpadViewController

@synthesize delegate,/*recipeViewController,*/ recipesImageView, imagesNames, browserViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"RecipesIpadViewController" bundle:nil];
    if (self) {
        // Custom initialization
		//recipeViewController = [[RecipeViewController alloc] initWithNibName:@"RecipeViewControllerIpad" bundle:nil];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.recipesImageView setHidden:NO];	
	
	/*
	imagesNames = [[NSArray alloc] initWithObjects:
                   @"BomalosSalty_ipad.jpg",
				   @"Bomalos_ipad.jpg",
                   @"Batzekaniot_ipad.jpg",
				   @"iraqies-harosset_ipad.jpg",
                   @"georgie-harosset_ipad.jpg",
				   @"Maziut_ipad.jpg",
                   @"horseradish_ipad.jpg",
                   @"Kneidalach_ipad.jpg",
				   @"Latkes_ipad.jpg",
                   @"Liver_ipad.jpg",
				   @"Krisha_ipad.jpg",
                   @"Mangold_ipad.jpg",
				   @"lazania_ipad.jpg",
                   @"Pizza_ipad.jpg",
				   @"Matza-Bri_ipad.jpg",
                   @"MatzotWithChicken_ipad.jpg",
				   @"AshkenazDefilte_ipad.jpg",
                   @"RomanianDefilte_ipad.jpg",
				   @"Matzot-Cake_ipad.jpg",
                   @"CoconatCake_ipad.jpg",
				   @"WalnutCake_ipad.jpg",
                   @"Tamar-Cake_ipad.jpg",
                   @"Pancake_ipad.jpg",
				   @"Brownis_ipad.jpg",
                   @"Traffels_ipad.jpg",
				   nil];
	*/
	
	imagesNames = [[NSArray alloc] initWithObjects:
                   @"Liver_ipad.jpg",    
				   @"AshkenazDefilte_ipad.jpg",				   
                   @"RomanianDefilte_ipad.jpg",
                   @"BomalosSalty_ipad.jpg",
				   @"Maziut_ipad.jpg",
				   @"Matza-Bri_ipad.jpg",
                   @"Batzekaniot_ipad.jpg",
				   @"lazania_ipad.jpg",
                   @"Pizza_ipad.jpg",
                   @"Mangold_ipad.jpg",
                   @"MatzotWithChicken_ipad.jpg",
				   @"Latkes_ipad.jpg",
				   @"Krisha_ipad.jpg",
				   @"iraqies-harosset_ipad.jpg",
                   @"georgie-harosset_ipad.jpg",
                   @"horseradish_ipad.jpg",				   
                   @"Kneidalach_ipad.jpg",
				   @"Bomalos_ipad.jpg",
				   @"Matzot-Cake_ipad.jpg",
                   @"CoconatCake_ipad.jpg",
				   @"WalnutCake_ipad.jpg",
                   @"Tamar-Cake_ipad.jpg",
                   @"Pancake_ipad.jpg",
				   @"Brownis_ipad.jpg",
                   @"Traffels_ipad.jpg",				   
				   nil];	
	
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	IHAnalyticsLogScreen(@"ipad_recipes", @"iPad Recipes", @"RecipesIpadViewController");

	[self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];	
}

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
}

- (IBAction) selectRecipe:(id)sender {
	IHAnalyticsLogAction(@"open_recipe", @"ipad_recipes", @"iPad Recipes", [imagesNames objectAtIndex:[(UIButton*)sender tag] - 1]);
	RecipeViewController *recipeViewController = [[RecipeViewController alloc] initWithNibName:@"RecipeViewControllerIpad" bundle:nil];
	[recipeViewController setImageName:[imagesNames objectAtIndex:[(UIButton*)sender tag] - 1]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];	
	[recipeViewController setHidesBottomBarWhenPushed:YES];
	recipeViewController.delegate = self;	
	[self.navigationController pushViewController:recipeViewController animated:YES];
	[recipeViewController release];
}

- (IBAction) sirimWebSite {
    IHAnalyticsLogAction(@"about_open_sirim", @"ipad_recipes", @"iPad Recipes", @"sirim");
    // Link disabled by request: keep action connected but intentionally no-op.
    return;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.recipesImageView = nil;
//	self.recipeViewController = nil;
}


- (void)dealloc {
	[self.recipesImageView release];
//	[self.recipeViewController release];
    [super dealloc];
}


@end
