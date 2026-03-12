//
//  FourSonsViewController.m
//  swipetest
//
//  Created by Yuval Tessone on 4/6/11.
//  Copyright 2011 www.zebrapps.com. All rights reserved.
//

#import "FourSonsViewController.h"
#import "ImagePickerViewController.h"
#import "FBFunViewController.h"
#import "OverlayChooseImage.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation FourSonsViewController

@synthesize delegate;
@synthesize photoView1,photoView2,photoView3,photoView4,photoNumber;
@synthesize photoViewLandscape1,photoViewLandscape2,photoViewLandscape3,photoViewLandscape4;
@synthesize basePhotoView1,basePhotoView2,basePhotoView3,basePhotoView4;
@synthesize basePhotoViewLandscape1,basePhotoViewLandscape2,basePhotoViewLandscape3,basePhotoViewLandscape4;
@synthesize landscapeScrollView;
@synthesize finalImage;
@synthesize finalImagePortrait,finalImageLandscape;
@synthesize imagePickerViewController;
@synthesize fourSonsChooseThemeViewController;
@synthesize chosenTheme;
@synthesize chachamFileName,rashaFileName,tamFileName,sheinoFileName;
@synthesize isEverBeenChosenTheme;
@synthesize landscapeButtons;
@synthesize landscapeIphoneBackground;
@synthesize activitiyIndicator;

int cellWidth; // Global parameter for all the other table view controllers;
OverlayChooseImage *ovController; 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // NSLog(@"FourSonsViewController initWithNibName");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    // NSLog(@"FourSonsViewController dealloc");    
    [landscapeScrollView release];
    [basePhotoViewLandscape1 release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
   //  NSLog(@"FourSonsViewController didReceiveMemoryWarning");    
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
        [self.landscapeScrollView setContentSize:CGSizeMake(1987, 719)];
        [self.landscapeScrollView scrollRectToVisible:CGRectMake(963, 0, 1024, 719) animated:NO];
    } else {
        [self.landscapeScrollView setContentSize:CGSizeMake(754, 271)];
        [self.landscapeScrollView scrollRectToVisible:CGRectMake(328, 0, 480, 271) animated:NO];
    }
    #endif
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file

    NSString* fullPathToFile1 = [documentsDirectory stringByAppendingPathComponent:@"photo1.png"];    
    UIImage *photoTemp1 = [UIImage imageWithContentsOfFile:fullPathToFile1];
    NSString* fullPathToFile2 = [documentsDirectory stringByAppendingPathComponent:@"photo2.png"];        
    UIImage *photoTemp2 = [UIImage imageWithContentsOfFile:fullPathToFile2];
    NSString* fullPathToFile3 = [documentsDirectory stringByAppendingPathComponent:@"photo3.png"];        
    UIImage *photoTemp3 = [UIImage imageWithContentsOfFile:fullPathToFile3];
    NSString* fullPathToFile4 = [documentsDirectory stringByAppendingPathComponent:@"photo4.png"];        
    UIImage *photoTemp4 = [UIImage imageWithContentsOfFile:fullPathToFile4];

    
    NSString *iphoneOrIpad;
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        iphoneOrIpad = @"_iPad.png";
    } else {
        iphoneOrIpad = @"_iPhone.png";
    }
    #endif
    
    
    // Now we get the full path to the file
    NSString* fullPathToFileChosenTheme = [documentsDirectory stringByAppendingPathComponent:@"chosenTheme"];
    
    NSString *chosenThemeString = [NSString stringWithContentsOfFile:fullPathToFileChosenTheme encoding:NSASCIIStringEncoding error:nil];
    

    if (!chosenThemeString) {
        
        isEverBeenChosenTheme = NO;        
        // Default, although not suppose to be shown ever.
        chachamFileName = [[NSString alloc] initWithFormat:@"monkeys_chacham%@",iphoneOrIpad];
        rashaFileName = [[NSString alloc] initWithFormat:@"monkeys_rasha%@",iphoneOrIpad];
        tamFileName = [[NSString alloc] initWithFormat:@"monkeys_tam%@",iphoneOrIpad];
        sheinoFileName = [[NSString alloc] initWithFormat:@"monkeys_sheino%@",iphoneOrIpad];
    } else {
        isEverBeenChosenTheme = YES;                
        chosenTheme = [chosenThemeString intValue];
        switch (chosenTheme) {
            case 0:
                chachamFileName = [[NSString alloc] initWithFormat:@"monkeys_chacham%@",iphoneOrIpad];
                rashaFileName = [[NSString alloc] initWithFormat:@"monkeys_rasha%@",iphoneOrIpad];
                tamFileName = [[NSString alloc] initWithFormat:@"monkeys_tam%@",iphoneOrIpad];
                sheinoFileName = [[NSString alloc] initWithFormat:@"monkeys_sheino%@",iphoneOrIpad];
                break;
            case 1:
                chachamFileName = [[NSString alloc] initWithFormat:@"dogs_chacham%@",iphoneOrIpad];
                rashaFileName = [[NSString alloc] initWithFormat:@"dogs_rasha%@",iphoneOrIpad];
                tamFileName = [[NSString alloc] initWithFormat:@"dogs_tam%@",iphoneOrIpad];
                sheinoFileName = [[NSString alloc] initWithFormat:@"dogs_sheino%@",iphoneOrIpad];                
                break;
            case 2:
                chachamFileName = [[NSString alloc] initWithFormat:@"rushmore_chacham%@",iphoneOrIpad];
                rashaFileName = [[NSString alloc] initWithFormat:@"rushmore_rasha%@",iphoneOrIpad];
                tamFileName = [[NSString alloc] initWithFormat:@"rushmore_tam%@",iphoneOrIpad];
                sheinoFileName = [[NSString alloc] initWithFormat:@"rushmore_sheino%@",iphoneOrIpad];
                break;
            default:
                break;
        }
    }
    
    [basePhotoView1 setImage:[UIImage imageNamed:chachamFileName]];
    [basePhotoView2 setImage:[UIImage imageNamed:rashaFileName]];
    [basePhotoView3 setImage:[UIImage imageNamed:tamFileName]];
    [basePhotoView4 setImage:[UIImage imageNamed:sheinoFileName]];
    [basePhotoViewLandscape1 setImage:[UIImage imageNamed:chachamFileName]];
    [basePhotoViewLandscape2 setImage:[UIImage imageNamed:rashaFileName]];
    [basePhotoViewLandscape3 setImage:[UIImage imageNamed:tamFileName]];
    [basePhotoViewLandscape4 setImage:[UIImage imageNamed:sheinoFileName]];
    
    if (photoTemp1 != nil) {
         [photoView1 setImage:photoTemp1];   
         [photoViewLandscape1 setImage:photoTemp1];
    } else { 
//         [photoView1 setImage:[UIImage imageNamed:chachamFileName]];
        
    }
    
    if (photoTemp2 != nil) {
        [photoView2 setImage:photoTemp2];   
        [photoViewLandscape2 setImage:photoTemp2];        
    } else { 
//        [photoView2 setImage:[UIImage imageNamed:rashaFileName]];
    }
    
    if (photoTemp3 != nil) {
        [photoView3 setImage:photoTemp3];  
        [photoViewLandscape3 setImage:photoTemp3];                
    } else { 
//        [photoView3 setImage:[UIImage imageNamed:tamFileName]];
    }
    
    if (photoTemp4 != nil) {
        [photoView4 setImage:photoTemp4];   
        [photoViewLandscape4 setImage:photoTemp4];                
    } else { 
//        [photoView4 setImage:[UIImage imageNamed:sheinoFileName]];
    }
    
    finalImage = [[UIImage alloc] init];
    
    if (!fourSonsChooseThemeViewController) {
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            fourSonsChooseThemeViewController = [[FourSonsChooseThemeViewController alloc] initWithNibName:@"FourSonsChooseThemeViewControllerHD" bundle:nil];
        } else {
            fourSonsChooseThemeViewController = [[FourSonsChooseThemeViewController alloc] initWithNibName:@"FourSonsChooseThemeViewController" bundle:nil];
        }
        #endif

    }
    
    fourSonsChooseThemeViewController.delegate = self;

    if (!isEverBeenChosenTheme) {
        [self.navigationController pushViewController:fourSonsChooseThemeViewController animated:NO];   
    } 
    
    if (UIDeviceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        return;
    }
    
    // Show the tutorial on an overlay, only on first use.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *isFirstImageLoad = [defaults objectForKey:@"isFirstImageLoad"];
    
    if (isFirstImageLoad == nil) {
        
        [defaults setObject:@"NO" forKey:@"isFirstImageLoad"];
        
        CGFloat yaxis; 
        CGFloat width;
        CGFloat height; 
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //Add the overlay view.
            if(ovController == nil) {
                ovController = [[OverlayChooseImage alloc] initWithNibName:@"OverlayChooseImage_iPad" bundle:[NSBundle mainBundle]];
            }
            
            yaxis = 425; 
            width = 768; 
            height = 60;                     
        } else {
            //Add the overlay view.
            if(ovController == nil) {
                ovController = [[OverlayChooseImage alloc] initWithNibName:@"OverlayChooseImage" bundle:[NSBundle mainBundle]];
            }
            
            yaxis = 175;
            width = 320; 
            height = 60; 
        }
