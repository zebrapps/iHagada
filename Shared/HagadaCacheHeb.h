//
//  HagadaCache.h
//  Reader
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HagadaViewHeb.h"


@protocol HagadaViewHebDataSource;

@interface HagadaCacheHeb : NSObject {
	NSMutableDictionary *pageCache;
	id<HagadaViewHebDataSource> dataSource;
	CGSize pageSize;
}

@property (nonatomic, assign) CGSize pageSize;
@property (assign) id<HagadaViewHebDataSource> dataSource;

- (id) initWithPageSize:(CGSize)aPageSize;
- (CGImageRef) cachedImageForPageIndex:(NSUInteger)pageIndex;
- (void) precacheImageForPageIndex:(NSUInteger)pageIndex;
- (void) minimizeToPageIndex:(NSUInteger)pageIndex viewMode:(HagadaViewHebMode)viewMode;
- (void) flush;

@end
