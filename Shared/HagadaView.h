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
    HagadaViewModeSinglePage,
    HagadaViewModeFacingPages,
} HagadaViewMode;



@class HagadaCache;

@protocol HagadaViewDataSource;
@protocol HagadaViewDelegate;

@interface HagadaView : UIView {
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
    HagadaViewMode mode;
    
	CGFloat leafEdge;
    
    // In two-page mode, this is always the index of the right page.
    // Pages with odd numbers (== pages where currentPageIndex is even) are always displayed 
    // on the right side (as in a book)
	NSUInteger currentPageIndex;
	NSUInteger numberOfPages;
    NSUInteger numberOfVisiblePages;
	id<HagadaViewDelegate> delegate;
	
	CGSize pageSize;
	HagadaCache *pageCache;
	BOOL backgroundRendering;
	
	CGPoint touchBeganPoint;
	BOOL touchIsActive;
	CGRect nextPageRect, prevPageRect;
	BOOL interactionLocked;
	
	//declare a system sound id
	SystemSoundID soundIDForward;
	SystemSoundID soundIDBackward;	
}

@property (assign) id<HagadaViewDataSource> dataSource;
@property (assign) id<HagadaViewDelegate> delegate;
@property (nonatomic, assign) HagadaViewMode mode;
@property (readonly) CGFloat targetWidth;
@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (assign) BOOL backgroundRendering;
@property (nonatomic, readonly) CGFloat leafEdge;


- (void) reloadData:(NSUInteger)pageIndex;

-(void) playForwardSound;
-(void) playBackwardSound;

@end


@protocol HagadaViewDataSource <NSObject>

- (NSUInteger) numberOfPagesInHagadaView:(HagadaView*)HagadaView;
- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx;

@end

@protocol HagadaViewDelegate <NSObject>

@optional

- (void) HagadaView:(HagadaView *)hagadaView willTurnToPageAtIndex:(NSUInteger)pageIndex;
- (void) HagadaView:(HagadaView *)hagadaView didTurnToPageAtIndex:(NSUInteger)pageIndex;

@end

