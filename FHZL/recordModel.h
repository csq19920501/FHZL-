//
//  recordModel.h
//  GT
//
//  Created by hk on 17/6/16.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recordModel : NSObject<NSCoding>
@property(nonatomic ,strong)NSString *dateStr;
@property(nonatomic ,strong)NSString *imeiStr;
@property(nonatomic ,strong)NSString *timeStr;
@property(nonatomic ,strong)NSString *loadStatusStr;
@property(nonatomic ,strong)NSString *saveRoadStr;
@property(nonatomic ,strong)NSString *downPathStr;
@property(nonatomic ,strong)NSString *recordID;
@property(nonatomic ,assign)BOOL isPlay;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)provinceWithDictionary:(NSDictionary *)dict;
@end
