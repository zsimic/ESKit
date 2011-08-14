//
//  ESAdView.m
//  CurrencyMaster
//
//  Created by Zoran Simic on 1/1/11.
//  Copyright 2011 esmiler.com. All rights reserved.
//

#import "ESAdView.h"

@implementation ESAdView

#define ES_IAD_FAIL_COUNT @"es_iAdFailCount"
#define ES_IAD_SEEN @"es_iAdSeen"

#define ES_IAD_GIVEUP 10.0f             // We stop querying iAds after this many consecutive fails (iAds probably not supported in current country)
#define ES_IAD_RETRY_THRESHOLD 100.0f   // Retry iAds after this many requests to AdMob (allows to retry iAds every now and then, just in case they become available in country)

@synthesize contentView;
@synthesize rootViewController;
@synthesize adPlacement;
@synthesize animateAds;

// iAd countries: en, fr, uk, it, germany, ca, spain

// Initialization
// --------------
- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		contentView = nil;
		animateAds = YES;
		currentlyShownProvider = ESAdProviderNone;
		isCurrentlyShowingAdFullScreen = NO;
		consecutiveAdMobFails = 0;
		iAdSeen = [[NSUserDefaults standardUserDefaults] boolForKey:ES_IAD_SEEN];
		if (NSClassFromString(@"ADBannerView")==nil) {
			desiredProvider = ESAdProviderGoogle;
		} else {
			float n = [[NSUserDefaults standardUserDefaults] floatForKey:ES_IAD_FAIL_COUNT];
			desiredProvider = n>ES_IAD_GIVEUP ? ESAdProviderGoogle : ESAdProviderApple;
		}
	}
	return self;
}

- (void)dealloc {
	ESRELEASE(contentView);
	iAdBanner.delegate = nil;
	ESRELEASE(iAdBanner);
	adMobBanner.delegate = nil;
	ESRELEASE(adMobBanner);
	[super dealloc];
}

// Properties
// ----------
- (void)setContentView:(UIView *)pview {
	if (contentView != pview) {
		[contentView removeFromSuperview];
		[contentView release];
		contentView = [pview retain];
		[self addSubview:contentView];
		[self setNeedsLayout];
	}
}

- (void)requestAdMobAd {
	if (desiredProvider != ESAdProviderGoogle) return;
	if (!isCurrentlyShowingAdFullScreen) {
		[adMobBanner loadRequest:nil];
		ES_LOG(@"--> Requesting ad from AdMob")
	} else {
		ES_LOG(@"--  Ad viewed in full screen, skipping request for a new AdMob ad")
	}
//	[self performSelector:@selector(requestAdMobAd) withObject:nil afterDelay:60];
}

- (void)updateAdViews {
	if (adPlacement == ESAdPlacementNone || desiredProvider != ESAdProviderApple) {
		if (iAdBanner != nil) {
			[iAdBanner removeFromSuperview];
			iAdBanner.delegate = nil;
			ESRELEASE(iAdBanner);
			currentlyShownProvider = ESAdProviderNone;
			[self setNeedsLayout];
		}
	}
	if (adPlacement == ESAdPlacementNone || desiredProvider != ESAdProviderGoogle) {
		if (adMobBanner != nil) {
			[adMobBanner removeFromSuperview];
			adMobBanner.delegate = nil;
			ESRELEASE(adMobBanner);
			currentlyShownProvider = ESAdProviderNone;
			[self setNeedsLayout];
		}
	}
	if (adPlacement != ESAdPlacementNone) {
		if (desiredProvider == ESAdProviderApple && iAdBanner==nil) {
			CGRect frame;
			if (&ADBannerContentSizeIdentifierPortrait != nil) {
				frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
				iAdBanner.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, nil];
				iAdBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
			} else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
				frame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:ADBannerContentSizeIdentifier320x50];
				iAdBanner.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50, nil];
				iAdBanner.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
			}
			frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.bounds));
			iAdBanner = [[ADBannerView alloc] initWithFrame:frame];
			iAdBanner.delegate = self;
			iAdBanner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
			[self addSubview:iAdBanner];
			currentlyShownProvider = ESAdProviderNone;
			ES_LOG(@"--> Requesting iAd");
		} else if (desiredProvider == ESAdProviderGoogle && adMobBanner==nil) {
			CGRect frame;
			frame.size = GAD_SIZE_320x50;
			frame.origin = CGPointMake(0.0f, CGRectGetMaxY(self.bounds));
			adMobBanner = [[GADBannerView alloc] initWithFrame:frame];
			adMobBanner.adUnitID = @"a14e45b7a541ea0";
			adMobBanner.rootViewController = self.rootViewController;
			adMobBanner.delegate = self;
			adMobBanner.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
			[self addSubview:adMobBanner];
			currentlyShownProvider = ESAdProviderNone;
			[self requestAdMobAd];
		}
	} 
}

- (void)setAdPlacement:(ESAdPlacement)pplacement {
	if (adPlacement != pplacement) {
		adPlacement = pplacement;
		[self updateAdViews];
	}
}

