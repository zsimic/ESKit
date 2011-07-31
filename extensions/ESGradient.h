//
//  ESGradient.h
//  Simple linear gradient
//
//  Created by Zoran Simic on 9/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+esmiler.h"

typedef enum {
	ESGradientStyleNone,
	ESGradientStyleTube,
	ESGradientStylePlastic
} ESGradientStyle;

@interface ESGradient : NSObject {
	ESGradientStyle style;
	float force;
}

@property (nonatomic, assign) ESGradientStyle style;
@property (nonatomic, assign) float force;
@property (nonatomic, readonly) NSString *styleName;

- (void)draw:(CGContextRef)pctx rect:(CGRect)prect color:(UIColor *)pcolor;

@end
