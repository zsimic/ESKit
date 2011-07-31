//
//  ESTableView.m
//  Currency Master
//
//  Created by Zoran Simic on 3/26/10.
//  Copyright 2010 esmiler.com. All rights reserved.
//

#import "ESTableView.h"

@implementation ESTableView

@synthesize backgroundImage;

- (void)drawRect:(CGRect)rect {
	[backgroundImage drawAtPoint:CGPointZero];
	[super drawRect:rect];
}

- (void)dealloc {
	[backgroundImage release];
	[super dealloc];
}

- (void)setBackgroundImage:(UIImage *)pimage {
	if (backgroundImage!=pimage) {
		[backgroundImage release];
		backgroundImage = [pimage retain];
		self.backgroundColor = [UIColor clearColor];
		[self setNeedsDisplay];
//		UIImageView *im = [[UIImageView alloc] initWithImage:pimage];
//		[self addSubview:im];
//		[self sendSubviewToBack:im];
//		[im release];
	}
}

@end
