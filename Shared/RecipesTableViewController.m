//
//  RecipesTableViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 3/20/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import "RecipesTableViewController.h"
#import "RecipeViewController.h"

@implementation RecipesTableViewController

@synthesize delegate, imagesNames, navBarRecipesReg, navBarRecipesWide, tableView, headerImageView;


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
    [self.view addSubview:headerView];
    self.headerImageView = headerView;
    [headerView release];

    UITableView *recipesListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    recipesListView.backgroundColor = [UIColor clearColor];
    recipesListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recipesListView.showsVerticalScrollIndicator = NO;
    recipesListView.bounces = NO;
    recipesListView.contentInset = UIEdgeInsetsZero;
    recipesListView.scrollIndicatorInsets = UIEdgeInsetsZero;
    recipesListView.delegate = self;
    recipesListView.dataSource = self;
    if (@available(iOS 15.0, *)) {
        recipesListView.sectionHeaderTopPadding = 0.0f;
    }
    [self.view addSubview:recipesListView];
    self.tableView = recipesListView;
    [recipesListView release];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }

	imagesNames = [[NSArray alloc] initWithObjects:
                   @"BomalosSalty.jpg",
				   @"Bomalos.jpg",
                   @"Batzekaniot.jpg",
				   @"iraqies-harosset.jpg",
                   @"georgie-harosset.jpg",
				   @"Maziut.jpg",
                   @"horseradish.jpg",
                   @"Kneidalach.jpg",
				   @"Latkes.jpg",
                   @"Liver.jpg",
				   @"Krisha.jpg",
                   @"Mangold.jpg",
				   @"lazania.jpg",
                   @"Pizza.jpg",
				   @"Matza-Bri.jpg",
                   @"MatzotWithChicken.jpg",
				   @"AshkenazDefilte.jpg",
                   @"RomanianDefilte.jpg",
				   @"Matzot-Cake.jpg",
                   @"CoconatCake.jpg",
				   @"WalnutCake.jpg",
                   @"Tamar-Cake.jpg",
                   @"Pancake.jpg",
				   @"Brownis.jpg",
                   @"Traffels.jpg",
				   nil];
	
    // set image to navigation bar
	UIImage *navImage = [UIImage imageNamed:@"r1.jpg"];
	navBarRecipesReg = [[UIImageView alloc] initWithImage:navImage];
    
    if( IS_IPHONE_5 )
    {
        navImage = [UIImage imageNamed:@"r1_w_568.jpg"];
        navBarRecipesWide = [[UIImageView alloc] initWithImage:navImage];
    } else {
        navImage = [UIImage imageNamed:@"r1_w.jpg"];
        navBarRecipesWide = [[UIImageView alloc] initWithImage:navImage];
    }

	[navBarRecipesReg setHidden:NO];
	[navBarRecipesWide setHidden:YES];	

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.tableView setRowHeight:66.0f];
    [self applyCurrentHeaderImage];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self applyCurrentHeaderImage];
    [self updateHeaderAndTableLayout];

				if (UIInterfaceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
				[self changeNavBarRecipesReg];
			} else if (UIInterfaceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
				[self changeNavBarRecipesWide];
			}				
	
	/* Reload the cells to avoid the problematic sitatuation when rotating the iphone in another view controller and then going back to this view controller */
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self updateHeaderAndTableLayout];
    [self.tableView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self updateHeaderAndTableLayout];
}
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//[self.tableView reloadData];  This will happen inside the imageViewController through using the delegate, and also change nav bar
//	[imageViewControllerHeb willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//	[imageViewControllerEng willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
	
	[self.tableView reloadData];
	
	if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
		cellWidth = 320;
		[self changeNavBarRecipesReg];
	} else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
		cellWidth = 480;		
		[self changeNavBarRecipesWide];
	}				
}

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
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

    CGFloat tableY = CGRectGetMaxY(self.headerImageView.frame);
    CGFloat tableHeight = viewBounds.size.height - tableY - bottomInset;
    self.tableView.frame = CGRectMake(contentX, tableY, contentWidth, MAX(tableHeight, 0.0f));
}

- (void)applyCurrentHeaderImage {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (UIInterfaceOrientationIsLandscape(orientation)) {
        [self changeNavBarRecipesWide];
    } else {
        [self changeNavBarRecipesReg];
    }
}

- (void)changeNavBarRecipesReg {
    self.headerImageView.image = navBarRecipesReg.image;
	[navBarRecipesReg setHidden:NO];
	[navBarRecipesWide setHidden:YES];
    [self updateHeaderAndTableLayout];
}

- (void)changeNavBarRecipesWide {
    self.headerImageView.image = navBarRecipesWide.image;
	[navBarRecipesReg setHidden:YES];
	[navBarRecipesWide setHidden:NO];
    [self updateHeaderAndTableLayout];
}


