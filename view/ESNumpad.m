//  ESNumpad - Numerical pad that automatically appears on bottom of screen (on top of current window)
//  Created by zoran on 12/13/08. Copyright 2008 esmiler.com. All rights reserved.

#import "ESNumpad.h"

@implementation ESNumpad

@synthesize textColor;
@synthesize numberFont;
@synthesize extrasFont;
@synthesize buttonFgColor;
@synthesize buttonBgColor;
@synthesize marginX;
@synthesize marginY;
@synthesize paddingX;
@synthesize paddingY;
@synthesize extraButtons;
@synthesize selectedCustomButton;
@synthesize forwardTouches;

// Initialization
//---------------
- (ESButton *)newButton {
	ESButton *pbutton = [[ESButton alloc] init];
	pbutton.color = textColor;
	pbutton.gradient.force = 30;
	pbutton.gradient.style = ESGradientStylePlastic;
	pbutton.cornerRadius = 8.0f;
	pbutton.opaque = YES;
	pbutton.delegate = self;
	pbutton.action = @selector(onButton:);
	[buttons addObject:pbutton];
	[self addSubview:pbutton];
	pbutton.hidden = YES;
	return pbutton;
}

- (ESButton *)newExtraButton:(NSString *)ptext {
	ESButton *pbutton = [self newButton];
	pbutton.text = ptext;
	pbutton.font = extrasFont;
	return pbutton;
}

- (ESButton *)newTextButton:(NSString *)ptext {
	ESButton *pbutton = [self newButton];
	pbutton.text = ptext;
	return pbutton;
}

- (ESButton *)newImageButton:(NSString *)pimageName {
	ESButton *pbutton = [self newButton];
	pbutton.image = [UIImage imageNamed:pimageName];
	return pbutton;
}

- (ESButton *)newNumberButton:(int)pnumber {
	ESButton *pbutton = [self newTextButton:ESFS(@"%i", pnumber)];
	pbutton.font = numberFont;
	return pbutton;
}

- (void)setButtonPosition:(ESButton *)pbutton ix:(float)ix iy:(float)iy lx:(float)lx ly:(float)ly {
	CGRect f = CGRectMake(ix, iy, lx, ly);
	int i = [buttons indexOfObjectIdenticalTo:pbutton];
	ES_CHECK_NR(i>=0 && i<buttons.count, @"Unknown button");
	pbutton.hidden = NO;
	bframes[i] = f;
}

