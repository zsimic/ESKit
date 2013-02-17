// ESView - Simple view with an optional gradient filled background and an optional text label
// Created by Zoran Simic on 9/21/09. Copyright 2009 esmiler.com. All rights reserved.

#import <UIKit/UIKit.h>
#import "ESGradient.h"

@interface ESView : UIView {
	UILabel *textLabel;			// Optional text label
	ESGradient *gradient;		// Optional gradient to render background
	float cornerRadius;			// For a 'rounded button' look, optional
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) ESGradient *gradient;
@property (nonatomic, assign) float cornerRadius;

@end
