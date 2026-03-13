//
//  ImagePickerViewController.m
//  ImagePicker
//
//  Created by Yuval Tessone on 4/4/11.
//  Copyright 2011 www.zebrapps.com All rights reserved.
//

#import "ImagePickerViewController.h"
#import "FourSonsViewController.h"
#import <QuartzCore/QuartzCore.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#define radians( degrees ) ( degrees * M_PI / 180 ) 

@implementation ImagePickerViewController

@synthesize picker,popover;
@synthesize selectedPickerImage, topImage,delegate;
@synthesize smallPictureDelegatePortrait,smallPictureDelegateLandscape;
@synthesize didSelectNewPicture;
@synthesize isFlipped;
@synthesize shadowsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    //    [selectedPickerImage addGestureRecognizer:rotationGesture];
    [self.view addGestureRecognizer:rotationGesture];    
    [rotationGesture release];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    //    [selectedPickerImage addGestureRecognizer:pinchGesture];
    [self.view addGestureRecognizer:pinchGesture];
    [pinchGesture release];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setDelegate:self];
    //    [selectedPickerImage addGestureRecognizer:panGesture];
    [self.view addGestureRecognizer:panGesture];
    [panGesture release];
    
    //    shadowsView = [[UIView alloc] initWithFrame:CGR]
}

-(IBAction)takeOrChoosePicture:(id)sender {
	
    if (!picker) {
        
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
    }
    
	if ([sender tag] == 1) {
        /* Take Photo Button */
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"בעיה בצילום תמונה" message: @"אין אפשרות לצלם, בחר תמונה קיימת מאלבום התמונות." delegate: self cancelButtonTitle: @"אשר" otherButtonTitles: nil];
            [someError show];
            [someError release];
        }
        
        [self presentModalViewController:picker animated:YES];		            
    }
	else if ([sender tag] == 2) {
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;            
        
        /* Choose From Photot Library Button */        
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            if (!popover) {
                popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            }
        
            [popover presentPopoverFromRect:CGRectMake(100, 100.0, 1.0, 1.0) 
                                     inView:self.view
                   permittedArrowDirections:UIPopoverArrowDirectionAny 
                                   animated:YES];        
            
        } else {
            [self presentModalViewController:picker animated:YES];		            
        }
        #endif
	}

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//	[[self.picker parentViewController] dismissModalViewControllerAnimated:YES];
    [self.picker dismissModalViewControllerAnimated:YES];
//	[picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   //  NSLog(@"imagePickerController");
    
    //[self.selectedPickerImage setImage:nil];
    self.selectedPickerImage.transform = CGAffineTransformIdentity;
    self.isFlipped = NO;
    didSelectNewPicture = YES;
    
	[picker1 dismissModalViewControllerAnimated:YES];
//	[picker release];
	
	// Edited image works great (if you allowed editing)
//	selectedPickerImage.image = [info objectForKey:UIImagePickerControllerEditedImage];
	
	// AND the original image works great

    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];

//	selectedPickerImage.image = [UIImage imageWithImage:originalImage scaledToSize:CGSizeMake(320, 480)];
    
    UIImage *smallImage;
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        smallImage = [ImagePickerViewController imageWithImage:originalImage scaledToSize:CGSizeMake(768, 1024)];
        smallImage = [ImagePickerViewController imageWithImage:originalImage scaledToSize:CGSizeMake(656, 896)];
    } else {
        smallImage = [ImagePickerViewController imageWithImage:originalImage scaledToSize:CGSizeMake(310, 394)];
    }
    #endif
    
    // Save OriginalImage In case of resizing it or using it in another theme
    int photoNumberChosen = [self.delegate photoNumber];
    NSString *imageName = nil;
    
    switch (photoNumberChosen) {
        case 1: {
            imageName = @"originalPhoto1.png";            
            break;
        }
        case 2: {
            //            [[self.delegate photoView2] setImage:self.selectedPickerImage.image];            
            imageName = @"originalPhoto2.png";                        
            break;
        }
        case 3: {
            //            [[self.delegate photoView3] setImage:self.selectedPickerImage.image];            
            imageName = @"originalPhoto3.png";            
            break;
        }
        case 4: {
            //            [[self.delegate photoView4] setImage:self.selectedPickerImage.image];            
            imageName = @"originalPhoto4.png";            
            break;
        }
        default:
            return;
    }
    
    NSData* imageData = UIImagePNGRepresentation(smallImage);
    
    // Now, we have to find the documents directory so we can save it
    // Note that you might want to save it elsewhere, like the cache directory,
    // or something similar.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];            

    
    
    [self.selectedPickerImage setImage:smallImage];
    
