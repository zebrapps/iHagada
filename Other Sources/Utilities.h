//
//  Utilities.h
//  Hagada
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect);
void IHAnalyticsLogScreen(NSString *screenName, NSString *pageTitle, NSString *screenClassName);
void IHAnalyticsLogAction(NSString *eventName, NSString *screenName, NSString *pageTitle, NSString *itemName);
