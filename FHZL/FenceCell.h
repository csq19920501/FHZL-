//
//  FenceCell.h
//  FHZL
//
//  Created by hk on 17/12/19.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FenceModel.h"
@interface FenceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fenceImage;
@property (weak, nonatomic) IBOutlet UILabel *fenceName;
@property (weak, nonatomic) IBOutlet UILabel *fenceAddress;
@property (weak, nonatomic) IBOutlet UILabel *fenceRail;
@property(nonatomic,strong)FenceModel *fenceModel;


@end
