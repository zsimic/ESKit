//  ESWebBrowser - Controller showing a web browser full screen with an easy way to browse pages relative to a prefix (example: wikipedia)
//  Created by Zoran Simic on 3/1/09. Copyright 2009 esmiler.com. All rights reserved

#import "ESWebBrowser.h"
#import "UIColor+esmiler.h"

@implementation ESWebBrowser

@synthesize nurl;
@synthesize prefix;
@synthesize referer;

// Initialization
// --------------
+ (ESWebBrowser *)withPrefix:(NSString *)pprefix relativePath:(NSString *)prelativePath {
	ESWebBrowser *b = ESAUTO([[ESWebBrowser alloc] initWithNibName:nil bundle:nil]);
	b.prefix = pprefix;
	b.relativePath = prelativePath;
	return b;
}

+ (ESWebBrowser *)wikipedia:(NSString *)purl {
	return [ESWebBrowser wikipedia:purl lang:@"en"];
}

+ (ESWebBrowser *)wikipedia:(NSString *)prelativePath lang:(NSString *)plang {
	return [ESWebBrowser withPrefix:ESFS(@"http://%@.m.wikipedia.org/wiki/", plang) relativePath:prelativePath];
}

+ (ESWebBrowser *)withFileNamed:(NSString *)pname {
	ESWebBrowser *b = ESAUTO([[ESWebBrowser alloc] initWithNibName:nil bundle:nil]);
	b.nurl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:pname ofType:@"html"]];
	return b;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		browser = [[UIWebView alloc] init];
		browser.backgroundColor = [UIColor cWhite];
		browser.scalesPageToFit = YES;
		browser.delegate = self;
		browser.autoresizesSubviews = YES;
		self.view = browser;
//		[browser loadHTMLString:@"<html><body style=\"font-size:28pt;\"><h1>Please wait...</h1>Loading...</body></html>" baseURL:nil];
	}
	return self;
}

- (void)dealloc {
	ESRELEASE(nurl);
	ESRELEASE(prefix);
	browser.delegate = nil;
	ESRELEASE(browser);
	ESRELEASE(referer);
    [super dealloc];
}

// Properties
// ----------
- (NSString *)relativePath {
	return nurl.relativePath;
}

- (void)setRelativePath:(NSString *)prelativePath {
	if (prelativePath==nil) return;
	if (prefix!=nil) self.nurl = [NSURL URLWithString:prelativePath relativeToURL:[NSURL URLWithString:prefix]];
	else self.nurl = [NSURL URLWithString:prelativePath];
}

- (BOOL)scalesPageToFit {
	return browser.scalesPageToFit;
}

- (void)setScalesPageToFit:(BOOL)pscales {
	browser.scalesPageToFit = pscales;
}

- (UIColor *)backgroundColor {
	return browser.backgroundColor;
}

- (void) setBackgroundColor:(UIColor *)pcolor {
	browser.backgroundColor = pcolor;
}

// Contoroller
// -----------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	ES_LOG(@"ESWebBrowser error: %@", error)
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	// don't let user press "back" button in landscape - otherwise previous view and the rest of the application
	// will also be in landscape which we did not feel like testing yet
	self.navigationController.navigationBarHidden = (UIInterfaceOrientationPortrait != self.interfaceOrientation);
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	NSString *html = nil;
	if (nurl==nil) {
		html = @"<html><body style=\"font-size:28pt;\"><h1>No URL provided...</h1></body></html>";
	} else if (!nurl.isFileURL && browser.scalesPageToFit) {
		html = ESFS(@"<html><body style=\"font-size:28pt;\"><h1>%@</h1>%@ %@</body></html>", tr(@"Please wait..."), tr(@"Loading"), self.relativePath);
	}
	if (html!=nil) [browser loadHTMLString:html baseURL:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (nurl==nil) return;
//	NSURL *nurl = [NSURL URLWithString:self.fullUrl];
	if (referer!=nil) {
		NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:nurl];
		[req addValue:referer forHTTPHeaderField:@"Referer"];
		[browser loadRequest:req];
	} else {
		NSURLRequest *req = [NSURLRequest requestWithURL:nurl];
		[browser loadRequest:req];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
