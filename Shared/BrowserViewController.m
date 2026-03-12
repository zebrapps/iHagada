//
//  BrowserViewController.m
//  HomeTheater
//
//  Created by Yuval Tessone on 6/6/10.
//  Copyright 2010 Zebrapps. All rights reserved.
//

#import "BrowserViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation BrowserViewController
@synthesize webView, addressBar, activityIndicator, urlAddress;
//@synthesize backButton;
@synthesize delegate;

int cellWidth;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.hidesBackButton = YES;
	/*
	backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 25, 45)];	
	[backButton addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
	UIImage *image = [UIImage imageNamed: @"backArrow.png"];
	[backButton setImage:image forState:0];
	 */
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	[self.navigationController setNavigationBarHidden:YES];
	
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[webView loadRequest:requestObj];
	[addressBar setText:urlAddress];

	
//	[self.navigationController.navigationBar addSubview:backButton];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[backButton removeFromSuperview];
}
 */

- (IBAction)gotoAddress:(id) sender {
	NSURL *url = [NSURL URLWithString:[addressBar text]];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[webView loadRequest:requestObj];
	[addressBar resignFirstResponder];
	
}

- (IBAction)goBack:(id) sender {
	[webView goBack];
}

- (IBAction)goForward:(id) sender {
	[webView goForward];
}


- (IBAction)refresh:(id) sender {
	[webView reload]; 
}

- (IBAction)stopLoading:(id) sender {
	[webView stopLoading]; 	
	[activityIndicator stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[activityIndicator stopAnimating];
}

- (IBAction) handleBack:(id)sender
{
	// Pop the controller for back action
    [self.navigationController popViewControllerAnimated:YES];
}

/*
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *URL = [request URL];
		if ([[URL scheme] isEqualToString:@"http"]) {
			[addressBar setText:[URL absoluteString]];
			[self gotoAddress:nil];
		}
		return NO;
	}
	return YES;
	 
}
*/


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
	
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		//nil;
        NSLog(@"Do Nothing");
	else {	
		if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
			cellWidth = 320;
		} else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
			cellWidth = 480;			
		}
	}
#endif		
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	
	self.webView = nil;
	self.addressBar = nil;
	self.activityIndicator = nil;
//	self.backButton = nil;
	
	[super viewDidUnload];
}


- (void)dealloc {
	[self.webView release];
	[addressBar release];
	[activityIndicator release];
//	[backButton release];
    [super dealloc];

}


@end

#pragma clang diagnostic pop
