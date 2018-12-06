//
//  TimePickView.h
//  FHZL
//
//  Created by hk on 2018/7/9.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZPickView.h"
@interface TimePickView : UIView<XZPickViewDataSource,XZPickViewDelegate>

@property(nonatomic,assign)NSInteger selectHour;
@property(nonatomic,assign)NSInteger selectMin;
@property(nonatomic,copy)void (^confirmClick)(NSInteger hour,NSInteger min);
-(instancetype)initWithFrame:(CGRect)frame Hour:(NSInteger)hour Min:(NSInteger)min;
@end
