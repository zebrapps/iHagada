//
//  HagadaChaptersViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HagadaChaptersViewController.h"
#import "Utilities.h"


@implementation HagadaChaptersViewController

@synthesize delegate, imageViewControllerHeb, imageViewControllerEng;
@synthesize BKadesh,BYahatz,BMagid,BMaror,BTzafun,BBerech,BHallel,BKorech,BRehatz,BRahatza,BKarpas,BMatza,BShulhan,BNirtza;
@synthesize imageViewHeb, imageViewEng;
@synthesize BHebrew;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"HagadaChaptersViewController" bundle:nil];
    if (self) {
        // Custom initialization
		imageViewControllerHeb = [[ImageViewControllerHeb alloc] init];
		self.imageViewControllerHeb.delegate = self;			
		imageViewControllerEng = [[ImageViewController alloc] init];
		self.imageViewControllerEng.delegate = self;					
    }
    return self;
}

- (void)dealloc
{
	
	[self.BKadesh release];
	[self.BYahatz release];
	[self.BMagid release];
	[self.BMaror release];
	[self.BTzafun release];
	[self.BBerech release];
	[self.BHallel release];
	[self.BKorech release];
	[self.BRehatz release];
	[self.BRahatza release];
	[self.BKarpas release];
	[self.BMatza release];
	[self.BShulhan release];
	[self.BNirtza release];
	[self.BHebrew release];
	
	[self.imageViewControllerHeb release];
	[self.imageViewControllerEng release];
	
	[self.imageViewHeb release];
	[self.imageViewEng release];
	
    [super dealloc];
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
	if (isHebrew) {
		[self.imageViewHeb setHidden:NO];	
		[self.imageViewEng setHidden:YES];		
		[self.BHebrew setSelected:NO];
	} else {
		[self.imageViewHeb setHidden:YES];
		[self.imageViewEng setHidden:NO];	
		[self.BHebrew setSelected:YES];		
	}
}

// Implemented viewWillAppear instead of viewDidLoad to do additional before after loading the view.
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	IHAnalyticsLogScreen(@"ipad_hagada_chapters", (isHebrew ? @"iPad Hagada Chapters Hebrew" : @"iPad Hagada Chapters English"), @"HagadaChaptersViewController");
	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
    [[self navigationItem] setPrompt:@""];
}

