//
//  NaviModel.h
//  WeiZhong_ios
//
//  Created by hk on 17/9/25.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NaviModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString *addName; //地址
@property (nonatomic, strong) NSString *content; //说明
@property (nonatomic, strong) NSString *sendTime; //发送时间
@property (nonatomic, assign) CGFloat srcX; //出发地经度
@property (nonatomic, assign) CGFloat srcY; //出发地纬度
@end