- (void)setDefaults {				// This is to be called only by the 'init' routines
	operators = [[NSCharacterSet characterSetWithCharactersInString:@"+-x*/"] retain];
	lowPriorityOperators = [[NSCharacterSet characterSetWithCharactersInString:@"+-"] retain];
	highPriorityOperators = [[NSCharacterSet characterSetWithCharactersInString:@"x*/"] retain];
	textColor = [[UIColor cWhite] retain];
	numberFont = [[UIFont boldSystemFontOfSize:32] retain];
	if (extrasFont==nil) extrasFont = [[UIFont boldSystemFontOfSize:32] retain];
	self.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor rgb:0x161616];
	text = [[NSMutableString alloc] initWithCapacity:64];
	buttons = [[NSMutableArray alloc] initWithCapacity:17];
	self.opaque = YES;
	b0 = [self newNumberButton:0];
	b1 = [self newNumberButton:1];
	b2 = [self newNumberButton:2];
	b3 = [self newNumberButton:3];
	b4 = [self newNumberButton:4];
	b5 = [self newNumberButton:5];
	b6 = [self newNumberButton:6];
	b7 = [self newNumberButton:7];
	b8 = [self newNumberButton:8];
	b9 = [self newNumberButton:9];
	bdot = [self newTextButton:@"."];
	bdot.font = numberFont;
	bdel = [self newImageButton:@"backspace.png"];
	//bclear = [self newExtraButton:@"C"];
	//bclear.font = [UIFont boldSystemFontOfSize:25];
	bplus = [self newExtraButton:@"+"];
	bminus = [self newExtraButton:@"-"];
	bmult = [self newExtraButton:@"x"];
	bdiv = [self newExtraButton:@"/"];
	bequal = [self newExtraButton:@"="];
	marginX = 8;
	marginY = 6;
	paddingX = 12;
	paddingY = 6;
	extraButtons = 0;
	[self setButtonPosition:b0 ix:0 iy:3 lx:1 ly:1];
	[self setButtonPosition:b1 ix:0 iy:2 lx:1 ly:1]; 
	[self setButtonPosition:b2 ix:1 iy:2 lx:1 ly:1];
	[self setButtonPosition:b3 ix:2 iy:2 lx:1 ly:1];
	[self setButtonPosition:b4 ix:0 iy:1 lx:1 ly:1];
	[self setButtonPosition:b5 ix:1 iy:1 lx:1 ly:1];
	[self setButtonPosition:b6 ix:2 iy:1 lx:1 ly:1];
	[self setButtonPosition:b7 ix:0 iy:0 lx:1 ly:1];
	[self setButtonPosition:b8 ix:1 iy:0 lx:1 ly:1];
	[self setButtonPosition:b9 ix:2 iy:0 lx:1 ly:1];
	[self setButtonPosition:bdot ix:1 iy:3 lx:1 ly:1];
	[self setButtonPosition:bdel ix:2 iy:3 lx:1 ly:1];
	//[self setButtonPosition:bclear ix:3 iy:0 lx:1 ly:2];
	self.userInteractionEnabled = YES;
	hasCustomButtons = NO;
	isLayedOut = NO;
}

- (id)init {
	ES_CHECK(NO, nil, @"Don't call init, call initSimple of initFull");
	return nil;
}

- (id)initSimple {				// Simple numerical pad: no operations, just numbers, delete and clear
    if ((self = [super initWithFrame:CGRectMake(0, 0, 320, 180)])) {
		[self setDefaults];
	}
	return self;
}

- (id)initFull {				// Full numerical pad with +, -, *, /, = operations
    if ((self = [super initWithFrame:CGRectMake(0, 0, 320, 200)])) {
		extrasFont = [[UIFont boldSystemFontOfSize:32] retain];
		[self setDefaults];
		marginX = 6;
		marginY = 6;
		paddingX = 8;
		paddingY = 6;
		self.extraButtons = 5;
	}
	return self;
}

- (id)initWithExtras:(int)pextras {		// Simple numerical pad with curstom extra buttons on the right
    if ((self = [super initWithFrame:CGRectMake(0, 0, 320, 200)])) {
		extrasFont = [[UIFont boldSystemFontOfSize:24] retain];
		[self setDefaults];
		marginX = 5;
		marginY = 6;
		paddingX = 7;
		paddingY = 6;
		self.extraButtons = pextras;
		hasCustomButtons = YES;
	}
	return self;
}

- (void)dealloc {
	ESRELEASE(textColor);
	ESRELEASE(numberFont);
	ESRELEASE(extrasFont);
	ESRELEASE(buttonFgColor);
	ESRELEASE(buttonBgColor);
	ESRELEASE(buttons);
	ESRELEASE(text);
	ESRELEASE(b0);
	ESRELEASE(b1);
	ESRELEASE(b2);
	ESRELEASE(b3);
	ESRELEASE(b4);
	ESRELEASE(b5);
	ESRELEASE(b6);
	ESRELEASE(b7);
	ESRELEASE(b8);
	ESRELEASE(b9);
	ESRELEASE(bdot);
	ESRELEASE(bdel);
	//ESRELEASE(bclear);
	ESRELEASE(bplus);
	ESRELEASE(bminus);
	ESRELEASE(bmult);
	ESRELEASE(bdiv);
	ESRELEASE(bequal);
	ESRELEASE(operators);
	ESRELEASE(lowPriorityOperators);
	ESRELEASE(highPriorityOperators);
    [super dealloc];
}

