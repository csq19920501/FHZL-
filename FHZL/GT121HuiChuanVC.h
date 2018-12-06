//
//  GT121HuiChuanVC.h
//  FHZL
//
//  Created by hk on 2018/7/6.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "RootViewController.h"
#import "Gt121Model.h"
@interface GT121HuiChuanVC : RootViewController
@property(nonatomic,strong)Gt121Model *gt121Model;
@property(nonatomic,copy)void (^changeGT121)(Gt121Model *gt121Model);


@property (weak, nonatomic) IBOutlet UIButton *twoYearButt;
@property (weak, nonatomic) IBOutlet UIButton *threeYearButt;

@property (weak, nonatomic) IBOutlet UILabel *timeModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekModeLabel;
@property (weak, nonatomic) IBOutlet UIButton *weekOpenButt;
@property (weak, nonatomic) IBOutlet UIButton *weekCloseButt;
@property (weak, nonatomic) IBOutlet UIButton *weekOneBut;
@property (weak, nonatomic) IBOutlet UIButton *weekTwoButt;
@property (weak, nonatomic) IBOutlet UIButton *weekThreeButt;
@property (weak, nonatomic) IBOutlet UIButton *weekFourButt;
@property (weak, nonatomic) IBOutlet UIButton *weekFiveButt;
@property (weak, nonatomic) IBOutlet UIButton *weekSixButt;
@property (weak, nonatomic) IBOutlet UIButton *weekSevenButt;
@property (weak, nonatomic) IBOutlet UILabel *alarmLabel;
@property (weak, nonatomic) IBOutlet UIButton *alarmOpenBUtt;
@property (weak, nonatomic) IBOutlet UIButton *alarmCloseBut;

@property (weak, nonatomic) IBOutlet UIButton *oneGroupBut;
@property (weak, nonatomic) IBOutlet UIButton *twoGroupBut;
@property (weak, nonatomic) IBOutlet UIButton *threeGroupBut;
@property (weak, nonatomic) IBOutlet UIButton *fourGroupBUt;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBut;

@end
