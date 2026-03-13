//
//  MainTableViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import "MainTableViewController.h"
#import "ImageViewController.h"
#import "AppDelegate_iPad.h"
#import "AppDelegate_iPhone.h"

@implementation MainTableViewController

@synthesize imageViewControllerHeb,imageViewControllerEng, delegate;
@synthesize navBarChaptersHebReg,navBarChaptersHebWide,navBarChaptersEngReg,navBarChaptersEngWide;
@synthesize langButton, tableView, headerImageView;

//static UIControlState btnState = UIControlStateNormal;

AppDelegate_iPhone *appDelegateIphone;
AppDelegate_iPad *appDelegateIpad;


#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
    UIView *rootView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    rootView.backgroundColor = [UIColor blackColor];
    rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = rootView;
    [rootView release];

    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.opaque = YES;
    headerView.userInteractionEnabled = YES;
    [self.view addSubview:headerView];
    self.headerImageView = headerView;
    [headerView release];

    UITableView *chaptersTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    chaptersTableView.backgroundColor = [UIColor clearColor];
    chaptersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chaptersTableView.showsVerticalScrollIndicator = NO;
    chaptersTableView.bounces = NO;
    chaptersTableView.contentInset = UIEdgeInsetsZero;
    chaptersTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    chaptersTableView.delegate = self;
    chaptersTableView.dataSource = self;
    if (@available(iOS 15.0, *)) {
        chaptersTableView.sectionHeaderTopPadding = 0.0f;
    }
    [self.view addSubview:chaptersTableView];
    self.tableView = chaptersTableView;
    [chaptersTableView release];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
	
	imageViewControllerHeb = [[ImageViewControllerHeb alloc] init];
	self.imageViewControllerHeb.delegate = self;	
	imageViewControllerEng = [[ImageViewController alloc] init];
	self.imageViewControllerEng.delegate = self;	
	
	if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
		cellWidth = 480;
	} else if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
		cellWidth = 320;
	}
	
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		appDelegateIpad = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
	else
		appDelegateIphone = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
	#endif

	
	// set image to navigation bar
    UIImage *navImage = [UIImage imageNamed:@"chapters.jpg"];
    navBarChaptersHebReg = [[UIImageView alloc] initWithImage:navImage];
    navImage = [UIImage imageNamed:@"chapters_eng.jpg"];
    navBarChaptersEngReg = [[UIImageView alloc] initWithImage:navImage];
    
    if( IS_IPHONE_5 )
    {
        navImage = [UIImage imageNamed:@"chapters_w2_568.jpg"];
        navBarChaptersHebWide = [[UIImageView alloc] initWithImage:navImage];
        navImage = [UIImage imageNamed:@"chapters_w_eng_568.jpg"];
        navBarChaptersEngWide = [[UIImageView alloc] initWithImage:navImage];
    }
    else
    {
        navImage = [UIImage imageNamed:@"chapters_w2.jpg"];
        navBarChaptersHebWide = [[UIImageView alloc] initWithImage:navImage];
        navImage = [UIImage imageNamed:@"chapters_w_eng.jpg"];
        navBarChaptersEngWide = [[UIImageView alloc] initWithImage:navImage];
	}
    
	langButton=[[UIButton alloc] initWithFrame:CGRectZero];
	[langButton setImage:[UIImage imageNamed:@"USAFlag.png"] forState:UIControlStateNormal];
	[langButton setImage:[UIImage imageNamed:@"IsraelFlag.png"] forState:UIControlStateSelected];	
	[langButton addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventTouchUpInside];		
    [self.headerImageView addSubview:langButton];
	
	if (isHebrew) {
		[langButton setSelected:NO];
	} else {
		[langButton setSelected:YES];
	}

	[navBarChaptersHebReg setHidden:NO];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:YES];	

    [self.tableView setRowHeight:66.0f];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self applyCurrentHeaderImage];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self applyCurrentHeaderImage];
    [self updateHeaderAndTableLayout];
		
	/* Reload the cells to avoid the problematic sitatuation when rotating the iphone in another view controller and then going back to this view controller */
	[self.tableView reloadData];
	
	if (isHebrew) {
		if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
			[self changeNavBarHebReg];
		} else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
			[self changeNavBarHebWide];
		}			
	} else {
		if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
			[self changeNavBarEngReg];
		} else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
			[self changeNavBarEngWide];
		}
	}
	
	//[[UIApplication sharedApplication] statusBarOrientation]
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self updateHeaderAndTableLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self updateHeaderAndTableLayout];
    [self.tableView reloadData];
}