#endif
        
        //Parameters x = origion on x-axis, y = origon on y-axis.
        CGRect frame = CGRectMake(0, yaxis, width, height);
        ovController.view.frame = frame;
        ovController.view.backgroundColor = [UIColor grayColor];
        ovController.view.alpha = 0.4;
        
        [self.view insertSubview:ovController.view aboveSubview:self.parentViewController.view];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    }

	if (UIDeviceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        [self rotatePortrait];
	} else if (UIDeviceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
        [self rotateLandscape];
	}
}

// Remove the overlay for the tutorial after the user choose an image
- (void) removeOverlayView {
    
    [ovController.view removeFromSuperview];
    [ovController release];
    ovController = nil;    
}

- (IBAction)clearFaces {
        
    [[self photoView1] setImage:nil];
    [[self photoView2] setImage:nil];
    [[self photoView3] setImage:nil];
    [[self photoView4] setImage:nil];
    [[self photoViewLandscape1] setImage:nil];
    [[self photoViewLandscape2] setImage:nil];
    [[self photoViewLandscape3] setImage:nil];
    [[self photoViewLandscape4] setImage:nil];    
    NSString *imageName1 = @"photo1.png";
    NSString *imageName2 = @"photo2.png";
    NSString *imageName3 = @"photo3.png";
    NSString *imageName4 = @"photo4.png";
    NSString *transform1 = @"transform1";
    NSString *transform2 = @"transform2";
    NSString *transform3 = @"transform3";
    NSString *transform4 = @"transform4";    
    
    // Now, we have to find the documents directory so we can save it
    // Note that you might want to save it elsewhere, like the cache directory,
    // or something similar.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    NSString* fullPathToFile1 = [documentsDirectory stringByAppendingPathComponent:imageName1];
    NSString* fullPathToFile2 = [documentsDirectory stringByAppendingPathComponent:imageName2];
    NSString* fullPathToFile3 = [documentsDirectory stringByAppendingPathComponent:imageName3];
    NSString* fullPathToFile4 = [documentsDirectory stringByAppendingPathComponent:imageName4];    
    
    // and then we write it out
    [[NSData data] writeToFile:fullPathToFile1 atomically:NO];
    [[NSData data] writeToFile:fullPathToFile2 atomically:NO];
    [[NSData data] writeToFile:fullPathToFile3 atomically:NO];
    [[NSData data] writeToFile:fullPathToFile4 atomically:NO];
    
    NSString *fullPathToFileTransform1 = [documentsDirectory stringByAppendingPathComponent:transform1];
    NSString *fullPathToFileTransform2 = [documentsDirectory stringByAppendingPathComponent:transform2];
    NSString *fullPathToFileTransform3 = [documentsDirectory stringByAppendingPathComponent:transform3];
    NSString *fullPathToFileTransform4 = [documentsDirectory stringByAppendingPathComponent:transform4];
    
    [[NSMutableDictionary dictionary] writeToFile:fullPathToFileTransform1 atomically:YES];
    [[NSMutableDictionary dictionary] writeToFile:fullPathToFileTransform2 atomically:YES];
    [[NSMutableDictionary dictionary] writeToFile:fullPathToFileTransform3 atomically:YES];
    [[NSMutableDictionary dictionary] writeToFile:fullPathToFileTransform4 atomically:YES];
}

