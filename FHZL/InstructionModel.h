//
//  InstructionModel.h
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstructionModel : NSObject
@property(nonatomic,copy)NSString *IMEI;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *instruct;

@property(nonatomic,copy)NSString *status_desc;
@property(nonatomic,copy)NSString *createtime;
@property(nonatomic,copy)NSString *instrID;
@property(nonatomic,copy)NSString *instruct_name;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
+(instancetype)provinceWithDictionary:(NSDictionary*)dict;
@end
