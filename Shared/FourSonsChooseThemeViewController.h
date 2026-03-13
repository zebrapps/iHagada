//
//  FourSonsChooseThemeViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 3/4/12.
//  Copyright (c) 2012 www.zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FourSonsChooseThemeViewController : UIViewController <UIScrollViewDelegate> {
    
    id delegate;
    
    IBOutlet UIScrollView *scrollViewPortrait;
    IBOutlet UIScrollView *scrollViewLandscape;    
    IBOutlet UIPageControl *pageController;
    
    IBOutlet UIImageView *framePortrait;
    IBOutlet UIImageView *frameLandscape;
    
    IBOutlet UIButton *cancelButtonPortrait;
    IBOutlet UIButton *confirmButtonPortrait;
    IBOutlet UIButton *cancelButtonLandscape;    
    IBOutlet UIButton *confirmButtonLandscape;    
}

@property (nonatomic, assign) id delegate;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewPortrait;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewLandscape;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@property (nonatomic, retain) IBOutlet UIImageView *framePortrait;
@property (nonatomic, retain) IBOutlet UIImageView *frameLandscape;

@property (nonatomic, retain) IBOutlet UIButton *cancelButtonPortrait;
@property (nonatomic, retain) IBOutlet UIButton *confirmButtonPortrait;
@property (nonatomic, retain) IBOutlet UIButton *cancelButtonLandscape;    
@property (nonatomic, retain) IBOutlet UIButton *confirmButtonLandscape;   

- (IBAction)ChooseTheme;
//- (void)rotatePortrait;
//- (void)setCurrentImageInImagePicker;
- (void)changeOtherScrollViewAfterPaging;
- (IBAction)cancelChooseTheme ;
-(IBAction)clickPageControl:(id)sender;
- (void) removeTemplateOverlayView;

@end
