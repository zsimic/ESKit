//
//  ESAdView.h
//  CurrencyMaster
//
//  Created by Zoran Simic on 1/1/11.
//  Copyright 2011 esmiler.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "esmiler.h"
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

@interface ESAdView : UIView <ADBannerViewDelegate, GADBannerViewDelegate> {
	UIView *contentView;                    // Content view to show besides ad
	UIViewController *rootViewController;   // Root view controller (needed by the AdMob API)
	ADBannerView *iAdBanner;                // iAd banner
	GADBannerView *adMobBanner;             // AdMob banner
	ESAdPlacement adPlacement;              // Desired ad banner placement
	ESAdProvider desiredProvider;           // Which provider do we want to query next
	ESAdProvider currentlyShownProvider;    // Provider from which we are currently showing an ad
	BOOL animateAds;                        // Animate when ads appear/disappear
	BOOL isCurrentlyShowingAdFullScreen;    // Are we currently showing an ad full screen?
	BOOL iAdSeen;                           // Have we ever seen an iAd (in current country)?
	int consecutiveAdMobFails;              // Allows to try iAds again after N consecutive AdMob requests fail
}

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, assign) ESAdPlacement adPlacement;
@property (nonatomic, assign) BOOL animateAds;
@property (nonatomic, retain) UIViewController *rootViewController;

@end
