//
//  RecipeViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 3/22/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import "RecipeViewController.h"
#import "RecipesTableViewController.h"

@implementation RecipeViewController

@synthesize recipeScrollView,recipeImageView, imageName, /*backButton,*/ delegate;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
	self.recipeImageView = tempImageView;
	[tempImageView release];
	
	if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			recipeImageView.frame = CGRectMake(0, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);		
		else {
			recipeImageView.frame = CGRectMake(0, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);		
		}
	#endif	
	}
	else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			recipeImageView.frame = CGRectMake(138, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);
		else {
			recipeImageView.frame = CGRectMake(80, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);		
		}
	#endif		
	}	

	recipeScrollView.contentSize = CGSizeMake(recipeImageView.frame.size.width, recipeImageView.frame.size.height);
	recipeScrollView.maximumZoomScale = 4.0;
	recipeScrollView.minimumZoomScale = 1.0;	
	recipeScrollView.clipsToBounds = YES;
	recipeScrollView.delegate = self;
	[recipeScrollView addSubview:recipeImageView];
	

	/*
	backButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 0, 25, 45)];	
	[backButton addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];	
	UIImage *image = [UIImage imageNamed: @"backArrow.png"];
	[backButton setImage:image forState:0];
	[self.view addSubview:backButton];	
	 */
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			recipeImageView.frame = CGRectMake(0, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);		
		else {
			recipeImageView.frame = CGRectMake(0, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);		
		}
	#endif	
	}
	else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			recipeImageView.frame = CGRectMake(138, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);
		else {
			recipeImageView.frame = CGRectMake(80, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);		
		}
	#endif		
	}	
}


-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO];	
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return recipeImageView;
}

 // Override to allow orientations other than the default portrait orientation.
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
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
	
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		//nil;
        NSLog(@"Do Nothing");
	else {
		[[self.delegate tableView] reloadData];		
		if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
			cellWidth = 320;
			[(RecipesTableViewController *)self.delegate changeNavBarRecipesReg];
		} else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
			cellWidth = 480;			
			[(RecipesTableViewController *)self.delegate changeNavBarRecipesWide];
		}
	}
	#endif		
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {	
	if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			recipeImageView.frame = CGRectMake(0, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);		
		else {
			recipeImageView.frame = CGRectMake(0, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);		
		}
	#endif	
	}
	else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			recipeImageView.frame = CGRectMake(138, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);
		} else {
			recipeImageView.frame = CGRectMake(80, 0, recipeImageView.frame.size.width, recipeImageView.frame.size.height);		
		}
	#endif		
	}
}

- (IBAction) handleBack:(id)sender
{	
	// Pop the controller for back action
    [self.navigationController popViewControllerAnimated:YES];
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
}


- (void)dealloc {
	[recipeImageView release];
	[recipeScrollView release];	
    [super dealloc];
}


@end
