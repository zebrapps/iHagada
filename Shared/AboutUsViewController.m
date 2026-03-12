//
//  AboutUsViewController.m
//  HomeTheater
//
//  Created by Yuval Tessone on 12/18/10.
//  Copyright 2010 Zebrapps. All rights reserved.
//

#import "AboutUsViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation AboutUsViewController

@synthesize delegate,browserViewController;
//@synthesize aboutUsImageViewReg, aboutUsImageViewWide;
//@synthesize b_contactUs, b_sirimWebSite, b_zebrappsWebSite;
@synthesize aboutUsViewPortrait, aboutUsViewLandscape;

int cellWidth; // Global parameter for all the other table view controllers;

- (void)displayAboutView:(UIView *)aboutView {
	for (UIView *subview in [self.view subviews]) {
		[subview removeFromSuperview];
	}
	
	aboutView.frame = self.view.bounds;
	aboutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	aboutView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:aboutView];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
	containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	containerView.backgroundColor = [UIColor blackColor];
	self.view = containerView;
	[containerView release];
	
	self.aboutUsViewPortrait.backgroundColor = [UIColor blackColor];
	self.aboutUsViewLandscape.backgroundColor = [UIColor blackColor];
}

// Implemented viewWillAppear instead of viewDidLoad to do additional before after loading the view.
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	self.view.backgroundColor = [UIColor blackColor];
	self.aboutUsViewPortrait.backgroundColor = [UIColor blackColor];
	self.aboutUsViewLandscape.backgroundColor = [UIColor blackColor];
	
	if (UIDeviceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
		[self displayAboutView:aboutUsViewPortrait];
	} else if (UIDeviceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
		[self displayAboutView:aboutUsViewLandscape];
	}		
}

// Send Mail Methods
- (IBAction) SendMail
{
	if ([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
		composer.mailComposeDelegate = self;
		
		[[composer navigationItem] setPrompt:@""];
		[composer setToRecipients:[NSArray arrayWithObjects:@"contact@zebrapps.com", nil]];
		[composer setSubject:@" "];
//		[composer setSubject:@"צור קשר דרך HomeTheater"];
//		[composer setMessageBody:shareStr isHTML: NO];
		
		[self presentModalViewController:composer animated:YES];
		[self.navigationController setNavigationBarHidden:YES animated:NO];
		
		[[[[composer navigationBar] items] objectAtIndex:0] setTitle:@""];
		[[[[composer navigationBar] items] objectAtIndex:0] setPrompt:@""];
		[composer release];
		return;
	}
	
	NSURL *mailURL = [NSURL URLWithString:@"mailto:contact@zebrapps.com"];
	if ([[UIApplication sharedApplication] canOpenURL:mailURL]) {
		[[UIApplication sharedApplication] openURL:mailURL];
		return;
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail Not Available"
													message:@"Please configure a mail account to contact Zebrapps."
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	[self dismissModalViewControllerAnimated:YES];
	
	if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"כשלון" message:@"הייתה בעייה בשליחת המייל"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else if (result == MFMailComposeResultSent) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"הצלחה" message:@"הדואר נשלח בהצלחה"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
}

/*
- (void) handleBack:(id)sender
{
	MoreItemsViewController *moreViewController = [[MoreItemsViewController alloc] initWithNibName:@"MoreItemsViewController" bundle:nil];
	
	// Pass the selected object to the new view controller.
	[self.navigationController pushViewController:moreViewController animated:NO];
	[moreViewController release];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];	
	
	if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
		cellWidth = 320;		
		[self displayAboutView:self.aboutUsViewPortrait];
	} else if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
		cellWidth = 480;		
		[self displayAboutView:self.aboutUsViewLandscape];
	}	
}


- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
}

 
- (void) handleBack:(id)sender
{
	// Pop the controller for back action
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction) sirimWebSite {
    // Link disabled by request: keep action connected but intentionally no-op.
    return;
}

- (IBAction) zebrappsWebSite {

	if (!self.browserViewController) {
		
		#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			self.browserViewController = [[BrowserViewController alloc] initWithNibName:@"BrowserViewControllerHD" bundle:nil];
		} else {
			self.browserViewController = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];									
		}
		#endif
		
	}
	
	self.browserViewController.delegate = self;
	
	[self.browserViewController setUrlAddress:@"https://www.zebrapps.com"/*[[request URL] absoluteString]*/];
	[browserViewController setHidesBottomBarWhenPushed:YES];	
	[self.navigationController pushViewController:browserViewController animated:YES];
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];		
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

#pragma clang diagnostic pop
