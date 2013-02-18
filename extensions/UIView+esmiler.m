// UIView+esmiler - Utility drawing routines for custom UIView descendants
// Created by zoran on 11/19/08. Copyright 2009 esmiler.com. All rights reserved

#import "UIView+esmiler.h"

@interface UIView (esmilerprivate)
CGFloat ESchecked(CGFloat value);
@end


@implementation UIView (esmiler)

void ESAddTriangle(CGContextRef ctx, CGPoint p1, CGPoint p2, CGPoint p3) {
	CGContextBeginPath(ctx);
	CGContextMoveToPoint(ctx, p1.x, p1.y);
	CGContextAddLineToPoint(ctx, p2.x, p2.y);
	CGContextAddLineToPoint(ctx, p3.x, p3.y);
	CGContextClosePath(ctx);
}

void ESAddRoundedRect(CGContextRef ctx, CGRect rect, float pcornerRadius) {
	if (pcornerRadius <= 2.0) {
		CGContextAddRect(ctx, rect);
	} else {
		float x_left = rect.origin.x;
		float x_left_center = x_left + pcornerRadius;
		float x_right_center = x_left + rect.size.width - pcornerRadius;
		float x_right = x_left + rect.size.width;
		float y_top = rect.origin.y;
		float y_top_center = y_top + pcornerRadius;
		float y_bottom_center = y_top + rect.size.height - pcornerRadius;
		float y_bottom = y_top + rect.size.height;
		/* Begin! */
		CGContextBeginPath(ctx);
		CGContextMoveToPoint(ctx, x_left, y_top_center);
		/* First corner */
		CGContextAddArcToPoint(ctx, x_left, y_top, x_left_center, y_top, pcornerRadius);
		CGContextAddLineToPoint(ctx, x_right_center, y_top);
		/* Second corner */
		CGContextAddArcToPoint(ctx, x_right, y_top, x_right, y_top_center, pcornerRadius);
		CGContextAddLineToPoint(ctx, x_right, y_bottom_center);
		/* Third corner */
		CGContextAddArcToPoint(ctx, x_right, y_bottom, x_right_center, y_bottom, pcornerRadius);
		CGContextAddLineToPoint(ctx, x_left_center, y_bottom);
		/* Fourth corner */
		CGContextAddArcToPoint(ctx, x_left, y_bottom, x_left, y_bottom_center, pcornerRadius);
		CGContextAddLineToPoint(ctx, x_left, y_top_center);
		/* Done */
		CGContextClosePath(ctx);
	}
}

//CGGradientRef ESGradientRadial(CGContextRef ctx, UIColor *c1) {
//	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//	CGFloat r = c1.red;
//	CGFloat g = c1.green;
//	CGFloat b = c1.blue;
//	CGFloat a = c1.alpha;
//	CGFloat colors[] = {
//		ESchecked(r), ESchecked(g), ESchecked(b), a,
//		ESchecked(r - 0.1f), ESchecked(g - 0.1f), ESchecked(b - 0.1f), a,
//		ESchecked(r - 0.3f), ESchecked(g - 0.3f), ESchecked(b - 0.3f), a,
//		ESchecked(r - 0.5f), ESchecked(g - 0.5f), ESchecked(b - 0.5f), a,
//	};
//	CGFloat locations[] = { 0.0f, 0.2f, 0.6f, 1.0f };
//	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, locations, 4);
//	CGColorSpaceRelease(rgb);
//	return gradient;
//}

//void ESFillGradientRadial(CGContextRef ctx, CGPoint p1, CGPoint p2, float r1, float r2, UIColor *c1) {
//	CGGradientRef gradient = ESGradientRadial(ctx, c1);
//	CGContextDrawRadialGradient(ctx, gradient, p1, r1, p2, r2, 0);
//	CGGradientRelease(gradient);
//}

BOOL ESIntersectsX(CGRect r, float x1, float x2) {
	if (CGRectGetMaxX(r) < (x1 < x2) ? x1 : x2) return NO;
	if (CGRectGetMinX(r) > (x1 > x2) ? x1 : x2) return NO;
	return YES;
}

BOOL ESIntersectsY(CGRect r, float py1, float py2) {
	if (CGRectGetMaxY(r) < (py1 < py2) ? py1 : py2) return NO;
	if (CGRectGetMinY(r) > (py1 > py2) ? py1 : py2) return NO;
	return YES;
}

BOOL ESIntersects(CGRect r, float px1, float py1, float px2, float py2) {
	return (ESIntersectsX(r, px1, px2) && ESIntersectsY(r, py1, py2));
}

@end
