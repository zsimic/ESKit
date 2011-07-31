//
//  NamedArray.m
//  PrettyGoodCountdown
//
//  Created by Zoran Simic on 9/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NamedArray.h"

@implementation NamedArray

@synthesize name;

// Initialization
// --------------
- (void)initialize {
	items = [[NSMutableArray alloc] init];
}

- (id)initWithName:(NSString *)pname items:(NSMutableArray *)pitems {
	if (self = [super init]) {
		name = [pname retain];
		items = [pitems retain];
	}
	return self;
}

- (id)initWithName:(NSString *)pname {
	if (self = [super init]) {
		[self initialize];
	}
	return self;
}

- (id)init {
	if (self = [super init]) {
		[self initialize];
	}
	return self;
}

- (void)dealloc {
	ESRELEASE(name);
	ESRELEASE(items);
	[super dealloc];
}

// Class methods
// -------------
+ (NamedArray *)withName:(NSString *)pname, ... {
	NamedArray *a = ESAUTO([[NamedArray alloc] initWithName:pname items:nil]);
	return a;
}

// Access
// ------
- (id)objectAtIndex:(int)pindex {
	return [items objectAtIndex:pindex];
}

- (void)addObject:(id)pobject {
	[items addObject:pobject];
}

- (void)addObjectsFromArray:(NSArray *)pobjects {
	[items addObjectsFromArray:pobjects];
}

- (void)removeObjectAtIndex:(int)pindex {
	[items removeObjectAtIndex:pindex];
}

- (void)removeObject:(id)pobject {
	[items removeObject:pobject];
}

// Properties
// ----------
- (int)count {
	return items.count;
}

@end