- (CGRect)contentLayoutFrame {
    if (self.view.superview == nil) {
        return self.view.bounds;
    }

    CGRect contentFrame = self.view.frame;
    contentFrame.origin.x = 0.0f;
    contentFrame.origin.y = 0.0f;
    contentFrame.size.width = self.view.superview.bounds.size.width;
    contentFrame.size.height = self.view.superview.bounds.size.height;

    return contentFrame;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)updateHeaderAndTableLayout {
    CGFloat bottomInset = 0.0f;

    if (@available(iOS 11.0, *)) {
        bottomInset = self.view.safeAreaInsets.bottom;
    }

    CGRect contentFrame = [self contentLayoutFrame];
    if (!CGRectEqualToRect(self.view.frame, contentFrame)) {
        self.view.frame = contentFrame;
    }

    CGRect viewBounds = self.view.bounds;
    BOOL isLandscapeLayout = viewBounds.size.width > viewBounds.size.height;
    CGFloat contentWidth = MIN(viewBounds.size.width, isLandscapeLayout ? 480.0f : 320.0f);
    CGFloat contentX = floor((viewBounds.size.width - contentWidth) / 2.0f);

    UIImage *headerImage = self.headerImageView.image;
    CGFloat headerHeight = 0.0f;
    if (headerImage != nil && headerImage.size.width > 0.0f) {
        headerHeight = floor((headerImage.size.height / headerImage.size.width) * contentWidth);
    }

    self.headerImageView.frame = CGRectMake(contentX, 0.0f, contentWidth, headerHeight);
    CGFloat langButtonY = isLandscapeLayout ? 3.0f : 7.0f;
    self.langButton.frame = CGRectMake(contentWidth - 37.0f, langButtonY, 30.0f, 30.0f);

    CGFloat tableY = CGRectGetMaxY(self.headerImageView.frame);
    CGFloat tableHeight = viewBounds.size.height - tableY - bottomInset;
    self.tableView.frame = CGRectMake(contentX, tableY, contentWidth, MAX(tableHeight, 0.0f));
}

- (void)applyCurrentHeaderImage {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (isHebrew) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self changeNavBarHebWide];
        } else {
            [self changeNavBarHebReg];
        }
    } else {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            [self changeNavBarEngWide];
        } else {
            [self changeNavBarEngReg];
        }
    }
}
 

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

	//[self.tableView reloadData];  This will happen inside the imageViewController through using the delegate, and also change nav bar
	[self.imageViewControllerHeb willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self.imageViewControllerEng willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	if (isHebrew) {
		if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
			cellWidth = 320;
			[self changeNavBarHebReg];
		} else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
			cellWidth = 480;			
			[self changeNavBarHebWide];
		}			
	} else {
		if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {					
			cellWidth = 320;			
			[self changeNavBarEngReg];
		} else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {		
			cellWidth = 480;			
			[self changeNavBarEngWide];
		}
	}
}

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
}

- (void)rotateViewFromAppDelegate:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	[imageViewControllerHeb rotateViewFromAppDelegate:toInterfaceOrientation duration:duration];
	[imageViewControllerEng rotateViewFromAppDelegate:toInterfaceOrientation duration:duration];	
}


- (void)changeNavBarHebReg {
	self.headerImageView.image = navBarChaptersHebReg.image;
	
	[navBarChaptersHebReg setHidden:NO];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:YES];

    [self updateHeaderAndTableLayout];
}

- (void)changeNavBarHebWide {
	self.headerImageView.image = navBarChaptersHebWide.image;
	
	[navBarChaptersHebReg setHidden:YES];
	[navBarChaptersHebWide setHidden:NO];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:YES];

    [self updateHeaderAndTableLayout];
}

