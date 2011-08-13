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
	ESAdTypeNone = 0,
	ESadApple,
	ESadGoogle
} ESAdType;

typedef enum {
    ESAdPlacementNone = 0,
    ESAdPlacementTop,
    ESAdPlacementBottom
} ESAdPlacement;

@interface ESAdView : UIView <ADBannerViewDelegate> {
	UIView *contentView;
	ADBannerView *iAdBanner;	// Ad banner
	CGRect contentRect;			// Rectangle holding view bounds on screen
	ESAdPlacement adPlacement;			// Desired ad banner placement
	ESAdType hasAd;
	BOOL animateAds;			// Animate when ads appear/disappear
}

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, assign) ESAdPlacement adPlacement;
@property (nonatomic, assign) BOOL animateAds;

@end
