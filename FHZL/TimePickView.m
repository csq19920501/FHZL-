//
//  TimePickView.m
//  FHZL
//
//  Created by hk on 2018/7/9.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "TimePickView.h"

@implementation TimePickView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame Hour:(NSInteger)hour Min:(NSInteger)min{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectMin = min;
        self.selectHour = hour;
        [self setupViews];
    }
    return self;
}
-(void)setupViews{
    
    XZPickView *pickView =[[XZPickView alloc]initWithFrame:self.bounds title:nil];
    pickView.delegate = self;
    pickView.dataSource = self;
    [self addSubview:pickView];
    [pickView show];
    [pickView selectRow:self.selectHour inComponent:0 animated:YES];
    [pickView selectRow:self.selectMin inComponent:1 animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(XZPickView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(XZPickView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 24;
    }else if (component == 1){
        return 1;
    }else{
        return 60;
    }
}
- (NSString *)pickerView:(XZPickView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [NSString stringWithFormat:@"%02d",(int)row];
    }else if (component == 1){
        return @":";
    }else{
        return [NSString stringWithFormat:@"%02d",(int)row];
    }
}
- (void)pickView:(XZPickView *)pickerView confirmButtonClick:(UIButton *)button
{
    if (self.confirmClick) {
        self.confirmClick(self.selectHour,self.selectMin);
    }
}
- (void)dismiss:(XZPickView *)pickerView
{
//    [UIView animateWithDuration:0.3 animations:^{
//        self.top = KScreenHeight;
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    [self removeFromSuperview];
}
- (void)pickerView:(XZPickView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _selectHour = row;
    }else if(component == 2){
        self.selectMin = row;
    }
}
@end
