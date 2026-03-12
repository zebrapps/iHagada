//
//  HagadaView.m
//  Hagada
//
//  Created by Yuval Tessone & Nadav Pozmantir on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import "HagadaViewHeb.h"
#import "HagadaCacheHeb.h"


#pragma mark -
#pragma mark Private interface

@interface HagadaViewHeb () 

@property (assign) CGFloat leafEdge;

- (void)setUpLayers;
- (void)setUpLayersForViewingMode;

@end

CGFloat distanceHeb(CGPoint a, CGPoint b);



#pragma mark -
#pragma mark Implementation

@implementation HagadaViewHeb

@synthesize delegate;
@synthesize mode;
@synthesize leafEdge, currentPageIndex, backgroundRendering;


- (void) setUpLayers {
	NSLog(@"HagadaViewHeb - setUpLayers");
	self.clipsToBounds = YES;
    
	topPage = [[CALayer alloc] init];
	topPage.masksToBounds = YES;
//	topPage.contentsGravity = kCAGravityLeft;
	topPage.contentsGravity = kCAGravityRight;	
	/// topPage.backgroundColor = [[UIColor whiteColor] CGColor];
    topPage.backgroundColor = [[UIColor blackColor] CGColor];
	
	topPageOverlay = [[CALayer alloc] init];
	topPageOverlay.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
	
	topPageShadow = [[CAGradientLayer alloc] init];
	topPageShadow.colors = [NSArray arrayWithObjects:
							
							(id)[[UIColor clearColor] CGColor],
						//	(id)[[UIColor greenColor] CGColor],
							(id)[[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],							
							nil];
	topPageShadow.startPoint = CGPointMake(1,0.5);
	topPageShadow.endPoint = CGPointMake(0,0.5);
//	topPageShadow.endPoint = CGPointMake(1,0.5);
//	topPageShadow.startPoint = CGPointMake(0,0.5);

	
	topPageReverse = [[CALayer alloc] init];
	/// topPageReverse.backgroundColor = [[UIColor whiteColor] CGColor];
	topPageReverse.backgroundColor = [[UIColor blackColor] CGColor];
	topPageReverse.masksToBounds = YES;
	
	topPageReverseImage = [[CALayer alloc] init];
	topPageReverseImage.masksToBounds = YES;
	
	topPageReverseOverlay = [[CALayer alloc] init];
	
	topPageReverseShading = [[CAGradientLayer alloc] init];
	topPageReverseShading.colors = [NSArray arrayWithObjects:
									
									(id)[[UIColor clearColor] CGColor],
								//	(id)[[UIColor blueColor] CGColor],									
									(id)[[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],									
									nil];
	topPageReverseShading.startPoint = CGPointMake(1,0.5);
	topPageReverseShading.endPoint = CGPointMake(0,0.5);
//	topPageReverseShading.endPoint = CGPointMake(1,0.5);
//	topPageReverseShading.startPoint = CGPointMake(0,0.5);
	
	bottomPage = [[CALayer alloc] init];
	/// bottomPage.backgroundColor = [[UIColor whiteColor] CGColor];
	bottomPage.backgroundColor = [[UIColor blackColor] CGColor];    
	bottomPage.masksToBounds = YES;
	
	bottomPageShadow = [[CAGradientLayer alloc] init];
	bottomPageShadow.colors = [NSArray arrayWithObjects:
							   
							   (id)[[UIColor clearColor] CGColor],
							 //  (id)[[UIColor yellowColor] CGColor],							   
							   (id)[[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor],							   
							   nil];
	bottomPageShadow.startPoint = CGPointMake(0,0.5);
	bottomPageShadow.endPoint = CGPointMake(1,0.5);
//	bottomPageShadow.endPoint = CGPointMake(0,0.5);
//	bottomPageShadow.startPoint = CGPointMake(1,0.5);
	
	[topPage addSublayer:topPageOverlay];
	[topPageReverse addSublayer:topPageReverseImage];
	[topPageReverse addSublayer:topPageReverseOverlay];
	[topPageReverse addSublayer:topPageReverseShading];
	[bottomPage addSublayer:bottomPageShadow];

    // Setup for the left page in two-page mode
    leftPage = [[CALayer alloc] init];
	leftPage.masksToBounds = YES;
//	leftPage.contentsGravity = kCAGravityLeft;
	leftPage.contentsGravity = kCAGravityRight;	
//	leftPage.backgroundColor = [[UIColor greenColor] CGColor];
	leftPage.backgroundColor = [[UIColor blackColor] CGColor];    
	
	leftPageOverlay = [[CALayer alloc] init];
	leftPageOverlay.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
		
	[leftPage addSublayer:leftPageOverlay];
    
	[self.layer addSublayer:leftPage];
	[self.layer addSublayer:bottomPage];
	[self.layer addSublayer:topPage];
	[self.layer addSublayer:topPageReverse];
    [self.layer addSublayer:topPageShadow];
    
    [self setUpLayersForViewingMode];
	
	self.leafEdge = 0.0;
}


- (void)setUpLayersForViewingMode {
	NSLog(@"HagadaViewHeb - setUpLayersForViewingMode");	
    if (self.mode == HagadaViewHebModeSinglePage) {
//        topPageReverseImage.contentsGravity = kCAGravityRight;
        topPageReverseImage.contentsGravity = kCAGravityLeft;		
        /// topPageReverseOverlay.backgroundColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.8] CGColor];
        topPageReverseOverlay.backgroundColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.1] CGColor];        
        topPageReverseImage.transform = CATransform3DMakeScale(-1, 1, 1);	
    } else {
//        topPageReverseImage.contentsGravity = kCAGravityLeft;
        topPageReverseImage.contentsGravity = kCAGravityRight;		
        ///topPageReverseOverlay.backgroundColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.0] CGColor];
        topPageReverseOverlay.backgroundColor = [[[UIColor whiteColor] colorWithAlphaComponent:0.1] CGColor];
        topPageReverseImage.transform = CATransform3DMakeScale(1, 1, 1);
    }
}



#pragma mark -
#pragma mark Initialization and teardown

- (void) initialize {
	NSLog(@"HagadaViewHeb - initialize");	
	mode = HagadaViewHebModeSinglePage;
    numberOfVisiblePages = 1;
	backgroundRendering = NO;
    
    CGSize cachePageSize = self.bounds.size;
    if (mode == HagadaViewHebModeFacingPages) {
        cachePageSize = CGSizeMake(self.bounds.size.width / 2.0f, self.bounds.size.height);
    }
	pageCache = [[HagadaCacheHeb alloc] initWithPageSize:cachePageSize];
}


- (id)initWithFrame:(CGRect)frame {
	NSLog(@"HagadaViewHeb - initWithFrame");	
    if ((self = [super initWithFrame:frame])) {
		[self setUpLayers];
		[self initialize];
    }
    return self;
}


- (void) awakeFromNib {
	NSLog(@"HagadaViewHeb - awakeFromNib");	
	[super awakeFromNib];
	[self setUpLayers];
	[self initialize];
}


- (void)dealloc {
	NSLog(@"HagadaViewHeb - dealloc");	
	[topPage release];
	[topPageShadow release];
	[topPageOverlay release];
	[topPageReverse release];
	[topPageReverseImage release];
	[topPageReverseOverlay release];
	[topPageReverseShading release];
	[bottomPage release];
	[bottomPageShadow release];
    [leftPage release];
	[leftPageOverlay release];
    
	[pageCache release];
	
    [super dealloc];
}



#pragma mark -
#pragma mark Image loading

- (void) reloadData:(NSUInteger)pageIndex {
	NSLog(@"HagadaViewHeb - reloadData");	
	[pageCache flush];
	numberOfPages = [pageCache.dataSource numberOfPagesInHagadaView:self];
	self.currentPageIndex = pageIndex;
}


- (void) getImages {
	NSLog(@"HagadaViewHeb - getImages");	
    if (self.mode == HagadaViewHebModeSinglePage) 
    {
        if (currentPageIndex < numberOfPages) {
            if (currentPageIndex > 0 && backgroundRendering) {
                [pageCache precacheImageForPageIndex:currentPageIndex-1];
            }
            topPage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex];
            leftPage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex];
            if (currentPageIndex < numberOfPages - 1) {
                topPageReverseImage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex];
                bottomPage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex + 1];
            }
            [pageCache minimizeToPageIndex:currentPageIndex viewMode:self.mode];
        } else {
            topPage.contents = nil;
            topPageReverseImage.contents = nil;
            bottomPage.contents = nil;
            
            leftPage.contents = nil;
        }
    }
    else
    {
        if (currentPageIndex <= numberOfPages) {
            if (currentPageIndex > 1 && backgroundRendering) {
                [pageCache precacheImageForPageIndex:currentPageIndex-2];
            }
            if (currentPageIndex > 2 && backgroundRendering) {
                [pageCache precacheImageForPageIndex:currentPageIndex-2];
            }
            
            topPage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex];
            if (currentPageIndex > 0) {
                leftPage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex-1];
            } else {
                leftPage.contents = nil;
            }
            
            if (currentPageIndex < numberOfPages - 1) {
                topPageReverseImage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex + 1];
                bottomPage.contents = (id)[pageCache cachedImageForPageIndex:currentPageIndex + 2];
            }
            [pageCache minimizeToPageIndex:currentPageIndex viewMode:self.mode];
        } else {
            topPage.contents = nil;
            topPageReverseImage.contents = nil;
            bottomPage.contents = nil;
            
            leftPage.contents = nil;
        }
    }
}



