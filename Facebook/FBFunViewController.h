//
//  FBFunViewController.h
//  FBFun
//
//  Created by Ray Wenderlich on 7/13/10.
//  Copyright Ray Wenderlich 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBFunLoginDialog.h"
#import "CustomAlert.h"
#import "AppDelegate_iPhone.h"
#import "AppDelegate_iPad.h"

typedef enum {
    LoginStateStartup,
    LoginStateLoggingIn,
    LoginStateLoggedIn,
    LoginStateLoggedOut
} LoginState;

@interface FBFunViewController : UIViewController <FBFunLoginDialogDelegate, UITextViewDelegate, UIAlertViewDelegate> {
    
    id delegate;
    
    UILabel *_loginStatusLabel;
    UIButton *_loginButton;
    LoginState _loginState;
    FBFunLoginDialog *_loginDialog;
    UIView *_loginDialogView;
    
    NSString *_accessToken;    
    
    IBOutlet UIImageView *finalImageviewPortrait;
    IBOutlet UITextView *captionPortrait;
    IBOutlet UIActivityIndicatorView *activityIndPortrait;
    IBOutlet UIButton *uploadButtonPortrait;
    
    IBOutlet UIImageView *finalImageviewLandscape;
    IBOutlet UITextView *captionLandscape;
    IBOutlet UIActivityIndicatorView *activityIndLandscape;
    IBOutlet UIButton *uploadButtonLandscape;

    IBOutlet UIView *portrait;
    IBOutlet UIView *landscape;
    
    AppDelegate_iPhone *appDelegateIphone;
    AppDelegate_iPad *appDelegateIPad;
}

@property (assign) id delegate;

@property (retain) IBOutlet UILabel *loginStatusLabel;
@property (retain) IBOutlet UIButton *loginButton;
@property (retain) FBFunLoginDialog *loginDialog;
@property (retain) IBOutlet UIView *loginDialogView;

@property (copy) NSString *accessToken;

@property (retain) IBOutlet UIImageView *finalImageviewPortrait;
@property (retain) IBOutlet UITextView *captionPortrait;
@property (retain) IBOutlet UIActivityIndicatorView *activityIndPortrait;
@property (retain) IBOutlet UIButton *uploadButtonPortrait;
@property (retain) IBOutlet UIImageView *finalImageviewLandscape;
@property (retain) IBOutlet UITextView *captionLandscape;
@property (retain) IBOutlet UIActivityIndicatorView *activityIndLandscape;
@property (retain) IBOutlet UIButton *uploadButtonLandscape;

@property (retain) IBOutlet UIView *portrait;
@property (retain) IBOutlet UIView *landscape;

@property (retain) AppDelegate_iPhone *appDelegateIphone;
@property (retain) AppDelegate_iPad *appDelegateIPad;

- (void)refresh;
-(void)connectToFacebook;
- (void)fbGraphCallback:(id)sender;
- (IBAction)uploadPhoto;
- (void)sendToPhotosFinished:(FbGraphResponse *)fb_graph_response;

@end

