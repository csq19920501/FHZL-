//
//  CustomeCsqButton.h
//  FHZL
//
//  Created by hk on 17/11/25.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomeCsqButton : UIButton
@property(nonatomic,strong)UIImageView *ImageView;
@property(nonatomic,strong)UILabel *TitleLabel;
@property(nonatomic,strong)UILabel *NumberLabel;
@property(nonatomic,copy)NSString *normalStr;
@property(nonatomic,copy)NSString *selectStr;
@property(nonatomic,copy)NSString *higthLigthStr;
@property(nonatomic,copy)void (^ClickActionBlock)(NSInteger buttonTag);
@property(nonatomic,assign)NSInteger NumberInt;
-(id)initWithFrame:(CGRect)frame normalImageStr:(NSString*)normalImageStr seleImageStr:(NSString *)seleImageStr titleStr:(NSString *)titleStr numberStr:(NSString *)numberStr;
-(id)initWithFrame:(CGRect)frame normalImageStr:(NSString*)normalImageStr seleImageStr:(NSString *)seleImageStr   higligthImageStr:(NSString *)higligthImageStr titleStr:(NSString *)titleStr numberStr:(NSString *)numberStr ClickBlock:(void(^)(NSInteger numberIntData))success;
-(void)setNumber:(NSString*)numberStr;
@end
