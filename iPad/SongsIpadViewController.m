    //
//  SongsIpadViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 4/2/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import "SongsIpadViewController.h"
#import "SongViewController.h"

@implementation SongsIpadViewController

@synthesize songsImageViewHeb, songsImageViewEng, delegate, imageViewControllerEng, imageViewControllerHeb;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"SongsIpadViewController" bundle:nil];
    if (self) {
        // Custom initialization
		imageViewControllerHeb = [[ImageViewControllerHeb alloc] init];
		self.imageViewControllerHeb.delegate = self;
		imageViewControllerEng = [[ImageViewController alloc] init];
		self.imageViewControllerEng.delegate = self;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	if (isHebrew) {
		[self.songsImageViewHeb setHidden:NO];	
		[self.songsImageViewEng setHidden:YES];		
	} else {
		[self.songsImageViewHeb setHidden:YES];
		[self.songsImageViewEng setHidden:NO];	
	}
}


-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (isHebrew) {
		[self.songsImageViewEng setHidden:YES];
		[self.songsImageViewHeb setHidden:NO];		
	} else {
		[self.songsImageViewEng setHidden:NO];
		[self.songsImageViewHeb setHidden:YES];		

	}

	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[[self navigationItem] setPrompt:@""];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//[self.tableView reloadData];  This will happen inside the imageViewController through using the delegate, and also change nav bar
	[imageViewControllerHeb willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[imageViewControllerEng willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
}

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
}

- (void)rotateViewFromAppDelegate:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[imageViewControllerHeb rotateViewFromAppDelegate:toInterfaceOrientation duration:duration];
	[imageViewControllerEng rotateViewFromAppDelegate:toInterfaceOrientation duration:duration];	
}


- (IBAction) selectSong:(id)sender
{	
    NSInteger selectedPage = 0;
	if (isHebrew) {
		/* The tag of the button is set in Interface builder */
		switch ([(UIButton*)sender tag]) {
			case 1: 
				selectedPage = 6;
				break;
			case 2: 
				selectedPage = 7;
				break;
			case 3:
				selectedPage = 8;
				break;
			case 4: 
				selectedPage = 13;
				break;
			case 5: 
				selectedPage = 21;
				break;
			case 6:
                selectedPage = 26;
				break;
			case 7: 
                selectedPage = 67;
				break;
			case 8: 
                selectedPage = 71;
				break;
				/*
			case 9: simcha raba song is being called through selectOtherSong because its not in the hagada
				*/
		}
		[[NSUserDefaults standardUserDefaults] setInteger:selectedPage forKey:@"currentPageHeb"];
		[self.imageViewControllerHeb setHidesBottomBarWhenPushed:YES];
		[self.navigationController pushViewController:imageViewControllerHeb animated:YES];	 
	} else {
		switch ([(UIButton*)sender tag]) {
			case 1: 
				selectedPage = 9;
				break;
			case 2: 
				selectedPage = 10;
				break;
			case 3:
				selectedPage = 12;
				break;
			case 4: 
				selectedPage = 21;
				break;
			case 5: 
				selectedPage = 38;
				break;
			case 6:
				selectedPage = 51;
				break;
			case 7: 
				selectedPage = 63;
				break;
			case 8: 
				selectedPage = 74;
				break;
			/*
			case 9:
				 SongViewController for simcha raba 
				 Right now this song is not in the english version
				break;
				 */
		}
		[[NSUserDefaults standardUserDefaults] setInteger:selectedPage forKey:@"currentPage"];		
		[self.imageViewControllerEng setHidesBottomBarWhenPushed:YES];
		[self.navigationController setNavigationBarHidden:YES animated:NO];		
		[self.navigationController pushViewController:imageViewControllerEng animated:YES];	
		

	}
}

- (IBAction) selectOtherSong:(id)sender {
	/* SongViewController for simcha raba */			
	SongViewController *songViewController = [[SongViewController alloc] initWithNibName:@"SongViewControllerIpad" bundle:nil];
	[songViewController setImageName:@"simhaRaba_ipad.jpg"];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[songViewController setHidesBottomBarWhenPushed:YES];
	songViewController.delegate = self;
	[self.navigationController pushViewController:songViewController animated:YES];
	[songViewController release];
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
	songsImageViewHeb = nil;
	songsImageViewEng = nil;
	
//	self.imageViewControllerHeb = nil;
//	self.imageViewControllerEng = nil;
}


- (void)dealloc {
	[self.imageViewControllerHeb release];
	[self.imageViewControllerEng release];
	[self.songsImageViewHeb release];
	[self.songsImageViewEng release];
    [super dealloc];
}


@end
