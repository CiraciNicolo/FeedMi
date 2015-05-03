//
//  UIColor+NCColor.m
//  FeedMi
//
//  Created by Nicolò Ciraci on 11/04/15.
//  Copyright (c) 2015 Nicolò Ciraci. All rights reserved.
//

#import "UIColor+NCColor.h"

@implementation UIColor (NCColor)

+(instancetype)colorFromHex:(NSInteger)hex andAlpha:(CGFloat)alpha {
    
    CGFloat red = (hex & 0xFF0000) >> 16;
    CGFloat green = (hex & 0xFF00) >> 8;
    CGFloat blue = hex & 0xFF;
    
    return [self colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

@end
