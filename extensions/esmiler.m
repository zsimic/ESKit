//  esmiler - Useful/handy macros, allow to reduce verbosity when writing, and provide a way to easily write assertions
//  Created by zoran on 12/31/08. Copyright 2009 esmiler.com. All rights reserved

#import "esmiler.h"

NSBundle *esBundle = nil;

void setEsBundle(NSString *lang) {
	ESRELEASE(esBundle);
	if (lang==nil) {
		esBundle = [[NSBundle mainBundle] retain];
	} else {
		NSString* path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:ESFS(@"%@.lproj", lang)];
		esBundle = [[NSBundle bundleWithPath:path] retain];
//		ES_LOG(@"path: %@, bundle: %@", path, esBundle);
	}
}

// Text translated in current language
NSString *tr(NSString *format, ...) {
	// TODO: get translation of 'format' and return it
	//#define NSLocalizedString(key, comment) \
	//	    [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
	NSString *tf = format;
	if (esBundle!=nil) {
		tf = [esBundle localizedStringForKey:format value:nil table:nil];
	}
	va_list args;
	va_start(args, format);
	NSString *s = ESAUTO([[NSString alloc] initWithFormat:tf arguments:args]);
	va_end(args);
	return s;
}

// ----------
// Formatting
// ----------
// String with all non alpha-numeric characters removed
NSString *escapedString (NSString *pstring) {
	NSMutableString *s = ESAUTO([[NSMutableString alloc] init]);
	BOOL wasEscaped = YES;
	int n = pstring.length;
    int i;
	for (i=0; i<n; i++) {
		char c = [pstring characterAtIndex:i];
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
