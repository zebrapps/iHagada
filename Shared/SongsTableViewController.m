//
//  SongsTableViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 3/30/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import "SongsTableViewController.h"
#import "SongViewController.h"

@implementation SongsTableViewController

@synthesize /*imagesNames,*/ navBarChaptersHebReg,navBarChaptersHebWide,navBarChaptersEngReg,navBarChaptersEngWide;
@synthesize delegate, imageViewControllerEng, imageViewControllerHeb;

BOOL isHebrew;
int	cellWidth;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	imageViewControllerHeb = [[ImageViewControllerHeb alloc] init];
	self.imageViewControllerHeb.delegate = self;	
	imageViewControllerEng = [[ImageViewController alloc] init];
	self.imageViewControllerEng.delegate = self;	
	
	/*
    imagesNames = [[NSArray alloc] initWithObjects:
                   [NSString stringWithString:@"6.jpg"],
				   [NSString stringWithString:@"7.jpg"],
                   [NSString stringWithString:@"8.jpg"],
				   [NSString stringWithString:@"13.jpg"],
                   [NSString stringWithString:@"21.jpg"],
				   [NSString stringWithString:@"26.jpg"],
                   [NSString stringWithString:@"63.jpg"],
                   [NSString stringWithString:@"67.jpg"],
				   [NSString stringWithString:@"71.jpg"],
				//   [NSString stringWithString:@"Aviv.jpg"]
				   nil];
	*/
	
	// set image to navigation bar
    
    UIImage *navImage = [UIImage imageNamed:@"s0.jpg"];
	navBarChaptersHebReg = [[UIImageView alloc] initWithImage:navImage];
	navImage = [UIImage imageNamed:@"s0_en.jpg"];
	navBarChaptersEngReg = [[UIImageView alloc] initWithImage:navImage];
    
    if( IS_IPHONE_5 )
    {
        navImage = [UIImage imageNamed:@"s0_w_568.jpg"];
        navBarChaptersHebWide = [[UIImageView alloc] initWithImage:navImage];
        navImage = [UIImage imageNamed:@"s0_w_en_568.jpg"];
        navBarChaptersEngWide = [[UIImageView alloc] initWithImage:navImage];
    } else {
        navImage = [UIImage imageNamed:@"s0_w.jpg"];
        navBarChaptersHebWide = [[UIImageView alloc] initWithImage:navImage];
        navImage = [UIImage imageNamed:@"s0_w_en.jpg"];
        navBarChaptersEngWide = [[UIImageView alloc] initWithImage:navImage];
    }
	
	[self.navigationController.navigationBar addSubview:navBarChaptersHebReg];
	[self.navigationController.navigationBar addSubview:navBarChaptersHebWide];
	[self.navigationController.navigationBar addSubview:navBarChaptersEngReg];
	[self.navigationController.navigationBar addSubview:navBarChaptersEngWide];	
	[navBarChaptersHebReg setHidden:NO];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:YES];	
	
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
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
	
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//[self.tableView reloadData];  This will happen inside the imageViewController through using the delegate, and also change nav bar
		[imageViewControllerHeb willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
		[imageViewControllerEng willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	//[self.tableView reloadData];
	
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
	[navBarChaptersHebReg setHidden:NO];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:YES];
}

- (void)changeNavBarHebWide {
	[navBarChaptersHebReg setHidden:YES];
	[navBarChaptersHebWide setHidden:NO];
	[navBarChaptersEngReg setHidden:YES];
	[navBarChaptersEngWide setHidden:YES];
}

- (void)changeNavBarEngReg {
	[navBarChaptersHebReg setHidden:YES];
	[navBarChaptersHebWide setHidden:YES];
	[navBarChaptersEngReg setHidden:NO];
	[navBarChaptersEngWide setHidden:YES];
}