/*
-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.recipeViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
*/

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 25;
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

	/*
	if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation][[UIApplication sharedApplication] statusBarOrientation])) {
//		cellWidth = 480;
//	} else if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation][[UIApplication sharedApplication] statusBarOrientation])) {
//		cellWidth = 320;
//	}
//	*/
    
	if (cellWidth == 480) {
        
        switch (indexPath.row) {
                
            case 0: 
                cellImage = [UIImage imageNamed:@"r2_w.jpg"];
                break;
            case 1: 
                cellImage = [UIImage imageNamed:@"r3_w.jpg"];
                break;
            case 2:
                cellImage = [UIImage imageNamed:@"r4_w.jpg"];
                break;
            case 3: 
                cellImage = [UIImage imageNamed:@"r5_w.jpg"];
                break;
            case 4:
                cellImage = [UIImage imageNamed:@"r6_w.jpg"];
                break;
            case 5: 
                cellImage = [UIImage imageNamed:@"r7_w.jpg"];
                break;
            case 6: 
                cellImage = [UIImage imageNamed:@"r8_w.jpg"];
                break;
            case 7: 
                cellImage = [UIImage imageNamed:@"r9_w.jpg"];
                break;
            case 8:
                cellImage = [UIImage imageNamed:@"r10_w.jpg"];
                break;
            case 9: 
                cellImage = [UIImage imageNamed:@"r11_w.jpg"];
                break;
            case 10: 
                cellImage = [UIImage imageNamed:@"r12_w.jpg"];
                break;
            case 11:
                cellImage = [UIImage imageNamed:@"r13_w.jpg"];
                break;
            case 12:
                cellImage = [UIImage imageNamed:@"r14_w.jpg"];
                break;
            case 13: 
                cellImage = [UIImage imageNamed:@"r15_w.jpg"];
                break;
            case 14: 
                cellImage = [UIImage imageNamed:@"r16_w.jpg"];
                break;
            case 15:
                cellImage = [UIImage imageNamed:@"r17_w.jpg"];
                break;
            case 16: 
                cellImage = [UIImage imageNamed:@"r18_w.jpg"];
                break;
            case 17: 
                cellImage = [UIImage imageNamed:@"r19_w.jpg"];
                break;
            case 18:
                cellImage = [UIImage imageNamed:@"r20_w.jpg"];
                break;
            case 19: 
                cellImage = [UIImage imageNamed:@"r21_w.jpg"];
                break;
            case 20: 
                cellImage = [UIImage imageNamed:@"r22_w.jpg"];
                break;
            case 21: 
                cellImage = [UIImage imageNamed:@"r23_w.jpg"];
                break;
            case 22:
                cellImage = [UIImage imageNamed:@"r24_w.jpg"];
                break;
            case 23: 
                cellImage = [UIImage imageNamed:@"r25_w.jpg"];
                break;
            case 24: 
                cellImage = [UIImage imageNamed:@"r26_w.jpg"];
                break;
			case 25: 
                cellImage = [UIImage imageNamed:@"r27_w.jpg"];
                break;				
        }
    }
    
    else {
        
        switch (indexPath.row) {
                
            case 0: 
                cellImage = [UIImage imageNamed:@"r2.jpg"];
                break;
            case 1: 
                cellImage = [UIImage imageNamed:@"r3.jpg"];
                break;
            case 2:
                cellImage = [UIImage imageNamed:@"r4.jpg"];
                break;
            case 3: 
                cellImage = [UIImage imageNamed:@"r5.jpg"];
                break;
            case 4:
                cellImage = [UIImage imageNamed:@"r6.jpg"];
                break;
            case 5: 
                cellImage = [UIImage imageNamed:@"r7.jpg"];
                break;
            case 6: 
                cellImage = [UIImage imageNamed:@"r8.jpg"];
                break;
            case 7: 
                cellImage = [UIImage imageNamed:@"r9.jpg"];
                break;
            case 8:
                cellImage = [UIImage imageNamed:@"r10.jpg"];
                break;
            case 9: 
                cellImage = [UIImage imageNamed:@"r11.jpg"];
                break;
            case 10: 
                cellImage = [UIImage imageNamed:@"r12.jpg"];
                break;
            case 11:
                cellImage = [UIImage imageNamed:@"r13.jpg"];
                break;
            case 12:
                cellImage = [UIImage imageNamed:@"r14.jpg"];
                break;
            case 13: 
                cellImage = [UIImage imageNamed:@"r15.jpg"];
                break;
            case 14: 
                cellImage = [UIImage imageNamed:@"r16.jpg"];
                break;
            case 15:
                cellImage = [UIImage imageNamed:@"r17.jpg"];
                break;
            case 16: 
                cellImage = [UIImage imageNamed:@"r18.jpg"];
                break;
            case 17: 
                cellImage = [UIImage imageNamed:@"r19.jpg"];
                break;
            case 18:
                cellImage = [UIImage imageNamed:@"r20.jpg"];
                break;
            case 19: 
                cellImage = [UIImage imageNamed:@"r21.jpg"];
                break;
            case 20: 
                cellImage = [UIImage imageNamed:@"r22.jpg"];
                break;
            case 21: 
                cellImage = [UIImage imageNamed:@"r23.jpg"];
                break;
            case 22:
                cellImage = [UIImage imageNamed:@"r24.jpg"];
                break;
            case 23: 
                cellImage = [UIImage imageNamed:@"r25.jpg"];
                break;
            case 24: 
                cellImage = [UIImage imageNamed:@"r26.jpg"];
                break;
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
	
	RecipeViewController *recipeViewController = [[RecipeViewController alloc] initWithNibName:@"RecipeViewController" bundle:nil];
	[recipeViewController setImageName:[imagesNames objectAtIndex:indexPath.row]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];	
	[recipeViewController setHidesBottomBarWhenPushed:YES];
	recipeViewController.delegate = self;	
	[self.navigationController pushViewController:recipeViewController animated:YES];
	[recipeViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.imagesNames = nil;
    self.navBarRecipesReg = nil;
    self.navBarRecipesWide = nil;
    self.tableView = nil;
    self.headerImageView = nil;
}


- (void)dealloc {
    [imagesNames release];
    [navBarRecipesReg release];
    [navBarRecipesWide release];
    [tableView release];
    [headerImageView release];
    [super dealloc];
}


@end
