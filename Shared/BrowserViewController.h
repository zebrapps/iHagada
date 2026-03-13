//
//  BrowserViewController.h
//  HomeTheater
//
//  Created by Yuval Tessone on 6/6/10.
//  Copyright 2010 Zebrapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol BrowserViewControllerDelegate;

@interface BrowserViewController : UIViewController <WKNavigationDelegate> {

	id delegate;
	
	IBOutlet UIView *webContainerView;
	IBOutlet UITextField *addressBar;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	NSString *urlAddress;
	
//	UIButton * backButton;
}

@property (nonatomic, assign) 	id delegate;

@property (nonatomic,retain) WKWebView *webView;
@property (nonatomic,retain) IBOutlet UIView *webContainerView;
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

/* This function will finally reach the app delegate for rotating all the other view controllers */
@protocol BrowserViewControllerDelegate 
-(void) rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
@end
