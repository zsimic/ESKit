// UIColor+eSmiler - Adds some convenience functions to UIColor
// Created by zoran on 11/19/08. Copyright 2009 esmiler.com. All rights reserved

#import "UIColor+esmiler.h"

@interface UIColor (esmilerprivate)
float checked_rgb(float value);
@end

@implementation UIColor (esmiler)

+ (UIColor *)rgb:(int)code {
	return [UIColor rgb:code alpha:1.0f];
}

+ (UIColor *)rgb:(int)code alpha:(float)alpha {
	float r = ((code & 0xff0000) >> 16) / 255.0f;
	float g = ((code & 0xff00) >> 8) / 255.0f;
	float b = (code & 0xff) / 255.0f;
	return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)red:(int)pred green:(int)pgreen blue:(int)pblue {
	return [UIColor red:pred green:pgreen blue:pblue alpha:1.0f];
}

+ (UIColor *)red:(int)pred green:(int)pgreen blue:(int)pblue alpha:(float)palpha {
	return [UIColor colorWithRed:pred/255.0f green:pgreen/255.0f blue:pblue/255.0f alpha:palpha];
}

+ (UIColor *)cGray:(float)pvalue alpha:(float)palpha{
	return [UIColor red:(int)(pvalue*255) green:(int)(pvalue*255) blue:(int)(pvalue*255) alpha:palpha];
}

+ (UIColor *)cGray:(float)pvalue { return [UIColor cGray:pvalue alpha:1.0f]; }
+ (UIColor *)cWhite { return [UIColor red:255 green:255 blue:255]; }
+ (UIColor *)cBlack { return [UIColor red:0 green:0 blue:0]; }
+ (UIColor *)cBlue { return [UIColor red:0 green:0 blue:255]; }
+ (UIColor *)cDarkBlue { return [UIColor red:0 green:0 blue:0x90]; }
+ (UIColor *)cCyan { return [UIColor red:0 green:255 blue:255]; }
+ (UIColor *)cYellow { return [UIColor red:255 green:255 blue:0]; }
+ (UIColor *)cOrange { return [UIColor red:0xFF green:0x80 blue:0x40]; }
+ (UIColor *)cRed { return [UIColor red:255 green:0 blue:0]; }
+ (UIColor *)cDarkRed { return [UIColor red:0xA0 green:0 blue:0]; }
+ (UIColor *)cGreen { return [UIColor red:0 green:240 blue:0]; }
+ (UIColor *)cDarkGreen { return [UIColor red:0 green:0x80 blue:0]; }
+ (UIColor *)cSettings { return [UIColor red:136 green:155 blue:179]; }
+ (UIColor *)cButton { return [UIColor red:128 green:151 blue:185]; }
+ (UIColor *)cHighlightBlue { return [UIColor red:2 green:119 blue:239]; }

- (float)red { return ((float *)CGColorGetComponents([self CGColor]))[0]; }
- (float)green { return ((float *)CGColorGetComponents([self CGColor]))[1]; }
- (float)blue { return ((float *)CGColorGetComponents([self CGColor]))[2]; }
- (float)alpha { return ((float *)CGColorGetComponents([self CGColor]))[3]; }
- (float)brightness { return (self.red + self.green + self.blue) / 3; }

- (NSString *)text {
	return ESFS(@"rgba:%1.0f %1.0f %1.0f %1.0f", self.red*255, self.green*255, self.blue*255, self.alpha*255);
}

// Same color, but with specified alpha (from 0 to 1)
- (UIColor *) withAlpha:(float)alpha {
	return [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:alpha];
}

// 'value' bound to 0-1 range
float checked_rgb(float value) {
	if (value > 1.0) return 1.0f;
	if (value < 0.0) return 0.0f;
	return value;
}

// Color with all its components emphasized by 'amount' (from -255 to +255)
-(UIColor *)emphasized:(float)pamount { return [self emphasized:pamount alpha:self.alpha]; }
-(UIColor *)emphasized:(float)pamount alpha:(float)palpha {
	float *c = (float *)CGColorGetComponents([self CGColor]);
	float d = pamount / 255.0f;
	float r = checked_rgb(c[0]+d);
	float g = checked_rgb(c[1]+d);
	float b = checked_rgb(c[2]+d);
	return [UIColor colorWithRed:r green:g blue:b alpha:checked_rgb(palpha)];
}

// Blended with other color by specified amount (from -255 to +255)
-(UIColor *)blended:(UIColor *)other { return [self blended:other amount:0.0f alpha:self.alpha]; }
-(UIColor *)blended:(UIColor *)other amount:(float)pamount { return [self blended:other amount:pamount alpha:self.alpha]; }
-(UIColor *)blended:(UIColor *)other amount:(float)pamount alpha:(float)palpha {
	float d = pamount / 255.0f;
	if (d < -1.0f) d = -1.0f;
	if (d > 1.0f) d = 1.0f;
	float r = checked_rgb(((1 - d) * self.red + (1 + d) * other.red) / 2);
	float g = checked_rgb(((1 - d) * self.green + (1 + d) * other.green) / 2);
	float b = checked_rgb(((1 - d) * self.blue + (1 + d) * other.blue) / 2);
	return [UIColor colorWithRed:r green:g blue:b alpha:checked_rgb(palpha)];
	return self;
}

@end
