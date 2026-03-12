//
//  FacebookViewController.m
//  Appocalypse Now
//
//  Created by Yuval Tessone on 20/11/12.
//  Copyright (c) 2012 www.zebrapps.com All rights reserved.
//

#import "FacebookViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FbGraphFile.h"

@interface FacebookViewController ()

@end

@implementation FacebookViewController
@synthesize urlString;
@synthesize shelterName;
@synthesize tracker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc
{
    [textView release];
    [urlString release];
    [shelterName release];
    
    [super dealloc];
}

-(void)viewDidUnload {

    textView = nil;
    urlString = nil;
    shelterName = nil;
    
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.titleView = imgView;
    [imgView release];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"בטל" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"שתף" style:UIBarButtonItemStyleBordered target:self action:@selector(shareOnFacebook)];
    
//    [textView becomeFirstResponder];
    textView.clipsToBounds = YES;
    textView.layer.cornerRadius = 5.0;
    
    self.trackedViewName = @"FacebookViewController";
}

-(void)viewWillAppear:(BOOL)animated
{
    // Add GoogleAnalytics
    tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker trackEventWithCategory:@"uiScreen"
                         withAction:@"ShowFacebook"
                          withLabel:[[UIDevice currentDevice] uniqueDeviceIdentifier]
                          withValue:[NSNumber numberWithInt:-1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Actions
-(void)dismiss {
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)shareOnFacebook {
    if (!textView.text || [textView.text isEqualToString:@""]) {
        [delegate alertWithTitle:@"הודעה" messageForAlert:@"באפשרותך לערוך את הודעתך" titleForButton:@"Ok"];
        return;
    }
    [textView resignFirstResponder];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        [delegate alertWithTitle:@"חיבור אינטרנט" messageForAlert:@"בעייה בחיבור לאינטרנט" titleForButton:@"Ok"];
        return;
    }
    
    
    if ( (delegate.fbGraph.accessToken == nil) || ([delegate.fbGraph.accessToken length] == 0) ) {
        /*Facebook Application ID*/
        NSString *client_id = @"488578971194911";
        
        //alloc and initalize our FbGraph instance
        delegate.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
        [delegate.fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access" andSuperView:self.view];
    }
    else {
        //Authentified, now share
        [self performSelectorOnMainThread:@selector(postOnFacebook) withObject:nil waitUntilDone:NO];
    }

}


/**
 * This function is called by FbGraph after it's finished the authentication process
 **/
- (void)fbGraphCallback:(id)sender {
	Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        [delegate alertWithTitle:@"חיבור אינטרנט" messageForAlert:@"בעייה בחיבור לאינטרנט" titleForButton:@"Ok"];
        return;
    }
    
	if ( (delegate.fbGraph.accessToken == nil) || ([delegate.fbGraph.accessToken length] == 0) ) {
		//restart the authentication process.....
        [delegate.fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"publish_stream,offline_access" andSuperView:self.view];
        
	} else {
        //Authentified, now share
        [self performSelectorOnMainThread:@selector(postOnFacebook) withObject:nil waitUntilDone:NO];
    }
	
}

-(void)postOnFacebook {
    delegate.progressIndic  = [[MBProgressHUD alloc] initWithView:self.view.window];
    
    // Add HUD to screen
    [delegate.window addSubview:delegate.progressIndic];
    
    delegate.progressIndic.mode = MBProgressHUDModeIndeterminate;
    
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    delegate.progressIndic.delegate = self;
    
    //Loading
    delegate.progressIndic.labelText = @"Sharing on facebook";
    
    // Show the HUD while the provided method executes in a new thread
    delegate.progressIndic.animationType = MBProgressHUDAnimationFade;
    
    [delegate.progressIndic showWhileExecuting:@selector(postFeed) onTarget:self withObject:nil animated:YES];

}

-(void)postFeed {
    NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:5];
    [variables setObject:@"http://israpps.com/iOS_app/recycle_app/recycle.png" forKey:@"picture"];
    [variables setObject:textView.text forKey:@"message"];
    [variables setObject:urlString forKey:@"link"];
    [variables setObject:shelterName forKey:@"name"];
    [variables setObject:@"אפליקציה המציגה את פח המיחזור הקרוב אלייך!" forKey:@"description"];

    @try {
        FbGraphResponse *fb_graph_response = [delegate.fbGraph doGraphPost:@"me/feed" withPostVars:variables];
        NSLog(@"Post feed:  %@", fb_graph_response.htmlResponse);
        [delegate alertWithTitle:@"שיתוף בפייסבוק" messageForAlert:@"הודעתך שותפה בהצלחה!" titleForButton:@"Ok"];
        [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:NO];
    }
    @catch (NSException* ex) {
        NSLog(@"failed: %@",ex);
        [delegate alertWithTitle:@"תקלה" messageForAlert:@"לא ניתן לשתף בפייסבוק" titleForButton:@"Ok"];
        [textView becomeFirstResponder];
        
        [tracker trackException:NO // Boolean indicates non-fatal exception.
                withDescription:@"Exception at FacebookViewController.postFeed %@: %@", ex];
    }
}
#pragma -

#pragma ProgressHudDelegate
- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was ;
    [delegate.progressIndic removeFromSuperview];
    [delegate.progressIndic release];
}
#pragma -

@end
