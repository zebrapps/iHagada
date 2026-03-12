//
//  OverlayChooseTemplate.h
//  iHagada
//
//  Created by Yuval Tessone on 3/15/12.
//  Copyright 2012 www.zebrapps.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSonsChooseThemeViewController.h"

@class FourSonsChooseThemeViewController;

@interface OverlayChooseTemplate : UIViewController {
    FourSonsChooseThemeViewController *fourSonsChooseThemeViewController;    
}

@property (nonatomic, retain) FourSonsChooseThemeViewController *fourSonsChooseThemeViewController;

@end