// Properties
// ----------
- (void)setTextColor:(UIColor *)pcolor {
	if (textColor!=pcolor) {
		[textColor release];
		textColor = [pcolor retain];
		b0.color = pcolor;
		b1.color = pcolor;
		b2.color = pcolor;
		b3.color = pcolor;
		b4.color = pcolor;
		b5.color = pcolor;
		b6.color = pcolor;
		b7.color = pcolor;
		b8.color = pcolor;
		b9.color = pcolor;
		bdot.color = pcolor;
		bdel.color = pcolor;
		//bclear.color = pcolor;
		bplus.color = pcolor;
		bminus.color = pcolor;
		bmult.color = pcolor;
		bdiv.color = pcolor;
		bequal.color = pcolor;
	}
}

- (NSString *)decimalSeparator {
	return bdot.text;
}

- (void)setDecimalSeparator:(NSString *)psep {
	bdot.text = psep;
}

- (void)setNumberFont:(UIFont *)pfont {
	if (numberFont!=pfont) {
		[numberFont release];
		numberFont = [pfont retain];
		b0.font = pfont;
		b1.font = pfont;
		b2.font = pfont;
		b3.font = pfont;
		b4.font = pfont;
		b5.font = pfont;
		b6.font = pfont;
		b7.font = pfont;
		b8.font = pfont;
		b9.font = pfont;
		bdot.font = pfont;
	}
}

- (void)setExtrasFont:(UIFont *)pfont {
	if (extrasFont!=pfont) {
		[extrasFont release];
		extrasFont = [pfont retain];
		bplus.font = pfont;
		bminus.font = pfont;
		bmult.font = pfont;
		bdiv.font = pfont;
		bequal.font = pfont;
	}
}

- (ESGradientStyle)gradientStyle {
	return b0.gradient.style;
}

- (void)setGradientStyle:(ESGradientStyle)pstyle {
	b0.gradient.style = pstyle;
	b1.gradient.style = pstyle;
	b2.gradient.style = pstyle;
	b3.gradient.style = pstyle;
	b4.gradient.style = pstyle;
	b5.gradient.style = pstyle;
	b6.gradient.style = pstyle;
	b7.gradient.style = pstyle;
	b8.gradient.style = pstyle;
	b9.gradient.style = pstyle;
	bdot.gradient.style = pstyle;
	bdel.gradient.style = pstyle;
	//bclear.gradient.style = pstyle;
	bplus.gradient.style = pstyle;
	bminus.gradient.style = pstyle;
	bmult.gradient.style = pstyle;
	bdiv.gradient.style = pstyle;
	bequal.gradient.style = pstyle;
}

- (NSString *)text {
	return text;
}

- (void)setText:(NSString *)ptext {
	[text setString:ptext];
}

- (void)setExtraButtons:(int)pextras {
	ES_CHECK_NR(pextras>=0, @"Invalid extras button count %i", pextras)
	int px = (extraButtons>=0) ? extraButtons : -extraButtons;
	if (px!=pextras) {
		extraButtons = (extraButtons>=0) ? pextras : -pextras;
		float dy = 4.0f / pextras;
		float ly = 0;
		if (pextras==1) ly = 4;
		if (pextras==2) ly = 2;
		if (pextras==3) ly = 1.3f;
		if (pextras==4) ly = 1;
		if (pextras==5) ly = 0.78f;
		[self setButtonPosition:bplus  ix:2.98f iy:0*dy lx:0.64f ly:ly];
		[self setButtonPosition:bminus ix:2.98f iy:1*dy lx:0.64f ly:ly];
		[self setButtonPosition:bmult  ix:2.98f iy:2*dy lx:0.64f ly:ly];
		[self setButtonPosition:bdiv   ix:2.98f iy:3*dy lx:0.64f ly:ly];
		[self setButtonPosition:bequal ix:2.98f iy:4*dy lx:0.64f ly:ly];
		bplus.hidden = pextras<1;
		bminus.hidden = pextras<2;
		bmult.hidden = pextras<3;
		bdiv.hidden = pextras<4;
		bequal.hidden = pextras<5;
		[self setNeedsLayout];
	}
}

