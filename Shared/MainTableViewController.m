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
@synthesize langButton;

//static UIControlState btnState = UIControlStateNormal;

AppDelegate_iPhone *appDelegateIphone;
AppDelegate_iPad *appDelegateIpad;

BOOL isHebrew;
int cellWidth;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	imageViewControllerHeb = [[ImageViewControllerHeb alloc] init];
	self.imageViewControllerHeb.delegate = self;	
	imageViewControllerEng = [[ImageViewController alloc] init];
	self.imageViewControllerEng.delegate = self;	
	
	if (UIDeviceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
		cellWidth = 480;
	} else if (UIDeviceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
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
    
	//	[self.navigationController.view addSubview:navImageView];
	[self.navigationController.navigationBar addSubview:navBarChaptersHebReg];
	[self.navigationController.navigationBar addSubview:navBarChaptersHebWide];
	[self.navigationController.navigationBar addSubview:navBarChaptersEngReg];
	[self.navigationController.navigationBar addSubview:navBarChaptersEngWide];

	if (UIDeviceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
		langButton=[[UIButton alloc] initWithFrame:CGRectMake(443, 7, 30, 30)];	
	} else if (UIDeviceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
		langButton=[[UIButton alloc] initWithFrame:CGRectMake(290, 7, 30, 30)];	
	}
	[langButton setImage:[UIImage imageNamed:@"USAFlag.png"] forState:UIControlStateNormal];
	[langButton setImage:[UIImage imageNamed:@"IsraelFlag.png"] forState:UIControlStateSelected];	
	[langButton addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventTouchUpInside];		
	
	if (isHebrew) {
		[langButton setSelected:NO];
	} else {
		[langButton setSelected:YES];
	}

	/* Adding the button will be in viewWill Appear */
	[navBarChaptersHebReg setHidden:NO];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:YES];	

	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	[self.navigationController.navigationBar addSubview:langButton];
	
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

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	
	[langButton removeFromSuperview];
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
	
	[langButton setFrame:CGRectMake(290, 7, 30, 30)];			
	
	[navBarChaptersHebReg setHidden:NO];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:YES];
}

- (void)changeNavBarHebWide {
	
	[langButton setFrame:CGRectMake(443, 7, 30, 30)];
	
	[navBarChaptersHebReg setHidden:YES];
	[navBarChaptersHebWide setHidden:NO];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:YES];
}

- (void)changeNavBarEngReg {
	
	[langButton setFrame:CGRectMake(290, 7, 30, 30)];			
	
	[navBarChaptersHebReg setHidden:YES];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:NO];
	[navBarChaptersEngWide setHidden:YES];
}

- (void)changeNavBarEngWide {

	[langButton setFrame:CGRectMake(443, 7, 30, 30)];	
	
	[navBarChaptersHebReg setHidden:YES];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:NO];
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
}


- (void)dealloc {
	[self.imageViewControllerHeb release];
	[self.imageViewControllerEng release];	
	[self.navBarChaptersHebReg release];
	[self.navBarChaptersHebWide release];
	[self.navBarChaptersEngReg release];
	[self.navBarChaptersEngWide release];
	[self.langButton release];
    [super dealloc];	
}


@end
