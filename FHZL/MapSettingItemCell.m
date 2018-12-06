/*
 ============================================================================
 Name        : MapSettingItemCell.m
 Version     : 1.0.0
 Copyright   : 
 Description : 设置地图Cell
 ============================================================================
 */

#import "MapSettingItemCell.h"

@interface MapSettingItemCell ()
{
    IBOutlet UIImageView* __weak _iconImageView;
    IBOutlet UILabel* __weak _titleLabel;
    IBOutlet UIButton* __weak _downloadButton;
    IBOutlet UIButton* __weak _checkButton;
}

@end

@implementation MapSettingItemCell

@synthesize iconImageView = _iconImageView;
@synthesize titleLabel = _titleLabel;
@synthesize downloadButton = _downloadButton;
@synthesize checkButton = _checkButton;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