//    self.selectedPickerImage.frame = CGRectMake(0, 0, self.selectedPickerImage.frame.size.width, self.selectedPickerImage.frame.size.height);
     
	// AND do whatever you want with it, (NSDictionary *)info is fine now
//	UIImage *myImage = [info objectForKey:UIImagePickerControllerEditedImage];
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.topImage.image && [self.delegate respondsToSelector:@selector(setCurrentImageInImagePicker)]) {
        // When image is not allocated yet
        [self.delegate setCurrentImageInImagePicker];
    }
//    [self.selectedPickerImage setImage:[UIImage imageNamed:@"chacham.png"]];
//    [self.topImage setImage:[UIImage imageNamed:@"rasha.png"]];

}

- (IBAction)confirmPicture {
        
    int photoNumberChosen = [self.delegate photoNumber];
    NSString *imageName = nil;
    NSString *imageTransformKey = nil;
    
    switch (photoNumberChosen) {
        case 1: {
           //  NSLog(@"photo1");
            imageName = @"photo1.png";            
            imageTransformKey = @"transform1";
            break;
        }
        case 2: {
//            [[self.delegate photoView2] setImage:self.selectedPickerImage.image];            
            imageName = @"photo2.png";                        
            imageTransformKey = @"transform2";            
            break;
        }
        case 3: {
//            [[self.delegate photoView3] setImage:self.selectedPickerImage.image];            
            imageName = @"photo3.png";      
            imageTransformKey = @"transform3";            
            break;
        }
        case 4: {
//            [[self.delegate photoView4] setImage:self.selectedPickerImage.image];            
            imageName = @"photo4.png";      
            imageTransformKey = @"transform4";            
            break;
        }
        default:
            return;
    }
    
        
//    NSLog(@"new transform = %f,%f,%f,%f,%f,%f",self.selectedPickerImage.transform.a,self.selectedPickerImage.transform.b,self.selectedPickerImage.transform.c,self.selectedPickerImage.transform.d,self.selectedPickerImage.transform.tx,self.selectedPickerImage.transform.ty);
    
    UIImage *myThumbnail;
//    if (didSelectNewPicture) {

    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        myThumbnail = [ImagePickerViewController imageWithTransform:self.selectedPickerImage.image scaledToSize:CGSizeMake(656, 896) transform:self.selectedPickerImage.transform];
    } else {
        myThumbnail = [ImagePickerViewController imageWithTransform:self.selectedPickerImage.image scaledToSize:CGSizeMake(310, 394) transform:self.selectedPickerImage.transform];    
    }
    #endif

//        didSelectNewPicture = NO;
//    } else {
//        myThumbnail = [ImagePickerViewController imageWithImage:self.selectedPickerImage.image scaledToSize:CGSizeMake(320, 480)];
//    }

    
    
//    UIImage *myThumbnail = [ImagePickerViewController imageWithImage:self.selectedPickerImage.image scaledToSize:CGSizeMake(160, 240)];
    
