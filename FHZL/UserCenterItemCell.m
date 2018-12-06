/*
 ============================================================================
 Name        : UserCenterItemCell.m
 Version     : 1.0.0
 Copyright   : 
 Description : 个人中心Cell
 ============================================================================
 */

#import "UserCenterItemCell.h"

@interface UserCenterItemCell ()
{
    IBOutlet UILabel* __weak _titleLabel;
    IBOutlet UILabel* __weak _valueLabel;
    IBOutlet UISwitch* __weak _valueSwitch;
}

@end

@implementation UserCenterItemCell

@synthesize titleLabel = _titleLabel;
@synthesize valueLabel = _valueLabel;
@synthesize valueSwitch = _valueSwitch;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
