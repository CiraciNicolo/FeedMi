//
//  NSString+NCString.m
//  FeedMi
//
//  Created by Nicolò Ciraci on 11/04/15.
//  Copyright (c) 2015 Nicolò Ciraci. All rights reserved.
//

#import "NSString+NCString.h"

@implementation NSString (NCString)

-(NSString *)stringByStrippingHTML {
    
    NSRange range;
    NSString *string = [self copy];
    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        
        string = [string stringByReplacingCharactersInRange:range withString:@""];
    }
    return string;
}

@end
