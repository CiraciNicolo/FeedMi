//
//  NCLabel.m
//  thefirstcalendar
//
//  Created by 150UP on 05/03/14.
//  Copyright (c) 2014 150UP. All rights reserved.
//

#import "NCLabel.h"

@implementation NCLabel

- (void) drawTextInRect:(CGRect)rect {
    
	if(_verticalAlignment == UIControlContentVerticalAlignmentTop || _verticalAlignment == UIControlContentVerticalAlignmentBottom)	{

		//	If one line, we can just use the lineHeight, faster than querying sizeThatFits
		const CGFloat height = ((self.numberOfLines == 1) ? ceilf(self.font.lineHeight) : [self sizeThatFits:self.frame.size].height);
        
		if(height < self.frame.size.height)
			rect.origin.y = ((self.frame.size.height - height) / 2.0f) * ((_verticalAlignment == UIControlContentVerticalAlignmentTop) ? -1.0f : 1.0f);
	}
    
	[super drawTextInRect:rect];
}

- (void) setVerticalAlignment:(UIControlContentVerticalAlignment)verticalAlignment {
	
    _verticalAlignment = verticalAlignment;
    [self setNeedsDisplay];
}

@end
