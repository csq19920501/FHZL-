/*
 ============================================================================
 Name        : MapSettingItemCell.h
 Version     : 1.0.0
 Copyright   : 
 Description : 设置地图Cell
 ============================================================================
 */

#import <UIKit/UIKit.h>

@interface MapSettingItemCell : UITableViewCell

@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *downloadButton;
@property (nonatomic, weak) UIButton *checkButton;

@end
