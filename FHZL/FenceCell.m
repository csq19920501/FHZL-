//
//  FenceCell.m
//  FHZL
//
//  Created by hk on 17/12/19.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "FenceCell.h"
#import "Header.h"
@implementation FenceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFenceModel:(FenceModel *)fenceModel{
    _fenceModel = fenceModel;
    if ([fenceModel.activate isEqualToString:@"0"]) {
        _fenceImage.image = [UIImage imageNamed:@"电子围栏_内容区_围栏图标_D.png"];
    }else{
        _fenceImage.image = [UIImage imageNamed:@"10_N.png"];
    }
    
    _fenceName.text = fenceModel.name;
    _fenceAddress.text = fenceModel.address;//fenceModel.
    _fenceRail.text = [NSString stringWithFormat:@"%@%@%@",L(@"radius"),fenceModel.radius,L(@"M")];
    _numberLabel.text = [NSString stringWithFormat:@"%d",[fenceModel.num integerValue] + 1];
    
}
@end