- (IBAction)chooseTheme {
//    [self presentModalViewController:fourSonsChooseThemeViewController animated:YES];

    [self.activitiyIndicator startAnimating];
    
    // NSLog(@"enable = YES");
    [fourSonsChooseThemeViewController.cancelButtonPortrait setEnabled:YES];
    [fourSonsChooseThemeViewController.cancelButtonLandscape setEnabled:YES];    
    
    [self.navigationController pushViewController:fourSonsChooseThemeViewController animated:NO];    
}

- (void)changeTheme:(int)changedThemeNum {
    chosenTheme = changedThemeNum;
    
    // Now, we have to find the documents directory so we can save it
    // Note that you might want to save it elsewhere, like the cache directory,
    // or something similar.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];    
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"chosenTheme"];

    [[[NSNumber numberWithInt:chosenTheme] stringValue] writeToFile:fullPathToFile atomically:YES encoding:NSASCIIStringEncoding error:nil];
    
    NSString *iphoneOrIpad;
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        iphoneOrIpad = @"_iPad.png";
    } else {
        iphoneOrIpad = @"_iPhone.png";
    }
    #endif
    
    switch (chosenTheme) {
        case 0:
            chachamFileName = [[NSString alloc] initWithFormat:@"monkeys_chacham%@",iphoneOrIpad];
            rashaFileName = [[NSString alloc] initWithFormat:@"monkeys_rasha%@",iphoneOrIpad];
            tamFileName = [[NSString alloc] initWithFormat:@"monkeys_tam%@",iphoneOrIpad];
            sheinoFileName = [[NSString alloc] initWithFormat:@"monkeys_sheino%@",iphoneOrIpad];
            break;
        case 1:            
            chachamFileName = [[NSString alloc] initWithFormat:@"dogs_chacham%@",iphoneOrIpad];
            rashaFileName = [[NSString alloc] initWithFormat:@"dogs_rasha%@",iphoneOrIpad];
            tamFileName = [[NSString alloc] initWithFormat:@"dogs_tam%@",iphoneOrIpad];
            sheinoFileName = [[NSString alloc] initWithFormat:@"dogs_sheino%@",iphoneOrIpad];
            break;
        case 2:
            chachamFileName = [[NSString alloc] initWithFormat:@"rushmore_chacham%@",iphoneOrIpad];
            rashaFileName = [[NSString alloc] initWithFormat:@"rushmore_rasha%@",iphoneOrIpad];
            tamFileName = [[NSString alloc] initWithFormat:@"rushmore_tam%@",iphoneOrIpad];
            sheinoFileName = [[NSString alloc] initWithFormat:@"rushmore_sheino%@",iphoneOrIpad];
            break;
        default:
            break;
    }
    
    [basePhotoView1 setImage:[UIImage imageNamed:chachamFileName]];
    [basePhotoView2 setImage:[UIImage imageNamed:rashaFileName]];
    [basePhotoView3 setImage:[UIImage imageNamed:tamFileName]];
    [basePhotoView4 setImage:[UIImage imageNamed:sheinoFileName]];
    [basePhotoViewLandscape1 setImage:[UIImage imageNamed:chachamFileName]];
    [basePhotoViewLandscape2 setImage:[UIImage imageNamed:rashaFileName]];
    [basePhotoViewLandscape3 setImage:[UIImage imageNamed:tamFileName]];
    [basePhotoViewLandscape4 setImage:[UIImage imageNamed:sheinoFileName]];    
}

- (void)setCurrentImageInImagePicker {
    // Init the transform of the photoView
    switch (photoNumber) {
        case 1:
            [imagePickerViewController.topImage setImage:[UIImage imageNamed:chachamFileName]];
            break;
        case 2:
            [imagePickerViewController.topImage setImage:[UIImage imageNamed:rashaFileName]];            
            break;
        case 3:
            [imagePickerViewController.topImage setImage:[UIImage imageNamed:tamFileName]];            
            break;
        case 4:
            [imagePickerViewController.topImage setImage:[UIImage imageNamed:sheinoFileName]];            
            break;
        default:
            break;
    }
}

- (IBAction)choosePhoto:(id)sender {
    
    [self removeOverlayView];

    if (!imagePickerViewController) {
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         imagePickerViewController = [[ImagePickerViewController alloc] initWithNibName:@"ImagePickerViewControllerHD" bundle:nil];        
        } else {
         imagePickerViewController = [[ImagePickerViewController alloc] initWithNibName:@"ImagePickerViewController" bundle:nil];        
        }
    #endif
    }

    photoNumber = (int)[sender tag];

    imagePickerViewController.delegate = self;
    
    /*
        imagePickerViewController.selectedPickerImage.image = nil;
    [imagePickerViewController.selectedPickerImage setTransform:CGAffineTransformIdentity];    
     */
    
    
    // Getting the original image    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    
    UIImage *originalPhoto = [[UIImage alloc] init];
    CGAffineTransform photoTransform = CGAffineTransformIdentity;
    
    NSMutableDictionary *photoTransformDict;
    
    switch (photoNumber) {
        case 1: {
            NSString* fullPathToFile1 = [documentsDirectory stringByAppendingPathComponent:@"originalPhoto1.png"];    
            originalPhoto = [UIImage imageWithContentsOfFile:fullPathToFile1];            
            NSString *fullPathToFileTransform = [documentsDirectory stringByAppendingPathComponent:@"transform1"];
            photoTransformDict = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPathToFileTransform];
            break;           
        }   
        case 2: {
            NSString* fullPathToFile2 = [documentsDirectory stringByAppendingPathComponent:@"originalPhoto2.png"];    
            originalPhoto = [UIImage imageWithContentsOfFile:fullPathToFile2];            
            NSString *fullPathToFileTransform = [documentsDirectory stringByAppendingPathComponent:@"transform2"];
            photoTransformDict = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPathToFileTransform];

            break;            
        }
        case 3: {
            NSString* fullPathToFile3 = [documentsDirectory stringByAppendingPathComponent:@"originalPhoto3.png"];    
            originalPhoto = [UIImage imageWithContentsOfFile:fullPathToFile3];            
            NSString *fullPathToFileTransform = [documentsDirectory stringByAppendingPathComponent:@"transform3"];
            photoTransformDict = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPathToFileTransform];
            break;            
        }case 4: {
            NSString* fullPathToFile4 = [documentsDirectory stringByAppendingPathComponent:@"originalPhoto4.png"];    
            originalPhoto = [UIImage imageWithContentsOfFile:fullPathToFile4];            
            NSString *fullPathToFileTransform = [documentsDirectory stringByAppendingPathComponent:@"transform4"];
            photoTransformDict = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPathToFileTransform];

            break;            
        }            
        default:
            break;
    }

    photoTransform = CGAffineTransformMake([[photoTransformDict objectForKey:@"a"] floatValue],
                                           [[photoTransformDict objectForKey:@"b"] floatValue],
                                           [[photoTransformDict objectForKey:@"c"] floatValue],
                                           [[photoTransformDict objectForKey:@"d"] floatValue],
                                           [[photoTransformDict objectForKey:@"tx"] floatValue],
                                           [[photoTransformDict objectForKey:@"ty"] floatValue]);

    BOOL isFlipped = [[photoTransformDict objectForKey:@"isFlipped"] boolValue];
    
    if ([imagePickerViewController respondsToSelector:@selector(setModalPresentationStyle:)]) {
        imagePickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }

    [self presentModalViewController:imagePickerViewController animated:YES];
  
    imagePickerViewController.selectedPickerImage.image = originalPhoto;  
    imagePickerViewController.selectedPickerImage.transform = photoTransform;
    imagePickerViewController.isFlipped = isFlipped;
