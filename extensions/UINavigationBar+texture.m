//  UINavigationBar+texture - Allows to easily set a texture to a UINavigationBar
//  Created by Zoran Simic on 3/25/10. Copyright 2010 esmiler.com. All rights reserved.

#import "UINavigationBar+texture.h"
#import "esmiler.h"

@interface UIView (EsAddition)
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
@end

@implementation UINavigationBar (EsmilerTexture)

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	UIImage *image = [self customBgImage:nil set:NO];
	if (image==nil) {
		[super drawLayer:layer inContext:ctx];
	} else {
		CGContextScaleCTM(ctx, 1.0f, -1.0f);
		CGContextDrawImage(ctx, CGRectMake(0, -image.size.height, self.frame.size.width, self.frame.size.height), image.CGImage);
	}
}

- (UIImage *)customBgImage:(UIImage *)pimage set:(BOOL)pset {
	static UIImage *stored_image = nil;
	if (pset) {
		if (stored_image!=pimage) {
			ESRELEASE(stored_image);
			stored_image = ESRETAIN(pimage);
			[self setNeedsDisplay];
		}
	}
	return stored_image;
}

@end
