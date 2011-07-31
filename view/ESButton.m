//
//  ESButton.m
//  Simplified button, less verbose than UIButton
//
//  Created by zoran on 12/28/08.
//  Copyright 2008 eSmiler.com. All rights reserved.
//

#import "ESButton.h"

@implementation ESButton

@synthesize text;
@synthesize image;
@synthesize font;
@synthesize color;
@synthesize bgColor;
@synthesize highlightColor;
@synthesize delegate;
@synthesize action;
@synthesize gradient;
@synthesize cornerRadius;
@synthesize forwardTouches;
@synthesize data;

// --------------
// Initialization
// --------------
+ (id) withDelegate:(id)pdelegate action:(SEL)paction {
	ESButton *b = ESAUTO([[ESButton alloc] init]);
	b.delegate = pdelegate;
	b.action = paction;
	return b;
}

- (id) initWithFrame:(CGRect)pframe {
    if ((self = [super initWithFrame:pframe])) {
		self.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
		self.color = [UIColor cBlack];
		self.highlightColor = [UIColor cHighlightBlue];
		self.bgColor = [UIColor cButton];
		gradient = [[ESGradient alloc] init];
		cornerRadius = 6.0f;
		self.contentMode = UIViewContentModeRedraw;
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)dealloc {
	ESRELEASE(text);
	ESRELEASE(image);
	ESRELEASE(font);
	ESRELEASE(color);
	ESRELEASE(bgColor);
	ESRELEASE(highlightColor);
	ESRELEASE(gradient);
	delegate = nil;
	data = nil;
    [super dealloc];
}

// ----------
// Properties
// ----------
- (void) setText:(NSString *)ptext {
	if (text != ptext) {
		[text release];
		text = [ptext retain];
		[self setNeedsLayout];
	}
}

- (void)setImage:(UIImage *)pimage {
	if (image != pimage) {
		[image release];
		image = [pimage retain];
		[self setNeedsDisplay];
	}
}

- (void) setBgColor:(UIColor *)pcolor {
	if (bgColor != pcolor) {
		[bgColor release];
		bgColor = [pcolor retain];
		[self setNeedsDisplay];
	}
}

- (void) setColor:(UIColor *)pcolor {
	if (color != pcolor) {
		[color release];
		color = [pcolor retain];
		[self setNeedsDisplay];
	}
}

- (void)setGradient:(ESGradient *)pgradient {
	if (gradient != pgradient) {
		[gradient release];
		gradient = [pgradient retain];
		[self setNeedsDisplay];
	}
}

//----------------------
// Touch event handling
//----------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (forwardTouches) [self.nextResponder touchesBegan:touches withEvent:event];
	if (isTouching) return;
	UITouch *touch = [touches anyObject];
	if (touch.view != self) return;
	isTouching = YES;
	startTouch = [touch locationInView:self];
	[self setNeedsDisplay];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (forwardTouches) [self.nextResponder touchesMoved:touches withEvent:event];
	if (!isTouching) return;
	UITouch *touch = [touches anyObject];
	CGPoint p = [touch locationInView:self];
	if (fabs(p.y - startTouch.y) >= self.bounds.size.height * 2.5) {
		[self touchesCancelled:touches withEvent:event];
		return;
	}
	if (fabs(p.x - startTouch.x) >= fmaxf(100, self.bounds.size.width * 1.9f)) {
		[self touchesCancelled:touches withEvent:event];
		return;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (forwardTouches) [self.nextResponder touchesEnded:touches withEvent:event];
	if (!isTouching) return;
	if (delegate != nil && [delegate respondsToSelector:action]) [delegate performSelector:action withObject:self];
	isTouching = NO;
	[self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (forwardTouches) [self.nextResponder touchesCancelled:touches withEvent:event];
	isTouching = NO;
	[self setNeedsDisplay];
}

- (void)cancelTouching {
	if (!isTouching) return;
	isTouching = NO;
	[self setNeedsDisplay];
}

// -------
// Drawing
// -------
- (CGSize) sizeThatFits:(CGSize)size {
	CGSize s = textRect.size;
	s.width = s.width + 2;
	s.height = s.height + 2;
	return s;
}

- (void) layoutSubviews {
	CGRect b = self.bounds;
	if (b.size.width < 1) return;
	textRect.size = [text sizeWithFont:font];
	textRect.origin.x = b.origin.x + (b.size.width - textRect.size.width) / 2;
	textRect.origin.y = b.origin.y + (b.size.height - textRect.size.height) / 2;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	if (ctx==nil) return;
	CGContextSaveGState(ctx);
	CGRect b = self.bounds;
	CGRect b1 = b;
	b1.origin.x += 1; b1.size.width -= 2;
	b1.origin.y += 1; b1.size.height -= 2;
	ESAddRoundedRect(ctx, b, cornerRadius);
	CGContextClip (ctx);
	// Fill background with gradient
	UIColor *cbg = bgColor;
	if (isTouching) {
		if (highlightColor != nil) {
			cbg = highlightColor;
		} else if (bgColor != nil) {
			float bs =(bgColor.brightness < 0.3) ? -1.0f : 1.0f;
			cbg = [bgColor emphasized:-bs*100.0f];
		}
	}
	[gradient draw:ctx rect:b color:cbg];
	if (image != nil) {
		CGRect ib = b;
		CGSize is = image.size;
		if (is.width<=b.size.width && is.height<=b.size.height) {
			ib.size = is;
		} else {
			ib.size.width = b.size.height - 4;
			ib.size.height = ib.size.width;
		}
		ib.origin.x = (b.size.width - ib.size.width) / 2;
		ib.origin.y = (b.size.height - ib.size.height) / 2;
		[image drawInRect:ib];
	}
	if (text != nil) {
		// Draw button text
		[color set];
		[text drawAtPoint:textRect.origin withFont:font];
	}
	// Done
	CGContextRestoreGState(ctx);
}

@end