//    [imagePickerViewController.selectedPickerImage setTransform:CGAffineTransformIdentity];        
    
    // Init the transform of the photoView
    /*
    if (UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {

        
        switch (photoNumber) {
            case 1:
                [self.photoView1 setTransform:CGAffineTransformIdentity];
                [imagePickerViewController.topImage setImage:[UIImage imageNamed:chachamFileName]];
                [imagePickerViewController setSmallPictureDelegate:self.photoView1];
                break;
            case 2:
                [self.photoView2 setTransform:CGAffineTransformIdentity];                
                [imagePickerViewController.topImage setImage:[UIImage imageNamed:rashaFileName]];            
                [imagePickerViewController setSmallPictureDelegate:self.photoView2];            
                break;
            case 3:
                [self.photoView3 setTransform:CGAffineTransformIdentity];                
                [imagePickerViewController.topImage setImage:[UIImage imageNamed:tamFileName]];            
                [imagePickerViewController setSmallPictureDelegate:self.photoView3];            
                break;
            case 4:
                [self.photoView4 setTransform:CGAffineTransformIdentity];                
                [imagePickerViewController.topImage setImage:[UIImage imageNamed:sheinoFileName]];            
                [imagePickerViewController setSmallPictureDelegate:self.photoView4];            
                break;
            default:
                break;
        }
        
	} else if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {

        switch (photoNumber) {
            case 1:
                [self.photoViewLandscape1 setTransform:CGAffineTransformIdentity];
                [imagePickerViewController.topImage setImage:[UIImage imageNamed:chachamFileName]];
                [imagePickerViewController setSmallPictureDelegate:self.photoViewLandscape1];
                break;
            case 2:
                [self.photoViewLandscape2 setTransform:CGAffineTransformIdentity];                
                [imagePickerViewController.topImage setImage:[UIImage imageNamed:rashaFileName]];            
                [imagePickerViewController setSmallPictureDelegate:self.photoViewLandscape2];            
                break;
            case 3:
                [self.photoViewLandscape3 setTransform:CGAffineTransformIdentity];                
                [imagePickerViewController.topImage setImage:[UIImage imageNamed:tamFileName]];            
                [imagePickerViewController setSmallPictureDelegate:self.photoViewLandscape3];            
                break;
            case 4:
                [self.photoViewLandscape4 setTransform:CGAffineTransformIdentity];                
                [imagePickerViewController.topImage setImage:[UIImage imageNamed:sheinoFileName]];            
                [imagePickerViewController setSmallPictureDelegate:self.photoViewLandscape4];            
                break;
            default:
                break;
        }
	}
     */
    
    switch (photoNumber) {
        case 1:
            [self.photoView1 setTransform:CGAffineTransformIdentity];
            [self.photoViewLandscape1 setTransform:CGAffineTransformIdentity];            
            [imagePickerViewController.topImage setImage:[UIImage imageNamed:chachamFileName]];
            [imagePickerViewController setSmallPictureDelegatePortrait:self.photoView1];
            [imagePickerViewController setSmallPictureDelegateLandscape:self.photoViewLandscape1];
            break;
        case 2:
            [self.photoView2 setTransform:CGAffineTransformIdentity];                
            [self.photoViewLandscape2 setTransform:CGAffineTransformIdentity];                            
            [imagePickerViewController.topImage setImage:[UIImage imageNamed:rashaFileName]];            
            [imagePickerViewController setSmallPictureDelegatePortrait:self.photoView2];            
            [imagePickerViewController setSmallPictureDelegateLandscape:self.photoViewLandscape2];
            break;
        case 3:
            [self.photoView3 setTransform:CGAffineTransformIdentity];                
            [self.photoViewLandscape3 setTransform:CGAffineTransformIdentity];                            
            [imagePickerViewController.topImage setImage:[UIImage imageNamed:tamFileName]];            
            [imagePickerViewController setSmallPictureDelegatePortrait:self.photoView3];            
            [imagePickerViewController setSmallPictureDelegateLandscape:self.photoViewLandscape3];            
            break;
        case 4:
            [self.photoView4 setTransform:CGAffineTransformIdentity];                
            [self.photoViewLandscape4 setTransform:CGAffineTransformIdentity];                            
            [imagePickerViewController.topImage setImage:[UIImage imageNamed:sheinoFileName]];            
            [imagePickerViewController setSmallPictureDelegatePortrait:self.photoView4];          
            [imagePickerViewController setSmallPictureDelegateLandscape:self.photoViewLandscape4];            
            break;
        default:
            break;
    }
    
