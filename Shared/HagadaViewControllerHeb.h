//
//  HagadaViewController.h
//  iHagada
//
//  Created by Yuval Tessone on 1/15/11.
//  Copyright 2011 Zebrapps.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HagadaViewHeb.h"

@interface HagadaViewControllerHeb : UIViewController <HagadaViewHebDataSource, HagadaViewHebDelegate> {
	HagadaViewHeb *hagadaView;
}

@end