#pragma mark -
#pragma mark Layout

- (void) setLayerFrames {
	NSLog(@"HagadaViewHeb - setLayerFrames");	
    CGRect rightPageBoundsRect = self.layer.bounds;

    CGRect leftHalf, rightHalf;

    CGRectDivide(rightPageBoundsRect, &leftHalf, &rightHalf, CGRectGetWidth(rightPageBoundsRect) / 2.0f, CGRectMinXEdge);
    if (self.mode == HagadaViewHebModeFacingPages) {
        //rightPageBoundsRect = rightHalf;
		rightPageBoundsRect = leftHalf;		
    }
    
	/* ORIGINAL 
	topPage.frame = CGRectMake(rightPageBoundsRect.origin.x, 
							   rightPageBoundsRect.origin.y, 
							   leafEdge * rightPageBoundsRect.size.width, 
							   rightPageBoundsRect.size.height);
	/*
	NSLog(@" ");
	NSLog(@"ORIGINAL");
	NSLog(@"topPage.frame.origin.x = %f",topPage.frame.origin.x);	
	NSLog(@"topPage.frame.origin.y = %f",topPage.frame.origin.y);	
	NSLog(@"topPage.frame.size.width = %f",topPage.frame.size.width);	
	NSLog(@"topPage.frame.size.height = %f",topPage.frame.size.height);
	 */
	
	//NSLog(@"leafEdge ======= %f",leafEdge);
 	/* Nadav */
	topPage.frame = CGRectMake(/*(leafEdge == 1 ? 0 : (leafEdge == 0 ? 1 : leafEdge))*/ leafEdge * rightPageBoundsRect.size.width, 
							   //rightPageBoundsRect.origin.x,
							   rightPageBoundsRect.origin.y, 
							   rightPageBoundsRect.size.width - (/*(leafEdge == 1 ? 0 : (leafEdge == 0 ? 1 : leafEdge))*/ leafEdge * rightPageBoundsRect.size.width), 
							   rightPageBoundsRect.size.height);
	
	
	/*	
	 topPage.frame = CGRectMake(rightPageBoundsRect.origin.x,
	 rightPageBoundsRect.origin.y, 
	 rightPageBoundsRect.size.width,// - ((leafEdge == 1 ? 0 : leafEdge) * rightPageBoundsRect.size.width), 
	 rightPageBoundsRect.size.height);
	 */
	//	topPage.bounds = CGRectMake(320, 0, 320, 480);						   
	
	
	/*
	NSLog(@" ");
	NSLog(@"NADAV");	
	NSLog(@"topPage.frame.origin.x = %f",topPage.frame.origin.x);	
	NSLog(@"topPage.frame.origin.y = %f",topPage.frame.origin.y);	
	NSLog(@"topPage.frame.size.width = %f",topPage.frame.size.width);	
	NSLog(@"topPage.frame.size.height = %f",topPage.frame.size.height);	
*/
	
	
	/* ORIGINAL 
	topPageReverse.frame = CGRectMake(rightPageBoundsRect.origin.x + (2*leafEdge-1) * rightPageBoundsRect.size.width, 
									  rightPageBoundsRect.origin.y, 
									  (1-leafEdge) * rightPageBoundsRect.size.width, 
									  rightPageBoundsRect.size.height);

	
	NSLog(@"");	
	NSLog(@"ORIGINAL");
	NSLog(@"topPageReverse.frame.origin.x = %f",topPageReverse.frame.origin.x);	
	NSLog(@"topPageReverse.frame.origin.y = %f",topPageReverse.frame.origin.y);	
	NSLog(@"topPageReverse.frame.size.width = %f",topPageReverse.frame.size.width);	
	NSLog(@"topPageReverse.frame.size.height = %f",topPageReverse.frame.size.height);
	 */
	/* NADAV */
	topPageReverse.frame = CGRectMake(rightPageBoundsRect.origin.x + (/*(leafEdge == 1 ? 0 : leafEdge)*/leafEdge * rightPageBoundsRect.size.width),
									  rightPageBoundsRect.origin.y, 
									  /*(leafEdge == 1 ? 0 : leafEdge)*/leafEdge * rightPageBoundsRect.size.width, 
									  rightPageBoundsRect.size.height);
	
/*
	NSLog(@"");	
	NSLog(@"Nadav");
	NSLog(@"topPageReverse.frame.origin.x = %f",topPageReverse.frame.origin.x);	
	NSLog(@"topPageReverse.frame.origin.y = %f",topPageReverse.frame.origin.y);	
	NSLog(@"topPageReverse.frame.size.width = %f",topPageReverse.frame.size.width);	
	NSLog(@"topPageReverse.frame.size.height = %f",topPageReverse.frame.size.height);
*/	 
	
	bottomPage.frame = rightPageBoundsRect;
	
	/* ORIGINAL 
	topPageShadow.frame = CGRectMake(topPageReverse.frame.origin.x - 40, 
									 0, 
									 40, 
									 bottomPage.bounds.size.height);
	 */
	
	/* NADAV */	
	topPageShadow.frame = CGRectMake(topPageReverse.frame.origin.x + topPageReverse.frame.size.width, 
									 0, 
									 (leafEdge == 1 ? 0 : 1) * 40, /* In the first touch, when topPageReverse is still 0, don't show topPageShadow */
									 bottomPage.bounds.size.height);
	
	
	
	/*
	NSLog(@"topPageShadow.frame.origin.x = %f",topPageShadow.frame.origin.x);	
	NSLog(@"topPageShadow.frame.origin.y = %f",topPageShadow.frame.origin.y);	
	NSLog(@"topPageShadow.frame.size.width = %f",topPageShadow.frame.size.width);	
	NSLog(@"topPageShadow.frame.size.height = %f",topPageShadow.frame.size.height);
	*/
	
	topPageReverseImage.frame = topPageReverse.bounds;
	
/*	
	NSLog(@"topPageReverseImage.frame.origin.x = %f",topPageReverseImage.frame.origin.x);	
	NSLog(@"topPageReverseImage.frame.origin.y = %f",topPageReverseImage.frame.origin.y);	
	NSLog(@"topPageReverseImage.frame.size.width = %f",topPageReverseImage.frame.size.width);	
	NSLog(@"topPageReverseImage.frame.size.height = %f",topPageReverseImage.frame.size.height);
*/	
	
	topPageReverseOverlay.frame = topPageReverse.bounds;

	/*
	NSLog(@"topPageReverseOverlay.frame.origin.x = %f",topPageReverseOverlay.frame.origin.x);	
	NSLog(@"topPageReverseOverlay.frame.origin.y = %f",topPageReverseOverlay.frame.origin.y);	
	NSLog(@"topPageReverseOverlay.frame.size.width = %f",topPageReverseOverlay.frame.size.width);	
	NSLog(@"topPageReverseOverlay.frame.size.height = %f",topPageReverseOverlay.frame.size.height);	
	 */
	
	/* ORIGINAL 
	topPageReverseShading.frame = CGRectMake(topPageReverse.bounds.size.width - 50, 
											 0, 
											 50 + 1, 
											 topPageReverse.bounds.size.height);
	 */
	
	/* NADAV */
	topPageReverseShading.frame = CGRectMake(0, 
											 0, 
											 50 + 1, 
											 topPageReverse.bounds.size.height);
/*	
	NSLog(@"topPageReverseShading.frame.origin.x = %f",topPageReverseShading.frame.origin.x);	
	NSLog(@"topPageReverseShading.frame.origin.y = %f",topPageReverseShading.frame.origin.y);	
	NSLog(@"topPageReverseShading.frame.size.width = %f",topPageReverseShading.frame.size.width);	
	NSLog(@"topPageReverseShading.frame.size.height = %f",topPageReverseShading.frame.size.height);	
*/
	
	/* ORIGINAL
	bottomPageShadow.frame = CGRectMake(leafEdge * rightPageBoundsRect.size.width, 
										0, 
										40, 
										bottomPage.bounds.size.height);
	 */
	
	/* NADAV */
	bottomPageShadow.frame = CGRectMake(topPageReverse.frame.origin.x - 40, 
										0, 
										40, 
										bottomPage.bounds.size.height);
/*	
	NSLog(@"bottomPageShadow.frame.origin.x = %f",bottomPageShadow.frame.origin.x);	
	NSLog(@"bottomPageShadow.frame.origin.y = %f",bottomPageShadow.frame.origin.y);	
	NSLog(@"bottomPageShadow.frame.size.width = %f",bottomPageShadow.frame.size.width);	
	NSLog(@"bottomPageShadow.frame.size.height = %f",bottomPageShadow.frame.size.height);	
*/	
	topPageOverlay.frame = topPage.bounds;
    
    
    
    if (self.mode == HagadaViewHebModeSinglePage) {
        leftPage.hidden = YES;
        leftPageOverlay.hidden = leftPage.hidden;
    } else {
        leftPage.hidden = NO;
        leftPageOverlay.hidden = leftPage.hidden;
		/*
        leftPage.frame = CGRectMake(leftHalf.origin.x, 
                                   leftHalf.origin.y, 
                                   leftHalf.size.width, 
                                   leftHalf.size.height);
		 */
		leftPage.frame = CGRectMake(rightHalf.origin.x, 
									rightHalf.origin.y, 
									rightHalf.size.width, 
									rightHalf.size.height);
        leftPageOverlay.frame = leftPage.bounds;
        
    }
}

