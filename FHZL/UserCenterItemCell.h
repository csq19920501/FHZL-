/*
 ============================================================================
 Name        : UserCenterItemCell.h
 Version     : 1.0.0
 Copyright   : 
 Description : 个人中心Cell
 ============================================================================
 */

#import <UIKit/UIKit.h>

@interface UserCenterItemCell : UITableViewCell

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *valueLabel;
@property (nonatomic, weak) UISwitch *valueSwitch;
@property (weak, nonatomic) IBOutlet UIButton *headButton;

@end
