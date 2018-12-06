//
//  FilterModel.h
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>
//缺少  104 掉b+   107 sos报警  110汽车异常移动  112 设备摘除警报  200 电子围栏
@interface FilterModel : NSObject<NSCoding>
@property(nonatomic,assign)BOOL hasOil;
@property(nonatomic,assign)BOOL hasZhengDong;
@property(nonatomic,assign)BOOL hasAccOpen;
@property(nonatomic,assign)BOOL hasAccClose;
@property(nonatomic,assign)BOOL hasGoInMangQu;
@property(nonatomic,assign)BOOL hasGoOutMangQu;
@property(nonatomic,assign)BOOL HasSpeed;
@property(nonatomic,assign)BOOL HasCarDoor;
@property(nonatomic,assign)BOOL HasDropB;
@property(nonatomic,assign)BOOL HasSoS;
@property(nonatomic,assign)BOOL HasCarMove;
@property(nonatomic,assign)BOOL HasDeviceClean;
@property(nonatomic,assign)BOOL HasCarFence;//驶出
@property(nonatomic,assign)BOOL HasCarFenceIn;//进入
-(void)setAll;
-(NSArray *)getArray;
-(FilterModel *)csqCopy;
@end