- (void) willTurnToPageAtIndex:(NSUInteger)index {
	NSLog(@"HagadaViewHeb - willTurnToPageAtIndex");	
	if ([delegate respondsToSelector:@selector(HagadaView:willTurnToPageAtIndex:)])
		[delegate HagadaView:self willTurnToPageAtIndex:index];
}

- (void) didTurnToPageAtIndex:(NSUInteger)index {
	NSLog(@"HagadaViewHeb - didTurnToPageAtIndex");	
	if ([delegate respondsToSelector:@selector(HagadaView:didTurnToPageAtIndex:)])
		[delegate HagadaView:self didTurnToPageAtIndex:index];
}

- (void) didTurnPageBackward {
	NSLog(@"HagadaViewHeb - didTurnPageBackward");	
	interactionLocked = NO;
	[self didTurnToPageAtIndex:currentPageIndex];
}

- (void) didTurnPageForward {
	NSLog(@"HagadaViewHeb - didTurnPageForward");	
	interactionLocked = NO;
	self.currentPageIndex = self.currentPageIndex + numberOfVisiblePages;	
	[self didTurnToPageAtIndex:currentPageIndex];
}

- (BOOL) hasPrevPage {
	NSLog(@"HagadaViewHeb - hasPrevPage");	
    return self.currentPageIndex > (numberOfVisiblePages - 1);
}