- (void)changeNavBarEngReg {
	self.headerImageView.image = navBarChaptersEngReg.image;
	
	[navBarChaptersHebReg setHidden:YES];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:NO];
	[navBarChaptersEngWide setHidden:YES];

    [self updateHeaderAndTableLayout];
}

- (void)changeNavBarEngWide {
	self.headerImageView.image = navBarChaptersEngWide.image;
	
	[navBarChaptersHebReg setHidden:YES];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:NO];

    [self updateHeaderAndTableLayout];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	//return [imageViewController.images count];
    return 14;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    UIImage *cellImage = nil;
		
	if (cellWidth == 480) {
		if (isHebrew) {
			switch (indexPath.row) {
				case 0: 
					cellImage = [UIImage imageNamed:@"Kadeish_w.jpg"];
                    break;
				case 1: 
					cellImage = [UIImage imageNamed:@"Urchatz_w.jpg"];
					break;
				case 2:
					cellImage = [UIImage imageNamed:@"Karpas_w.jpg"];
					break;
				case 3: 
					cellImage = [UIImage imageNamed:@"Yachatz_w.jpg"];
					break;
				case 4: 
					cellImage = [UIImage imageNamed:@"Magid_w.jpg"];
					break;
				case 5:
					cellImage = [UIImage imageNamed:@"Rohtzah_w.jpg"];
					break;
				case 6: 
					cellImage = [UIImage imageNamed:@"Motzi_w.jpg"];
					break;
				case 7: 
					cellImage = [UIImage imageNamed:@"Maror_w.jpg"];
					break;
				case 8: 
					cellImage = [UIImage imageNamed:@"Koreich_w.jpg"];
					break;
				case 9:
					cellImage = [UIImage imageNamed:@"Shulchan Orech_w.jpg"];
					break;
				case 10: 
					cellImage = [UIImage imageNamed:@"Tzafun_w.jpg"];
					break;
				case 11: 
					cellImage = [UIImage imageNamed:@"Bareich_w.jpg"];
					break;
				case 12:
					cellImage = [UIImage imageNamed:@"Hallel_w.jpg"];
					break;
				case 13:
					cellImage = [UIImage imageNamed:@"Nirtzah_w.jpg"];
					break;
			}
		} else {
			switch (indexPath.row) {
				case 0: 
					cellImage = [UIImage imageNamed:@"Kadeish_w_eng.jpg"];
                    break;
				case 1: 
					cellImage = [UIImage imageNamed:@"Urchatz_w_en.jpg"];
					break;
				case 2:
					cellImage = [UIImage imageNamed:@"Karpas_w_en.jpg"];
					break;
				case 3: 
					cellImage = [UIImage imageNamed:@"Yachatz_w_en.jpg"];
					break;
				case 4: 
					cellImage = [UIImage imageNamed:@"Magid_w_en.jpg"];
					break;
				case 5:
					cellImage = [UIImage imageNamed:@"Rohtzah_w_en.jpg"];
					break;
				case 6: 
					cellImage = [UIImage imageNamed:@"Motzi_w_en.jpg"];
					break;
				case 7: 
					cellImage = [UIImage imageNamed:@"Maror_w_en.jpg"];
					break;
				case 8: 
					cellImage = [UIImage imageNamed:@"Koreich_w_en.jpg"];
					break;
				case 9:
					cellImage = [UIImage imageNamed:@"Shulchan Orech_w_en.jpg"];
					break;
				case 10: 
					cellImage = [UIImage imageNamed:@"Tzafun_w_en.jpg"];
					break;
				case 11: 
					cellImage = [UIImage imageNamed:@"Bareich_w_en.jpg"];
					break;
				case 12:
					cellImage = [UIImage imageNamed:@"Hallel_w_en.jpg"];
					break;
				case 13:
                    cellImage = [UIImage imageNamed:@"Nirtzah_w_en.jpg"];			}
            }
	} else {
		if (isHebrew) {
			switch (indexPath.row) {
				case 0: 
					cellImage = [UIImage imageNamed:@"Kadeish.jpg"];
                    break;
				case 1: 
					cellImage = [UIImage imageNamed:@"Urchatz.jpg"];
					break;
				case 2:
					cellImage = [UIImage imageNamed:@"Karpas.jpg"];
					break;
				case 3: 
					cellImage = [UIImage imageNamed:@"Yachatz.jpg"];
					break;
				case 4: 
					cellImage = [UIImage imageNamed:@"Magid.jpg"];
					break;
				case 5:
					cellImage = [UIImage imageNamed:@"Rohtzah.jpg"];
					break;
				case 6: 
					cellImage = [UIImage imageNamed:@"Motzi.jpg"];
					break;
				case 7: 
					cellImage = [UIImage imageNamed:@"Maror.jpg"];
					break;
				case 8: 
					cellImage = [UIImage imageNamed:@"Koreich.jpg"];
					break;
				case 9:
					cellImage = [UIImage imageNamed:@"Shulchan Orech.jpg"];
					break;
				case 10: 
					cellImage = [UIImage imageNamed:@"Tzafun.jpg"];
					break;
				case 11: 
					cellImage = [UIImage imageNamed:@"Bareich.jpg"];
					break;
				case 12:
					cellImage = [UIImage imageNamed:@"Hallel.jpg"];
					break;
				case 13:
					cellImage = [UIImage imageNamed:@"Nirtzah.jpg"];
					break;
			}
		} else {
			switch (indexPath.row) {
				case 0: 
					cellImage = [UIImage imageNamed:@"Kadeish_eng.jpg"];
                    break;
				case 1: 
					cellImage = [UIImage imageNamed:@"Urchatz_en.jpg"];
					break;
				case 2:
					cellImage = [UIImage imageNamed:@"Karpas_en.jpg"];
					break;
				case 3: 
					cellImage = [UIImage imageNamed:@"Yachatz_en.jpg"];
					break;
				case 4: 
					cellImage = [UIImage imageNamed:@"Magid_en.jpg"];
					break;
				case 5:
					cellImage = [UIImage imageNamed:@"Rohtzah_en.jpg"];
					break;
				case 6: 
					cellImage = [UIImage imageNamed:@"Motzi_en.jpg"];
					break;
				case 7: 
					cellImage = [UIImage imageNamed:@"Maror_en.jpg"];
					break;
				case 8: 
					cellImage = [UIImage imageNamed:@"Koreich_en.jpg"];
					break;
				case 9:
					cellImage = [UIImage imageNamed:@"Shulchan Orech_en.jpg"];
					break;
				case 10: 
					cellImage = [UIImage imageNamed:@"Tzafun_en.jpg"];
					break;
				case 11: 
					cellImage = [UIImage imageNamed:@"Bareich_en.jpg"];
					break;
				case 12:
					cellImage = [UIImage imageNamed:@"Hallel_en.jpg"];
					break;
				case 13:
					cellImage = [UIImage imageNamed:@"Nirtzah_en.jpg"];
                break;
			}
		}
	}

    UIImageView *cellImageView = [[UIImageView  alloc] initWithImage:cellImage];
    [cellImageView setFrame:CGRectMake(0, 0, cellWidth, 66)];
    [cellImageView setOpaque:YES];
	[cell setBackgroundView:cellImageView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cellImageView release];				
    return cell;

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/* TODO here we need to set the page number */
	
    NSInteger selectedPage = 0;
    
	if (isHebrew) {
		switch (indexPath.row) {
			case 0: 
				selectedPage = 1;
				break;
			case 1: 
				selectedPage = 3;
				break;
			case 2:
				selectedPage = 4;
				break;
			case 3: 
				selectedPage = 5;
				break;
			case 4: 
				selectedPage = 6;
				break;
			case 5:
                selectedPage = 28;
				break;
			case 6: 
                selectedPage = 29;
				break;
			case 7: 
                selectedPage = 30;
				break;
			case 8: 
                selectedPage = 31;
				break;
			case 9:
				selectedPage = 32;
				break;
			case 10: 
				selectedPage = 33;
				break;
			case 11: 
				selectedPage = 34;
				break;
			case 12:
				selectedPage = 45;
				break;
			case 13:
				selectedPage = 58;
				break;				
		}
		[[NSUserDefaults standardUserDefaults] setInteger:selectedPage forKey:@"currentPageHeb"];	
		[self.imageViewControllerHeb setHidesBottomBarWhenPushed:YES];
		[self.navigationController setNavigationBarHidden:YES animated:NO];		
		[self.navigationController pushViewController:imageViewControllerHeb animated:YES];		
	} else {
			switch (indexPath.row) {
				case 0: 
					selectedPage = 1;
					break;
				case 1: 
					selectedPage = 3;
					break;
			case 2:
				selectedPage = 7;
				break;
			case 3: 
				selectedPage = 8;
				break;
			case 4: 
				selectedPage = 9;
				break;				
			case 5: 
				selectedPage = 54;
				break;
			case 6:
				selectedPage = 55;
				break;
			case 7: 
				selectedPage = 56;
				break;
			case 8: 
				selectedPage = 57;
				break;
			case 9: 
				selectedPage = 58;
				break;
			case 10:
				selectedPage = 59;
				break;
			case 11: 
				selectedPage = 60;
				break;
			case 12: 
				selectedPage = 77;
				break;
			case 13:
				selectedPage = 78;
				break;
		}
		[[NSUserDefaults standardUserDefaults] setInteger:selectedPage forKey:@"currentPage"];		
		[self.imageViewControllerEng setHidesBottomBarWhenPushed:YES];
		[self.navigationController setNavigationBarHidden:YES animated:NO];		
		[self.navigationController pushViewController:imageViewControllerEng animated:YES];		
	}
}

