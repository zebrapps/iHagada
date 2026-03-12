//
//  FBFunViewController.m

//  FBFun
//
//  Created by Ray Wenderlich on 7/13/10.
//  Copyright Ray Wenderlich 2010. All rights reserved.
//

#import "FBFunViewController.h"
#import "SBJson.h"
#import "FourSonsViewController.h"
#import "Reachability.h"
#import "AppDelegate_iPhone.h"
#import "AppDelegate_iPad.h"
#import "FbGraphFile.h" 

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation FBFunViewController

@synthesize loginStatusLabel = _loginStatusLabel;
@synthesize loginButton = _loginButton;
@synthesize loginDialog = _loginDialog;
@synthesize loginDialogView = _loginDialogView;

@synthesize accessToken = _accessToken;

@synthesize delegate;

@synthesize finalImageviewPortrait;
@synthesize captionPortrait;
@synthesize activityIndPortrait;
@synthesize uploadButtonPortrait;
@synthesize finalImageviewLandscape;
@synthesize captionLandscape;
@synthesize activityIndLandscape;
@synthesize uploadButtonLandscape;
@synthesize appDelegateIphone;
@synthesize appDelegateIPad;

@synthesize portrait, landscape;

int cellWidth; // Global parameter for all the other table view controllers;

#pragma mark Main

- (void)dealloc {
    self.loginStatusLabel = nil;
    self.loginButton = nil;
    self.loginDialog = nil;
    self.loginDialogView = nil;
    [finalImageviewPortrait release];
    [finalImageviewLandscape release];    
    [super dealloc];
}

- (void)refresh {
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
        // NSLog(@"startup logged out");
        [self.activityIndPortrait performSelectorInBackground:@selector(stopAnimating) withObject:nil];        
        [self.activityIndLandscape performSelectorInBackground:@selector(stopAnimating) withObject:nil];                
        [self.uploadButtonPortrait setEnabled:YES];
        [self.uploadButtonLandscape setEnabled:YES];        
        _loginStatusLabel.text = @"Not connected to Facebook";
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        _loginButton.hidden = NO;
    } else if (_loginState == LoginStateLoggingIn) {
        // NSLog(@"logging");        
        [self.activityIndPortrait performSelectorInBackground:@selector(startAnimating) withObject:nil];        
        [self.uploadButtonPortrait setEnabled:NO];        
        [self.activityIndLandscape performSelectorInBackground:@selector(startAnimating) withObject:nil];        
        [self.uploadButtonLandscape setEnabled:NO];                
        _loginStatusLabel.text = @"Connecting to Facebook...";
        _loginButton.hidden = YES;
    } else if (_loginState == LoginStateLoggedIn) {
        // NSLog(@"logged IN");                
        [self.activityIndPortrait performSelectorInBackground:@selector(stopAnimating) withObject:nil];
        [self.uploadButtonPortrait setEnabled:YES];        
        [self.activityIndLandscape performSelectorInBackground:@selector(stopAnimating) withObject:nil];
        [self.uploadButtonLandscape setEnabled:YES];                
        _loginStatusLabel.text = @"Connected to Facebook";
        [_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        _loginButton.hidden = NO;
    }   
}

- (void)viewWillAppear:(BOOL)animated {
    // NSLog(@"viewWillAppear");
    
    [self.uploadButtonPortrait setEnabled:YES];            
    [self.uploadButtonLandscape setEnabled:YES];                
    [self refresh];

    if (UIDeviceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        [self.portrait setHidden:NO];

        [self.landscape setHidden:YES];         
        
	} else if (UIDeviceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        [self.portrait setHidden:YES];
        
        [self.landscape setHidden:NO];         
	}	    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		appDelegateIPad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	else
		appDelegateIphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
#endif
    
//    [self loginButtonTapped:nil];
    [self connectToFacebook];
    
    // Getting the original image    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    
    NSString* fullPathFinalPortrait = [documentsDirectory stringByAppendingPathComponent:@"finalPortrait.png"];
    
    UIImage *finalImagePortrait = [UIImage imageWithContentsOfFile:fullPathFinalPortrait];

    [finalImageviewPortrait setImage:finalImagePortrait];

    // NSLog(@"finalImagePortrait = %f,%f",finalImagePortrait.size.width,finalImagePortrait.size.height);
    
    NSString* fullPathFinalLandscape = [documentsDirectory stringByAppendingPathComponent:@"finalLandscape.png"];
    
    UIImage *finalImageLandscape = [UIImage imageWithContentsOfFile:fullPathFinalLandscape];
    
    [finalImageviewLandscape setImage:finalImageLandscape];
    
    // NSLog(@"finalImageLandscape = %f,%f",finalImageLandscape.size.width,finalImageLandscape.size.height);
    
}


-(void)connectToFacebook {
    
//    _loginState = LoginStateLoggingIn;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            [appDelegateIPad alertWithTitle:@"חיבור אינטרנט" messageForAlert:@"בעייה בחיבור לאינטרנט" titleForButton:@"Ok"];
            return;
        }
        
        
        if ( (appDelegateIPad.fbGraph.accessToken == nil) || ([appDelegateIPad.fbGraph.accessToken length] == 0) ) {
            /*Facebook Application ID*/
            NSString *client_id = @"350594091646106";
            
            //alloc and initalize our FbGraph instance
            appDelegateIPad.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
            [appDelegateIPad.fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access" andSuperView:self.view];
        }
        else {
            //Authentified
            [self refresh];
        }

    }else
    {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            [appDelegateIphone alertWithTitle:@"חיבור אינטרנט" messageForAlert:@"בעייה בחיבור לאינטרנט" titleForButton:@"Ok"];
            return;
        }
        
        
        if ( (appDelegateIphone.fbGraph.accessToken == nil) || ([appDelegateIphone.fbGraph.accessToken length] == 0) ) {
            /*Facebook Application ID*/
            NSString *client_id = @"350594091646106";
            
            //alloc and initalize our FbGraph instance
            appDelegateIphone.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
            [appDelegateIphone.fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access" andSuperView:self.view];
        }
        else {
            //Authentified
            [self refresh];
        }

    }
