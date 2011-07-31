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

// Initialization
// --------------
- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		hasAd = NO;
	}
	return self;
}

- (void)dealloc {
	ESRELEASE(contentView);
    adBanner.delegate = nil;
	ESRELEASE(adBanner);
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
- (void)setAdPlacement:(int)pplacement {
	if (ES_AD_UNAVAILABLE) return;
	if (adPlacement != pplacement) {
		adPlacement = pplacement;
		if (adPlacement == ES_AD_NONE) {
			if (adBanner != nil) {
				[adBanner removeFromSuperview];
				adBanner.delegate = nil;
				ESRELEASE(adBanner);
				hasAd = NO;
				[self setNeedsLayout];
			}
		} else {
			if (adBanner==nil) {
				CGRect frame;
				frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:ADBannerContentSizeIdentifier320x50];
				frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.bounds));
				adBanner = [[ADBannerView alloc] initWithFrame:frame];
				adBanner.delegate = self;
				adBanner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
				adBanner.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, nil];
				[self addSubview:adBanner];
				hasAd = NO;
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
	if (adBanner!=nil) {
		CGRect fAd = adBanner.frame;
		if (hasAd) {
			contentRect.size.height -= fAd.size.height;
			if (adPlacement==ES_AD_BOTTOM) {
				fAd.origin.y = contentRect.size.height;
			} else {
				fAd.origin.y = 0.0f;
				contentRect.origin.y = fAd.size.height;
			}
		} else if (adPlacement==ES_AD_BOTTOM) {
			fAd.origin.y = contentRect.size.height + 4.0f;
		} else {
			fAd.origin.y = -fAd.size.height - 4.0f;
		}
		adBanner.frame = fAd;
//		ES_LOG(@"---- Layout: %i %i %g %g (%g %g %g %g)", n++, hasAd, fAd.origin.y, contentRect.size.height, contentRect.origin.x, contentRect.origin.y, contentRect.size.width, contentRect.size.height);
	}
	contentView.frame = contentRect;
	if (animateAds) [UIView commitAnimations];
}

// Ads
// ---
//#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	if (hasAd) return;
	hasAd = YES;
	[self setNeedsLayout];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	if (!hasAd) return;
	hasAd = NO;
	[self setNeedsLayout];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
}

@end
