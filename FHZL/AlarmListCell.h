//
//  AlarmListCell.h
//  FHZL
//
//  Created by hk on 17/12/21.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "alarmModel.h"
@interface AlarmListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *alarmImage;
@property (weak, nonatomic) IBOutlet UILabel *alarmIMEILabel;
@property (weak, nonatomic) IBOutlet UILabel *alrmType;
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property(nonatomic,strong)alarmModel *AlarmModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidth;

@end
