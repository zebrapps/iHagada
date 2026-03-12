//
//  FacebookViewController.h
//  Appocalypse Now
//
//  Created by Yuval Tessone on 20/11/12.
//  Copyright (c) 2012 www.zebrapps.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GAI.h"
#import "GAITrackedViewController.h"

@interface FacebookViewController : GAITrackedViewController <MBProgressHUDDelegate>{
    AppDelegate *delegate;
    IBOutlet UITextView *textView;
    
    NSString *urlString;
    NSString *shelterName;
    id<GAITracker> tracker;
}
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSString *shelterName;
@property (nonatomic, weak) id<GAITracker> tracker;
@end
