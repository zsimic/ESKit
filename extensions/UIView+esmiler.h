//  UIView+esmiler - Utility drawing routines for custom UIView descendants
//  Created by zoran on 11/19/08. Copyright 2009 esmiler.com. All rights reserved

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>
#import "UIColor+esmiler.h"

@interface UIView (esmiler)

void ESAddTriangle(CGContextRef ctx, CGPoint p1, CGPoint p2, CGPoint p3);
void ESAddRoundedRect(CGContextRef ctx, CGRect rect, float pcornerRadius);

//CGGradientRef ESGradientRadial(CGContextRef ctx, UIColor *c1);
//void ESFillGradientRadial(CGContextRef ctx, CGPoint p1, CGPoint p2, float r1, float r2, UIColor *c1);

BOOL ESIntersectsX(CGRect r, float x1, float x2);
BOOL ESIntersectsY(CGRect r, float y1, float y2);
BOOL ESIntersects(CGRect r, float x1, float y1, float x2, float y2);

@end
