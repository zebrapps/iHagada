//
//  HagadaCache.h
//  Reader
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HagadaView.h"


@protocol HagadaViewDataSource;

@interface HagadaCache : NSObject {
	NSMutableDictionary *pageCache;
	id<HagadaViewDataSource> dataSource;
	CGSize pageSize;
}

@property (nonatomic, assign) CGSize pageSize;
@property (assign) id<HagadaViewDataSource> dataSource;

- (id) initWithPageSize:(CGSize)aPageSize;
- (CGImageRef) cachedImageForPageIndex:(NSUInteger)pageIndex;
- (void) precacheImageForPageIndex:(NSUInteger)pageIndex;
- (void) minimizeToPageIndex:(NSUInteger)pageIndex viewMode:(HagadaViewMode)viewMode;
- (void) flush;

@end
