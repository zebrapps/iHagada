//
//  SongsTableViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 3/30/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewController.h"
#import "ImageViewControllerHeb.h"

@protocol SongsTableViewControllerDelegate;

@interface SongsTableViewController : UITableViewController <ImageViewControllerDelegate> {
	
    id <SongsTableViewControllerDelegate> delegate;
	
	ImageViewControllerHeb *imageViewControllerHeb;
	ImageViewController *imageViewControllerEng;
	
//	NSArray *imagesNames;

	UIImageView *navBarChaptersHebReg;
	UIImageView *navBarChaptersHebWide;
	UIImageView *navBarChaptersEngReg;
	UIImageView *navBarChaptersEngWide;
}

@property (nonatomic, assign) id <SongsTableViewControllerDelegate> delegate;

@property (nonatomic, retain) ImageViewControllerHeb *imageViewControllerHeb;
@property (nonatomic, retain) ImageViewController *imageViewControllerEng;


//@property (nonatomic, retain) NSArray *imagesNames;

@property (nonatomic, retain) UIImageView *navBarChaptersHebReg;
@property (nonatomic, retain) UIImageView *navBarChaptersHebWide;
@property (nonatomic, retain) UIImageView *navBarChaptersEngReg;
@property (nonatomic, retain) UIImageView *navBarChaptersEngWide;

- (void)changeNavBarHebReg;
- (void)changeNavBarHebWide;
- (void)changeNavBarEngReg;
- (void)changeNavBarEngWide;

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)rotateViewFromAppDelegate:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end

@protocol SongsTableViewControllerDelegate
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end

