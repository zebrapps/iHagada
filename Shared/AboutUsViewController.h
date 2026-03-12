//
//  AboutUsViewController.h
//  HomeTheater
//
//  Created by Yuval Tessone on 12/18/10.
//  Copyright 2010 Zebrapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "BrowserViewController.h"

@protocol AboutUsViewControllerDelegate;

@interface AboutUsViewController : UIViewController <MFMailComposeViewControllerDelegate, BrowserViewControllerDelegate>  {
	
	id <AboutUsViewControllerDelegate> delegate;
	
	BrowserViewController *browserViewController;
	
	/*
	IBOutlet UIImageView *aboutUsImageViewReg;
	IBOutlet UIImageView *aboutUsImageViewWide;	
	
	IBOutlet UIButton *b_contactUs;
	IBOutlet UIButton *b_sirimWebSite;
	IBOutlet UIButton *b_zebrappsWebSite;
	 */
	IBOutlet UIView *aboutUsViewPortrait;
	IBOutlet UIView *aboutUsViewLandscape;
}

@property (nonatomic, assign) id <AboutUsViewControllerDelegate> delegate;

@property (nonatomic, retain) BrowserViewController *browserViewController;

/*
@property (nonatomic, retain) IBOutlet UIImageView *aboutUsImageViewReg;
@property (nonatomic, retain) IBOutlet UIImageView *aboutUsImageViewWide;

@property (nonatomic, retain) IBOutlet UIButton *b_contactUs;
@property (nonatomic, retain) IBOutlet UIButton *b_sirimWebSite;
@property (nonatomic, retain) IBOutlet UIButton *b_zebrappsWebSite;
*/

@property (nonatomic, retain) IBOutlet UIView *aboutUsViewPortrait;
@property (nonatomic, retain) IBOutlet UIView *aboutUsViewLandscape;


- (IBAction) SendMail;
- (void) handleBack:(id)sender;
- (IBAction) sirimWebSite;
- (IBAction) zebrappsWebSite;

-(void) rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;

@end

@protocol AboutUsViewControllerDelegate
-(void) rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end