/*    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    
    NSString* fullPathToFile1 = [documentsDirectory stringByAppendingPathComponent:@"photo1.png"];    
    UIImage *photoTemp1 = [UIImage imageWithContentsOfFile:fullPathToFile1];
*/    

    
//    [imagePickerViewController.selectedPickerImage setImage:photoTemp1];
    
}

- (void)flipsideViewControllerDidFinish;
{
    [self dismissModalViewControllerAnimated:NO];
}

-(IBAction)saveFinalPictureToLibrary {
    [self.activitiyIndicator performSelectorInBackground:@selector(startAnimating) withObject:nil];
    
    [self prepareFinalPicture];
    
    UIImageWriteToSavedPhotosAlbum(finalImage, self, @selector(image:didFinishSavingWithError:contextInfo:), self);
     
}
             
- (void)selectFacebook {
    [self prepareFinalPicturePortrait];
    [self prepareFinalPictureLandscape];    
    [self postOnFacebook];    
}

- (UIImage *)currentFinalImageForSharing {
    if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return self.finalImageLandscape;
    }

    return self.finalImagePortrait;
}

- (void)postOnFacebook {
    UIImage *imageToShare = [self currentFinalImageForSharing];

    if (!imageToShare) {
        return;
    }

    NSArray *activityItems = [NSArray arrayWithObject:imageToShare];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];

    if (@available(iOS 8.0, *)) {
        activityViewController.popoverPresentationController.sourceView = self.view;
        activityViewController.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1.0f, 1.0f);
        activityViewController.popoverPresentationController.permittedArrowDirections = 0;
    }

    [self presentViewController:activityViewController animated:YES completion:nil];
    [activityViewController release];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    [self.activitiyIndicator stopAnimating];
    
    NSString *str = @"חג שמח!";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"התמונה נשמרה באלבום" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alert show];
     
}

-(IBAction)showActionSheet:(id)sender {
    
    NSString *shareAlertTitle = @"שתף תמונה";
    NSString *shareAlertCancel = @"ביטול";
    NSString *shareAlertMail = @"מייל";
    NSString *shareAlertFacebook = @"שיתוף";
    
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:shareAlertTitle 
                                                      delegate:self 
                                             cancelButtonTitle:shareAlertCancel 
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:
                           shareAlertMail ,
                           shareAlertFacebook ,
                           nil]; 
	menu.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [menu showInView:self.view];
    } else {
        [menu showFromTabBar:self.tabBarController.tabBar];
    }
#endif
    
	[menu release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self sendFinalPicture];
	} else if (buttonIndex == 1) {
        [self selectFacebook];
	} /*else if (buttonIndex == 2) { //Facebook Share
        NSLog(@"Cancel Button Clicked");
	}*/
}

- (IBAction)sendFinalPicture {
    
    [self.activitiyIndicator performSelectorInBackground:@selector(startAnimating) withObject:nil];
    
    [self prepareFinalPicture];
    [self displayComposerSheet];
}

