//
//  CarListModel.h
//  FHZL
//
//  Created by hk on 17/12/19.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarListModel : NSObject
@property(nonatomic,copy)NSString *CarNumber;
@property(nonatomic,copy)NSString *CarIMEI;
@property(nonatomic,copy)NSString *CarImage;
@property(nonatomic,assign)BOOL  isOpen;
@end
