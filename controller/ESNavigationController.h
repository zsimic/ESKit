//
//  ESNavigationController.h
//  CurrencyMaster
//
//  Created by Zoran Simic on 2/1/11.
//  Copyright 2011 esmiler.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESAdView.h"

@interface ESNavigationController : UINavigationController {
	ESAdView *adView;
}

@property (nonatomic, assign) int adPlacement;
@property (nonatomic, assign) BOOL animateAds;

@end
