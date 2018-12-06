/*
 ============================================================================
 Name        : AboutUsItemCell.h
 Version     : 1.0.0
 Copyright   : 
 Description : 关于我们Cell
 ============================================================================
 */

#import <UIKit/UIKit.h>

//cell
@interface AboutUsItemCell : UITableViewCell

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *valueLabel;

@end

//头部cell
@interface AboutUsHeaderCell : UITableViewCell

@end
