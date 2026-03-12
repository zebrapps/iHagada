//
//  SongViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 3/30/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SongViewControllerDelegate;

@interface SongViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView *songScrollView;
	UIImageView *songImageView;
	
	NSString *imageName;
	
//	UIButton *backButton;
	
	id delegate;
	
}

@property (nonatomic, retain) IBOutlet UIScrollView *songScrollView;
@property (nonatomic, retain) UIImageView *songImageView;

@property (nonatomic, retain) NSString *imageName;

//@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, assign) id delegate;

- (IBAction) handleBack:(id)sender;

@end

/* This function will finally reach the app delegate for rotating all the other view controllers */
@protocol SongViewControllerDelegate 
-(void) rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end