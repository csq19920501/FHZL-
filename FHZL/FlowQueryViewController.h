//
//  FlowQueryViewController.h
//  WeiZhong_ios
//
//  Created by haoke on 17/4/6.
//
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface FlowQueryViewController : RootViewController
+ (FlowQueryViewController *)shareInstance;
@property(nonatomic,strong)NSString *macIdStr;
@end
