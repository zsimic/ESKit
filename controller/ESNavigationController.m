//
//  ESNavigationController.m
//  CurrencyMaster
//
//  Created by Zoran Simic on 2/1/11.
//  Copyright 2011 esmiler.com. All rights reserved.
//

#import "ESNavigationController.h"

@implementation ESNavigationController

// Initialization
// --------------

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
	if (self = [super initWithNibName:nibName bundle:nibBundle]) {
		adView = [[ESAdView alloc] initWithFrame:CGRectZero];
		adView.rootViewController = self;
	}
	return self;
}

- (void)dealloc {
	ESRELEASE(adView);
	[super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	UIView *cv = self.view;
	self.view = adView;
	[adView addSubview:cv];
}

//- (void)setView:(UIView *)view {
//	if (view != adView) {
//		ES_LOG(@"Setting adView content")
//		adView.contentView = view;
//	}
//	ES_LOG(@"Setting nav controller's view")
//	[super setView:adView];
//}

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
