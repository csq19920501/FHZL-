//
//  noPictureCell.h
//  GT
//
//  Created by hk on 17/6/21.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface noPictureCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nextPicture;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchOn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
