//
//  Utilities.m
//  Hagada
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import "Utilities.h"
#import <Foundation/Foundation.h>
#if __has_include(<FirebaseAnalytics/FIRAnalytics.h>)
#import <FirebaseAnalytics/FIRAnalytics.h>
#endif

CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect) {
	CGFloat scaleFactor = MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
	CGAffineTransform translation = 
	CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x, 
									 (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	return CGAffineTransformConcat(scale, translation);
}

static NSString *IHAnalyticsTrimmedString(NSString *value, NSUInteger maxLength) {
    if (![value isKindOfClass:[NSString class]]) {
        return nil;
    }

    NSString *trimmedValue = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([trimmedValue length] == 0) {
        return nil;
    }

    if ([trimmedValue length] > maxLength) {
        return [trimmedValue substringToIndex:maxLength];
    }

    return trimmedValue;
}

static NSString *IHAnalyticsSanitizedEventName(NSString *value) {
    NSString *baseValue = [[IHAnalyticsTrimmedString(value, 64) lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    if ([baseValue length] == 0) {
        return @"app_action";
    }

    NSMutableString *eventName = [NSMutableString stringWithCapacity:[baseValue length]];
    NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz0123456789_"];
    BOOL lastCharacterWasUnderscore = NO;

    for (NSUInteger index = 0; index < [baseValue length]; index++) {
        unichar currentCharacter = [baseValue characterAtIndex:index];
        if ([allowedCharacters characterIsMember:currentCharacter]) {
            [eventName appendFormat:@"%C", currentCharacter];
            lastCharacterWasUnderscore = (currentCharacter == '_');
        } else if (!lastCharacterWasUnderscore) {
            [eventName appendString:@"_"];
            lastCharacterWasUnderscore = YES;
        }
    }

    while ([eventName hasPrefix:@"_"]) {
        [eventName deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    while ([eventName hasSuffix:@"_"]) {
        [eventName deleteCharactersInRange:NSMakeRange([eventName length] - 1, 1)];
    }

    if ([eventName length] == 0) {
        return @"app_action";
    }

    if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[eventName characterAtIndex:0]]) {
        [eventName insertString:@"e_" atIndex:0];
    }

    if ([eventName length] > 40) {
        [eventName deleteCharactersInRange:NSMakeRange(40, [eventName length] - 40)];
    }

    return eventName;
}

static NSMutableDictionary *IHAnalyticsBaseParameters(NSString *screenName, NSString *pageTitle) {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *safeScreenName = IHAnalyticsTrimmedString(screenName, 100);
    NSString *safePageTitle = IHAnalyticsTrimmedString(pageTitle, 100);

    if (safeScreenName != nil) {
        [parameters setObject:safeScreenName forKey:@"ih_screen_name"];
    }
    if (safePageTitle != nil) {
        [parameters setObject:safePageTitle forKey:@"ih_page_title"];
    }

    return parameters;
}

void IHAnalyticsLogScreen(NSString *screenName, NSString *pageTitle, NSString *screenClassName) {
#if __has_include(<FirebaseAnalytics/FIRAnalytics.h>)
    NSMutableDictionary *parameters = IHAnalyticsBaseParameters(screenName, pageTitle);
    NSString *safeScreenClassName = IHAnalyticsTrimmedString(screenClassName, 100);

    if ([parameters objectForKey:@"ih_screen_name"] == nil && safeScreenClassName == nil) {
        return;
    }

    if ([parameters objectForKey:@"ih_screen_name"] != nil) {
        [parameters setObject:[parameters objectForKey:@"ih_screen_name"] forKey:kFIRParameterScreenName];
    }
    if (safeScreenClassName != nil) {
        [parameters setObject:safeScreenClassName forKey:kFIRParameterScreenClass];
    }

    [FIRAnalytics logEventWithName:kFIREventScreenView parameters:parameters];
#else
    (void)screenName;
    (void)pageTitle;
    (void)screenClassName;
#endif
}

void IHAnalyticsLogAction(NSString *eventName, NSString *screenName, NSString *pageTitle, NSString *itemName) {
#if __has_include(<FirebaseAnalytics/FIRAnalytics.h>)
    NSString *safeEventName = IHAnalyticsSanitizedEventName(eventName);
    NSMutableDictionary *parameters = IHAnalyticsBaseParameters(screenName, pageTitle);
    NSString *safeItemName = IHAnalyticsTrimmedString(itemName, 100);

    if (safeItemName != nil) {
        [parameters setObject:safeItemName forKey:@"item_name"];
        [parameters setObject:safeItemName forKey:@"ih_button_name"];
    }

    [FIRAnalytics logEventWithName:safeEventName parameters:parameters];
#else
    (void)eventName;
    (void)screenName;
    (void)pageTitle;
    (void)itemName;
#endif
}