- (void)viewDidUnload
{
	self.BKadesh = nil;
	self.BYahatz = nil;
	self.BMagid = nil;
	self.BMaror = nil;
	self.BTzafun = nil;
	self.BBerech = nil;
	self.BHallel = nil;
	self.BKorech = nil;
	self.BRehatz = nil;
	self.BRahatza = nil;
	self.BKarpas = nil;
	self.BMatza = nil;
	self.BShulhan = nil;
	self.BNirtza = nil;
	
	self.BHebrew = nil;
	self.imageViewHeb = nil; 
	self.imageViewEng = nil;
	
    [super viewDidUnload];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//[self.tableView reloadData];  This will happen inside the imageViewController through using the delegate
	[imageViewControllerHeb willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[imageViewControllerEng willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
}

- (void)rotateViewFromAppDelegate:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[imageViewControllerHeb rotateViewFromAppDelegate:toInterfaceOrientation duration:duration];
	[imageViewControllerEng rotateViewFromAppDelegate:toInterfaceOrientation duration:duration];	
}


/*
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
		BKadesh.frame = CGRectMake(556, 100, 256, 143);
		BYahatz.frame = CGRectMake(800, 188, 256, 134);		
		BMagid.frame = CGRectMake(550, 246, 256, 166);
		BMaror.frame = CGRectMake(765, 330, 256, 167);
		BTzafun.frame = CGRectMake(794, 498, 256, 165);
		BBerech.frame = CGRectMake(581, 549, 256, 179);
		BHallel.frame = CGRectMake(309, 577, 264, 156);
		BKorech.frame = CGRectMake(462, 418, 259, 131);
		BRehatz.frame = CGRectMake(288, 148, 260, 156);
		BRahatza.frame = CGRectMake(221, 305, 256, 156);
		BKarpas.frame = CGRectMake(0, 119, 280, 172);
		BMatza.frame = CGRectMake(-5, 294, 256, 154);
		BShulhan.frame = CGRectMake(0, 464, 427, 111);
		BNirtza.frame = CGRectMake(36, 604, 272, 139);
	} else {
		BKadesh.frame = CGRectMake(556, 100, 256, 143);
		BYahatz.frame = CGRectMake(800, 188, 256, 134);		
		BMagid.frame = CGRectMake(550, 246, 256, 166);
		BMaror.frame = CGRectMake(765, 330, 256, 167);
		BTzafun.frame = CGRectMake(794, 498, 256, 165);
		BBerech.frame = CGRectMake(581, 549, 256, 179);
		BHallel.frame = CGRectMake(309, 577, 264, 156);
		BKorech.frame = CGRectMake(462, 418, 259, 131);
		BRehatz.frame = CGRectMake(288, 148, 260, 156);
		BRahatza.frame = CGRectMake(221, 305, 256, 156);
		BKarpas.frame = CGRectMake(0, 119, 280, 172);
		BMatza.frame = CGRectMake(-5, 294, 256, 154);
		BShulhan.frame = CGRectMake(0, 464, 427, 111);
		BNirtza.frame = CGRectMake(36, 604, 272, 139);
	}

}
*/

- (IBAction) selectChapter:(id)sender
{	
    NSInteger selectedPage = 0;
    NSString *selectedButton = [NSString stringWithFormat:@"chapter_%ld", (long)[(UIButton*)sender tag]];
	if (isHebrew) {
		switch ([(UIButton*)sender tag]) {
			case 1: 
				selectedPage = 1;
				break;
			case 2: 
				selectedPage = 3;
				break;
			case 3:
				selectedPage = 4;
				break;
			case 4: 
				selectedPage = 5;
				break;
			case 5: 
				selectedPage = 6;
				break;
			case 6:
                selectedPage = 28;
				break;
			case 7: 
                selectedPage = 29;
				break;
			case 8: 
                selectedPage = 30;
				break;
			case 9: 
                selectedPage = 31;
				break;
			case 10:
				selectedPage = 32;
				break;
			case 11: 
				selectedPage = 33;
				break;
			case 12: 
				selectedPage = 34;
				break;
			case 13:
				selectedPage = 45;
				break;
			case 14:
				selectedPage = 58;
				break;				
		}
		IHAnalyticsLogAction(@"open_chapter", @"ipad_hagada_chapters", @"iPad Hagada Chapters Hebrew", selectedButton);
		[[NSUserDefaults standardUserDefaults] setInteger:selectedPage forKey:@"currentPageHeb"];
		[self.imageViewControllerHeb setHidesBottomBarWhenPushed:YES];
		[self.navigationController pushViewController:imageViewControllerHeb animated:YES];	 
	} else {
			switch ([(UIButton*)sender tag]) {
				case 1: 
					selectedPage = 1;
					break;
				case 2: 
					selectedPage = 3;
					break;
			case 3:
				selectedPage = 7;
				break;
			case 4: 
				selectedPage = 8;
				break;
			case 5: 
				selectedPage = 9;
				break;
			case 6:
				selectedPage = 54;
				break;
			case 7: 
				selectedPage = 55;
				break;
			case 8: 
				selectedPage = 56;
				break;
			case 9: 
				selectedPage = 57;
				break;
			case 10:
				selectedPage = 58;
				break;
			case 11: 
				selectedPage = 59;
				break;
			case 12: 
				selectedPage = 60;
				break;
			case 13:
				selectedPage = 77;
				break;
			case 14:
				selectedPage = 78;
				break;		
		}
		IHAnalyticsLogAction(@"open_chapter", @"ipad_hagada_chapters", @"iPad Hagada Chapters English", selectedButton);
		[[NSUserDefaults standardUserDefaults] setInteger:selectedPage forKey:@"currentPage"];		
		[self.imageViewControllerEng setHidesBottomBarWhenPushed:YES];
		[self.navigationController setNavigationBarHidden:YES animated:NO];		
		[self.navigationController pushViewController:imageViewControllerEng animated:YES];	

	}
}

- (IBAction)changeLanguage:(id)sender
{
	IHAnalyticsLogAction(@"change_language", @"ipad_hagada_chapters", @"iPad Hagada Chapters", ([(UIButton *)sender isSelected] ? @"hebrew" : @"english"));
	if ([sender isSelected]) {
		[sender setSelected:NO];
		[self.delegate changeLanguage];
		[self.imageViewEng setHidden:YES];
		[self.imageViewHeb setHidden:NO];
//		[self.tableView reloadData];
	}else {
		[sender setSelected:YES];		
		[self.delegate changeLanguage];		
		[self.imageViewEng setHidden:NO];
		[self.imageViewHeb setHidden:YES];		
//		[self.tableView reloadData];			
	}
}

@end
