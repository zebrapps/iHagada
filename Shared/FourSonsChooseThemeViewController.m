//
//  FourSonsChooseThemeViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 3/4/12.
//  Copyright (c) 2012 www.zebrapps.com. All rights reserved.
//

#import "FourSonsChooseThemeViewController.h"
#import "Utilities.h"
#import "FourSonsViewController.h"
#import "OverlayChooseTemplate.h"

@implementation FourSonsChooseThemeViewController

@synthesize delegate;
@synthesize scrollViewPortrait,scrollViewLandscape, pageControl;
@synthesize framePortrait,frameLandscape;
@synthesize cancelButtonPortrait,confirmButtonPortrait,cancelButtonLandscape,confirmButtonLandscape;

OverlayChooseTemplate *ovTemplateController; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        [self.scrollViewPortrait setContentSize:CGSizeMake(2028, 901)];
        [self.scrollViewPortrait setContentSize:CGSizeMake(1968, 830)];
//        [self.scrollViewLandscape setContentSize:CGSizeMake(3072, 719)];
//        [self.scrollViewLandscape setContentSize:CGSizeMake(6000, 768)];        
//        [self.scrollViewLandscape setContentSize:CGSizeMake(1894, 657)];                
        [self.scrollViewLandscape setContentSize:CGSizeMake(2844, 657)];                        
    } else {
        [self.scrollViewPortrait setContentSize:CGSizeMake(960, 431)];
        [self.scrollViewLandscape setContentSize:CGSizeMake(1440, 238)];
    }
    #endif
    
    self.hidesBottomBarWhenPushed = NO;    
    
    if (![self.delegate isEverBeenChosenTheme]) {
       //  NSLog(@"enable = NO");        
        [cancelButtonPortrait setEnabled:NO];
        [cancelButtonLandscape setEnabled:NO];        
    }
    
    [self.pageControl setCurrentPage:[self.delegate chosenTheme]];
    
    [self changeOtherScrollViewAfterPaging];  
    
    if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isFirstThemeLoad = [defaults objectForKey:@"isFirstThemeLoad"];
    
    if (isFirstThemeLoad == nil) {
        
        CGFloat yaxis; 
        CGFloat width;
        CGFloat height;
        
        [defaults setObject:@"NO" forKey:@"isFirstThemeLoad"];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //Add the overlay view.
            if(ovTemplateController == nil)
                ovTemplateController = [[OverlayChooseTemplate alloc] initWithNibName:@"OverlayChooseTemplate_iPad" bundle:[NSBundle mainBundle]];
            
            yaxis = 830; 
            width = 768; 
            height = 60;                    
        } else {
            //Add the overlay view.
            if(ovTemplateController == nil)
                ovTemplateController = [[OverlayChooseTemplate alloc] initWithNibName:@"OverlayChooseTemplate" bundle:[NSBundle mainBundle]];
            
            yaxis = 340;
            width = 320; 
            height = 60; 
        }
#endif
        
        //Parameters x = origion on x-axis, y = origon on y-axis.
        CGRect frame = CGRectMake(0, yaxis, width, height);
        ovTemplateController.view.frame = frame;
        ovTemplateController.view.backgroundColor = [UIColor grayColor];
        ovTemplateController.view.alpha = 0.4;
        
        [self.view insertSubview:ovTemplateController.view aboveSubview:self.parentViewController.view];
    }
}

- (void) removeTemplateOverlayView {
    
    [ovTemplateController.view removeFromSuperview];
    [ovTemplateController release];
    ovTemplateController = nil;    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IHAnalyticsLogScreen(@"four_sons_themes", @"Four Sons Themes", @"FourSonsChooseThemeViewController");

    if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        [self.scrollViewPortrait setHidden:NO];
        [self.framePortrait setHidden:NO];
        [self.cancelButtonPortrait setHidden:NO];
        [self.confirmButtonPortrait setHidden:NO];
        [self.scrollViewLandscape setHidden:YES];
        [self.frameLandscape setHidden:YES];
        [self.cancelButtonLandscape setHidden:YES];
        [self.confirmButtonLandscape setHidden:YES];
        
	} else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        [self.scrollViewPortrait setHidden:YES];
        [self.framePortrait setHidden:YES];
        [self.cancelButtonPortrait setHidden:YES];
        [self.confirmButtonPortrait setHidden:YES];        
        [self.scrollViewLandscape setHidden:NO];        
        [self.frameLandscape setHidden:NO];
        [self.cancelButtonLandscape setHidden:NO];
        [self.confirmButtonLandscape setHidden:NO];        
	}	
    
   //  NSLog(@"SELF.DELEGATE = %p",self.delegate);
   //  NSLog(@"SELF.DELEGATE activitiyIndicator = %p",[self.delegate activitiyIndicator]);    
    [[self.delegate activitiyIndicator] stopAnimating];
}