- (void)changeLanguage:(id)sender
{
	UIInterfaceOrientation orientation = /*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation];
	
	if ([sender isSelected]) {
		/* HEBREW */
		[sender setSelected:NO];
		[self.delegate changeLanguage];
		[self.tableView reloadData];
		if (UIInterfaceOrientationIsPortrait(orientation)) {
			[self changeNavBarHebReg];
		} else if (UIInterfaceOrientationIsLandscape(orientation)) {
			[self changeNavBarHebWide];
		}
	}else {
		/* ENGLISH */
		[sender setSelected:YES];		
		[self.delegate changeLanguage];		
		[self.tableView reloadData];
		if (UIInterfaceOrientationIsPortrait(orientation)) {
			[self changeNavBarEngReg];
		} else if (UIInterfaceOrientationIsLandscape(orientation)) {
			[self changeNavBarEngWide];
		}
	}
/*	
	if ([self.navigationItem.rightBarButtonItem ] = UIControlStateNormal) {
		NSLog(@"1");
		[btn setSelected:YES];
	} else {
		NSLog(@"2");
		[btn setSelected:NO];
	}
*/
	
	/*
	if([iHagadaAppDelegate chosenLanguageType] == languageHeb){
		[iHagadaAppDelegate setChosenLanguageType:languageEng];
		btnState = UIControlStateSelected;
		[appDelegate initializeDatabase];
		[self.tableView reloadData];
		[appDelegate changeTabControllerWhenLanguageChanges];
		//[self viewDidLoad];
	}else{
		[iHagadaAppDelegate setChosenLanguageType:languageHeb];
		btnState = UIControlStateNormal;
		[appDelegate initializeDatabase];	
		[self.tableView reloadData];
		[appDelegate changeTabControllerWhenLanguageChanges];		
		//		[self viewDidLoad];
	}
	 */
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.imageViewControllerHeb = nil;
	self.imageViewControllerEng = nil;
	[self.navBarChaptersHebReg removeFromSuperview];
	[self.navBarChaptersHebWide removeFromSuperview];
	[self.navBarChaptersEngReg removeFromSuperview];
	[self.navBarChaptersEngWide removeFromSuperview];	
	self.navBarChaptersHebReg = nil;
	self.navBarChaptersHebWide = nil;
	self.navBarChaptersEngReg = nil;
	self.navBarChaptersEngWide = nil;	
	self.langButton = nil;
    self.tableView = nil;
    self.headerImageView = nil;
}


- (void)dealloc {
	[self.imageViewControllerHeb release];
	[self.imageViewControllerEng release];	
	[self.navBarChaptersHebReg release];
	[self.navBarChaptersHebWide release];
	[self.navBarChaptersEngReg release];
	[self.navBarChaptersEngWide release];
	[self.langButton release];
    [self.tableView release];
    [self.headerImageView release];
    [super dealloc];	
}


@end
