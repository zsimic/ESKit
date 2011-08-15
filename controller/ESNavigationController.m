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
	[super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[[ESAdView shareAdView] setController:nil];
	[super loadView];
	[[ESAdView shareAdView] setController:self];
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

@end
