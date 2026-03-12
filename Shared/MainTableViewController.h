//
//  MainTableViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewControllerHeb.h"
#import "ImageViewController.h"

@protocol MainTableViewControllerDelegate;

@interface MainTableViewController : UITableViewController <ImageViewControllerDelegate> {
	ImageViewControllerHeb *imageViewControllerHeb;
	ImageViewController *imageViewControllerEng;
	
	id <MainTableViewControllerDelegate> delegate;
	
	UIImageView *navBarChaptersHebReg;
	UIImageView *navBarChaptersHebWide;
	UIImageView *navBarChaptersEngReg;
	UIImageView *navBarChaptersEngWide;
	
	UIButton *langButton;	
}

@property (nonatomic, retain) ImageViewControllerHeb *imageViewControllerHeb;
@property (nonatomic, retain) ImageViewController *imageViewControllerEng;
@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) UIImageView *navBarChaptersHebReg;
@property (nonatomic, retain) UIImageView *navBarChaptersHebWide;
@property (nonatomic, retain) UIImageView *navBarChaptersEngReg;
@property (nonatomic, retain) UIImageView *navBarChaptersEngWide;

@property (nonatomic, retain) UIButton *langButton;

- (void)changeNavBarHebReg;
- (void)changeNavBarHebWide;
- (void)changeNavBarEngReg;
- (void)changeNavBarEngWide;

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)rotateViewFromAppDelegate:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end

@protocol MainTableViewControllerDelegate
//- (void)chooseSite;
- (void) changeLanguage;
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end


