//
//  recordCell.m
//  GT
//
//  Created by hk on 17/6/16.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "recordCell.h"
#import "LocalizedStringTool.h"
#import "UserManager.h"
@implementation recordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _backVIew.layer.masksToBounds = YES;
    _backVIew.layer.cornerRadius = 5.;

    _loadButton.layer.masksToBounds = YES;
    _loadButton.layer.cornerRadius = 3.;
}                          
-(void)setModel:(recordModel*)model{
    self.dateLabel.text = [NSString stringWithFormat:@"%@:%@",L(@"Time"),[UserManager getDateDisplayString:[model.dateStr longLongValue]]];
    self.imeiLabel.text = [NSString stringWithFormat:@"IMEI:%@",model.imeiStr];
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@",model.timeStr,L(@"s")];;
    switch ([model.loadStatusStr intValue]) {
        case 1:
//            [self.loadButton setTitle:L(@"Not downloaded") forState:UIControlStateNormal];
//            [self.loadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _playLabel.text = L(@"Not downloaded");
            break;
        case 2:
//            [self.loadButton setTitle:L(@"Downloading") forState:UIControlStateNormal];
//            [self.loadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _playLabel.text = L(@"Downloading");
            break;
        case 3:
//            [self.loadButton setTitle:L(@"play") forState:UIControlStateNormal];
//            [self.loadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _playLabel.text = L(@"Click Play");
            break;
        case 4:
//            [self.loadButton setTitle:L(@"Download failed") forState:UIControlStateNormal];
//            [self.loadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             _playLabel.text = L(@"Download failed");
            break;
        default:
            break;
    }
    if (model.isPlay) {
//        [self.loadButton setTitle:L(@"Playing") forState:UIControlStateNormal];
//        [self.loadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
         _playLabel.text = L(@"Playing");
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
