//
//  BrowserViewController.h
//  HomeTheater
//
//  Created by Yuval Tessone on 6/6/10.
//  Copyright 2010 Zebrapps. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@protocol BrowserViewControllerDelegate;

@interface BrowserViewController : UIViewController <UIWebViewDelegate> {

	id delegate;
	
	IBOutlet UIWebView *webView;
	IBOutlet UITextField *addressBar;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSString *urlAddress;
	
//	UIButton * backButton;
}

@property (nonatomic, assign) 	id delegate;

@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) UITextField *addressBar;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (copy) NSString *urlAddress;

//@property (nonatomic, retain) UIButton * backButton;


-(IBAction) gotoAddress:(id)sender;
-(IBAction) goBack:(id)sender;
-(IBAction) goForward:(id)sender;
-(IBAction) refresh:(id) sender;
-(IBAction) stopLoading:(id) sender;

-(IBAction) handleBack:(id) sender;

@end

#pragma clang diagnostic pop

/* This function will finally reach the app delegate for rotating all the other view controllers */
@protocol BrowserViewControllerDelegate 
-(void) rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end
