//
//  RemoteNotiCell.h
//  GT
//
//  Created by hk on 17/6/9.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviModel.h"
@interface RemoteNotiCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titelLabel;
@property (weak, nonatomic) IBOutlet UILabel *concentLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;

-(void)setModel:(NaviModel*)model;
@end