#endif
    
}


/**
 * This function is called by FbGraph after it's finished the authentication process
 **/
- (void)fbGraphCallback:(id)sender {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            [appDelegateIPad alertWithTitle:@"חיבור אינטרנט" messageForAlert:@"בעייה בחיבור לאינטרנט" titleForButton:@"Ok"];
            return;
        }
        
        if ( (appDelegateIPad.fbGraph.accessToken == nil) || ([appDelegateIPad.fbGraph.accessToken length] == 0) ) {
            //restart the authentication process.....
            [appDelegateIPad.fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"publish_stream,offline_access" andSuperView:self.view];
            
        } else {
            _loginState = LoginStateLoggedIn;
        }
    }else
    {
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        NetworkStatus netStatus = [reach currentReachabilityStatus];
        if (netStatus == NotReachable) {
            [appDelegateIphone alertWithTitle:@"חיבור אינטרנט" messageForAlert:@"בעייה בחיבור לאינטרנט" titleForButton:@"Ok"];
            return;
        }
        
        if ( (appDelegateIphone.fbGraph.accessToken == nil) || ([appDelegateIphone.fbGraph.accessToken length] == 0) ) {
            //restart the authentication process.....
            [appDelegateIphone.fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"publish_stream,offline_access" andSuperView:self.view];
            
        } else {
            _loginState = LoginStateLoggedIn;
        }
    }
#endif
    
}


- (IBAction)uploadPhoto {

    /* INDICIATOR WHILE LOADING TO FACEBOOK */
    [self.activityIndPortrait performSelectorInBackground:@selector(startAnimating) withObject:nil];        
    [self.uploadButtonPortrait setEnabled:NO];
    [self.activityIndLandscape performSelectorInBackground:@selector(startAnimating) withObject:nil];        
    [self.uploadButtonLandscape setEnabled:NO];        
    

    NSString *filePath = nil;
    filePath = [[NSBundle mainBundle] pathForResource:@"dogs_sheino_iPad" ofType:@"png"];


    NSString *message;
        
    if (UIDeviceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        message = [captionPortrait text];
    } else if (UIDeviceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        message = [captionLandscape text];
    }

    // Getting the original image    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    
        NSString *finalPortraitOrLandscape;
        if (UIDeviceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
                finalPortraitOrLandscape = @"finalPortrait.png";
        } else if (UIDeviceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
                finalPortraitOrLandscape = @"finalLandscape.png";
        }
        
    NSString* fullPathFinal = [documentsDirectory stringByAppendingPathComponent:finalPortraitOrLandscape];
    filePath = fullPathFinal;

    NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:2];

    UIImage *graphImage = [[UIImage alloc] initWithContentsOfFile: filePath];
    
    //create a FbGraphFile object insance and set the picture we wish to publish on it
    FbGraphFile *graph_file = [[FbGraphFile alloc] initWithImage:graphImage];
    
    //finally, set the FbGraphFileobject onto our variables dictionary....
    [variables setObject:graph_file forKey:@"file"];
    [variables setObject:message forKey:@"message"];
    

    FbGraphResponse *fb_graph_response;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        fb_graph_response = [appDelegateIPad.fbGraph doGraphPost:@"me/photos" withPostVars:variables];
    }else
    {
        fb_graph_response = [appDelegateIphone.fbGraph doGraphPost:@"me/photos" withPostVars:variables];
    }
#endif
    
    
//    NSLog(@"fb_graph_response = %@",fb_graph_response);
    
    [self sendToPhotosFinished:fb_graph_response];
}

- (void)sendToPhotosFinished:(FbGraphResponse *)fb_graph_response
{
    
    [self.activityIndPortrait performSelectorInBackground:@selector(stopAnimating) withObject:nil];        
    [self.uploadButtonPortrait setEnabled:YES];
    [self.activityIndLandscape performSelectorInBackground:@selector(stopAnimating) withObject:nil];        
    [self.uploadButtonLandscape setEnabled:YES];        
    
    // Use when fetching text data
    NSString *responseString = fb_graph_response.htmlResponse;

    // NSLog(@"sendToPhotosFinished responseString = %@",responseString);
    
    if ([responseString rangeOfString:@"post_id"].location != NSNotFound) {
        NSString *str = @"חג שמח!";        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"התמונה הועלתה לפייסבוק" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        
        [alert show];
         
    }
}

- (void)displayRequired {
    [self presentModalViewController:_loginDialog animated:YES];
}

- (void)closeTapped {
    [self dismissModalViewControllerAnimated:YES];
    _loginState = LoginStateLoggedOut;        
    [_loginDialog logout];
    [self refresh];
}

- (IBAction)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    //   [textView setTextAlignment:UITextAlignmentRight];
    
    return YES;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
    
    if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
        
        cellWidth = 320;         
        [self.portrait setHidden:NO];
        
        [self.landscape setHidden:YES];         
          
    } else if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        
        cellWidth = 480;         
        [self.portrait setHidden:YES];
        
        [self.landscape setHidden:NO];         

    } 
}


- (void)viewDidUnload {
    [finalImageviewPortrait release];
    [finalImageviewLandscape release];    
    finalImageviewPortrait = nil;
    finalImageviewLandscape = nil;    
    [super viewDidUnload];
}
@end

#pragma clang diagnostic pop
