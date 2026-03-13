//
//  SongViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 3/30/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import "SongViewController.h"
#import "SongsTableViewController.h"
#import "Utilities.h"


@implementation SongViewController

@synthesize songScrollView,songImageView, imageName, /*backButton,*/ delegate;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
	self.songImageView = tempImageView;
	[tempImageView release];
	
	if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			songImageView.frame = CGRectMake(0, 0, songImageView.frame.size.width, songImageView.frame.size.height);		
		else {
			songImageView.frame = CGRectMake(0, 0, songImageView.frame.size.width, songImageView.frame.size.height);		
		}
	#endif	
	}
	else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			songImageView.frame = CGRectMake(138, 0, songImageView.frame.size.width, songImageView.frame.size.height);
		else {
			songImageView.frame = CGRectMake(80, 0, songImageView.frame.size.width, songImageView.frame.size.height);		
		}
	#endif		
	}
	
	songScrollView.contentSize = CGSizeMake(songImageView.frame.size.width, songImageView.frame.size.height);
	songScrollView.maximumZoomScale = 4.0;
	songScrollView.minimumZoomScale = 1.0;	
	songScrollView.clipsToBounds = YES;
	songScrollView.delegate = self;
	[songScrollView addSubview:songImageView];
	
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
	IHAnalyticsLogScreen(@"song_detail", imageName, @"SongViewController");
	if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			songImageView.frame = CGRectMake(0, 0, songImageView.frame.size.width, songImageView.frame.size.height);		
		else {
			songImageView.frame = CGRectMake(0, 0, songImageView.frame.size.width, songImageView.frame.size.height);		
		}
	#endif	
	}
	else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			songImageView.frame = CGRectMake(138, 0, songImageView.frame.size.width, songImageView.frame.size.height);
		else {
			songImageView.frame = CGRectMake(80, 0, songImageView.frame.size.width, songImageView.frame.size.height);		
		}
	#endif		
	}	
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO];	
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return songImageView;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
	/* Special case for calling this method from inside and not from the delegate, because if not, the imageViewController won't update to the right rotation */
	[self.delegate rotateViewFromAppDelegate:toInterfaceOrientation duration:0];
	
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		//nil;
        NSLog(@"Do Nothing");
	else {
		[[self.delegate tableView] reloadData];
		if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
			cellWidth = 320;
			if (isHebrew) {
				[self.delegate changeNavBarHebReg];	
			} else {
				[self.delegate changeNavBarEngReg];	
			}
		} else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
			cellWidth = 480;
			if (isHebrew) {
				[self.delegate changeNavBarHebWide];	
			} else {
				[self.delegate changeNavBarEngWide];	
			}
		}
	}
	#endif		
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {	
	if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			songImageView.frame = CGRectMake(0, 0, songImageView.frame.size.width, songImageView.frame.size.height);		
		else {
			songImageView.frame = CGRectMake(0, 0, songImageView.frame.size.width, songImageView.frame.size.height);		
		}
	#endif	
	}
	else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			songImageView.frame = CGRectMake(138, 0, songImageView.frame.size.width, songImageView.frame.size.height);
		else {
			songImageView.frame = CGRectMake(80, 0, songImageView.frame.size.width, songImageView.frame.size.height);		
		}
	#endif		
	}
}

- (void) handleBack:(id)sender
{	
	IHAnalyticsLogAction(@"back_tap", @"song_detail", imageName, @"back");
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
	[imageName release];
	[songImageView release];
	[songScrollView release];
    [super dealloc];
}


@end