- (BOOL) hasNextPage {
	NSLog(@"HagadaViewHeb - hasNextPage");	
	if (self.mode == HagadaViewHebModeSinglePage) {
        return self.currentPageIndex < numberOfPages - 1;
    } else {
        return  ((self.currentPageIndex % 2 == 0) && (self.currentPageIndex < numberOfPages - 1)) ||
                ((self.currentPageIndex % 2 != 0) && (self.currentPageIndex < numberOfPages - 2));
    }
}

- (BOOL) touchedNextPage {
	NSLog(@"HagadaViewHeb - touchedNextPage");	
	return CGRectContainsPoint(nextPageRect, touchBeganPoint);
}

- (BOOL) touchedPrevPage {
	NSLog(@"HagadaViewHeb - touchedPrevPage");	
	return CGRectContainsPoint(prevPageRect, touchBeganPoint);
}

- (CGFloat) dragThreshold {
	NSLog(@"HagadaViewHeb - dragThreshold");	
	// Magic empirical number
	return 10;
}

- (CGFloat) targetWidth {
	NSLog(@"HagadaViewHeb - targetWidth");	
	// Magic empirical formula
	return MAX(28, self.bounds.size.width / 5);
}

#pragma mark -
#pragma mark accessors

- (id<HagadaViewHebDataSource>) dataSource {
	NSLog(@"HagadaViewHeb - dataSource");	
	return pageCache.dataSource;
}

