//
//  HagadaViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import "HagadaViewControllerHeb.h"
#import "Utilities.h"

@implementation HagadaViewControllerHeb

- (void)updateViewingModeForCurrentLayout {
    BOOL isLandscapeLayout = CGRectGetWidth(self.view.bounds) > CGRectGetHeight(self.view.bounds);
    hagadaView.mode = isLandscapeLayout ? HagadaViewHebModeFacingPages : HagadaViewHebModeSinglePage;
}

- (id)init {
    if (self = [super init]) {
		hagadaView = [[HagadaViewHeb alloc] initWithFrame:CGRectZero];			
        hagadaView.mode = HagadaViewHebModeSinglePage;
    }
    return self;
}

- (void)dealloc {
	[hagadaView release];
    [super dealloc];
}

#pragma mark -
#pragma mark HagadaViewDataSource methods

- (NSUInteger) numberOfPagesInHagadaView:(HagadaViewHeb*)hagadaView {
	return 0;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {

	
}

- (void)HagadaView:(HagadaViewHeb *)aHagadaView didTurnToPageAtIndex:(NSUInteger)pageIndex {
    [[NSUserDefaults standardUserDefaults] setInteger:pageIndex forKey:@"currentPageHeb"];
    IHAnalyticsLogAction(@"turn_page", @"hagada_reader_hebrew", [NSString stringWithFormat:@"Page %ld", (long)pageIndex], [NSString stringWithFormat:@"page_%ld", (long)pageIndex]);
}

#pragma mark -
#pragma mark  UIViewController methods

- (void)loadView {
	[super loadView];
	hagadaView.frame = self.view.bounds;
	hagadaView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:hagadaView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    IHAnalyticsLogScreen(@"Hagada Screen", [NSString stringWithFormat:@"Page %ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"currentPageHeb"]], @"HagadaViewControllerHeb");
    [self updateViewingModeForCurrentLayout];
	hagadaView.dataSource = self;
	hagadaView.delegate = self;
	NSUInteger currentPageHeb = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentPageHeb"];
	[hagadaView reloadData:currentPageHeb];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateViewingModeForCurrentLayout];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO];	
}


#pragma mark -
#pragma mark Interface rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    hagadaView.mode = UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? HagadaViewHebModeFacingPages : HagadaViewHebModeSinglePage;
}

@end
