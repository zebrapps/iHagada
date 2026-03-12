//
//  HagadaViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import "HagadaViewController.h"

@implementation HagadaViewController

- (void)updateViewingModeForCurrentLayout {
    BOOL isLandscapeLayout = CGRectGetWidth(self.view.bounds) > CGRectGetHeight(self.view.bounds);
    hagadaView.mode = isLandscapeLayout ? HagadaViewModeFacingPages : HagadaViewModeSinglePage;
}

- (id)init {
    if (self = [super init]) {
		hagadaView = [[HagadaView alloc] initWithFrame:CGRectZero];
        hagadaView.mode = HagadaViewModeSinglePage;
    }
    return self;
}

- (void)dealloc {
	[hagadaView release];
    [super dealloc];
}

#pragma mark -
#pragma mark HagadaViewDataSource methods

- (NSUInteger) numberOfPagesInHagadaView:(HagadaView*)hagadaView {
	return 0;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	
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
    [self updateViewingModeForCurrentLayout];
	hagadaView.dataSource = self;
	hagadaView.delegate = self;
	NSUInteger currentPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentPage"];
	[hagadaView reloadData:currentPage];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateViewingModeForCurrentLayout];
}

-(void)viewWillDisappear:(BOOL)animated {
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
    hagadaView.mode = UIInterfaceOrientationIsLandscape(toInterfaceOrientation) ? HagadaViewModeFacingPages : HagadaViewModeSinglePage;
}

@end
