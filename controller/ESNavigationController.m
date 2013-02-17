// ESNavigationController - Navigation controller with an ad staying across navigations
// Created by Zoran Simic on 2/1/11. Copyright 2011 esmiler.com. All rights reserved.

#import "ESNavigationController.h"

@implementation ESNavigationController

// Initialization
// --------------

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
#if ES_ADS
	[[ESAdView sharedAdView] setController:nil];
#endif
	[super loadView];
#if ES_ADS
	[[ESAdView sharedAdView] setController:self];
#endif
}

// Properties
// ----------

@end
