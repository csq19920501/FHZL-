/*
 ============================================================================
 Name        : NSDictionary+addition.m
 Version     : 1.0.0
 Copyright   : 
 Description : NSDictionary additions
 ============================================================================
 */

#import "NSDictionary+addition.h"


@implementation NSDictionary (addition)

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [self objectForKey:key] == [NSNull null] ? defaultValue
    : [[self objectForKey:key] boolValue];
}

- (NSInteger)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue
{
	return [self objectForKey:key] == [NSNull null] ? defaultValue : [[self objectForKey:key] integerValue];
}

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue {
	NSString *stringTime   = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
	struct tm created;
    time_t now;
    time(&now);
    
	if (stringTime) {
		if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL) {
			strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
		}
		return mktime(&created);
	}
	return defaultValue;
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
	return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] longLongValue];
}

- (unsigned long long)getUnsignedLongLongValueValueForKey:(NSString *)key defaultValue:(unsigned long long)defaultValue {
    return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] unsignedLongLongValue];
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
	return [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null] ? defaultValue : [self objectForKey:key];
}


@end