/*
    CGSize rotatedSize = self.selectedPickerImage.image.size;
    NSLog(@"rotatedSize = %f,%f",rotatedSize.width,rotatedSize.height);
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    

    CGAffineTransform a = CGContextGetCTM(bitmap);
    NSLog(@"a transform  = %f,%f,%f,%f,%f,%f",a.a,a.b,a.c,a.d,a.tx,a.ty);        

    
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width, 0);
//    NSLog(@"translate  = %f,%f",rotatedSize.width/2,rotatedSize.height/2);    
    //Rotate the image context using tranform
    
    CGAffineTransform b = CGContextGetCTM(bitmap);
    NSLog(@"b transform  = %f,%f,%f,%f,%f,%f",b.a,b.b,b.c,b.d,b.tx,b.ty);        
    
    
    CGContextConcatCTM(bitmap, self.selectedPickerImage.transform);
    
    
    CGAffineTransform c = CGContextGetCTM(bitmap);
    NSLog(@"c transform  = %f,%f,%f,%f,%f,%f",c.a,c.b,c.c,c.d,c.tx,c.ty);        

    
    NSLog(@"transform  = %f,%f,%f,%f,%f,%f",self.selectedPickerImage.transform.a,self.selectedPickerImage.transform.b,self.selectedPickerImage.transform.c,self.selectedPickerImage.transform.d,self.selectedPickerImage.transform.tx,self.selectedPickerImage.transform.ty);        
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    
    CGRect drawImageRect = CGRectMake(-self.selectedPickerImage.image.size.width, -self.selectedPickerImage.image.size.height, self.selectedPickerImage.image.size.width, self.selectedPickerImage.image.size.height);
    NSLog(@"drawImageRect = %f,%f,%f,%f",drawImageRect.origin.x,drawImageRect.origin.y,drawImageRect.size.width,drawImageRect.size.height);
    CGContextDrawImage(bitmap, drawImageRect, [self.selectedPickerImage.image CGImage]);
    
    UIImage* myThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    */
     /*
    // Create a graphics context the size of the bounding rectangle
    UIGraphicsBeginImageContext(CGSizeMake(self.selectedPickerImage.image.size.width, self.selectedPickerImage.image.size.height));

    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextRotateCTM(context, 180);
  
    // Move the origin to the middle of the image so we will rotate and scale around the center.
//    CGContextTranslateCTM(context, self.selectedPickerImage.frame.size.width/2, self.selectedPickerImage.frame.size.height/2);
    
    //Rotate the image context using tranform    
    
    CGContextTranslateCTM (context, self.selectedPickerImage.image.size.width/2, self.selectedPickerImage.image.size.height/2);
    
    CGContextConcatCTM(context, self.selectedPickerImage.transform);



    CGContextScaleCTM(context, 1.0, -1.0);
    
 //   CGContextRotateCTM(context, 180);
    //    CGContextRotateCTM (context, radians(0));        

    
//    CGContextDrawImage(context, CGRectMake(0, 0, 320, 480), self.selectedPickerImage.image.CGImage);

    // Draw the image into the context
    CGContextDrawImage(context, CGRectMake(0, 0, self.selectedPickerImage.image.size.width, self.selectedPickerImage.image.size.height), self.selectedPickerImage.image.CGImage);
    
    // Get an image from the context
    UIImage* myThumbnail = [UIImage imageWithCGImage: CGBitmapContextCreateImage(context)];
    
    // Clean up
    UIGraphicsEndImageContext();
*/
    
    

//    UIImage* myThumbnail = self.selectedPickerImage.image;
//    [[self.delegate photoView1] setImage:myThumbnail];
    [[self smallPictureDelegatePortrait] setImage:myThumbnail];
    [[self smallPictureDelegateLandscape] setImage:myThumbnail];
    
    
    

