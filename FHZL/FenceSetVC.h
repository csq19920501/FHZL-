//
//  FenceSetVC.h
//  FHZL
//
//  Created by hk on 17/12/21.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FenceModel.h"
#import "LocationModel.h"
#import "Header.h"
@interface FenceSetVC : RootViewController
@property(nonatomic,strong)LocationModel *carModel;
@property(nonatomic,strong)FenceModel *fenModel;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;

@property (weak, nonatomic) IBOutlet UILabel *minRadius;
@property (weak, nonatomic) IBOutlet UILabel *maxRadius;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *inBUtton;
@property (weak, nonatomic) IBOutlet UIButton *outBUtton;

@end
