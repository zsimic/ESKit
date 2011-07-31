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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		adView = [[ESAdView alloc] initWithFrame:CGRectZero];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
	ESRELEASE(adView);
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
	adView.contentView = self.view;
	self.view = adView;
	/* for visual debugging of view layout
	[[_mainView layer] setCornerRadius: 6.0];
	[[_mainView layer] setMasksToBounds: YES];
	[[_mainView layer] setBorderWidth: 1.5];
	[[_mainView layer] setBorderColor: [[UIColor grayColor] CGColor]];  
	*/
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
