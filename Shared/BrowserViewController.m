//
//  BrowserViewController.m
//  HomeTheater
//
//  Created by Yuval Tessone on 6/6/10.
//  Copyright 2010 Zebrapps. All rights reserved.
//

#import "BrowserViewController.h"
#import "Utilities.h"

@implementation BrowserViewController
@synthesize webView, webContainerView, addressBar, activityIndicator, urlAddress;
//@synthesize backButton;
@synthesize delegate;

static NSArray *IHBrowserToolbarItems(id target) {
    UIBarButtonItem *backItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                                               target:target
                                                                               action:@selector(goBack:)] autorelease];
    UIBarButtonItem *refreshItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                  target:target
                                                                                  action:@selector(refresh:)] autorelease];
    UIBarButtonItem *stopItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                               target:target
                                                                               action:@selector(stopLoading:)] autorelease];
    UIBarButtonItem *forwardItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                  target:target
                                                                                  action:@selector(goForward:)] autorelease];
    UIBarButtonItem *flex1 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil] autorelease];
    UIBarButtonItem *flex2 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil] autorelease];
    UIBarButtonItem *flex3 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil] autorelease];

    return [NSArray arrayWithObjects:backItem, flex1, refreshItem, flex2, stopItem, flex3, forwardItem, nil];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.hidesBackButton = YES;
    UIToolbar *legacyToolbar = nil;
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UIToolbar class]]) {
            legacyToolbar = (UIToolbar *)subview;
            break;
        }
    }

    if (legacyToolbar) {
        UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:legacyToolbar.frame] autorelease];
        toolbar.autoresizingMask = legacyToolbar.autoresizingMask;
        toolbar.barStyle = legacyToolbar.barStyle;
        toolbar.tintColor = legacyToolbar.tintColor;
        toolbar.translucent = legacyToolbar.translucent;
        [toolbar setItems:IHBrowserToolbarItems(self)];
        [self.view insertSubview:toolbar aboveSubview:legacyToolbar];
        [legacyToolbar removeFromSuperview];
    }

    if (!self.webView) {
        WKWebViewConfiguration *configuration = [[[WKWebViewConfiguration alloc] init] autorelease];
        WKWebView *browserWebView = [[WKWebView alloc] initWithFrame:self.webContainerView.bounds configuration:configuration];
        browserWebView.navigationDelegate = self;
        browserWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        browserWebView.backgroundColor = [UIColor whiteColor];
        browserWebView.opaque = NO;
        self.webView = browserWebView;
        [browserWebView release];
        [self.webContainerView addSubview:self.webView];
    }
	/*
	backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 25, 45)];	
	[backButton addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
	UIImage *image = [UIImage imageNamed: @"backArrow.png"];
	[backButton setImage:image forState:0];
	 */
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	IHAnalyticsLogScreen(@"browser_screen", urlAddress, @"BrowserViewController");
    
	[self.navigationController setNavigationBarHidden:YES];
	
	NSURL *url = [NSURL URLWithString:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[self.webView loadRequest:requestObj];
	[addressBar setText:urlAddress];

	
//	[self.navigationController.navigationBar addSubview:backButton];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[self.webView stopLoading];
	[self.webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[backButton removeFromSuperview];
}
 */

- (IBAction)gotoAddress:(id) sender {
	IHAnalyticsLogAction(@"browser_open_url", @"browser_screen", urlAddress, [addressBar text]);
	NSURL *url = [NSURL URLWithString:[addressBar text]];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[self.webView loadRequest:requestObj];
	[addressBar resignFirstResponder];
	
}

- (IBAction)goBack:(id) sender {
	IHAnalyticsLogAction(@"browser_back", @"browser_screen", urlAddress, @"back");
	[self.webView goBack];
}

- (IBAction)goForward:(id) sender {
	IHAnalyticsLogAction(@"browser_forward", @"browser_screen", urlAddress, @"forward");
	[self.webView goForward];
}


- (IBAction)refresh:(id) sender {
	IHAnalyticsLogAction(@"browser_refresh", @"browser_screen", urlAddress, @"refresh");
	[self.webView reload]; 
}

- (IBAction)stopLoading:(id) sender {
	IHAnalyticsLogAction(@"browser_stop", @"browser_screen", urlAddress, @"stop");
	[self.webView stopLoading]; 	
	[activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	[activityIndicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	[activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	[activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
	[activityIndicator stopAnimating];
}

- (IBAction) handleBack:(id)sender
{
	IHAnalyticsLogAction(@"back_tap", @"browser_screen", urlAddress, @"back");
	// Pop the controller for back action
    [self.navigationController popViewControllerAnimated:YES];
}

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
	self.webContainerView = nil;
	self.addressBar = nil;
	self.activityIndicator = nil;
//	self.backButton = nil;
	
	[super viewDidUnload];
}


- (void)dealloc {
	[self.webView release];
	[webContainerView release];
	[addressBar release];
	[activityIndicator release];
//	[backButton release];
    [super dealloc];

}


@end
