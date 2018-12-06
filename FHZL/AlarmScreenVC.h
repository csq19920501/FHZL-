//
//  AlarmScreenVC.h
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "RootViewController.h"

@interface AlarmScreenVC : RootViewController
@property(nonatomic,copy)void (^blackRefresh)();
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@end
