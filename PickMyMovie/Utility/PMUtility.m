//
//  Utility.m
//  PickMyMovie
//
//  Created by Niklas Persson on 11/19/14.
//  Copyright (c) 2014 NPFLASH. All rights reserved.
//


#import "PMUtility.h"
#import "MBProgressHUD.h"

#define BlueColor 0x00688B
#define GraceTime 0.2f
#define MinShowTime 0.8
#define NewLine @"\n"
/*
 
 This class have different methods and color hex decimals to make things easier, and that can be reached by all the classes, if the methods are needed.
 */

@implementation PMUtility

+ (void)hideLoaderWithView:(UIView *)view {
    
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

//show loader with a default text
+ (void)showLoaderWithView:(UIView *)view {
    MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:view animated:YES];
	HUD.detailsLabelText = [NSString stringWithFormat:NSLocalizedString(@"UPDATING_DATA", nil),NewLine];
	HUD.square = YES;
    HUD.color = [PMUtility colorWithHexValue:BlueColor];
    HUD.graceTime = GraceTime;
    HUD.minShowTime = MinShowTime;
    HUD.animationType= MBProgressHUDAnimationFade;
}

//show a loader with a specific text
+(void)showCustomTextLoaderWithView:(UIView *)view detailsLabelText:(NSString *)detailsLabeltext{
    MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:view animated:YES];
	HUD.detailsLabelText = detailsLabeltext;
	HUD.square = YES;
    HUD.color = [PMUtility colorWithHexValue:BlueColor];
    HUD.minShowTime = MinShowTime;
    HUD.animationType= MBProgressHUDAnimationFade;
    
}


// Return the correct string for iso code // give hexdecimal and it returns the correct color
+ (UIColor *)colorWithHexValue:(int)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}


@end