- (IBAction)ChooseTheme {
//    [self dismissModalViewControllerAnimated:YES];
    IHAnalyticsLogAction(@"select_theme", @"four_sons_themes", @"Four Sons Themes", [NSString stringWithFormat:@"theme_%ld", (long)pageControl.currentPage]);
    [self.delegate changeTheme:(int)pageControl.currentPage];
    [self.navigationController popToRootViewControllerAnimated:NO];     
    [self removeTemplateOverlayView];
}

- (IBAction)cancelChooseTheme {
    IHAnalyticsLogAction(@"cancel_theme", @"four_sons_themes", @"Four Sons Themes", @"cancel");
    [self.navigationController popToRootViewControllerAnimated:NO];    
    [self removeTemplateOverlayView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    pageControl.currentPage=page;
    
    [self changeOtherScrollViewAfterPaging];    
}

-(IBAction)clickPageControl:(id)sender

{
    IHAnalyticsLogAction(@"theme_page_control", @"four_sons_themes", @"Four Sons Themes", [NSString stringWithFormat:@"theme_%ld", (long)pageControl.currentPage]);
    int page = (int)pageControl.currentPage;
    
    if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        CGRect frame=scrollViewPortrait.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y=0;
        [scrollViewPortrait scrollRectToVisible:frame animated:YES];
	} else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        CGRect frame=scrollViewLandscape.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y=0;
        [scrollViewLandscape scrollRectToVisible:frame animated:YES];
	}
    
    [self changeOtherScrollViewAfterPaging];

}

- (void)changeOtherScrollViewAfterPaging {
    // If the device orientation is portrait, so change the landscpae scroll view
//    if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        CGRect frame=scrollViewLandscape.frame;
        frame.origin.x = frame.size.width * pageControl.currentPage;
        frame.origin.y=0;
        [scrollViewLandscape scrollRectToVisible:frame animated:NO];
//	} else if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        CGRect frameP=scrollViewPortrait.frame;
        frameP.origin.x = frameP.size.width * pageControl.currentPage;
        frameP.origin.y=0;
        [scrollViewPortrait scrollRectToVisible:frameP animated:NO];
//	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [ovTemplateController release];
    [scrollViewPortrait release];
    [scrollViewLandscape release];
    [pageControl release];
    [framePortrait release];
    [frameLandscape release];
    [cancelButtonPortrait release];
    [confirmButtonPortrait release];
    [cancelButtonLandscape release];
    [confirmButtonLandscape release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
    
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        
        cellWidth = 320;         
        [self.scrollViewPortrait setHidden:NO];
        [self.framePortrait setHidden:NO];
        [self.cancelButtonPortrait setHidden:NO];
        [self.confirmButtonPortrait setHidden:NO];
        [self.scrollViewLandscape setHidden:YES];
        [self.frameLandscape setHidden:YES];
        [self.cancelButtonLandscape setHidden:YES];
        [self.confirmButtonLandscape setHidden:YES];
        
        
    } else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        
        cellWidth = 480;         
        [self.scrollViewPortrait setHidden:YES];
        [self.framePortrait setHidden:YES]; 
        [self.cancelButtonPortrait setHidden:YES];
        [self.confirmButtonPortrait setHidden:YES];        
        [self.scrollViewLandscape setHidden:NO];        
        [self.frameLandscape setHidden:NO];        
        [self.cancelButtonLandscape setHidden:NO];
        [self.confirmButtonLandscape setHidden:NO];        
    } 
    
    [self removeTemplateOverlayView];
}

@end
