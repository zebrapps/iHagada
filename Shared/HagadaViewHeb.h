//
//  HagadaView.h
//  iHagada
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>


typedef enum {
    HagadaViewHebModeSinglePage,
    HagadaViewHebModeFacingPages,
} HagadaViewHebMode;



@class HagadaCacheHeb;

@protocol HagadaViewHebDataSource;
@protocol HagadaViewHebDelegate;

@interface HagadaViewHeb: UIView {
	CALayer *topPage;
	CALayer *topPageOverlay;
	CAGradientLayer *topPageShadow;
	
	CALayer *topPageReverse;
	CALayer *topPageReverseImage;
	CALayer *topPageReverseOverlay;
	CAGradientLayer *topPageReverseShading;
	
	CALayer *bottomPage;
	CAGradientLayer *bottomPageShadow;

    // The left page in two-page mode.
    // Animation is always done on the right page
    CALayer *leftPage;
	CALayer *leftPageOverlay;
    
    // Single page or facing pages?
    HagadaViewHebMode mode;
    
	CGFloat leafEdge;
    
    // In two-page mode, this is always the index of the right page.
    // Pages with odd numbers (== pages where currentPageIndex is even) are always displayed 
    // on the right side (as in a book)
	NSUInteger currentPageIndex;
	NSUInteger numberOfPages;
    NSUInteger numberOfVisiblePages;
	id<HagadaViewHebDelegate> delegate;
	
	CGSize pageSize;
	HagadaCacheHeb *pageCache;
	BOOL backgroundRendering;
	
	CGPoint touchBeganPoint;
	BOOL touchIsActive;
	CGRect nextPageRect, prevPageRect;
	BOOL interactionLocked;
	
	
	//declare a system sound id
	SystemSoundID soundIDForward;
	SystemSoundID soundIDBackward;
	
}

@property (assign) id<HagadaViewHebDataSource> dataSource;
@property (assign) id<HagadaViewHebDelegate> delegate;
@property (nonatomic, assign) HagadaViewHebMode mode;
@property (readonly) CGFloat targetWidth;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (assign) BOOL backgroundRendering;

- (void) reloadData:(NSUInteger)pageIndex;

-(void) playForwardSound;
-(void) playBackwardSound;

@end


@protocol HagadaViewHebDataSource <NSObject>

- (NSUInteger) numberOfPagesInHagadaView:(HagadaViewHeb*)HagadaViewHeb;
- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx;

@end

@protocol HagadaViewHebDelegate <NSObject>

@optional

- (void) HagadaView:(HagadaViewHeb *)hagadaView willTurnToPageAtIndex:(NSUInteger)pageIndex;
- (void) HagadaView:(HagadaViewHeb *)hagadaView didTurnToPageAtIndex:(NSUInteger)pageIndex;

@end