- (void) setDataSource:(id<HagadaViewHebDataSource>)value {
	NSLog(@"HagadaViewHeb - setDataSource");	
	pageCache.dataSource = value;
}

- (void) setLeafEdge:(CGFloat)aLeafEdge {
	NSLog(@"HagadaViewHeb - setLeafEdge");	
	leafEdge = aLeafEdge;
	
    CGFloat pageOpacity = MIN(1.0, 4*(1-leafEdge));
	
	/* Nadav - Due to the hebrew changes, now the leafEdge changed sizes so the opacity need to be as the old function */
	if (leafEdge == 0) {
		pageOpacity = 0;
	} else if (leafEdge == 1) {
		pageOpacity = 1.0;
	}
    
    topPageShadow.opacity        = pageOpacity;
	bottomPageShadow.opacity     = pageOpacity;
	topPageOverlay.opacity       = pageOpacity;
	leftPageOverlay.opacity   = pageOpacity;

    [self setLayerFrames];
}


- (void) setCurrentPageIndex:(NSUInteger)aCurrentPageIndex {
	NSLog(@"HagadaViewHeb - setCurrentPageIndex");	
    currentPageIndex = aCurrentPageIndex;
	if (self.mode == HagadaViewHebModeFacingPages && aCurrentPageIndex % 2 != 0) {
        currentPageIndex = aCurrentPageIndex + 1;
    }
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	
	[self getImages];
	
	self.leafEdge = 0.0;
//	leafEdge = 1;
	
	[CATransaction commit];
}