- (BOOL)showExtraButtons {
	return extraButtons>0;
}

- (void)setShowExtraButtons:(BOOL)pshow {
	if (pshow) {
		if (extraButtons<0) {
			extraButtons = -extraButtons;
			bplus.hidden = extraButtons<1;
			bminus.hidden = extraButtons<2;
			bmult.hidden = extraButtons<3;
			bdiv.hidden = extraButtons<4;
			bequal.hidden = extraButtons<5;
			[self setNeedsLayout];
		}
	} else {
		if (extraButtons>0) {
			extraButtons = -extraButtons;
			bplus.hidden = YES;
			bminus.hidden = YES;
			bmult.hidden = YES;
			bdiv.hidden = YES;
			bequal.hidden = YES;
			[self setNeedsLayout];
		}
	}
}

- (ESButton *)customButton:(int)pnumber {
	if (pnumber==1) return bplus;
	if (pnumber==2) return bminus;
	if (pnumber==3) return bmult;
	if (pnumber==4) return bdiv;
	if (pnumber==5) return bequal;
	return nil;
}

- (void)setButtonFgColor:(UIColor *)pcolor {
	if (buttonFgColor!=pcolor) {
		[buttonFgColor release];
		buttonFgColor = [pcolor retain];
		b0.bgColor = pcolor;
		b1.bgColor = pcolor;
		b2.bgColor = pcolor;
		b3.bgColor = pcolor;
		b4.bgColor = pcolor;
		b5.bgColor = pcolor;
		b6.bgColor = pcolor;
		b7.bgColor = pcolor;
		b8.bgColor = pcolor;
		b9.bgColor = pcolor;
		bdot.bgColor = pcolor;
		bdel.bgColor = pcolor;
		bplus.bgColor = pcolor;
		bminus.bgColor = pcolor;
		bmult.bgColor = pcolor;
		bdiv.bgColor = pcolor;
		bequal.bgColor = pcolor;
	}
}

- (void)setButtonBgColor:(UIColor *)pcolor {
	if (buttonBgColor!=pcolor) {
		[buttonBgColor release];
		buttonBgColor = [pcolor retain];
		b0.bgColor = pcolor;
		b1.bgColor = pcolor;
		b2.bgColor = pcolor;
		b3.bgColor = pcolor;
		b4.bgColor = pcolor;
		b5.bgColor = pcolor;
		b6.bgColor = pcolor;
		b7.bgColor = pcolor;
		b8.bgColor = pcolor;
		b9.bgColor = pcolor;
		bdot.bgColor = pcolor;
		bdel.bgColor = pcolor;
		bplus.bgColor = pcolor;
		bminus.bgColor = pcolor;
		bmult.bgColor = pcolor;
		bdiv.bgColor = pcolor;
		bequal.bgColor = pcolor;
	}
}

- (void)setSelectedCustomButton:(int)pnumber {
	if (selectedCustomButton!=pnumber) {
		ESButton *b = [self customButton:selectedCustomButton];
		b.color = textColor;
		b.bgColor = self.buttonBgColor;
		b = [self customButton:pnumber];
		b.color = self.buttonBgColor;
		b.bgColor = textColor;
		selectedCustomButton = pnumber;
	}
}

- (void)setForwardTouches:(BOOL)doForwardTouches {
    int i;
	forwardTouches = doForwardTouches;
	for (i = 0; i < buttons.count; i++) {
		[[buttons objectAtIndex:i] setForwardTouches:doForwardTouches];
	}
}

// Operations
// ----------

