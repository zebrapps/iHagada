//
//  HagadaChaptersViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageViewControllerHeb.h"
#import "ImageViewController.h"

@protocol HagadaChaptersViewControllerDelegate;

@interface HagadaChaptersViewController : UIViewController <ImageViewControllerDelegate> {
    
    id <HagadaChaptersViewControllerDelegate> delegate;
	
	ImageViewControllerHeb *imageViewControllerHeb;
	ImageViewController *imageViewControllerEng;
	
	IBOutlet UIButton *BKadesh;
	IBOutlet UIButton *BYahatz;
	IBOutlet UIButton *BMagid;
	IBOutlet UIButton *BMaror;
	IBOutlet UIButton *BTzafun;
	IBOutlet UIButton *BBerech;
	IBOutlet UIButton *BHallel;
	IBOutlet UIButton *BKorech;
	IBOutlet UIButton *BRehatz;
	IBOutlet UIButton *BRahatza;
	IBOutlet UIButton *BKarpas;
	IBOutlet UIButton *BMatza;
	IBOutlet UIButton *BShulhan;
	IBOutlet UIButton *BNirtza;
	
	IBOutlet UIButton *BHebrew;
	
	IBOutlet UIImageView *imageViewHeb;
	IBOutlet UIImageView *imageViewEng;
}

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) ImageViewControllerHeb *imageViewControllerHeb;
@property (nonatomic, retain) ImageViewController *imageViewControllerEng;

@property (nonatomic, retain) IBOutlet UIButton *BKadesh;
@property (nonatomic, retain) IBOutlet UIButton *BYahatz;
@property (nonatomic, retain) IBOutlet UIButton *BMagid;
@property (nonatomic, retain) IBOutlet UIButton *BMaror;
@property (nonatomic, retain) IBOutlet UIButton *BTzafun;
@property (nonatomic, retain) IBOutlet UIButton *BBerech;
@property (nonatomic, retain) IBOutlet UIButton *BHallel;
@property (nonatomic, retain) IBOutlet UIButton *BKorech;
@property (nonatomic, retain) IBOutlet UIButton *BRehatz;
@property (nonatomic, retain) IBOutlet UIButton *BRahatza;
@property (nonatomic, retain) IBOutlet UIButton *BKarpas;
@property (nonatomic, retain) IBOutlet UIButton *BMatza;
@property (nonatomic, retain) IBOutlet UIButton *BShulhan;
@property (nonatomic, retain) IBOutlet UIButton *BNirtza;

@property (nonatomic, retain) IBOutlet UIButton *BHebrew;

@property (nonatomic, retain) IBOutlet UIImageView *imageViewHeb;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewEng;

- (IBAction) selectChapter:(id)sender;

- (IBAction)changeLanguage:(id)sender;

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)rotateViewFromAppDelegate:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end

@protocol HagadaChaptersViewControllerDelegate
//- (void)chooseSite;
- (void) changeLanguage;
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end
