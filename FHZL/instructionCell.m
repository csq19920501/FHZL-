//
//  instructionCell.m
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "instructionCell.h"
#import "UserManager.h"
@implementation instructionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.successButton.layer.cornerRadius = 4;
    self.successButton.layer.masksToBounds = YES;
//    [_successButton setTitle:NSLocalizedString(@"Success", nil) forState:UIControlStateNormal];
//    [_successButton setTitle:NSLocalizedString(@"Failed", nil) forState:UIControlStateNormal];
}
-(void)setInsHistoryModel:(InstructionModel*)model{
    _insHistoryModel = model;
    _imeiLabel.text = [NSString stringWithFormat:@"IMEI:%@",model.IMEI];
    _insName.text = model.instruct_name;
    _insDesc.text = model.status_desc;
    _timeLable.text = [UserManager getDateDisplayString:(long long)[model.createtime longLongValue]];
    _insIsOnline.text = NSLocalizedString(@"Online send", nil);
//    _successButton.selected = !([model.status intValue] == 1015205);
    if (([model.status intValue] == 0)) {
        
        [_successButton setTitle:NSLocalizedString(@"Success", nil) forState:UIControlStateNormal];
        [_successButton setBackgroundColor:[UIColor colorWithRed:64/255.0 green:174/255.0 blue:248/255.0 alpha:1]];
    }else{
        [_successButton setTitle:NSLocalizedString(@"Failed", nil) forState:UIControlStateNormal];
        [_successButton setBackgroundColor:[UIColor lightGrayColor]];
//        NSLog(@"model.status DEFAULT= %@",model.status);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
