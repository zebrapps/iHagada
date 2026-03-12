//
//  OverlayChooseImage.m
//  iHagada
//
//  Created by Yuval Tessone on 3/15/12.
//  Copyright 2012 www.zebrapps.com All rights reserved.
//

#import "OverlayChooseTemplate.h"
#import "FourSonsChooseThemeViewController.h"

@implementation OverlayChooseTemplate

@synthesize fourSonsChooseThemeViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        fourSonsChooseThemeViewController = [[FourSonsChooseThemeViewController alloc] init ];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.fourSonsChooseThemeViewController removeTemplateOverlayView];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [fourSonsChooseThemeViewController release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