//    UIImage* myThumbnail = [[self.delegate photoView1] image];    
    

    NSMutableDictionary *imageTransformDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:self.selectedPickerImage.transform.a],@"a",
                                               [NSNumber numberWithFloat:self.selectedPickerImage.transform.b],@"b",
                                               [NSNumber numberWithFloat:self.selectedPickerImage.transform.c],@"c",
                                               [NSNumber numberWithFloat:self.selectedPickerImage.transform.d],@"d",
                                               [NSNumber numberWithFloat:self.selectedPickerImage.transform.tx],@"tx",
                                               [NSNumber numberWithFloat:self.selectedPickerImage.transform.ty],@"ty",
                                               [NSString stringWithFormat:@"%d",isFlipped],@"isFlipped", 
                                               nil];
    
    NSData* imageData = UIImagePNGRepresentation(myThumbnail);
    
    // Now, we have to find the documents directory so we can save it
    // Note that you might want to save it elsewhere, like the cache directory,
    // or something similar.
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];            
    
    NSString *fullPathToFileTransform = [documentsDirectory stringByAppendingPathComponent:imageTransformKey];
    [imageTransformDict writeToFile:fullPathToFileTransform atomically:YES];
     
    [self.delegate flipsideViewControllerDidFinish];
    self.delegate = nil;
}

- (IBAction)cancelPicture {
    [self.delegate flipsideViewControllerDidFinish];
    self.delegate = nil;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
	// NSLog(@"touchesShouldBegin");    
    NSSet *allTouches = [event allTouches];
	
	if ([allTouches count] == 1)
        return YES;
    
    return NO;  
}

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)targetSize
{
   //  NSLog(@"imageWithImage");
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
  //  CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    if (alphaInfo == kCGImageAlphaNone) {
        bitmapInfo = (bitmapInfo & ~kCGBitmapAlphaInfoMask) | kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        
        //bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
        bitmap = CGBitmapContextCreate(
                                                    NULL,
                                                    targetWidth,
                                                    targetHeight,
                                                    8, /* bits per channel */
                                                    (targetWidth * 4), /* 4 channels per pixel * numPixels/row */
                                                    CGColorSpaceCreateDeviceRGB(),
                                                    (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                                    );        
        
    } else {
//        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
        bitmap = CGBitmapContextCreate(
                                       NULL,
                                       targetHeight,
                                       targetWidth,
                                       8, /* bits per channel */
                                       (targetHeight * 4), /* 4 channels per pixel * numPixels/row */
                                       CGColorSpaceCreateDeviceRGB(),
                                       (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                       );        
        
    }   
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage; 
}

+ (UIImage*)imageWithTransform:(UIImage*)sourceImage scaledToSize:(CGSize)targetSize transform:(CGAffineTransform)transform
{
    // NSLog(@"imageWithTransform");
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];

//    NSLog(@"sizeeee = %lu,%lu",CGImageGetHeight(imageRef),CGImageGetWidth(imageRef));
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
 //   CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    if (alphaInfo == kCGImageAlphaNone) {
        bitmapInfo = (bitmapInfo & ~kCGBitmapAlphaInfoMask) | kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    // NSLog(@"DATAAAAA = %lu,%lu,%@,%d",CGImageGetBitsPerComponent(imageRef),CGImageGetBytesPerRow(imageRef),colorSpaceInfo,bitmapInfo);    
//    bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef)/*6140*/, colorSpaceInfo, bitmapInfo);
    
    bitmap = CGBitmapContextCreate(NULL,
                                   targetWidth,
                                   targetHeight,
                                   8, /* bits per channel */
                                   (targetWidth * 4), /* 4 channels per pixel * numPixels/row */
                                   CGColorSpaceCreateDeviceRGB(),
                                   (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                   ); 
    
    
//    CGContextTranslateCTM(bitmap, 20, 20);
//    CGContextDrawImage(bitmap, CGRectMake((targetWidth/2)*transform.a, (targetHeight/2)*transform.a, targetWidth, targetHeight), imageRef);
  
    /*
    CGRect thisFrame = CGRectMake(0, 0, 320, 480);
    
    CGRect rect = CGRectMake(-160, 0, 160, 240);
    CGSize contextSize = targetSize;
    
    
    CGAffineTransform newTransform = CGAffineTransformIdentity;
    newTransform = CGAffineTransformTranslate(newTransform, rect.origin.x, contextSize.height - rect.origin.y - rect.size.height);
    newTransform = CGAffineTransformTranslate(newTransform, 
                                           +(rect.size.width/2.0f), 
                                           +(rect.size.height/2.0f));
//    newTransform = CGAffineTransformRotate(newTransform, -rotation);
    newTransform = CGAffineTransformTranslate(newTransform, 
                                           -(rect.size.width/2.0f), 
                                           -(rect.size.height/2.0f));
    
    
    CGContextConcatCTM(bitmap, newTransform);
        CGContextDrawImage(bitmap, thisFrame, [sourceImage CGImage]); 
    CGContextConcatCTM(bitmap, CGAffineTransformInvert(transform));
    */
    
    CGRect thisFrame;
    CGRect rect;
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        thisFrame = CGRectMake(0, 0, 656, 896);
        rect = CGRectMake(0, 0, 656, 896);
    } else {
        thisFrame = CGRectMake(0, 0, 310, 394);
        rect = CGRectMake(0, 0, 310, 394);    
    }
    #endif
    
    CGSize contextSize = targetSize;
    
    CGAffineTransform newTransform = CGAffineTransformIdentity;
//    CGContextTranslateCTM(bitmap, 20, -20);
//    CGContextRotateCTM(bitmap, radians(45));
    
    
    newTransform = CGAffineTransformTranslate(newTransform, rect.origin.x, contextSize.height - rect.origin.y - rect.size.height);
    newTransform = CGAffineTransformTranslate(newTransform, 
                                              +(rect.size.width/2.0f), 
                                              +(rect.size.height/2.0f));
//   newTransform = CGAffineTransformRotate(newTransform, radians(0)); 
    CGContextConcatCTM(bitmap, newTransform);
  
    CGAffineTransform originalTransformWithGoodRotation = CGAffineTransformMake(transform.a, -transform.b, -transform.c, transform.d, transform.tx, -transform.ty);
    
//    CGContextConcatCTM(bitmap, transform);
    CGContextConcatCTM(bitmap, originalTransformWithGoodRotation);    
    
    newTransform = CGAffineTransformIdentity;
//    CGContextConcatCTM(bitmap, transform);       
    newTransform = CGAffineTransformTranslate(newTransform, 
                                              -(rect.size.width/2.0f), 
                                              -(rect.size.height/2.0f));
    CGContextConcatCTM(bitmap, newTransform);
    // NSLog(@"sourceImage image size = %f,%f",sourceImage.size.width,sourceImage.size.height); 
    CGContextDrawImage(bitmap, thisFrame, [sourceImage CGImage]);    

//    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    // NSLog(@"newImage image size = %f,%f",newImage.size.width,newImage.size.height);
    return newImage; 
}

