//
//  CustomAlert.h
//  iStar
//
//  Created by Yuval Tessone on 12/1/11.
//  Copyright 2011 www.zebrapps.com All rights reserved. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface CustomAlert : UIAlertView
{
    
}

+ (void) setBackgroundColor:(UIColor *) background 
            withStrokeColor:(UIColor *) stroke;

@end

#pragma clang diagnostic pop