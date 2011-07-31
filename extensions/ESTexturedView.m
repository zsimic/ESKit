//
//  ESTexturedView.m
//  Currency Master
//
//  Created by Zoran Simic on 3/28/10.
//  Copyright 2010 esmiler.com. All rights reserved.
//

#import "ESTexturedView.h"

@implementation ESTexturedView

@synthesize view;
@synthesize texture;
@synthesize adPlacement;
@synthesize animateAds;

// Initialization
// --------------
- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		textureRect.origin.y = -200;
		hasAd = NO;
	}
	return self;
}

- (void)dealloc {
	ESRELEASE(view);
	ESRELEASE(texture);
    adBanner.delegate = nil;
	ESRELEASE(adBanner);
	[super dealloc];
}

// Properties
// ----------
- (void)setView:(UIView *)pview {
	if (view!=pview) {
		[view removeFromSuperview];
		[view release];
		view = [pview retain];
		[self addSubview:pview];
		[self setNeedsLayout];
	}
}

- (void)setTexture:(UIImage *)ptexture {
	if (texture!=ptexture) {
		[texture release];
		texture = [ptexture retain];
		textureRect.size = texture.size;
		textureRect.origin.y = -200;
		[self setNeedsDisplay];
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
//- (void)setFrame:(CGRect)pframe {
//	[super setFrame:pframe];
//	needsLayout = YES;
//	[self setNeedsLayout];
//}

- (void)layoutSubviews {
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
	}
	view.frame = contentRect;
	if (animateAds) [UIView commitAnimations];
}

- (void)setContentOffset:(CGFloat)poffset {
	if (poffset==prevContentY || texture==nil) return;
	textureRect.origin.y -= poffset - prevContentY;
	if (textureRect.origin.y>=0) {
		textureRect.origin.y -= 2*textureRect.size.height;
	} else if (textureRect.origin.y+4*textureRect.size.height<=contentRect.size.height) {
		textureRect.origin.y += 2*textureRect.size.height;
	}
	prevContentY = poffset;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	if (ctx==nil) return;
	CGContextSaveGState(ctx);
	CGContextClearRect(ctx, rect);
	if (texture!=nil) {
		//CGContextSetAlpha(ctx, 0.5f);
		CGContextScaleCTM(ctx, 1.0f, 1.0f);
		CGRect f = textureRect;
		CGContextDrawImage(ctx, f, texture.CGImage);
		f.origin.y += 2*f.size.height;
		if (f.origin.y <= rect.size.height) {
			CGContextDrawImage(ctx, f, texture.CGImage);
		}
		CGContextScaleCTM(ctx, 1.0f, -1.0f);
		CGContextDrawImage(ctx, CGRectMake(0, -f.origin.y, f.size.width, f.size.height), texture.CGImage);
		f.origin.y += f.size.height;
		if (f.origin.y <= rect.size.height) {
			f.origin.y += f.size.height;
			CGContextDrawImage(ctx, CGRectMake(0, -f.origin.y, f.size.width, f.size.height), texture.CGImage);
		}
	}
	CGContextRestoreGState(ctx);
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
