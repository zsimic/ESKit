//  UIImage+esmiler - Adds some convenience functions to UIImage
//  Created by Zoran Simic on 11/29/10. Copyright 2010 esmiler.com. All rights reserved.

#import <UIKit/UIKit.h>


@interface UIImage (esmiler)

- (void)drawInRect:(CGRect)drawRect fromRect:(CGRect)fromRect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

@end