- (double)calculated:(NSString *)ptext {
	if (ptext.length<1) return 0;
	char c0 = [ptext characterAtIndex:0];
	NSRange start = NSMakeRange(c0=='-' ? 1 : 0, ptext.length - (c0=='-' ? 1 : 0));
	NSRange rngl = [ptext rangeOfCharacterFromSet:lowPriorityOperators options:NSLiteralSearch range:start];
	if (rngl.length>0) {
		NSString *s1 = [ptext substringToIndex:rngl.location];
		NSString *s2 = [ptext substringFromIndex:rngl.location+1];
		char c = [ptext characterAtIndex:rngl.location];
		if (c=='+') {
			return [self calculated:s1] + [self calculated:s2];
		} else {
			return [self calculated:s1] - [self calculated:s2];
		}
	} else {
		NSRange rngh = [ptext rangeOfCharacterFromSet:highPriorityOperators options:NSLiteralSearch range:start];
		if (rngh.length>0) {
			NSString *s1 = [ptext substringToIndex:rngh.location];
			NSString *s2 = [ptext substringFromIndex:rngh.location+1];
			char c = [ptext characterAtIndex:rngh.location];
			if (c=='x' || c=='*') {
				return [self calculated:s1] * [self calculated:s2];
			} else {
				return [self calculated:s1] / [self calculated:s2];
			}
		}
	}
	return [ptext doubleValue];
}

- (NSString *)innerSimplified:(NSString *)ptext lastOperator:(char)plast {
	char c0 = [ptext characterAtIndex:0];
	NSRange start = NSMakeRange(c0=='-' ? 1 : 0, ptext.length - (c0=='-' ? 1 : 0));
	if (plast=='+' || plast=='-') {
		NSRange rng = [ptext rangeOfCharacterFromSet:operators options:NSLiteralSearch range:start];
		if (rng.length>0) return ESFS(@"%g", [self calculated:ptext]);
	} else if (plast=='x' || plast=='*' || plast=='/') {
		NSRange rngl = [ptext rangeOfCharacterFromSet:lowPriorityOperators options:NSLiteralSearch range:start];
		if (rngl.length>0) {
			NSString *s1 = [ptext substringToIndex:rngl.location];
			NSString *s2 = [ptext substringFromIndex:rngl.location+1];
			char c = [ptext characterAtIndex:rngl.location];
			return ESFS(@"%@%c%g", s1, c, [self calculated:s2]);
		} else {
			NSRange rngh = [ptext rangeOfCharacterFromSet:highPriorityOperators options:NSLiteralSearch range:start];
			if (rngh.length>0) return ESFS(@"%g", [self calculated:ptext]);
		}
	}
	return ptext;
}

- (NSString *)simplified:(NSString *)ptext {
	if (ptext.length<4) return ptext;
	char c = [ptext characterAtIndex:ptext.length-1];
	if (c=='+' || c=='-' || c=='x' || c=='*' || c=='/') {
		NSString *sub = [ptext substringToIndex:ptext.length-1];
		NSString *s = [self innerSimplified:sub lastOperator:c];
		if (s!=sub) return ESFS(@"%@%c", [self innerSimplified:sub lastOperator:c], c);
	}
	return ptext;
}

- (char)lastNonNumerical:(NSString *)pstring {
	for (int i = pstring.length - 1; i>=0; i--) {
		char c = [pstring characterAtIndex:i];
		if (c<'0' || c>'9') return c;
	}
	return '\0';
}

