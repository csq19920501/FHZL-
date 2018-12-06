//
//  CarListCell.m
//  FHZL
//
//  Created by hk on 17/12/18.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "CarListCell.h"
#import "Header.h"
#import "CustomeCsqButton.h"

@implementation CarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    if (_isOpen) {
    DISPATCH_ON_MAIN_THREAD((^{
        NSArray *buttonArray = @[L(@"Navigate"),L(@"Track"),L(@"Electronic fence"),L(@"instructions"),L(@"Alarm"),@"SIM"];
        NSArray *imageArray = @[@"列表_5_N.png",@"列表_6_N.png",@"列表_7_N.png",@"列表_8_N.png",@"列表_9_N.png",@"SIMka_N.png",];
        NSArray *higthLigthImageArray = @[@"列表_5_P.png",@"列表_6_P.png",@"列表_7_P.png",@"列表_8_P.png",@"列表_9_P.png",@"SIMka_P.png",];
        CGRect rect = _buttonBackView.bounds;
        CGFloat width = rect.size.width/buttonArray.count;
        CGFloat height = rect.size.height;
        for (int i = 0 ; i < buttonArray.count; i++) {
            CustomeCsqButton *csqButtom = [[CustomeCsqButton alloc]initWithFrame:CGRectMake(i * width, 0, width, height) normalImageStr:imageArray[i] seleImageStr:higthLigthImageArray[i] higligthImageStr:higthLigthImageArray[i] titleStr:buttonArray[i] numberStr:nil ClickBlock:^(NSInteger number){
                NSLog(@"第一次打印block方法%d",number);
                [[NSNotificationCenter defaultCenter]postNotificationName:@"GoToCarTrack" object:self userInfo:@{@"CarModel":_carModel,@"Type":[NSString stringWithFormat:@"%d",number]}];
//                switch (number) {
//                    case 0:
//                    {
//                        
//                      
//                    }
//                        break;
//                        
//                    default:
//                        break;
//                }
                
                
            }];
            csqButtom.tag = i;
            [_buttonBackView addSubview:csqButtom];
        }
    }));
//    }
}
-(void)setCarModel:(LocationModel*)model{
    _carModel = model;
    _CarIMEI.text = model.macId;

    _CarImage.image = [UIImage imageNamed:@"列表_10_P.png"];

    if (!kStringIsEmpty(model.ico)) {
        if ([model.ico intValue] >=0 && [model.ico intValue] <=8) {
             _CarImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"车子类型_%@.png",model.ico]];
        }else{
             _CarImage.image = [UIImage imageNamed:@"车子类型_8.png"];
        }
    }
    
    _CarNumber.text = model.macName;
    _isOpen = model.isOpen;
    if (_isOpen) {
        _buttonBackView.hidden = NO;
    }else{
        _buttonBackView.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        
    }
}

@end
