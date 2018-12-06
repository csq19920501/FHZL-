//
//  FenceModel.h
//  FHZL
//
//  Created by hk on 18/1/3.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FenceModel : NSObject
@property(nonatomic,copy)NSString *fenceId;
@property(nonatomic,copy)NSString *macId;
@property(nonatomic,copy)NSString *macType;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *radius;
@property(nonatomic,copy)NSString *activate;
@property(nonatomic,copy)NSString *x;
@property(nonatomic,copy)NSString *y;
@property(nonatomic,copy)NSString *mode;
@property(nonatomic,copy)NSString *num;
@property(nonatomic,copy)NSString *createDate;
@property(nonatomic,copy)NSString *address;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
+(instancetype)provinceWithDictionary:(NSDictionary *)dict;
@end
