//  esmiler - Useful/handy macros, allow to reduce verbosity when writing, and provide a way to easily write assertions
//  Created by zoran on 12/31/08. Copyright 2009 esmiler.com. All rights reserved

#import <Foundation/Foundation.h>
#include "TargetConditionals.h"

// Globals
NSBundle *esBundle;

void setEsBundle(NSString *lang);

// Handy macros
#define ESFS(msg...) [NSString stringWithFormat:msg]
#define ESViewRep(what, v) ESFS(@"%@: hidden=%i, frame=%1.0f %1.0f %1.0f %1.0f - superview=%@", what, v.hidden, v.frame.origin.x, v.frame.origin.y, v.frame.size.width, v.frame.size.height, [v superview])
#define ESRectRep(r) ESFS(@"%1.0f %1.0f %1.0f %1.0f", r.origin.x, r.origin.y, r.size.width, r.size.height)

// The following allows to report/raise errors only when ES_DEBUG is defined

// ---------------- Debug mode
#if ES_DEBUG

#define ES_ASSERT(cond) assert(cond);
//#define ES_LOG(msg...) printf("%s %d:\t%s\n", __PRETTY_FUNCTION__, __LINE__, [ESFS(msg) UTF8String]);
#define ES_LOG(msg...) printf("%s %s\n", [ESFS(@"%@", [NSDate date]) UTF8String], [ESFS(msg) UTF8String]);
#define ES_TRACE(msg...) ES_LOG(msg)
#define ES_CHECKF(cond, ret, msg...) if (!(cond)) { ES_LOG(msg) ES_ASSERT(cond) return (ret); }		// Check for routines for which checking may have an important performance impact

#define ESRELEASE(v) [v release]; v = nil
//#define ESRELEASE(v) if ((v!=nil) && ([v retainCount]==1)) ES_LOG(@"Released %@ *" #v " %@", [v class], [v description]) [v release]; v = nil

#define ESCFShow(x) CFShow(x);

// ---------------- Release mode
#else

#define ES_ASSERT(cond)							// No assert, log or trace in release mode...
#define ES_LOG(msg...)
#define ES_TRACE(msg...)
#define ES_CHECKF(cond, ret, msg...)

#define ESRELEASE(v) [v release]; v = nil		// One should *always* set to nil released objects, this macro allows to make sure not to forget that

#define ESCFShow(x)

#endif
// ----------------

#if ES_DEBUG
#define ES_CHECK_NR(cond, msg...) if (!(cond)) { ES_LOG(msg) ES_ASSERT(cond) return; }				// Check for procedures (no return value)
#define ES_CHECK(cond, ret, msg...) if (!(cond)) { ES_LOG(msg) ES_ASSERT(cond) return (ret); }		// Check with specified return value (when condition fails)
#else
#define ES_CHECK_NR(cond, msg...)
#define ES_CHECK(cond, ret, msg...)
#endif

// Root of wikipedia pages, optimized for the iPhone
#define ES_WIKIPEDIA @"http://en.m.wikipedia.org/wiki/"

// The following allows to simplify a bit things like [[[MyObject alloc] init] autorelease]; -- one pair of square brackets less
// It also allows to find all statements of this form quickly, and provides a way to customize this in the future
#define ESAUTO(v) [v autorelease]

// Quick macro for easy access to bundle version number
#define EsBuildNumber		[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

// Devide model name stripped of 'special' characters (suitable for easy sending in URLs, without encoding)
#define ESDeviceModel		escapedString([[UIDevice currentDevice] model])

// User name stripped of 'special' characters (suitable for easy sending in URLs, without encoding)
#define ESDeviceUserName	escapedString([[UIDevice currentDevice] name])

#define ES_isiPhone()		[[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]


// Text translated in current language
// -----------------------------------
NSString *tr(NSString *text, ...);

NSString *escapedString (NSString *pstring);	// String with all non alpha-numeric characters removed
void ESDumpDictionary(NSString *pname, NSDictionary *pdict);
