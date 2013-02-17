// ESHeaderView - View designed to be used as table header or footer
// Created by Zoran Simic on 9/13/09. Copyright 2009 esmiler.com. All rights reserved

#import <UIKit/UIKit.h>
#import "ESGradient.h"

@interface ESHeaderView : UIView {
	UILabel *label;
	float xMargin;
	float yMargin;
	ESGradient *gradient;		// Optional gradient to render background
	float cornerRadius;			// For a 'rounded button' look, optional
}

@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *textColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) float xMargin;
@property (nonatomic, assign) float yMargin;
@property (nonatomic, retain) ESGradient *gradient;
@property (nonatomic, assign) float cornerRadius;

@end
