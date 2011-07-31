//
//  UIImage+esmiler.m
//  CurrencyMaster
//
//  Created by Zoran Simic on 11/29/10.
//  Copyright 2010 esmiler.com. All rights reserved.
//

#import "UIImage+esmiler.h"

@implementation UIImage (esmiler)

- (void)drawInRect:(CGRect)drawRect fromRect:(CGRect)fromRect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
    CGImageRef drawImage = CGImageCreateWithImageInRect(self.CGImage, fromRect); 
    if (drawImage != NULL)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Push current graphics state so we can restore later
        CGContextSaveGState(context);   
        
        // Set the alpha and blend based on passed in settings
        CGContextSetBlendMode(context, blendMode);
        CGContextSetAlpha(context, alpha);
        
        // Take care of Y-axis inversion problem by translating the context on the y axis
        CGContextTranslateCTM(context, 0, drawRect.origin.y + fromRect.size.height);  
        
        // Scaling -1.0 on y-axis to flip
        CGContextScaleCTM(context, 1.0f, -1.0f);
        
        // Then accommodate the translate by adjusting the draw rect
        drawRect.origin.y = 0.0f;
        
        // Draw the image
        CGContextDrawImage(context, drawRect, drawImage);
        
        // Clean up memory and restore previous state
        CGImageRelease(drawImage);
        
        // Restore previous graphics state to what it was before we tweaked it
        CGContextRestoreGState(context); 
    }
}

@end
