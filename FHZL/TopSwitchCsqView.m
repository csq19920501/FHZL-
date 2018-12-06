//
//  TopSwitchCsqView.m
//  FHZL
//
//  Created by hk on 17/11/24.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "TopSwitchCsqView.h"
#define bottonWIDTH 90
@implementation TopSwitchCsqView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}
-(void)codered:(CGRect)frame :(NSArray*)titleArray categryStr:(NSString*)categryStr{
    CGFloat viewHeigth = frame.size.height;
    CGFloat viewWidth = frame.size.width;
    long  buttonNumber = titleArray.count;
    
    _CategryStr = categryStr;
    _bottonView = [[UIView alloc]initWithFrame:self.bounds];
    _bottonView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottonView];
    for (int  i = 0; i < buttonNumber; i ++) {
        
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        topButton.frame = CGRectMake(i*viewWidth/buttonNumber, 0, viewWidth/buttonNumber, viewHeigth);
        //            topButton.titleLabel.text = titleArray[i];
        [topButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [topButton setTitle:titleArray[i] forState:UIControlStateSelected];
        
        [topButton setTitleColor:[UIColor colorWithRed:19/255. green:154/255. blue:252/255. alpha:1] forState:UIControlStateSelected];
        [topButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        topButton.tag = 1000 + i;
        topButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottonView addSubview:topButton];
        if (i == 0) {
            topButton.selected = YES;
        }else{
            //添加间隔线
            CGFloat heigths = (viewHeigth - 30)/2;
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, heigths, 1, viewHeigth - 2*heigths)];
            lineLabel.backgroundColor  = [[UIColor grayColor]colorWithAlphaComponent:0.5];
            [topButton addSubview:lineLabel];
        }
    }
    _titleArray = titleArray;
}
- (id)initWithFrame:(CGRect)frame :(NSArray*)titleArray categryStr:(NSString*)categryStr
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat viewHeigth = frame.size.height;
        CGFloat viewWidth = frame.size.width;
        long  buttonNumber = titleArray.count;
        
        _CategryStr = categryStr;
        _bottonView = [[UIView alloc]initWithFrame:self.bounds];
        _bottonView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottonView];
        for (int  i = 0; i < buttonNumber; i ++) {
            
            UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
            topButton.frame = CGRectMake(i*viewWidth/buttonNumber, 0, viewWidth/buttonNumber, viewHeigth);

            [topButton setTitle:titleArray[i] forState:UIControlStateNormal];
            [topButton setTitle:titleArray[i] forState:UIControlStateSelected];
           
            [topButton setTitleColor:[UIColor colorWithRed:19/255. green:154/255. blue:252/255. alpha:1] forState:UIControlStateSelected];
            [topButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            topButton.tag = 1000 + i;
            topButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bottonView addSubview:topButton];
            if (i == 0) {
                topButton.selected = YES;
            }else{
                //添加间隔线
                CGFloat heigths = (viewHeigth - 30)/2;
                UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, heigths, 1, viewHeigth - 2*heigths)];
                lineLabel.backgroundColor  = [[UIColor grayColor]colorWithAlphaComponent:0.5];
                [topButton addSubview:lineLabel];
            }
        }
        _titleArray = titleArray;
    }
    return self;
}
-(void)topButtonClick:(UIButton*)but{
    int tag = (int)but.tag - 1000;
    if (!but.selected) {
        for (UIButton *button in _bottonView.subviews) {
            button.selected = NO;
        }
        but.selected = YES;
        if (_topSwitchDele && [_topSwitchDele respondsToSelector:@selector(topButtonClick: categryStr:)] ) {
            [_topSwitchDele topButtonClick:tag categryStr:_CategryStr];
        }
    }
}
-(void)setSelectButton:(int)tag{
    for (UIButton *button in _bottonView.subviews) {
        button.selected = NO;
    }
    UIButton *but = [self viewWithTag:1000 + tag];
    but.selected = YES;
}
-(void)reSetTitleStr:(NSArray *)array{
    for (NSString *titleStr in array) {
        int a = [array indexOfObject: titleStr];
        UIButton *but = [self viewWithTag:1000 + a];
        [but setTitle:titleStr forState:UIControlStateNormal];
        [but setTitle:titleStr forState:UIControlStateSelected];
    }
}

@end
