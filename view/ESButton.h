//  ESButton - Simplified button, allows to make buttons with background images and/or gradients on the fly, simpler than UIButton
//  Created by zoran on 12/28/08. Copyright 2008 esmiler.com. All rights reserved.

#import <UIKit/UIKit.h>
//#import "UIView+esmiler.h"
#import "ESGradient.h"

@interface ESButton : UIView {
	NSString *text;				// Text displayed on button, centered
	UIImage *image;				// Image shown on button, appears behind 'text' if both specified
	UIFont *font;				// Font used to display the text
	UIColor *color;				// Text color
	UIColor *bgColor;			// Button background color
	UIColor *highlightColor;	// Color to use to show that button is being pressed (emphasized background color if nil)
	ESGradient *gradient;		// Gradient to use for background
	id delegate;				// Delegate called when button is pressed (weak pointer)
	SEL action;					// Action (selector) to call on 'delegate' when button is pressed
	float cornerRadius;			// Rounded corners if > 0
	BOOL forwardTouches;		// Forward touches to parent view
	id data;					// Arbitrary data associated to the button (the button itself does nothing with this) (weak pointer)
@private
	BOOL isTouching;
	CGRect textRect;
	CGPoint startTouch;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIFont *font;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) UIColor *bgColor;
@property (nonatomic, retain) UIColor *highlightColor;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) ESGradient *gradient;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) float cornerRadius;
@property (nonatomic, assign) BOOL forwardTouches;
@property (nonatomic, assign) id data;

+ (id)withDelegate:(id)pdelegate action:(SEL)paction;

- (void)cancelTouching;

@end
