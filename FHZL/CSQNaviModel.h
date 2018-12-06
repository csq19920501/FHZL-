//
//  CSQNaviModel.h
//  FHZL
//
//  Created by hk on 2018/8/3.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationModel.h"
@interface CSQNaviModel : NSObject
+(void)sendNaviWithModel:(LocationModel*)model;
@end
