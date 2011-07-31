//
//  ESTexturedView.h - A view that allows to show a movable texture in its background
//  Currency Master
//
//  Created by Zoran Simic on 3/28/10.
//  Copyright 2010 esmiler.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "esmiler.h"

@interface ESTexturedView : UIView <UIScrollViewDelegate, ADBannerViewDelegate> {
	UIView *view;				// View showed on top of this textured view
	UIImage *texture;			// Texture shown in background
	CGRect textureRect;			// Rectangle holding where the current main texture should be shown
	CGRect contentRect;			// Rectangle holding view bounds on screen
	CGFloat prevContentY;
	ADBannerView *adBanner;		// Ad banner
	int adPlacement;			// Ad banner placement, if any
	BOOL hasAd;
	BOOL animateAds;			// Animate views when ads appear/disappear
}

@property (nonatomic, retain) UIView *view;
@property (nonatomic, retain) UIImage *texture;
@property (nonatomic, assign) int adPlacement;
@property (nonatomic, assign) BOOL animateAds;

- (void)setContentOffset:(CGFloat)poffset;

@end
