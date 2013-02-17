//  ESTableView - Table View with a customizable background image
//  Created by Zoran Simic on 3/26/10. Copyright 2010 esmiler.com. All rights reserved.

#import "ESTableView.h"
#import "esmiler.h"

@implementation ESTableView

@synthesize backgroundImage;

- (void)drawRect:(CGRect)rect {
	[backgroundImage drawAtPoint:CGPointZero];
	[super drawRect:rect];
}

- (void)setBackgroundImage:(UIImage *)pimage {
	if (backgroundImage!=pimage) {
		backgroundImage = pimage;
		self.backgroundColor = [UIColor clearColor];
		[self setNeedsDisplay];
	}
}

@end
