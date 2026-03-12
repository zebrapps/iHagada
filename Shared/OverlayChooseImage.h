//
//  OverlayChooseImage.h
//  iHagada
//
//  Created by Yuval Tessone on 3/15/12.
//  Copyright 2012 www.zebrapps.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSonsViewController.h"

@class FourSonsViewController;

@interface OverlayChooseImage : UIViewController {
    FourSonsViewController *fourSonsViewController;    
}

@property (nonatomic, retain) FourSonsViewController *fourSonsViewController;

@end