- (void)prepareFinalPicture {
    
    if (UIDeviceOrientationIsPortrait(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {

//        UIGraphicsBeginImageContext(CGSizeMake(photoView1.frame.size.width + photoView2.frame.size.width + 10, photoView1.frame.size.height + photoView3.frame.size.height + 39));        
        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            [[UIImage imageNamed:@"newFrame_iPad.png"] drawInRect:CGRectMake(0, 0, 768, 975)];
//            UIGraphicsBeginImageContext(self.view.frame.size);            
            UIGraphicsBeginImageContext(CGSizeMake(768, 908));             
            [[UIImage imageNamed:@"longFrameSharePortrait.jpg"] drawInRect:CGRectMake(0, 0, 768, 908)];
            [[photoView1 image] drawInRect:CGRectMake(photoView1.frame.origin.x, photoView1.frame.origin.y, photoView1.frame.size.width, photoView1.frame.size.height)];
            [[UIImage imageNamed:chachamFileName] drawInRect:CGRectMake(photoView1.frame.origin.x, photoView1.frame.origin.y, photoView1.frame.size.width, photoView1.frame.size.height)];    
            [[photoView2 image] drawInRect:CGRectMake(photoView2.frame.origin.x, photoView2.frame.origin.y, photoView2.frame.size.width, photoView2.frame.size.height)];
            [[UIImage imageNamed:rashaFileName] drawInRect:CGRectMake(photoView2.frame.origin.x, photoView2.frame.origin.y, photoView2.frame.size.width, photoView2.frame.size.height)];        
            [[photoView3 image] drawInRect:CGRectMake(photoView3.frame.origin.x, photoView3.frame.origin.y, photoView3.frame.size.width, photoView3.frame.size.height)];
            [[UIImage imageNamed:tamFileName] drawInRect:CGRectMake(photoView3.frame.origin.x, photoView3.frame.origin.y, photoView3.frame.size.width, photoView3.frame.size.height)];        
            [[photoView4 image] drawInRect:CGRectMake(photoView4.frame.origin.x, photoView4.frame.origin.y, photoView4.frame.size.width, photoView4.frame.size.height)];    
            [[UIImage imageNamed:sheinoFileName] drawInRect:CGRectMake(photoView4.frame.origin.x, photoView4.frame.origin.y, photoView4.frame.size.width, photoView4.frame.size.height)];               
        } else {
            // This image width is frameleft(27) + firstimage(157) + spacebetween(2) + secondeimage(157) + frameright(27)
            // This image height is frametop(16.5) + firstimage(200) + spacebetween(2) + secondeimage(200) + framebottem(18)
            UIGraphicsBeginImageContext(CGSizeMake(369, 436));            
            [[UIImage imageNamed:@"FrameSharePortraitIphone.png"] drawInRect:CGRectMake(0, 0, 369, 436)];
            [[photoView1 image] drawInRect:CGRectMake(27 + 157 + 2, 16.5, photoView1.frame.size.width, photoView1.frame.size.height)];
            [[UIImage imageNamed:chachamFileName] drawInRect:CGRectMake(27 + 157 + 2, 16.5, photoView1.frame.size.width, photoView1.frame.size.height)];    
            [[photoView2 image] drawInRect:CGRectMake(27, 16.5, photoView2.frame.size.width, photoView2.frame.size.height)];
            [[UIImage imageNamed:rashaFileName] drawInRect:CGRectMake(27, 16.5, photoView2.frame.size.width, photoView2.frame.size.height)];        
            [[photoView3 image] drawInRect:CGRectMake(27 + 157 + 2, 16.5 + 200 + 2, photoView3.frame.size.width, photoView3.frame.size.height)];
            [[UIImage imageNamed:tamFileName] drawInRect:CGRectMake(27 + 157 + 2, 16.5 + 200 + 2, photoView3.frame.size.width, photoView3.frame.size.height)];        
            [[photoView4 image] drawInRect:CGRectMake(27,  16.5 + 200 + 2, photoView4.frame.size.width, photoView4.frame.size.height)];    
            [[UIImage imageNamed:sheinoFileName] drawInRect:CGRectMake(27,  16.5 + 200 + 2, photoView4.frame.size.width, photoView4.frame.size.height)];               
        }
        #endif

            
        
        finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    } else if (UIDeviceOrientationIsLandscape(/*[[UIDevice currentDevice] orientation]*/[[UIApplication sharedApplication] statusBarOrientation])) {
    
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
//            UIGraphicsBeginImageContext(self.landscapeScrollView.contentSize);
        UIGraphicsBeginImageContext(CGSizeMake(1987, 660));                
            [[UIImage imageNamed:@"longFrameShareLandscape.jpg"] drawInRect:CGRectMake(0, 0, 1987, 660)];
            [[photoViewLandscape1 image] drawInRect:CGRectMake(photoViewLandscape1.frame.origin.x, photoViewLandscape1.frame.origin.y, photoViewLandscape1.frame.size.width, photoViewLandscape1.frame.size.height)];
            [[UIImage imageNamed:chachamFileName] drawInRect:CGRectMake(photoViewLandscape1.frame.origin.x, photoViewLandscape1.frame.origin.y, photoViewLandscape1.frame.size.width, photoViewLandscape1.frame.size.height)];    
            [[photoViewLandscape2 image] drawInRect:CGRectMake(photoViewLandscape2.frame.origin.x, photoViewLandscape2.frame.origin.y, photoViewLandscape2.frame.size.width, photoViewLandscape2.frame.size.height)];
            [[UIImage imageNamed:rashaFileName] drawInRect:CGRectMake(photoViewLandscape2.frame.origin.x, photoViewLandscape2.frame.origin.y, photoViewLandscape2.frame.size.width, photoViewLandscape2.frame.size.height)];        
            [[photoViewLandscape3 image] drawInRect:CGRectMake(photoViewLandscape3.frame.origin.x, photoViewLandscape3.frame.origin.y, photoViewLandscape3.frame.size.width, photoViewLandscape3.frame.size.height)];
            [[UIImage imageNamed:tamFileName] drawInRect:CGRectMake(photoViewLandscape3.frame.origin.x, photoViewLandscape3.frame.origin.y, photoViewLandscape3.frame.size.width, photoViewLandscape3.frame.size.height)];        
            [[photoViewLandscape4 image] drawInRect:CGRectMake(photoViewLandscape4.frame.origin.x, photoViewLandscape4.frame.origin.y, photoViewLandscape4.frame.size.width, photoViewLandscape4.frame.size.height)];    
            [[UIImage imageNamed:sheinoFileName] drawInRect:CGRectMake(photoViewLandscape4.frame.origin.x, photoViewLandscape4.frame.origin.y, photoViewLandscape4.frame.size.width, photoViewLandscape4.frame.size.height)];  
        } else {
            // This image width is frameleft(16) + firstimage(187) + spacebetween(2) + secondeimage(187) + frameright(15)
            // This image height is frametop(13.5) + firstimage(238) + spacebetween(2) + secondeimage(238) + framebottem(11)
            UIGraphicsBeginImageContext(CGSizeMake(786, 261));
            [[UIImage imageNamed:@"FrameShareLandscapeIphone.png"] drawInRect:CGRectMake(0, 0, 786, 261)];
            [[photoViewLandscape1 image] drawInRect:CGRectMake(16 + 187 + 2 + 187 + 2 + 187 + 2, 13.5, photoViewLandscape1.frame.size.width, photoViewLandscape1.frame.size.height)];
            [[UIImage imageNamed:chachamFileName] drawInRect:CGRectMake(16 + 187 + 2 + 187 + 2 + 187 + 2, 13.5, photoViewLandscape1.frame.size.width, photoViewLandscape1.frame.size.height)];    
            [[photoViewLandscape2 image] drawInRect:CGRectMake(16 + 187 + 2 + 187 + 2, 13.5, photoViewLandscape2.frame.size.width, photoViewLandscape2.frame.size.height)];
            [[UIImage imageNamed:rashaFileName] drawInRect:CGRectMake(16 + 187 + 2 + 187 + 2, 13.5, photoViewLandscape2.frame.size.width, photoViewLandscape2.frame.size.height)];        
            [[photoViewLandscape3 image] drawInRect:CGRectMake(16 + 187 + 2, 13.5, photoViewLandscape3.frame.size.width, photoViewLandscape3.frame.size.height)];
            [[UIImage imageNamed:tamFileName] drawInRect:CGRectMake(16 + 187 + 2, 13.5, photoViewLandscape3.frame.size.width, photoViewLandscape3.frame.size.height)];        
            [[photoViewLandscape4 image] drawInRect:CGRectMake(16, 13.5, photoViewLandscape4.frame.size.width, photoViewLandscape4.frame.size.height)];    
            [[UIImage imageNamed:sheinoFileName] drawInRect:CGRectMake(16, 13.5, photoViewLandscape4.frame.size.width, photoViewLandscape4.frame.size.height)]; 
        }
        #endif
        
        finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (void)prepareFinalPicturePortrait {
    

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //            [[UIImage imageNamed:@"newFrame_iPad.png"] drawInRect:CGRectMake(0, 0, 768, 975)];
            UIGraphicsBeginImageContext(CGSizeMake(768, 908));            
            [[UIImage imageNamed:@"longFrameSharePortrait.jpg"] drawInRect:CGRectMake(0, 0, 768, 908)];
            [[photoView1 image] drawInRect:CGRectMake(photoView1.frame.origin.x, photoView1.frame.origin.y, photoView1.frame.size.width, photoView1.frame.size.height)];
            [[UIImage imageNamed:chachamFileName] drawInRect:CGRectMake(photoView1.frame.origin.x, photoView1.frame.origin.y, photoView1.frame.size.width, photoView1.frame.size.height)];    
            [[photoView2 image] drawInRect:CGRectMake(photoView2.frame.origin.x, photoView2.frame.origin.y, photoView2.frame.size.width, photoView2.frame.size.height)];
            [[UIImage imageNamed:rashaFileName] drawInRect:CGRectMake(photoView2.frame.origin.x, photoView2.frame.origin.y, photoView2.frame.size.width, photoView2.frame.size.height)];        
            [[photoView3 image] drawInRect:CGRectMake(photoView3.frame.origin.x, photoView3.frame.origin.y, photoView3.frame.size.width, photoView3.frame.size.height)];
            [[UIImage imageNamed:tamFileName] drawInRect:CGRectMake(photoView3.frame.origin.x, photoView3.frame.origin.y, photoView3.frame.size.width, photoView3.frame.size.height)];        
            [[photoView4 image] drawInRect:CGRectMake(photoView4.frame.origin.x, photoView4.frame.origin.y, photoView4.frame.size.width, photoView4.frame.size.height)];    
            [[UIImage imageNamed:sheinoFileName] drawInRect:CGRectMake(photoView4.frame.origin.x, photoView4.frame.origin.y, photoView4.frame.size.width, photoView4.frame.size.height)];               
        } else {
            // This image width is frameleft(27) + firstimage(157) + spacebetween(2) + secondeimage(157) + frameright(27)
            // This image height is frametop(16.5) + firstimage(200) + spacebetween(2) + secondeimage(200) + framebottem(18)
            UIGraphicsBeginImageContext(CGSizeMake(369, 436));            
            [[UIImage imageNamed:@"FrameSharePortraitIphone.png"] drawInRect:CGRectMake(0, 0, 369, 436)];
            [[photoView1 image] drawInRect:CGRectMake(27 + 157 + 2, 16.5, photoView1.frame.size.width, photoView1.frame.size.height)];
            [[UIImage imageNamed:chachamFileName] drawInRect:CGRectMake(27 + 157 + 2, 16.5, photoView1.frame.size.width, photoView1.frame.size.height)];    
            [[photoView2 image] drawInRect:CGRectMake(27, 16.5, photoView2.frame.size.width, photoView2.frame.size.height)];
            [[UIImage imageNamed:rashaFileName] drawInRect:CGRectMake(27, 16.5, photoView2.frame.size.width, photoView2.frame.size.height)];        
            [[photoView3 image] drawInRect:CGRectMake(27 + 157 + 2, 16.5 + 200 + 2, photoView3.frame.size.width, photoView3.frame.size.height)];
            [[UIImage imageNamed:tamFileName] drawInRect:CGRectMake(27 + 157 + 2, 16.5 + 200 + 2, photoView3.frame.size.width, photoView3.frame.size.height)];        
            [[photoView4 image] drawInRect:CGRectMake(27,  16.5 + 200 + 2, photoView4.frame.size.width, photoView4.frame.size.height)];    
            [[UIImage imageNamed:sheinoFileName] drawInRect:CGRectMake(27,  16.5 + 200 + 2, photoView4.frame.size.width, photoView4.frame.size.height)];               
        }
#endif
        
        finalImagePortrait = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
}

- (void)prepareFinalPictureLandscape {
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
//        UIGraphicsBeginImageContext(self.landscapeScrollView.contentSize);
        UIGraphicsBeginImageContext(CGSizeMake(1987, 660));        
        [[UIImage imageNamed:@"longFrameShareLandscape.jpg"] drawInRect:CGRectMake(0, 0, 1987, 660)];
        [[photoViewLandscape1 image] drawInRect:CGRectMake(photoViewLandscape1.frame.origin.x, photoViewLandscape1.frame.origin.y, photoViewLandscape1.frame.size.width, photoViewLandscape1.frame.size.height)];
        [[UIImage imageNamed:chachamFileName] drawInRect:CGRectMake(photoViewLandscape1.frame.origin.x, photoViewLandscape1.frame.origin.y, photoViewLandscape1.frame.size.width, photoViewLandscape1.frame.size.height)];    
        [[photoViewLandscape2 image] drawInRect:CGRectMake(photoViewLandscape2.frame.origin.x, photoViewLandscape2.frame.origin.y, photoViewLandscape2.frame.size.width, photoViewLandscape2.frame.size.height)];
        [[UIImage imageNamed:rashaFileName] drawInRect:CGRectMake(photoViewLandscape2.frame.origin.x, photoViewLandscape2.frame.origin.y, photoViewLandscape2.frame.size.width, photoViewLandscape2.frame.size.height)];        
        [[photoViewLandscape3 image] drawInRect:CGRectMake(photoViewLandscape3.frame.origin.x, photoViewLandscape3.frame.origin.y, photoViewLandscape3.frame.size.width, photoViewLandscape3.frame.size.height)];
        [[UIImage imageNamed:tamFileName] drawInRect:CGRectMake(photoViewLandscape3.frame.origin.x, photoViewLandscape3.frame.origin.y, photoViewLandscape3.frame.size.width, photoViewLandscape3.frame.size.height)];        
        [[photoViewLandscape4 image] drawInRect:CGRectMake(photoViewLandscape4.frame.origin.x, photoViewLandscape4.frame.origin.y, photoViewLandscape4.frame.size.width, photoViewLandscape4.frame.size.height)];    
        [[UIImage imageNamed:sheinoFileName] drawInRect:CGRectMake(photoViewLandscape4.frame.origin.x, photoViewLandscape4.frame.origin.y, photoViewLandscape4.frame.size.width, photoViewLandscape4.frame.size.height)];  
    } else {
        // This image width is frameleft(16) + firstimage(187) + spacebetween(2) + secondeimage(187) + frameright(15)
        // This image height is frametop(13.5) + firstimage(238) + spacebetween(2) + secondeimage(238) + framebottem(11)
        UIGraphicsBeginImageContext(CGSizeMake(786, 261));
        [[UIImage imageNamed:@"FrameShareLandscapeIphone.png"] drawInRect:CGRectMake(0, 0, 786, 261)];
        [[photoViewLandscape1 image] drawInRect:CGRectMake(16 + 187 + 2 + 187 + 2 + 187 + 2, 13.5, photoViewLandscape1.frame.size.width, photoViewLandscape1.frame.size.height)];
        [[UIImage imageNamed:chachamFileName] drawInRect:CGRectMake(16 + 187 + 2 + 187 + 2 + 187 + 2, 13.5, photoViewLandscape1.frame.size.width, photoViewLandscape1.frame.size.height)];    
        [[photoViewLandscape2 image] drawInRect:CGRectMake(16 + 187 + 2 + 187 + 2, 13.5, photoViewLandscape2.frame.size.width, photoViewLandscape2.frame.size.height)];
        [[UIImage imageNamed:rashaFileName] drawInRect:CGRectMake(16 + 187 + 2 + 187 + 2, 13.5, photoViewLandscape2.frame.size.width, photoViewLandscape2.frame.size.height)];        
        [[photoViewLandscape3 image] drawInRect:CGRectMake(16 + 187 + 2, 13.5, photoViewLandscape3.frame.size.width, photoViewLandscape3.frame.size.height)];
        [[UIImage imageNamed:tamFileName] drawInRect:CGRectMake(16 + 187 + 2, 13.5, photoViewLandscape3.frame.size.width, photoViewLandscape3.frame.size.height)];        
        [[photoViewLandscape4 image] drawInRect:CGRectMake(16, 13.5, photoViewLandscape4.frame.size.width, photoViewLandscape4.frame.size.height)];    
        [[UIImage imageNamed:sheinoFileName] drawInRect:CGRectMake(16, 13.5, photoViewLandscape4.frame.size.width, photoViewLandscape4.frame.size.height)]; 
    }
#endif
    
    finalImageLandscape = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-(void)displayComposerSheet 
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"חכם, רשע, תם ושאינו יודע לשאול..."];
    
    // Set up recipients
    // NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
    // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
    // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
    
    // [picker setToRecipients:toRecipients];
    // [picker setCcRecipients:ccRecipients];   
    // [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    
    /*
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    
    NSString* finalPicturePath = [documentsDirectory stringByAppendingPathComponent:@"finalPicture.png"];        
    UIImage *finalPicture = [UIImage imageWithContentsOfFile:finalPicturePath];
     */
    
    NSData *myData = UIImagePNGRepresentation(finalImage);
    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"iHagada.png"];
    
    // Fill out the email body text
    NSString *emailBody = @"נשלח מאפליקציית <a href=\"http://itunes.apple.com/app/ihagada/id362179346?ls=1&mt=8\">iHagada</a><p>חג שמח!";
    NSString *alignString = @"rtl";        
        NSString *fullStrHtml = [NSString stringWithFormat:@"<html dir=\"%@\"><div dir=\"%@\"><body><table><tr><td>%@</td></tr></table></body></div></html>",alignString,alignString,emailBody];

    [picker setMessageBody:fullStrHtml isHTML:YES];
    [self presentModalViewController:picker animated:YES];
    
    [picker release];
    
    [self.activitiyIndicator stopAnimating];    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	[self dismissModalViewControllerAnimated:YES];
	
    /*
	NSString *mailSendingFailedTitle = [stringsPlistDictionary objectForKey:@"MailSendingFailedTitle"];
    NSString *mailSendingFailedMessage = [stringsPlistDictionary objectForKey:@"MailSendingFailedMessage"];
    NSString *mailSendingSuccessTitle = [stringsPlistDictionary objectForKey:@"MailSendingSuccessTitle"];
    */
    
    NSString *mailSendingFailedTitle = @"שליחת מייל נכשלה.";
    NSString *mailSendingFailedMessage = @"אנא נסה/י שוב.";
    NSString *mailSendingSuccessTitle = @"המייל נשלח בהצלחה!";
    
	if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:mailSendingFailedTitle message:mailSendingFailedMessage  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else if (result == MFMailComposeResultSent) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:mailSendingSuccessTitle message:nil  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

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

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];	
	
	if (UIDeviceOrientationIsPortrait(toInterfaceOrientation)) {
        [self rotatePortrait];
	} else if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        [self rotateLandscape];
	}	
    
    [self removeOverlayView];
}