- (void) setMode:(HagadaViewHebMode)newMode
{
	NSLog(@"HagadaViewHeb - setMode");	
    mode = newMode;
    
    if (mode == HagadaViewHebModeSinglePage) {
        numberOfVisiblePages = 1;
        if (self.currentPageIndex > numberOfPages - 1) {
            self.currentPageIndex = numberOfPages - 1;
        }
        
    } else {
        numberOfVisiblePages = 2;
        if (self.currentPageIndex % 2 != 0) {
            self.currentPageIndex++;
        }
    }

    [self setUpLayersForViewingMode];
    [self setNeedsLayout];
}



#pragma mark -
#pragma mark UIView methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"HagadaViewHeb - touchesBegan");	
	if (interactionLocked)
		return;
	
	UITouch *touch = [event.allTouches anyObject];
	touchBeganPoint = [touch locationInView:self];
	
	if ([self touchedPrevPage] && [self hasPrevPage]) {		
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue
						 forKey:kCATransactionDisableActions];

        self.currentPageIndex = self.currentPageIndex - numberOfVisiblePages;
//        self.leafEdge = 0.0;
		self.leafEdge = 1.0;
		[CATransaction commit];
		touchIsActive = YES;		
	} 
	else if ([self touchedNextPage] && [self hasNextPage]) {
		touchIsActive = YES;
	}
	else 
		touchIsActive = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"HagadaViewHeb - touchesMoved");	
	if (!touchIsActive)
		return;
	UITouch *touch = [event.allTouches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:0.07]
					 forKey:kCATransactionAnimationDuration];
	self.leafEdge = touchPoint.x / self.bounds.size.width;
	/*
	NSLog(@"touchPoint.x = %f",touchPoint.x);
	NSLog(@"self.bounds.size.width = %f",self.bounds.size.width);	
	NSLog(@"self.leafEdge = %f",self.leafEdge);	
	 */
	[CATransaction commit];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"HagadaViewHeb - touchesEnded");	
	if (!touchIsActive)
		return;
	touchIsActive = NO;
	
	UITouch *touch = [event.allTouches anyObject];
	CGPoint touchPoint = [touch locationInView:self];
	BOOL dragged = distanceHeb(touchPoint, touchBeganPoint) > [self dragThreshold];
	[CATransaction begin];
	float duration;
	/* NADAV - Changed for hebrew */
	//if ((dragged && self.leafEdge < 0.5) || (!dragged && [self touchedNextPage])) {
	if ((dragged && self.leafEdge > 0.5) || (!dragged && [self touchedNextPage])) {	
        [self willTurnToPageAtIndex:currentPageIndex + numberOfVisiblePages];
//		self.leafEdge = 0;
		self.leafEdge = 1.0;
//		duration = leafEdge;
		duration = 0;		
		interactionLocked = YES;
		if (currentPageIndex+2 < numberOfPages && backgroundRendering)
			[pageCache precacheImageForPageIndex:currentPageIndex+2];
		[self performSelector:@selector(didTurnPageForward)
				   withObject:nil 
				   afterDelay:duration + 0.25];
	}
	else {
		[self willTurnToPageAtIndex:currentPageIndex];
//		self.leafEdge = 1.0;
		self.leafEdge = 0;		
//		duration = 1 - leafEdge;
		duration = 0;
		interactionLocked = YES;
		[self performSelector:@selector(didTurnPageBackward)
				   withObject:nil 
				   afterDelay:duration + 0.25];
	}
	[CATransaction setValue:[NSNumber numberWithFloat:duration]
					 forKey:kCATransactionAnimationDuration];
	[CATransaction commit];
}

