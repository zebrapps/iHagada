//
//  HagadaCache.m
//  Reader
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import "HagadaCacheHeb.h"


@implementation HagadaCacheHeb

@synthesize dataSource, pageSize;

- (id) initWithPageSize:(CGSize)aPageSize
{
	if ((self = [super init])) {
		pageSize = aPageSize;
		pageCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[pageCache release];
	[super dealloc];
}



- (CGImageRef) imageForPageIndex:(NSUInteger)pageIndex {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, 
												 pageSize.width, 
												 pageSize.height, 
												 8,						/* bits per component*/
												 pageSize.width * 4, 	/* bytes per row */
												 colorSpace, 
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	CGContextClipToRect(context, CGRectMake(0, 0, pageSize.width, pageSize.height));
	
	[dataSource renderPageAtIndex:pageIndex inContext:context];
	
	CGImageRef image = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	
	return image;
}

- (CGImageRef) cachedImageForPageIndex:(NSUInteger)pageIndex {
	NSNumber *pageIndexNumber = [NSNumber numberWithUnsignedInteger:pageIndex];
	UIImage *pageImage;
	@synchronized (pageCache) {
		pageImage = [pageCache objectForKey:pageIndexNumber];
	}
	if (!pageImage) {
		CGImageRef pageCGImage = [self imageForPageIndex:pageIndex];
		pageImage = [UIImage imageWithCGImage:pageCGImage];
		CGImageRelease(pageCGImage);
		@synchronized (pageCache) {
			[pageCache setObject:pageImage forKey:pageIndexNumber];
		}
	}
	return pageImage.CGImage;
}

- (void) precacheImageForPageIndexNumber:(NSNumber *)pageIndexNumber {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[self cachedImageForPageIndex:[pageIndexNumber intValue]];
	[pool release];
}

- (void) precacheImageForPageIndex:(NSUInteger)pageIndex {
	[self performSelectorInBackground:@selector(precacheImageForPageIndexNumber:)
						   withObject:[NSNumber numberWithUnsignedInteger:pageIndex]];
}

- (void) minimizeToPageIndex:(NSUInteger)pageIndex viewMode:(HagadaViewHebMode)viewMode {
	/* Uncache all pages except previous, current, and next. */
	@synchronized (pageCache) {
        int cutoffValueFromPageIndex = 2;
        if (viewMode == HagadaViewHebModeFacingPages) {
            cutoffValueFromPageIndex = 3;
        }
		for (NSNumber *key in [pageCache allKeys])
			if (ABS([key intValue] - (int)pageIndex) > cutoffValueFromPageIndex)
				[pageCache removeObjectForKey:key];
	}
}

- (void) flush {
	@synchronized (pageCache) {
		[pageCache removeAllObjects];
	}
}

#pragma mark accessors

- (void) setPageSize:(CGSize)value {
	pageSize = value;
	[self flush];
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

@end