- (void)rotateOtherViewControllers:sender toInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    [self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
}

- (void)rotatePortrait {
    cellWidth = 320;		
    [self.landscapeScrollView setHidden:YES];
    [self.landscapeButtons setHidden:YES];
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    } else {
        [self.landscapeIphoneBackground setHidden:YES];
    }
    #endif
     
    [self.photoView1 setImage:self.photoViewLandscape1.image];
    [self.photoView2 setImage:self.photoViewLandscape2.image];
    [self.photoView3 setImage:self.photoViewLandscape3.image];
    [self.photoView4 setImage:self.photoViewLandscape4.image];
    [self.basePhotoView1 setImage:self.basePhotoViewLandscape1.image];
    [self.basePhotoView2 setImage:self.basePhotoViewLandscape2.image];
    [self.basePhotoView3 setImage:self.basePhotoViewLandscape3.image];
    [self.basePhotoView4 setImage:self.basePhotoViewLandscape4.image]; 
}

- (void)rotateLandscape {
    cellWidth = 480;		
    [self.landscapeScrollView setHidden:NO];
    [self.landscapeButtons setHidden:NO];    
    
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    } else {
        [self.landscapeIphoneBackground setHidden:NO];
    }
    #endif
    
    [self.photoViewLandscape1 setImage:self.photoView1.image];
    [self.photoViewLandscape2 setImage:self.photoView2.image];
    [self.photoViewLandscape3 setImage:self.photoView3.image];
    [self.photoViewLandscape4 setImage:self.photoView4.image];        
    [self.basePhotoViewLandscape1 setImage:self.basePhotoView1.image];
    [self.basePhotoViewLandscape2 setImage:self.basePhotoView2.image];
    [self.basePhotoViewLandscape3 setImage:self.basePhotoView3.image];
    [self.basePhotoViewLandscape4 setImage:self.basePhotoView4.image];        
}

- (void)viewDidUnload
{
    [landscapeScrollView release];
    landscapeScrollView = nil;
    [basePhotoViewLandscape1 release];
    basePhotoViewLandscape1 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end

#pragma clang diagnostic pop
