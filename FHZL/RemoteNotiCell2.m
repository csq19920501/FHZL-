//
//  RemoteNotiCell.m
//  GT
//
//  Created by hk on 17/6/9.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "RemoteNotiCell2.h"
#import "Header.h"
@implementation RemoteNotiCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5.;

}

-(void)setModel:(NaviModel*)model{
    _titelLabel.text = model.addName;
    _timeLabel.text = model.sendTime;
    _concentLabel.text = model.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
