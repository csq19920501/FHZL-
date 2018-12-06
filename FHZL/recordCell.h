//
//  recordCell.h
//  GT
//
//  Created by hk on 17/6/16.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "recordModel.h"

@interface recordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backVIew;
@property (weak, nonatomic) IBOutlet UILabel *imeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, copy)  NSString * filePath;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;


-(void)setModel:(recordModel*)model;
@end
