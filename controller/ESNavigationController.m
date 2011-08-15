//
//  ESNavigationController.m
//  Navigation controller with an ad staying across navigations
//
//  Created by Zoran Simic on 2/1/11.
//  Copyright 2011 esmiler.com. All rights reserved.
//

#import "ESNavigationController.h"

@implementation ESNavigationController

// Initialization
// --------------

- (void)dealloc {
	ESRELEASE(adView);
	[super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	adView.controller = nil;
	ESRELEASE(adView);
	adView = [[ESAdView alloc] initWithFrame:CGRectZero];
	[super loadView];
	adView.controller = self;
}

#if ES_DEBUG
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (BOOL)canResignFirstResponder {
	return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion==UIEventSubtypeMotionShake) {
		if (self.viewControllers.count == 1) {
		}
	}
}
#endif

// Properties
// ----------

- (int)adPlacement {
	return adView.adPlacement;
}

- (void)setAdPlacement:(int)pplacement {
	adView.adPlacement = pplacement;
}

- (BOOL)animateAds {
	return adView.animateAds;
}

- (void)setAnimateAds:(BOOL)panimate {
	adView.animateAds = panimate;
}

@end
