// NamedArray - Simple array of objects with a name
// Created by Zoran Simic on 9/29/09. Copyright 2009 esmiler.com. All rights reserved.

#import <Foundation/Foundation.h>
#import "esmiler.h"

@interface NamedArray : NSObject {
	NSString *name;				// Name of this list
	NSMutableArray *items;		// Actual array
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, readonly) int count;

+ (NamedArray *)withName:(NSString *)pname, ...;

- (id)initWithName:(NSString *)pname;

- (id)objectAtIndex:(int)pindex;
- (void)addObject:(id)pobject;
- (void)addObjectsFromArray:(NSArray *)pobjects;
- (void)removeObjectAtIndex:(int)pindex;
- (void)removeObject:(id)pobject;

@end