- (void)changeNavBarEngWide {
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
	return 9;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //    [cell setImage:(UIImage*)[imageViewController.allImages objectAtIndex:indexPath.row]];
    //	[cell.textLabel setText:[NSString stringWithFormat:@"pic %d",indexPath.row]];
	
//	int cellWidth;
    UIImage *cellImage = nil;
	
	
//	if (UIDeviceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
//		cellWidth = 480;
//	} else if (UIDeviceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
//		cellWidth = 320;
//	}
	
	
	if (cellWidth == 480) {
		if (isHebrew) {
			switch (indexPath.row) {
				case 0: 
					cellImage = [UIImage imageNamed:@"s1_w.jpg"];
					break;
				case 1: 
					cellImage = [UIImage imageNamed:@"s2_w.jpg"];
					break;
				case 2:
					cellImage = [UIImage imageNamed:@"s3_w.jpg"];
					break;
				case 3: 
					cellImage = [UIImage imageNamed:@"s4_w.jpg"];
					break;
				case 4:
					cellImage = [UIImage imageNamed:@"s5_w.jpg"];
					break;
				case 5: 
					cellImage = [UIImage imageNamed:@"s6_w.jpg"];
					break;
				case 6: 
					cellImage = [UIImage imageNamed:@"s7_w.jpg"];
					break;
				case 7: 
					cellImage = [UIImage imageNamed:@"s8_w.jpg"];
					break;
				case 8:
					cellImage = [UIImage imageNamed:@"s9_w.jpg"];
					break;
			}
		} else {
			switch (indexPath.row) {
				case 0: 
					cellImage = [UIImage imageNamed:@"s1_w_en.jpg"];
					break;
				case 1: 
					cellImage = [UIImage imageNamed:@"s2_w_en.jpg"];
					break;
				case 2:
					cellImage = [UIImage imageNamed:@"s3_w_en.jpg"];
					break;
				case 3: 
					cellImage = [UIImage imageNamed:@"s4_w_en.jpg"];
					break;
				case 4:
					cellImage = [UIImage imageNamed:@"s5_w_en.jpg"];
					break;
				case 5: 
					cellImage = [UIImage imageNamed:@"s6_w_en.jpg"];
					break;
				case 6: 
					cellImage = [UIImage imageNamed:@"s7_w_en.jpg"];
					break;
				case 7: 
					cellImage = [UIImage imageNamed:@"s8_w_en.jpg"];
					break;
				case 8:
					cellImage = [UIImage imageNamed:@"s9_w_en.jpg"];
					break;
			}
		}
	} else {
		if (isHebrew) {
			switch (indexPath.row) {
				case 0: 
					cellImage = [UIImage imageNamed:@"s1.jpg"];
					break;
				case 1: 
					cellImage = [UIImage imageNamed:@"s2.jpg"];
					break;
				case 2:
					cellImage = [UIImage imageNamed:@"s3.jpg"];
					break;
				case 3: 
					cellImage = [UIImage imageNamed:@"s4.jpg"];
					break;
				case 4:
					cellImage = [UIImage imageNamed:@"s5.jpg"];
					break;
				case 5: 
					cellImage = [UIImage imageNamed:@"s6.jpg"];
					break;
				case 6: 
					cellImage = [UIImage imageNamed:@"s7.jpg"];
					break;
				case 7: 
					cellImage = [UIImage imageNamed:@"s8.jpg"];
					break;
				case 8:
					cellImage = [UIImage imageNamed:@"s9.jpg"];
					break;
			}
		} else {
			switch (indexPath.row) {
				case 0: 
					cellImage = [UIImage imageNamed:@"s1_en.jpg"];
					break;
				case 1: 
					cellImage = [UIImage imageNamed:@"s2_en.jpg"];
					break;
				case 2:
					cellImage = [UIImage imageNamed:@"s3_en.jpg"];
					break;
				case 3: 
					cellImage = [UIImage imageNamed:@"s4_en.jpg"];
					break;
				case 4:
					cellImage = [UIImage imageNamed:@"s5_en.jpg"];
					break;
				case 5: 
					cellImage = [UIImage imageNamed:@"s6_en.jpg"];
					break;
				case 6: 
					cellImage = [UIImage imageNamed:@"s7_en.jpg"];
					break;
				case 7: 
					cellImage = [UIImage imageNamed:@"s8_en.jpg"];
					break;
				case 8:
					cellImage = [UIImage imageNamed:@"s9_en.jpg"];
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
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
	
	NSInteger selectedPage = 0;
	
	if (isHebrew) {
		switch (indexPath.row) {
			case 0: 
				selectedPage = 6;
				break;
			case 1: 
				selectedPage = 7;
				break;
			case 2:
				selectedPage = 8;
				break;
			case 3: 
				selectedPage = 13;
				break;
			case 4: 
				selectedPage = 21;
				break;
			case 5:
                selectedPage = 26;
				break;
				/* The song "lo nae velo yahe", wont be in the songs list
			case 6: 
                selectedPage = 63;
				break;
				 */
			case 6: 
                selectedPage = 67;
				break;
			case 7: 
                selectedPage = 71;
				break;
			case 8:	
				/* SongViewController for simcha raba */
				break;
		}
		
		if (indexPath.row == 8) {
			/* SongViewController for simcha raba */			
			SongViewController *songViewController = [[SongViewController alloc] initWithNibName:@"SongViewController" bundle:nil];
			[songViewController setImageName:@"simchaRaba_iphone.jpg"];
			[self.navigationController setNavigationBarHidden:YES animated:NO];
			[songViewController setHidesBottomBarWhenPushed:YES];
			songViewController.delegate = self;
			[self.navigationController pushViewController:songViewController animated:YES];
			[songViewController release];
		} else {
			[[NSUserDefaults standardUserDefaults] setInteger:selectedPage forKey:@"currentPageHeb"];	
			[self.imageViewControllerHeb setHidesBottomBarWhenPushed:YES];
			[self.navigationController setNavigationBarHidden:YES animated:NO];		
			[self.navigationController pushViewController:imageViewControllerHeb animated:YES];					
		}

	} else {
		switch (indexPath.row) {
			case 0: 
				selectedPage = 9;
				break;
			case 1: 
				selectedPage = 10;
				break;
			case 2:
				selectedPage = 12;
				break;
			case 3: 
				selectedPage = 21;
				break;
			case 4: 
				selectedPage = 38;
				break;
			case 5:
				selectedPage = 51;
				break;
			case 6: 
				selectedPage = 92;
				break;
			case 7: 
				selectedPage = 103;
				break;
			case 8:
				/* SongViewController for simcha raba */
				break;
	
		}
		
		if (indexPath.row == 8) {
			/* SongViewController for simcha raba */			
			SongViewController *songViewController = [[SongViewController alloc] initWithNibName:@"SongViewController" bundle:nil];
			[songViewController setImageName:@"simchaRaba_iphone.jpg"];
			[self.navigationController setNavigationBarHidden:YES animated:NO];
			[songViewController setHidesBottomBarWhenPushed:YES];
			songViewController.delegate = self;
			[self.navigationController pushViewController:songViewController animated:YES];
			[songViewController release];
		} else {
			[[NSUserDefaults standardUserDefaults] setInteger:selectedPage forKey:@"currentPage"];		
			[self.imageViewControllerEng setHidesBottomBarWhenPushed:YES];
			[self.navigationController setNavigationBarHidden:YES animated:NO];		
			[self.navigationController pushViewController:imageViewControllerEng animated:YES];					
		}
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    imageViewControllerHeb = nil;
	imageViewControllerEng = nil;
	[navBarChaptersHebReg removeFromSuperview];
	[navBarChaptersHebWide removeFromSuperview];
	[navBarChaptersEngReg removeFromSuperview];
	[navBarChaptersEngWide removeFromSuperview];	
	navBarChaptersHebReg = nil;
	navBarChaptersHebWide = nil;
	navBarChaptersEngReg = nil;
	navBarChaptersEngWide = nil;	
}


- (void)dealloc {
	[imageViewControllerHeb release];
	[imageViewControllerEng release];	
	[navBarChaptersHebReg release];
	[navBarChaptersHebWide release];
	[navBarChaptersEngReg release];
	[navBarChaptersEngWide release];
    [super dealloc];	
}

@end

