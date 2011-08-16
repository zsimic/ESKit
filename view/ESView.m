//  ESView - Simple view with an optional gradient filled background and an optional text label
//  Created by Zoran Simic on 9/21/09. Copyright 2009 esmiler.com. All rights reserved.

#import "ESView.h"

@implementation ESView

@synthesize gradient;
@synthesize cornerRadius;

// Initialization
// --------------
- (void)initialize {
	gradient = [[ESGradient alloc] init];
	cornerRadius = 0;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self initialize];
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
		[self initialize];
    }
    return self;
}

- (void)dealloc {
	ESRELEASE(gradient);
	ESRELEASE(textLabel);
    [super dealloc];
}

// Properties
// ----------
- (NSString *)text {
	return textLabel.text;
}

- (void)setText:(NSString *)ptext {
	if (textLabel == nil) textLabel = [[UILabel alloc] init];
	textLabel.text = ptext;
	[self setNeedsLayout];
}

- (void)setGradient:(ESGradient *)pgradient {
	if (gradient != pgradient) {
		gradient = pgradient;
		[self setNeedsDisplay];
	}
}

// Composition
// -----------
- (void)drawRect:(CGRect)rect {
	//	if (color == nil) return;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	if (ctx == nil) return;
	CGRect b = self.bounds;
	CGContextSaveGState(ctx);
	[gradient draw:ctx rect:b color:self.backgroundColor];
	CGContextRestoreGState(ctx);
}

@end
