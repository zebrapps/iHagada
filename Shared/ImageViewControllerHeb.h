//
//  ImageViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import "HagadaViewControllerHeb.h"

@protocol ImageViewControllerDelegate;

@interface ImageViewControllerHeb : HagadaViewControllerHeb {
	NSArray *images;
	
	UIButton *backButton;

	id delegate;
}

@property (nonatomic, retain) NSArray * images;

@property (nonatomic, retain) UIButton *backButton;

@property (nonatomic, assign) id delegate;

- (void)rotateViewFromAppDelegate:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
	
@end

/* This function will finally reach the app delegate for rotating all the other view controllers */
@protocol ImageViewControllerDelegate 
-(void) rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end
