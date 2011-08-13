//
//  ESAdView.m
//  CurrencyMaster
//
//  Created by Zoran Simic on 1/1/11.
//  Copyright 2011 esmiler.com. All rights reserved.
//

#import "ESAdView.h"

@implementation ESAdView

@synthesize contentView;
@synthesize adPlacement;
@synthesize animateAds;

// iAd countries: en, fr, uk, it, germany, ca, spain

// Initialization
// --------------
- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		hasAd = ESAdTypeNone;
	}
	return self;
}

- (void)dealloc {
	ESRELEASE(contentView);
    iAdBanner.delegate = nil;
	ESRELEASE(iAdBanner);
	[super dealloc];
}

// Properties
// ----------
- (void)setContentView:(UIView *)pview {
	if (contentView!=pview) {
		[contentView removeFromSuperview];
		[contentView release];
		contentView = [pview retain];
		[self addSubview:contentView];
		[self setNeedsLayout];
	}
}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)setAdPlacement:(ESAdPlacement)pplacement {
	if (ES_AD_UNAVAILABLE) return;
	if (adPlacement != pplacement) {
		adPlacement = pplacement;
		if (adPlacement == ESAdPlacementNone) {
			if (iAdBanner != nil) {
				[iAdBanner removeFromSuperview];
				iAdBanner.delegate = nil;
				ESRELEASE(iAdBanner);
				hasAd = ESAdTypeNone;
				[self setNeedsLayout];
			}
		} else {
			if (iAdBanner==nil) {
				CGRect frame;
				frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:ADBannerContentSizeIdentifier320x50];
				frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.bounds));
				iAdBanner = [[ADBannerView alloc] initWithFrame:frame];
				iAdBanner.delegate = self;
				iAdBanner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
				iAdBanner.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, nil];
				[self addSubview:iAdBanner];
				hasAd = ESAdTypeNone;
				[self setNeedsLayout];
			}
		} 
	}
}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

// Composition
// -----------
- (void)layoutSubviews {
//	static int n = 0;
	contentRect = self.bounds;
	if (animateAds) {
		[UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.8f];
	}
	if (iAdBanner!=nil) {
		CGRect fAd = iAdBanner.frame;
		if (hasAd!=ESAdTypeNone) {
			contentRect.size.height -= fAd.size.height;
			if (adPlacement==ESAdPlacementBottom) {
				fAd.origin.y = contentRect.size.height;
			} else {
				fAd.origin.y = 0.0f;
				contentRect.origin.y = fAd.size.height;
			}
		} else if (adPlacement==ESAdPlacementBottom) {
			fAd.origin.y = contentRect.size.height + 4.0f;
		} else {
			fAd.origin.y = -fAd.size.height - 4.0f;
		}
		iAdBanner.frame = fAd;
//		ES_LOG(@"---- Layout: %i %i %g %g (%g %g %g %g)", n++, hasAd, fAd.origin.y, contentRect.size.height, contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.height);
	}
	contentView.frame = contentRect;
	if (animateAds) [UIView commitAnimations];
}

// Ads
// ---
//#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	if (hasAd==ESadApple) return;
	hasAd = ESadApple;
	[self setNeedsLayout];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	if (hasAd==ESAdTypeNone) return;
	hasAd = ESAdTypeNone;
	[self setNeedsLayout];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

@end
