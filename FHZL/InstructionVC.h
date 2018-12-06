//
//  InstructionVC.h
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "RootViewController.h"
#import "InstructionStateModel.h"
typedef NS_OPTIONS(NSInteger,MacType){
    None = 0,
    DR30 = 2,
    GT_31 = 3,
    GT_51 = 4,
    GT_121 ,
    GT_52 ,
};
@interface InstructionVC : RootViewController
@property(nonatomic,strong)InstructionStateModel *insStateModel;
@property(nonatomic,assign)MacType macType;
@end