- (void) layoutSubviews {
	NSLog(@"HagadaViewHeb - layoutSubviews");	
	[super layoutSubviews];
	
    
	CGSize desiredPageSize = self.bounds.size;
    if (self.mode == HagadaViewHebModeFacingPages) {
        desiredPageSize = CGSizeMake(self.bounds.size.width/2.0f, self.bounds.size.height);
    }
    
	if (!CGSizeEqualToSize(pageSize, desiredPageSize)) {
		pageSize = desiredPageSize;
		
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue
						 forKey:kCATransactionDisableActions];
		[self setLayerFrames];
		[CATransaction commit];
		pageCache.pageSize = pageSize;
		[self getImages];
		
		// Yuval - Fix Start of touch down from the middle of screen.
		//CGFloat touchRectsWidth = self.bounds.size.width / 7;
		CGFloat touchRectsWidth = self.bounds.size.width / 3;

		/*
		NSLog(@"touchRectsWidth = %f",touchRectsWidth);
		NSLog(@"self.bounds.size.width = %f",self.bounds.size.width);
		NSLog(@"self.bounds.size.height = %f",self.bounds.size.height);	
		*/
		
		/*
		nextPageRect = CGRectMake(self.bounds.size.width - touchRectsWidth,
								  0,
								  touchRectsWidth,
								  self.bounds.size.height);
		prevPageRect = CGRectMake(0,
								  0,
								  touchRectsWidth,
								  self.bounds.size.height);
		 */
		
		/* Nadav The next page will be from the left side and prev page from the right */
		prevPageRect = CGRectMake(self.bounds.size.width - touchRectsWidth,
								  0,
								  touchRectsWidth,
								  self.bounds.size.height);
		nextPageRect = CGRectMake(0,
								  0,
								  touchRectsWidth,
								  self.bounds.size.height);
		 
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	NSLog(@"HagadaViewHeb - shouldAutorotateToInterfaceOrientation");	
    // Return YES for supported orientations
	//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

@end

CGFloat distanceHeb(CGPoint a, CGPoint b) {
	NSLog(@"HagadaViewHeb - distanceHeb");	
	return sqrtf(powf(a.x-b.x, 2) + powf(a.y-b.y, 2));
}
