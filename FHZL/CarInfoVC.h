//
//  CarInfoVC.h
//  FHZL
//
//  Created by hk on 17/12/21.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationModel.h"
#import "Header.h"
@interface CarInfoVC : RootViewController
@property(nonatomic,strong)LocationModel *carModel;

@property (weak, nonatomic) IBOutlet UILabel *apnLabel;
@property (weak, nonatomic) IBOutlet UILabel *queryLabel;

@end