- (void)dealloc
{
    [selectedPickerImage release];
    [super dealloc];
}

- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer {
    //    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        [self fadeTheImageView];
        
        if (isFlipped) {
            selectedPickerImage.transform = CGAffineTransformRotate([selectedPickerImage transform], -([gestureRecognizer rotation]));
        } else {
            selectedPickerImage.transform = CGAffineTransformRotate([selectedPickerImage transform], [gestureRecognizer rotation]);
        }
        
        [gestureRecognizer setRotation:0];
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        [self unFadeTheImageView];
    }
    
}

- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer {
    //    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        [self fadeTheImageView];
        
        selectedPickerImage.transform = CGAffineTransformScale([selectedPickerImage transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
        
        //            NSLog(@"selected transform  = %f,%f,%f,%f,%f,%f",self.selectedPickerImage.transform.a,self.selectedPickerImage.transform.b,self.selectedPickerImage.transform.c,self.selectedPickerImage.transform.d,self.selectedPickerImage.transform.tx,self.selectedPickerImage.transform.ty);    
        
        //            NSLog(@"gesture transform  = %f,%f,%f,%f,%f,%f",[gestureRecognizer view].transform.a,[gestureRecognizer view].transform.b,[gestureRecognizer view].transform.c,[gestureRecognizer view].transform.d,[gestureRecognizer view].transform.tx,[gestureRecognizer view].transform.ty);        
        
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        [self unFadeTheImageView];
    }
    
}

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer {
    //    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        [self fadeTheImageView];
        
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.selectedPickerImage];

        selectedPickerImage.transform = CGAffineTransformTranslate([selectedPickerImage transform], translation.x, translation.y);
      /*  
        if (isFlipped) {
            selectedPickerImage.transform = CGAffineTransformTranslate([selectedPickerImage transform], -(translation.x), translation.y);            
        } else {
            selectedPickerImage.transform = CGAffineTransformTranslate([selectedPickerImage transform], translation.x, translation.y);
        }
       */
        //        gestureRecognizer.view.center = CGPointMake(gestureRecognizer.view.center.x + translation.x, 
        //                                                    gestureRecognizer.view.center.y + translation.y);        
        
        //                    NSLog(@"selected transform  = %f,%f,%f,%f,%f,%f",self.selectedPickerImage.transform.a,self.selectedPickerImage.transform.b,self.selectedPickerImage.transform.c,self.selectedPickerImage.transform.d,self.selectedPickerImage.transform.tx,self.selectedPickerImage.transform.ty);    
        
        //                    NSLog(@"gesture transform  = %f,%f,%f,%f,%f,%f",[gestureRecognizer view].transform.a,[gestureRecognizer view].transform.b,[gestureRecognizer view].transform.c,[gestureRecognizer view].transform.d,[gestureRecognizer view].transform.tx,[gestureRecognizer view].transform.ty);        
        
        
        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.selectedPickerImage];
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        [self unFadeTheImageView];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view) {
        return NO;
    }
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;

    return YES;
}

