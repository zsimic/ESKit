// ESNumpad - Numerical pad that automatically appears on bottom of screen (on top of current window)
// Created by zoran on 12/13/08. Copyright 2008 esmiler.com. All rights reserved.

#import <UIKit/UIKit.h>
#import "ESView.h"
#import "ESButton.h"

#define ESN_NUMPAD_TEXT		@"NumpadText"
#define ESN_NUMPAD_CUSTOM	@"NumpadCustomButton"

@interface ESNumpad : UIView {
	UIColor *textColor;				// Text color for buttons
	UIFont *numberFont;
	UIFont *extrasFont;
	UIColor *buttonFgColor;
	UIColor *buttonBgColor;
	float marginX;					// Margins for the buttons
	float marginY;
	float paddingX;					// Padding between buttons
	float paddingY;
	int extraButtons;				// Number of extra buttons shown on the right side
	BOOL hasCustomButtons;
	int selectedCustomButton;
	BOOL forwardTouches;			// Forward touches to parent view
@private
	NSMutableArray *buttons;		// Buttons composing the numerical pad
	NSMutableString *text;			// Text of the number being edited
	ESButton *b0;					// Numeric buttons 0 - 9
	ESButton *b1;
	ESButton *b2;
	ESButton *b3;
	ESButton *b4;
	ESButton *b5;
	ESButton *b6;
	ESButton *b7;
	ESButton *b8;
	ESButton *b9;
	ESButton *bdot;		// '.'
	ESButton *bdel;		// delete button (clear)
	//ESButton *bclear;	// 'C' button (clear)
	ESButton *bplus;
	ESButton *bminus;
	ESButton *bmult;
	ESButton *bdiv;
	ESButton *bequal;
	NSCharacterSet *operators;				// All operators: +-x*/
	NSCharacterSet *lowPriorityOperators;	// Low priority operators: + and -
	NSCharacterSet *highPriorityOperators;	// Low priority operators: x, * and /
	CGRect bframes[17];
	BOOL isLayedOut;
}

@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, retain) NSString *decimalSeparator;
@property (nonatomic, retain) UIFont *numberFont;
@property (nonatomic, retain) UIFont *extrasFont;
@property (nonatomic, retain) UIColor *buttonFgColor;
@property (nonatomic, retain) UIColor *buttonBgColor;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) float marginX;
@property (nonatomic, assign) float marginY;
@property (nonatomic, assign) float paddingX;
@property (nonatomic, assign) float paddingY;
@property (nonatomic, assign) int extraButtons;
@property (nonatomic, assign) int selectedCustomButton;
@property (nonatomic, assign) BOOL showExtraButtons;
@property (nonatomic, assign) ESGradientStyle gradientStyle;
@property (nonatomic, assign) BOOL forwardTouches;

// Initialization
- (id)initSimple;					// Simple numerical pad: no operations, just numbers, delete and clear
- (id)initFull;						// Full numerical pad with +, -, *, /, = operations
- (id)initWithExtras:(int)pextras;	// Simple numerical pad with curstom extra buttons on the right

// Operations
- (void)clearText;
- (void)cancelTouching;
- (void)setCustomButtons:(NSString *)t1 b2:(NSString *)t2 b3:(NSString *)t3 b4:(NSString *)t4 b5:(NSString *)t5;

@end
