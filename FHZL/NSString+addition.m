/*
 ============================================================================
 Name        : NSString+addition.m
 Version     : 1.0.0
 Copyright   : 
 Description : NSString addition functions
 ============================================================================
 */

#import "NSString+addition.h"


@implementation NSString (addition)

-(NSString *)md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(original_str, strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
    {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}

- (NSString*)urlEncode
{
    NSMutableString* output = [NSMutableString string];
    const unsigned char* source = (const unsigned char*)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; i++)
    {
        const unsigned char thisChar = source[i];
        if (thisChar == '!' || thisChar == '*' || thisChar == '\'' || thisChar == '(' || thisChar == ')' || thisChar == ';' || thisChar == '@' || thisChar == '&' || thisChar == '=' || thisChar == '+' || thisChar == '$' || thisChar == ',' || thisChar == '/' || thisChar == ':' ||  thisChar == '?' ||  thisChar == '%' || thisChar == '#' || thisChar == '['  || thisChar == ']' || thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
            (thisChar >= 'a' && thisChar <= 'z') ||
            (thisChar >= 'A' && thisChar <= 'Z') ||
            (thisChar >= '0' && thisChar <= '9'))
        {
            [output appendFormat:@"%c", thisChar];
        }
        else
        {
            [output appendFormat:@"%%%02x", thisChar];
        }
    }
    
    return output;
}

+ (NSString*)stringWithTime:(NSDate*)time isIncludeTime:(BOOL)isIncludeTime
{
	NSCalendar* cal = [NSCalendar currentCalendar];
	NSDateComponents* comp = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:time];
	
	NSDate* currDate = [NSDate date];
	NSDateComponents* currComp = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:currDate];
	
	NSMutableString* timeStr = [[NSMutableString alloc] init];
	if ([currComp year] == [comp year]
		&& [currComp month] == [comp month]
		&& [currComp day] == [comp day])
    {
        [timeStr appendFormat:@"%02d:%02d:%02d", [comp hour], [comp minute], [comp second]];
	}
    else
    {
		[timeStr appendFormat:@"%d-%02d-%02d", [comp year], [comp month], [comp day]];
        
        if (isIncludeTime)
        {
            [timeStr appendString:@" "];
            [timeStr appendFormat:@"%02d:%02d:%02d", [comp hour], [comp minute], [comp second]];
        }
	}
    
	return timeStr;
}

@end
