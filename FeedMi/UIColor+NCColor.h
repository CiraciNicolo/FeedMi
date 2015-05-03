//
//  UIColor+NCColor.h
//  FeedMi
//
//  Created by Nicolò Ciraci on 11/04/15.
//  Copyright (c) 2015 Nicolò Ciraci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NCColor)

+(instancetype)colorFromHex:(NSInteger)hex andAlpha:(CGFloat)alpha;

@end
