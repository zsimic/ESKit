// UIColor+eSmiler - Adds some convenience functions to UIColor
// Created by zoran on 11/19/08. Copyright 2009 esmiler.com. All rights reserved

#import <UIKit/UIKit.h>
#import "esmiler.h"

@interface UIColor (esmiler)

@property (nonatomic, readonly) float red;
@property (nonatomic, readonly) float green;
@property (nonatomic, readonly) float blue;
@property (nonatomic, readonly) float alpha;
@property (nonatomic, readonly) float brightness;
@property (nonatomic, readonly) NSString *text;

+ (UIColor *)rgb:(int)code;
+ (UIColor *)rgb:(int)code alpha:(float)alpha;
+ (UIColor *)red:(int)pred green:(int)pgreen blue:(int)pblue;
+ (UIColor *)red:(int)pred green:(int)pgreen blue:(int)pblue alpha:(float)palpha;

+ (UIColor *)cGray:(float)pvalue;
+ (UIColor *)cGray:(float)pvalue alpha:(float)palpha;
+ (UIColor *)cWhite;
+ (UIColor *)cBlack;
+ (UIColor *)cBlue;
+ (UIColor *)cDarkBlue;
+ (UIColor *)cCyan;
+ (UIColor *)cYellow;
+ (UIColor *)cOrange;
+ (UIColor *)cRed;
+ (UIColor *)cDarkRed;
+ (UIColor *)cGreen;
+ (UIColor *)cDarkGreen;
+ (UIColor *)cSettings;
+ (UIColor *)cButton;
+ (UIColor *)cHighlightBlue;

- (UIColor *) withAlpha:(float)alpha;							// Same color, but with specified alpha (from 0 to 1)
- (UIColor *) emphasized:(float)amount;							// Color with all its components emphasized by 'amount' (from -255 to +255)
- (UIColor *) emphasized:(float)pamount alpha:(float)palpha;
- (UIColor *) blended:(UIColor *)other;							// Blended with other color by specified amount (from -100 to +100)
- (UIColor *) blended:(UIColor *)other amount:(float)pamount;
- (UIColor *) blended:(UIColor *)other amount:(float)pamount alpha:(float)palpha;

@end
