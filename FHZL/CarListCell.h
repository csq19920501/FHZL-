//
//  CarListCell.h
//  FHZL
//
//  Created by hk on 17/12/18.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationModel.h"
@interface CarListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *buttonBackView;
@property (weak, nonatomic) IBOutlet UIButton *LocalButton;
@property (weak, nonatomic) IBOutlet UILabel *CarNumber;
@property (weak, nonatomic) IBOutlet UILabel *CarIMEI;
@property (weak, nonatomic) IBOutlet UIImageView *CarImage;
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,strong)LocationModel*carModel;
//-(void)setCarModel:(CarListModel*)model;
@end
