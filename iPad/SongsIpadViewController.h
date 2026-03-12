//
//  SongsIpadViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 4/2/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongViewController.h"
#import "ImageViewControllerHeb.h"
#import "ImageViewController.h"


@protocol SongsIpadViewControllerDelegate;

@interface SongsIpadViewController : UIViewController <ImageViewControllerDelegate> {

    id <SongsIpadViewControllerDelegate> delegate;
	
	ImageViewControllerHeb *imageViewControllerHeb;
	ImageViewController *imageViewControllerEng;
	
	IBOutlet UIImageView *songsImageViewHeb;
	IBOutlet UIImageView *songsImageViewEng;	
}

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) ImageViewControllerHeb *imageViewControllerHeb;
@property (nonatomic, retain) ImageViewController *imageViewControllerEng;

@property (nonatomic, retain) IBOutlet UIImageView *songsImageViewHeb;
@property (nonatomic, retain) IBOutlet UIImageView *songsImageViewEng;

- (IBAction) selectSong:(id)sender;
- (IBAction) selectOtherSong:(id)sender;
	
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)rotateViewFromAppDelegate:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end

@protocol SongsIpadViewControllerDelegate
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end
