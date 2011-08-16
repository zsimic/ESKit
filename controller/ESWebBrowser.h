//  ESWebBrowser - Controller showing a web browser full screen with an easy way to browse pages relative to a prefix (example: wikipedia)
//  Created by Zoran Simic on 3/1/09. Copyright 2009 esmiler.com. All rights reserved

#import <UIKit/UIKit.h>

@interface ESWebBrowser : UIViewController <UIWebViewDelegate> {
	NSURL *nurl;			// URL to show in browser
	NSString *prefix;		// Prefix to add to each partial 'relativePath' shown (optional)
	UIWebView *browser;		// Browser view used to show actual web page
	NSString *referer;		// Referer to send in HTTP request (optional)
}

@property (nonatomic, retain) NSURL *nurl;
@property (nonatomic, retain) NSString *prefix;
@property (nonatomic, retain) NSString *relativePath;
@property (nonatomic, retain) NSString *referer;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL scalesPageToFit;

+ (ESWebBrowser *)withPrefix:(NSString *)pprefix relativePath:(NSString *)prelativePath;
+ (ESWebBrowser *)wikipedia:(NSString *)purl;
+ (ESWebBrowser *)wikipedia:(NSString *)prelativePath lang:(NSString *)plang;
+ (ESWebBrowser *)withFileNamed:(NSString *)pname;

@end
