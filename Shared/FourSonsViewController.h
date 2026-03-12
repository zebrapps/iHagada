//
//  FourSonsViewController.h
//  swipetest
//
//  Created by Yuval Tessone on 4/6/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ImagePickerViewController.h"
#import "FourSonsChooseThemeViewController.h"

@protocol FourSonsViewControllerDelegate;

@interface FourSonsViewController : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, ImagePickerViewControllerDelegate >{
    
    id <FourSonsViewControllerDelegate> delegate;
    
    IBOutlet UIImageView *photoView1;
    IBOutlet UIImageView *photoView2;
    IBOutlet UIImageView *photoView3;
    IBOutlet UIImageView *photoView4; 

    IBOutlet UIImageView *photoViewLandscape1;
    IBOutlet UIImageView *photoViewLandscape2;
    IBOutlet UIImageView *photoViewLandscape3;
    IBOutlet UIImageView *photoViewLandscape4; 
    
    IBOutlet UIImageView *basePhotoView1;
    IBOutlet UIImageView *basePhotoView2;
    IBOutlet UIImageView *basePhotoView3;
    IBOutlet UIImageView *basePhotoView4; 

    IBOutlet UIImageView *basePhotoViewLandscape1;
    IBOutlet UIImageView *basePhotoViewLandscape2;
    IBOutlet UIImageView *basePhotoViewLandscape3;
    IBOutlet UIImageView *basePhotoViewLandscape4;
    
    IBOutlet UIScrollView *landscapeScrollView;
    
    int photoNumber;
    
    UIImage *finalImage;
    UIImage *finalImagePortrait;
    UIImage *finalImageLandscape;    
    
    ImagePickerViewController *imagePickerViewController;    
    
    FourSonsChooseThemeViewController *fourSonsChooseThemeViewController;
    
    int chosenTheme;
    
    NSString *chachamFileName;
    NSString *rashaFileName;
    NSString *tamFileName;
    NSString *sheinoFileName;
    
    BOOL isEverBeenChosenTheme;    
    
    IBOutlet UIView *landscapeButtons;
    IBOutlet UIImageView *landscapeIphoneBackground;    
    
    IBOutlet UIActivityIndicatorView *activitiyIndicator;
}

@property (nonatomic, assign) id <FourSonsViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIImageView *photoView1;
@property (nonatomic, retain) IBOutlet UIImageView *photoView2;
@property (nonatomic, retain) IBOutlet UIImageView *photoView3;
@property (nonatomic, retain) IBOutlet UIImageView *photoView4;

@property (nonatomic, retain) IBOutlet UIImageView *photoViewLandscape1;
@property (nonatomic, retain) IBOutlet UIImageView *photoViewLandscape2;
@property (nonatomic, retain) IBOutlet UIImageView *photoViewLandscape3;
@property (nonatomic, retain) IBOutlet UIImageView *photoViewLandscape4; 

@property (nonatomic, retain) IBOutlet UIImageView *basePhotoView1;
@property (nonatomic, retain) IBOutlet UIImageView *basePhotoView2;
@property (nonatomic, retain) IBOutlet UIImageView *basePhotoView3;
@property (nonatomic, retain) IBOutlet UIImageView *basePhotoView4;

@property (nonatomic, retain) IBOutlet UIImageView *basePhotoViewLandscape1;
@property (nonatomic, retain) IBOutlet UIImageView *basePhotoViewLandscape2;
@property (nonatomic, retain) IBOutlet UIImageView *basePhotoViewLandscape3;
@property (nonatomic, retain) IBOutlet UIImageView *basePhotoViewLandscape4;

@property (nonatomic, retain) IBOutlet UIScrollView *landscapeScrollView;


@property (assign) int photoNumber;

@property (nonatomic, retain) UIImage *finalImage;
@property (nonatomic, retain) UIImage *finalImagePortrait;
@property (nonatomic, retain) UIImage *finalImageLandscape;    

@property (nonatomic, retain) ImagePickerViewController *imagePickerViewController;
@property (nonatomic, retain) FourSonsChooseThemeViewController *fourSonsChooseThemeViewController;

@property int chosenTheme;

@property (nonatomic, retain) NSString *chachamFileName;
@property (nonatomic, retain) NSString *rashaFileName;
@property (nonatomic, retain) NSString *tamFileName;
@property (nonatomic, retain) NSString *sheinoFileName;

@property (assign) BOOL isEverBeenChosenTheme;

@property (nonatomic, retain) IBOutlet UIView *landscapeButtons;
@property (nonatomic, retain) IBOutlet UIImageView *landscapeIphoneBackground;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activitiyIndicator;

- (IBAction)choosePhoto:(id)sender;
- (void)flipsideViewControllerDidFinish;

- (IBAction)sendFinalPicture;

- (IBAction)chooseTheme;

- (void)changeTheme:(int)changedThemeNum;
- (void)prepareFinalPicture;
- (void)displayComposerSheet;
- (void)rotatePortrait;
- (void)rotateLandscape;
- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void) removeOverlayView;
- (void)postOnFacebook;
- (void)prepareFinalPicturePortrait;
- (void)prepareFinalPictureLandscape;

-(IBAction)showActionSheet:(id)sender;

@end

@protocol FourSonsViewControllerDelegate
-(void) rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end