- (void)fadeTheImageView
{    
	[UIView beginAnimations:@"fadeTheImageView" context:NULL];
	[UIView setAnimationDelegate:self];
//	[UIView setAnimationDidStopSelector:@selector(yourAnimationHasFinished:finished:context:)];
	[UIView setAnimationDuration:0.5];
	[self.topImage setAlpha:0.7];    
//	[self.topImage setAlpha:1.0];
	[UIView commitAnimations];	
}

- (void)unFadeTheImageView
{
	[UIView beginAnimations:@"unFadeTheImageView" context:NULL];
	[UIView setAnimationDelegate:self];
    //	[UIView setAnimationDidStopSelector:@selector(yourAnimationHasFinished:finished:context:)];
	[UIView setAnimationDuration:0.5];
	[self.topImage setAlpha:1.0];    
    //	[self.topImage setAlpha:1.0];
	[UIView commitAnimations];	
}

- (IBAction)flipImage {
    
    if (isFlipped) {
        isFlipped = NO;
    } else {
        isFlipped = YES;
    }
    
    self.selectedPickerImage.transform = CGAffineTransformScale(self.selectedPickerImage.transform, -1.0, 1.0);
}
/*
- (IBAction)showShadowView {
    CATransition *applicationLoadViewIn = [CATransition animation];        
    [applicationLoadViewIn setDuration:0];
    [applicationLoadViewIn setType:kCATransitionMoveIn];
    [applicationLoadViewIn setSubtype:kCATransitionFromBottom];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.view setFrame:CGRectMake(0, 410, 320, AUDIO_BAR_HEIGHT)];
    openBarView.frame = CGRectMake(0, 0, 270, AUDIO_BAR_HEIGHT);
    
    [[self.openBarView layer] addAnimation:applicationLoadViewIn forKey:kCATransitionMoveIn]; 
}
*/
/*
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        [piece setBackgroundColor:[UIColor greenColor]];
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);

        NSLog(@"other piece center before = %f,%f",piece.center.x,piece.center.y);
        piece.center = locationInSuperview;
        NSLog(@"other piece center after = %f,%f",piece.center.x,piece.center.y);        
    }
}
*/
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

@end
#pragma clang diagnostic pop