- (void)onButton:(ESButton *)pbutton {
	if (pbutton == bdel) {
		if (text.length > 0) [text deleteCharactersInRange:NSMakeRange(text.length-1, 1)];
	} else if (pbutton == bdot) {
		char c = [self lastNonNumerical:text];
		if (c!='.') [text appendString:self.decimalSeparator];
	} else if (pbutton==bplus || pbutton==bminus || pbutton==bmult || pbutton==bdiv || pbutton==bequal) {
		if (hasCustomButtons) {
			if (pbutton==bplus) {
				if (extraButtons>=1) [[NSNotificationCenter defaultCenter] postNotificationName:ESN_NUMPAD_CUSTOM object:pbutton.text];
			} else if (pbutton==bminus) {
				if (extraButtons>=2) [[NSNotificationCenter defaultCenter] postNotificationName:ESN_NUMPAD_CUSTOM object:pbutton.text];
			} else if (pbutton==bmult) {
				if (extraButtons>=3) [[NSNotificationCenter defaultCenter] postNotificationName:ESN_NUMPAD_CUSTOM object:pbutton.text];
			} else if (pbutton==bdiv) {
				if (extraButtons>=4) [[NSNotificationCenter defaultCenter] postNotificationName:ESN_NUMPAD_CUSTOM object:pbutton.text];
			} else if (pbutton==bequal) {
				if (extraButtons>=5) [[NSNotificationCenter defaultCenter] postNotificationName:ESN_NUMPAD_CUSTOM object:pbutton.text];
			}
			return;
		} else if (text.length>0) {
			if (pbutton==bequal) {
				if (text.length>=3) {
					char c = [text characterAtIndex:text.length-1];
					if (c=='+' || c=='-' || c=='x' || c=='*' || c=='/') {
						// Remove last operation character
						[text deleteCharactersInRange:NSMakeRange(text.length-1, 1)];
					}
					char c0 = [text characterAtIndex:0];
					NSRange start = NSMakeRange(c0=='-' ? 1 : 0, text.length - (c0=='-' ? 1 : 0));
					NSRange rng = [text rangeOfCharacterFromSet:operators options:NSLiteralSearch range:start];
					if (rng.length>0) {
						self.text = ESFS(@"%g", [self calculated:text]);
					}
				}
			} else {
				char c = [text characterAtIndex:text.length-1];
				if (c=='.' || (c>='0' && c<='9')) {
					[text appendString:pbutton.text];
					if (pbutton==bplus || pbutton==bminus || pbutton==bmult || pbutton==bdiv) {
						NSString *s = [self simplified:text];
						if (s!=text) self.text = s;
					}
				} else {
					// Replace last operation character with new one
					[text deleteCharactersInRange:NSMakeRange(text.length-1, 1)];
					[text appendString:pbutton.text];
				}
			}
		} else {
			return;
		}
	} else {
		if (text.length<18) [text appendString:pbutton.text];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:ESN_NUMPAD_TEXT object:text];
}

- (void)cancelTouching {
    int i;
	for (i = 0; i < buttons.count; i++) {
		[[buttons objectAtIndex:i] cancelTouching];
	}
}

- (void)clearText {
	[text setString:@""];
}

- (void)setCustomButtons:(NSString *)t1 b2:(NSString *)t2 b3:(NSString *)t3 b4:(NSString *)t4 b5:(NSString *)t5 {
	ES_CHECK_NR(hasCustomButtons, @"Cant set custom buttons text")
	bplus.text = t1;
	bminus.text = t2;
	bmult.text = t3;
	bdiv.text = t4;
	bequal.text = t5;
}

// Composition
// -----------
- (void)layoutSubviews {
	CGRect sf = self.bounds;
	if (isLayedOut) {
		[UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.2f];
	}
	float sx = extraButtons>0 ? 3.6f : 3;
	float sy = extraButtons>0 ? 4 : 4;
    int i;
	for (i = 0; i < buttons.count; i++) {
		CGRect f = bframes[i];
		float dx = (sf.size.width - 2*marginX - (sx-1)*paddingX) / sx;
		float dy = (sf.size.height - 2*marginY - (sy-1)*paddingY) / sy;
		f.origin.x = marginX + f.origin.x * (dx + paddingX);
		f.origin.y = marginY + f.origin.y * (dy + paddingY);
		f.size.width = f.size.width * dx + (f.size.width-1)*paddingX;
		f.size.height = f.size.height * dy + (f.size.height-1)*paddingY;
		[[buttons objectAtIndex:i] setFrame:f];
	}
	if (isLayedOut) [UIView commitAnimations];
	isLayedOut = YES;
}

//----------------------
// Touch event handling
//----------------------
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (forwardTouches) [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (forwardTouches) [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if (forwardTouches) [self.nextResponder touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if (forwardTouches) [self.nextResponder touchesCancelled:touches withEvent:event];
}


@end
