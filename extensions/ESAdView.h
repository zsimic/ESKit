// ESAdView - Allows to have one ad view appearing (top or bottom) and staying across views in an UINavigationController
// Created by Zoran Simic on 1/1/11. Copyright 2011 esmiler.com. All rights reserved.

#if ES_ADS

#import <UIKit/UIKit.h>
#import "esmiler.h"
#import <iAd/iAd.h>
#import "GADBannerView.h"

typedef enum {
	ESAdProviderNone = 0,
	ESAdProviderApple,
	ESAdProviderGoogle
} ESAdProvider;

typedef enum {
	ESAdPlacementNone = 0,
	ESAdPlacementTop,
	ESAdPlacementBottom
} ESAdPlacement;

typedef enum {
	ESAdAutoRefreshQuery = 0,
	ESAdAutoRefreshOn,
	ESAdAutoRefreshOff
} ESAdAutoRefresh;

@interface ESAdView : UIView <ADBannerViewDelegate, GADBannerViewDelegate> {
	NSString *adMobUnitID;					// Unit ID identifying which account to fetch ads for
	UIView *contentView;					// Content view, weak reference
	UIViewController *controller;			// Root view controller (needed by the AdMob API)
	ADBannerView *iAdBanner;				// iAd banner
	GADBannerView *adMobBanner;				// AdMob banner
	ESAdPlacement adPlacement;				// Desired ad banner placement
	ESAdProvider desiredProvider;			// Which provider do we want to query next
	ESAdProvider currentlyShownProvider;	// Provider from which we are currently showing an ad
	BOOL animateAds;						// Animate when ads appear/disappear
	BOOL isCurrentlyShowingAdFullScreen;	// Are we currently showing an ad full screen?
	BOOL iAdSeen;							// Have we ever seen an iAd (in current country)?
	int iAdFails;							// Number of times we failed to get an iAd in current session
	int consecutiveAdMobFails;				// Allows to try iAds again after N consecutive AdMob requests fail
}

@property (nonatomic, retain) NSString *adMobUnitID;
@property (nonatomic, retain) UIViewController *controller;
@property (nonatomic, assign) ESAdPlacement adPlacement;
@property (nonatomic, assign) BOOL animateAds;

+ (ESAdView *)sharedAdView;
+ (void)setAdMobUnitID:(NSString *)pid;
+ (BOOL)autoRefresh:(ESAdAutoRefresh)pset;
- (void)updateAdViews;

@end

#endif
