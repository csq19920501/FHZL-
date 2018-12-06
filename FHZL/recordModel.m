//
//  recordModel.m
//  GT
//
//  Created by hk on 17/6/16.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "recordModel.h"
#import "AppData.h"

@implementation recordModel
-(void)setDateStr:(NSString *)dateStr{
    
//    _dateStr = dateStr;
//    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];;
//    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:dateStr]
//                                stringByAppendingPathExtension:@"wav"]
//                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    _saveRoadStr = fileDirectory;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init])
    {
        self.recordID    = [aDecoder decodeObjectForKey:@"recordID"];
        self.dateStr       = [aDecoder decodeObjectForKey:@"dateStr"];
        self.imeiStr       = [aDecoder decodeObjectForKey:@"imeiStr"];
        self.timeStr       = [aDecoder decodeObjectForKey:@"timeStr"];
        self.loadStatusStr       = [aDecoder decodeObjectForKey:@"loadStatusStr"];
        self.saveRoadStr = [aDecoder decodeObjectForKey:@"saveRoadStr"];
        self.downPathStr    = [aDecoder decodeObjectForKey:@"downPathStr"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.recordID forKey:@"recordID"];
    [aCoder encodeObject:self.dateStr forKey:@"dateStr"];
    [aCoder encodeObject:self.imeiStr forKey:@"imeiStr"];
    [aCoder encodeObject:self.timeStr forKey:@"timeStr"];
    [aCoder encodeObject:self.loadStatusStr forKey:@"loadStatusStr"];
    [aCoder encodeObject:self.saveRoadStr forKey:@"saveRoadStr"];
    [aCoder encodeObject:self.downPathStr forKey:@"downPathStr"];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        _dateStr = dict[@"inTime"];
        _imeiStr = dict[@"macId"];
        _timeStr = dict[@"timeLong"];
        _downPathStr = dict[@"sPath"];
        _recordID = dict[@"id"];
        NSInteger fileLong = [AppData getFileSize:[AppData getFilePath:[NSString stringWithFormat:@"/%@%@.wav",_imeiStr,_recordID]]];
        if (fileLong > 0) {
            _loadStatusStr = @"3";
            _saveRoadStr = [NSString stringWithFormat:@"/%@%@.wav",_imeiStr,_recordID];
        }else{
            _loadStatusStr = @"1";
        }
        
    }
    return self;
    
}

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict

{
    return [[self alloc] initWithDictionary:dict];
}
@end

