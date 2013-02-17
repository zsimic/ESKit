// ESHeaderView - View designed to be used as table header or footer
// Created by Zoran Simic on 9/13/09. Copyright 2009 esmiler.com. All rights reserved

#import "ESHeaderView.h"
#import "UIColor+esmiler.h"

@implementation ESHeaderView

@synthesize label;
@synthesize xMargin;
@synthesize yMargin;
@synthesize gradient;
@synthesize cornerRadius;

// Initialization
// --------------
- (void)initialize {
	label = [[UILabel alloc] init];
	self.backgroundColor = [UIColor clearColor];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor cGray:0.2f];
	label.shadowOffset = CGSizeMake(1, 1);
	label.opaque = YES;
	self.opaque = YES;
	[self addSubview:label];
	xMargin = 16;
	yMargin = 4;
}

//- (id)initWithFrame:(CGRect)frame {
//	if (self = [super initWithFrame:frame]) {
//		[self initialize];
//	}
//	return self;
//}

//- (id)init {
//	if (self = [super init]) {
//		[self initialize];
//	}
//	return self;
//}

// Properties
// ----------
- (NSString *)text {
	return label.text;
}

- (void) setText:(NSString *)ptext {
	if (label==nil) [self initialize];
	label.text = ptext;
}

- (UIColor *)textColor {
	return label.textColor;
}

- (void)setTextColor:(UIColor *)pcolor {
	ES_CHECK_NR(label!=nil,@"No text in ESHeaderView, can't set color")
	label.textColor = pcolor;
	label.shadowColor = [pcolor withAlpha:0.6f];
}

- (CGSize)shadowOffset {
	return label.shadowOffset;
}

- (void)setShadowOffset:(CGSize)psize {
	ES_CHECK_NR(label!=nil,@"No text in ESHeaderView, can't set shadow offset")
	label.shadowOffset = psize;
}

- (void)setGradient:(ESGradient *)pgradient {
	ES_CHECK_NR(label!=nil,@"No text in ESHeaderView, can't set gradient")
	if (gradient != pgradient) {
		gradient = pgradient;
		[self setNeedsDisplay];
	}
}

// Composition
// ----------
- (void) layoutSubviews {
	if (label==nil) return;
	CGRect b = self.bounds;
	if (b.size.width < 1) return;
	CGSize ts = [self.text sizeWithFont:label.font];
	b.origin.x = xMargin >= 0 ? xMargin : b.size.width - ts.width + xMargin;
	b.origin.y = yMargin >= 0 ? yMargin : b.size.height - ts.height + yMargin;
	b.size.width -= b.origin.x * 2;
	b.size.height = ts.height;
	label.frame = b;
}

- (void)drawRect:(CGRect)rect {
	if (gradient==nil || label==nil) return;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	if (ctx == nil) return;
	CGRect b = self.bounds;
	CGContextSaveGState(ctx);
	[gradient draw:ctx rect:b color:self.backgroundColor];
	CGContextRestoreGState(ctx);
}

@end
