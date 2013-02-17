// esmiler - Useful/handy macros, allow to reduce verbosity when writing, and provide a way to easily write assertions
// Created by zoran on 12/31/08. Copyright 2009 esmiler.com. All rights reserved

#import "esmiler.h"
#include "ESAdView.h"

NSBundle *esBundle = nil;

void setEsBundle(NSString *lang) {
	if (lang == nil) {
		esBundle = [NSBundle mainBundle];
	} else {
		NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:ESFS(@"%@.lproj", lang)];
		esBundle = [NSBundle bundleWithPath:path];
//		ES_LOG(@"path: %@, bundle: %@", path, esBundle);
	}
}

// Text translated in current language
NSString *tr(NSString *format, ...) {
	NSString *tf = format;
	if (esBundle != nil) {
		tf = [esBundle localizedStringForKey:format value:nil table:nil];
	}
	va_list args;
	va_start(args, format);
	NSString *s = [[NSString alloc] initWithFormat:tf arguments:args];
	va_end(args);
	return s;
}

UIView *topMostView(UIView *pview) {
	UIView *topMost = pview;
	while (topMost) {
		UIView *parent = topMost.superview;
		if (!parent) {
			return topMost;
		}
		if ([parent isKindOfClass:[UIWindow class]]) {
			return topMost;
		}
		if ([parent isKindOfClass:[UIViewController class]]) {
			ES_LOG(@"Found controller")
		}
#if ES_ADS
		if ([parent isKindOfClass:[ESAdView class]]) {
			return topMost;
		}
#endif
		topMost = parent;
	}
	return topMost;
}

#define CPK_TICKET			@"cpadTicket"
NSString *getCustomUniqueId(void) {
	NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:CPK_TICKET];
	if (identifier.length<30) {		// example uid: 04567f1639637f32568b1002874abceeac4d6506
		CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
		CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
		identifier = ESFS(@"%@-%@", escapedString(ESFS(@"%@", newUniqueIdString)), ESDeviceModel);
		CFRelease(newUniqueId);
		CFRelease(newUniqueIdString);
		[[NSUserDefaults standardUserDefaults] setObject:identifier forKey:CPK_TICKET];
	}
	return identifier;
}

// ----------
// Formatting
// ----------
// String with all non alpha-numeric characters removed
NSString *escapedString (NSString *pstring) {
	NSMutableString *s = [[NSMutableString alloc] init];
	BOOL wasEscaped = YES;
	int n = pstring.length;
	int i;
	for (i=0; i<n; i++) {
		unichar c = [pstring characterAtIndex:i];
		if (c == '-') {
			// Do nothing, ignore
		} else if ((c>='0' && c<='9') || (c>='A' && c<='Z') || (c>='a' && c<='z')) {
			[s appendFormat:@"%c", c];
			wasEscaped = NO;
		} else if (!wasEscaped) {
			[s appendString:@"_"];
			wasEscaped = YES;
		}
		if (s.length>64) return s;
	}
	return s;
}

// ---------
// Debugging
// ---------
void ESDumpDictionary(NSString *pname, NSDictionary *pdict) {
#if ES_DEBUG
	ES_LOG(@"Dictionary '%@':", pname);
	ES_LOG(@"----");
	for (id pkey in pdict) {
		ES_LOG(@"%@: %@", pkey, [pdict objectForKey:pkey]);
	}
	ES_LOG(@"----");
#endif
}
