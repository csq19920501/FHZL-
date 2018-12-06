//
//  instructionCell.h
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstructionModel.h"
@interface instructionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *successButton;
@property(nonatomic,strong)InstructionModel *insHistoryModel;

@property (weak, nonatomic) IBOutlet UILabel *imeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *insName;

@property (weak, nonatomic) IBOutlet UILabel *insDesc;
@property (weak, nonatomic) IBOutlet UILabel *insIsOnline;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIButton *isSuccessButton;

@end
