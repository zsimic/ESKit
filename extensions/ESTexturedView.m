//  ESTexturedView - A view that allows to show a movable texture in its background
//  Created by Zoran Simic on 3/28/10. Copyright 2010 esmiler.com. All rights reserved.

#import "ESTexturedView.h"

@implementation ESTexturedView

@synthesize view;
@synthesize texture;

// Initialization
// --------------
- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		textureRect.origin.y = -200;
	}
	return self;
}

- (void)dealloc {
	ESRELEASE(view);
	ESRELEASE(texture);
	[super dealloc];
}

// Properties
// ----------
- (void)setView:(UIView *)pview {
	if (view!=pview) {
		[view removeFromSuperview];
		[view release];
		view = [pview retain];
		[self addSubview:pview];
		[self setNeedsLayout];
	}
}

- (void)setTexture:(UIImage *)ptexture {
	if (texture!=ptexture) {
		[texture release];
		texture = [ptexture retain];
		textureRect.size = texture.size;
		textureRect.origin.y = -200;
		[self setNeedsDisplay];
	}
}

// Composition
// -----------
//- (void)setFrame:(CGRect)pframe {
//	[super setFrame:pframe];
//	needsLayout = YES;
//	[self setNeedsLayout];
//}

- (void)layoutSubviews {
	contentRect = self.bounds;
	view.frame = contentRect;
}

- (void)setContentOffset:(CGFloat)poffset {
	if (poffset==prevContentY || texture==nil) return;
	textureRect.origin.y -= poffset - prevContentY;
	if (textureRect.origin.y>=0) {
		textureRect.origin.y -= 2*textureRect.size.height;
	} else if (textureRect.origin.y+4*textureRect.size.height<=contentRect.size.height) {
		textureRect.origin.y += 2*textureRect.size.height;
	}
	prevContentY = poffset;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	if (ctx==nil) return;
	CGContextSaveGState(ctx);
	CGContextClearRect(ctx, rect);
	if (texture!=nil) {
		//CGContextSetAlpha(ctx, 0.5f);
		CGContextScaleCTM(ctx, 1.0f, 1.0f);
		CGRect f = textureRect;
		CGContextDrawImage(ctx, f, texture.CGImage);
		f.origin.y += 2*f.size.height;
		if (f.origin.y <= rect.size.height) {
			CGContextDrawImage(ctx, f, texture.CGImage);
		}
		CGContextScaleCTM(ctx, 1.0f, -1.0f);
		CGContextDrawImage(ctx, CGRectMake(0, -f.origin.y, f.size.width, f.size.height), texture.CGImage);
		f.origin.y += f.size.height;
		if (f.origin.y <= rect.size.height) {
			f.origin.y += f.size.height;
			CGContextDrawImage(ctx, CGRectMake(0, -f.origin.y, f.size.width, f.size.height), texture.CGImage);
		}
	}
	CGContextRestoreGState(ctx);
}

// Ads
// ---
//#pragma mark ADBannerViewDelegate methods

@end
