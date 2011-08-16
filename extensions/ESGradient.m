//  ESGradient - Simplified use cases for linear gradients
//  Created by Zoran Simic on 9/19/09. Copyright 2009 esmiler.com. All rights reserved.

#import "ESGradient.h"

@implementation ESGradient

@synthesize style;
@synthesize force;

// --------------
// Initialization
// --------------
- (id)init {
    if ((self = [super init])) {
		style = ESGradientStylePlastic;
		force = 10;
    }
    return self;
}

// ---------
// Gradients
// ---------
#define ES_COLOR_CHECKED(value)	(value < 0.0) ? 0.0f : ((value > 1.0) ? 1.0f : value)

- (CGGradientRef) newGradient:(CGContextRef)pctx color:(UIColor *)pcolor {
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat r = pcolor.red;
	CGFloat g = pcolor.green;
	CGFloat b = pcolor.blue;
	CGFloat a = pcolor.alpha;
	CGFloat brightness = (r + g + b) / 3;
	CGFloat e0, e1, e2, e3, e4, p1, p3;
	if (style == ESGradientStyleTube) {
		// Tube
		if (brightness < 0.3) {
			e0 = 0.3f;
			e1 = 0.1f;	p1 = 0.15f;
			e2 = 0.0f;
			e3 = -0.05f;	p3 = 0.7f;
			e4 = -0.15f;
		} else {
			e0 = 0.2f;
			e1 = 0.07f;	p1 = 0.4f;
			e2 = 0;
			e3 = -0.1f;	p3 = 0.8f;
			e4 = -0.3f;
		}
	} else {// if (style == ESGradientStylePlastic) {
		// Plastic
		if (brightness < 0.2) {
			e0 = 0.46f;
			e1 = 0.14f;
			e2 = 0.04f;
			e3 = 0.04f;
			e4 = 0.0f;
		} else 	if (brightness < 0.8) {
			e0 = 0.26f;
			e1 = 0.08f;
			e2 = 0.0f;
			e3 = 0.0f;
			e4 = 0.0f;
		} else {
			e0 = -0.26f;
			e1 = -0.08f;
			e2 = 0.0f;
			e3 = 0.0f;
			e4 = 0.0f;
		}
		if (force<0) {
			CGFloat t = e0; e0 = e4; e4 = t; 
			t = e1; e1 = e2; e2 = t; 
		}
		p1 = 0.5f-fabsf(force)/200;
		p3 = 0.5f+fabsf(force)/200;
	}
	CGFloat colors[] = {
		ES_COLOR_CHECKED(r+e0), ES_COLOR_CHECKED(g+e0), ES_COLOR_CHECKED(b+e0), a,
		ES_COLOR_CHECKED(r+e1), ES_COLOR_CHECKED(g+e1), ES_COLOR_CHECKED(b+e1), a,
		ES_COLOR_CHECKED(r+e2), ES_COLOR_CHECKED(g+e2), ES_COLOR_CHECKED(b+e2), a,
		ES_COLOR_CHECKED(r+e3), ES_COLOR_CHECKED(g+e3), ES_COLOR_CHECKED(b+e3), a,
		ES_COLOR_CHECKED(r+e4), ES_COLOR_CHECKED(g+e4), ES_COLOR_CHECKED(b+e4), a,
	};
	CGFloat locations[] = { 0.0f, p1, 0.5f, p3, 1.0f };
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, locations, 5);
	CGColorSpaceRelease(rgb);
	return gradient;
}

// -----------
// Composition
// -----------
- (void)draw:(CGContextRef)pctx rect:(CGRect)prect color:(UIColor *)pcolor {
	if (style==ESGradientStyleNone) {
		[pcolor set];
		CGContextAddRect(pctx, prect);
		CGContextFillPath(pctx);
	} else {
		CGGradientRef gradient = [self newGradient:pctx color:pcolor];
		CGContextDrawLinearGradient(pctx, gradient, prect.origin, CGPointMake(prect.origin.x, prect.origin.y + prect.size.height), 0);
		CGGradientRelease(gradient);
	}
}

// Properties
// ----------
- (NSString *)styleName {
	switch (style) {
		case ESGradientStyleNone:	return @"none";		break;
		case ESGradientStyleTube:	return @"tube";		break;
		case ESGradientStylePlastic:	return @"plastic";		break;
		default: return nil; break;
	}
}

- (NSString *)description {
	return ESFS(@"style=%@, force=%.1f", self.styleName, force);
}

@end
