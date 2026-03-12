//
//  ImageViewController.m
//  iHagada
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import "ImageViewControllerHeb.h"
#import "Utilities.h"
#import "MainTableViewController.h"

@implementation ImageViewControllerHeb

@synthesize images, backButton, delegate;

int cellWidth;

static UIImage *IHLoadFirstAvailableOrFallback(NSArray *names, UIImage *fallback) {
    for (NSString *name in names) {
        UIImage *image = [UIImage imageNamed:name];
        if (image) {
            return image;
        }
    }
    NSLog(@"[iHagada] Missing image asset candidates: %@", [names componentsJoinedByString:@", "]);
    return fallback;
}

/*
UIImage *finalImage;

-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
//    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
//    CGContextSelectFont(context, "Georgia", 30, kCGEncodingMacRoman);
//    char* text = (char *)[text1 cStringUsingEncoding:NSUTF8StringEncoding];    
    const char *text = [text1 cStringUsingEncoding:NSUTF8StringEncoding];    
    CGContextSelectFont(context, "Helvetica", 30, kCGEncodingFontSpecific);    
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
//    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
    CGContextShowTextAtPoint(context, 60, 390, text, strlen(text));
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
    
}
*/

- (id)init {		
    if (self == [super init]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
        BOOL isiPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
        UIImage *fallback = [UIImage imageNamed:(isiPad ? @"Default-Portrait~ipad.png" : @"Default.png")];
        NSMutableArray *allImages = [NSMutableArray array];
        [allImages addObject:fallback];

        NSUInteger pageCount = 73;
        for (NSUInteger page = 1; page <= pageCount; page++) {
            NSArray *candidates = nil;
            if (isiPad) {
                candidates = [NSArray arrayWithObject:[NSString stringWithFormat:@"%lu_ipad.jpg", (unsigned long)page]];
            } else {
                candidates = [NSArray arrayWithObjects:
                              [NSString stringWithFormat:@"%lu.jpg", (unsigned long)page],
                              [NSString stringWithFormat:@"pages/%lu.jpg", (unsigned long)page],
                              nil];
            }
            [allImages addObject:IHLoadFirstAvailableOrFallback(candidates, fallback)];
        }

        NSArray *endCandidates = isiPad ? [NSArray arrayWithObject:@"end_ipad.jpg"]
                                        : [NSArray arrayWithObjects:@"end.jpg", @"pages/end.jpg", nil];
        [allImages addObject:IHLoadFirstAvailableOrFallback(endCandidates, fallback)];
        images = [allImages copy];
#endif
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	#if  __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
			self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 32, 38, 37)];		
		} else if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
			self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 55, 38, 37)];					
		}
		UIImage *image = [UIImage imageNamed: @"backArrow_HD.png"];		
		[self.backButton setImage:image forState:0];		
	} else {
		self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(35, 0, 25, 45)];			
		UIImage *image = [UIImage imageNamed: @"backArrow.png"];
		[self.backButton setImage:image forState:0];		
	}
	#endif
	
	[self.backButton addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];		
	[self.view addSubview:self.backButton];	
	
}

- (void)viewDidUnload {
	[self.backButton removeFromSuperview];
	self.backButton = nil;
}

- (void) handleBack:(id)sender
{
	// Pop the controller for back action
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
	[self.backButton release];
	[images release];
    [super dealloc];
}

#pragma mark HagadaViewDataSource methods

- (NSUInteger) numberOfPagesInHagadaView:(HagadaViewHeb*)hagadaView {
	return images.count;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	// Yuval - Fix for crash bug when landscape.
	if (images.count <= index)
		return;
	
	UIImage *image = [images objectAtIndex:index];
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	CGAffineTransform transform = aspectFit(imageRect,
											CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawImage(ctx, imageRect, [image CGImage]);
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {	
	/* No super rotation callback here; this method is app-triggered manually. */
	[self.delegate rotateOtherViewControllers:self toInterfaceOrientation:toInterfaceOrientation];
	
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
			[backButton setFrame:CGRectMake(55, 32, 38, 37)];
		} else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
			[backButton setFrame:CGRectMake(50, 55, 38, 37)];
		}
	} else {
		[[self.delegate tableView] reloadData];

		if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
			cellWidth = 320;
			[self.delegate changeNavBarHebReg];
		} else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
			cellWidth = 480;
			[self.delegate changeNavBarHebWide];
		}
	}
	#endif	
}

/* This Function is being call for manually rotating */
- (void)rotateViewFromAppDelegate:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	/* No super rotation callback here; this method is app-triggered manually. */
	#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200								
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
			[backButton setFrame:CGRectMake(55, 32, 38, 37)];
		} else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
			[backButton setFrame:CGRectMake(50, 55, 38, 37)];
		}
	} else {
		[[self.delegate tableView] reloadData];
		
		if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
			[self.delegate changeNavBarHebReg];
		} else if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
			[self.delegate changeNavBarHebWide];
		}
	}
	#endif	
}

@end
