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

@interface ESAdView : UIView <ADBannerViewDelegate> {
	UIView *contentView;
	ADBannerView *adBanner;		// Ad banner
	CGRect contentRect;			// Rectangle holding view bounds on screen
	int adPlacement;			// Ad banner placement, if any
	BOOL hasAd;
	BOOL animateAds;			// Animate when ads appear/disappear
}

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, assign) int adPlacement;
@property (nonatomic, assign) BOOL animateAds;

@end
