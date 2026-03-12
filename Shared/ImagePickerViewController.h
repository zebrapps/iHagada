//
//  ImagePickerViewController.h
//  ImagePicker
//
//  Created by Yuval Tessone on 4/4/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@protocol ImagePickerViewControllerDelegate <NSObject>
- (int)photoNumber;
- (void)flipsideViewControllerDidFinish;
@optional
- (void)setCurrentImageInImagePicker;
@end

@interface ImagePickerViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate> {
    
    id<ImagePickerViewControllerDelegate> delegate;
    
    UIImagePickerController *picker;
    UIPopoverController *popover;
    
	IBOutlet UIImageView *selectedPickerImage;
	IBOutlet UIImageView *topImage;
    
    UIImageView *smallPictureDelegatePortrait;
    UIImageView *smallPictureDelegateLandscape;
    
    BOOL *didSelectNewPicture;
    
    BOOL isFlipped;
    
    UIView *shadowsView;
}

@property (nonatomic, assign) id<ImagePickerViewControllerDelegate> delegate;

@property (nonatomic, retain) UIImagePickerController *picker;
@property (nonatomic, retain) UIPopoverController *popover;

@property (nonatomic, retain) UIImageView *selectedPickerImage;
@property (nonatomic, retain) IBOutlet UIImageView *topImage;

@property (nonatomic, retain) UIImageView *smallPictureDelegatePortrait;
@property (nonatomic, retain) UIImageView *smallPictureDelegateLandscape;

@property (assign)     BOOL *didSelectNewPicture;

@property (assign) BOOL isFlipped;

@property (nonatomic, retain) UIView *shadowsView;

-(IBAction)takeOrChoosePicture:(id)sender;
-(IBAction)confirmPicture;
-(IBAction)cancelPicture;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)targetSize;

//- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (void)fadeTheImageView;
- (void)unFadeTheImageView;

@end

#pragma clang diagnostic pop