// Composition
// -----------
- (void)layoutSubviews {
	CGRect contentRect = self.bounds;
	if (animateAds) {
		[UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.8f];
	}
	if (iAdBanner != nil || adMobBanner != nil) {
		CGRect fAd = iAdBanner ? iAdBanner.frame : adMobBanner.frame;
		if (currentlyShownProvider != ESAdProviderNone) {
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
		if (iAdBanner) iAdBanner.frame = fAd; else adMobBanner.frame = fAd;
	}
	contentView.frame = contentRect;
	if (animateAds) [UIView commitAnimations];
}

// iAds
// ----
//#pragma mark ADBannerViewDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	if (desiredProvider != ESAdProviderApple) return;
	if (!iAdSeen) {
		iAdSeen = YES;
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:ES_IAD_SEEN];
	}
	currentlyShownProvider = ESAdProviderApple;
	isCurrentlyShowingAdFullScreen = NO;
	[[NSUserDefaults standardUserDefaults] setFloat:-10.0f forKey:ES_IAD_FAIL_COUNT];
	[self setNeedsLayout];
	ES_LOG(@"<-- Received iAd")
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	if (desiredProvider != ESAdProviderApple) return;
	float n = [[NSUserDefaults standardUserDefaults] floatForKey:ES_IAD_FAIL_COUNT] + 1;
	[[NSUserDefaults standardUserDefaults] setFloat:n forKey:ES_IAD_FAIL_COUNT];
	currentlyShownProvider = ESAdProviderNone;
	isCurrentlyShowingAdFullScreen = NO;
	desiredProvider = ESAdProviderGoogle;
	ES_LOG(@"<+++ iAd reception failed (%f), trying Google", n);
	[self updateAdViews];
	[self setNeedsLayout];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
	if (desiredProvider != ESAdProviderApple) return NO;
	BOOL okToProceed = currentlyShownProvider == ESAdProviderApple;
	if (willLeave) {
		isCurrentlyShowingAdFullScreen = NO;
		ES_LOG(@"--  Leaving app because of iAd ad click: %i", okToProceed)
	} else {
		isCurrentlyShowingAdFullScreen = YES;
		ES_LOG(@"--  Full screen iAd open: %i", okToProceed)
	}
	return okToProceed;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
	isCurrentlyShowingAdFullScreen = NO;
	ES_LOG(@"--  Full screen iAd ad closed")
}

// AdMob
// -----

#pragma mark Ad Request Lifecycle Notifications

// Sent when an ad request loaded an ad.  This is a good opportunity to add this
// view to the hierarchy if it has not yet been added.  If the ad was received
// as a part of the server-side auto refreshing, you can examine the
// hasAutoRefreshed property of the view.
- (void)adViewDidReceiveAd:(GADBannerView *)view {
	if (desiredProvider != ESAdProviderGoogle) return;
	// Retry iAds after ES_IAD_RETRY_THRESHOLD succesful AdMob fetches
	float n = [[NSUserDefaults standardUserDefaults] floatForKey:ES_IAD_FAIL_COUNT] - 1.0f/ES_IAD_RETRY_THRESHOLD;
	if (n<-10.0f) n = -10.0f;
	[[NSUserDefaults standardUserDefaults] setFloat:n forKey:ES_IAD_FAIL_COUNT];
	currentlyShownProvider = ESAdProviderGoogle;
	isCurrentlyShowingAdFullScreen = NO;
	[self setNeedsLayout];
	consecutiveAdMobFails = 0;
	ES_LOG(@"<-- Received AdMob ad (iAd fail: %f)", n);
}

// Sent when an ad request failed.  Normally this is because no network
// connection was available or no ads were available (i.e. no fill).  If the
// error was received as a part of the server-side auto refreshing, you can
// examine the hasAutoRefreshed property of the view.
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
	if (desiredProvider != ESAdProviderGoogle) return;
	float n = [[NSUserDefaults standardUserDefaults] floatForKey:ES_IAD_FAIL_COUNT] - 1.0f/ES_IAD_RETRY_THRESHOLD;
	if (n<-10.0f) n = -10.0f;
	[[NSUserDefaults standardUserDefaults] setFloat:n forKey:ES_IAD_FAIL_COUNT];
	isCurrentlyShowingAdFullScreen = NO;
	consecutiveAdMobFails++;
	// We don't set 'currentlyShownProvider' to none when an AdMob ad fails to load because we can let the previous AdMob on screen (not the case with iAds, which disappear by themselves on fail-to-load)
	if (iAdSeen && (consecutiveAdMobFails>1 || currentlyShownProvider == ESAdProviderNone) && n<ES_IAD_GIVEUP && NSClassFromString(@"ADBannerView")!=nil) {
		// Swith to iAd only after a certain number of AdMob fails
		desiredProvider = ESAdProviderApple;
		[self updateAdViews];
		consecutiveAdMobFails = 0;
		ES_LOG(@"<+++ AdMob ad reception failed, trying iAd (iAd fail: %f)", n)
	} else {
		ES_LOG(@"<+++ AdMob ad reception failed (iAd fail: %f)", n)
	}
}

#pragma mark Click-Time Lifecycle Notifications

// Sent just before presenting the user a full screen view, such as a browser,
// in response to clicking on an ad.  Use this opportunity to stop animations,
// time sensitive interactions, etc.
//
// Normally the user looks at the ad, dismisses it, and control returns to your
// application by calling adViewDidDismissScreen:.  However if the user hits the
// Home button or clicks on an App Store link your application will end.  On iOS
// 4.0+ the next method called will be applicationWillResignActive: of your
// UIViewController (UIApplicationWillResignActiveNotification).  Immediately
// after that adViewWillLeaveApplication: is called.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
	isCurrentlyShowingAdFullScreen = YES;
	ES_LOG(@"--  Showing full screen AdMob ad")
}

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
	isCurrentlyShowingAdFullScreen = NO;
	ES_LOG(@"--  Full screen AdMob ad closed")
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
	isCurrentlyShowingAdFullScreen = NO;
	ES_LOG(@"--  Leaving app because of AdMob ad click")
}

@end
