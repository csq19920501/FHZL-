//
//  CustomeCsqButton.m
//  FHZL
//
//  Created by hk on 17/11/25.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "CustomeCsqButton.h"

@implementation CustomeCsqButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame normalImageStr:(NSString*)normalImageStr seleImageStr:(NSString *)seleImageStr titleStr:(NSString *)titleStr numberStr:(NSString *)numberStr {
    CGFloat higth = frame.size.height;
    CGFloat width = frame.size.width;
    CGFloat imageWidth = (higth )*2/3;
    CGFloat titleHigth = (higth )/3;
    CGFloat numberLabelWidth = 20;
    self = [super initWithFrame:frame];
    if (self) {
        _normalStr = normalImageStr;
        _selectStr = seleImageStr;
        _ImageView = [[UIImageView alloc]initWithFrame:CGRectMake((width - imageWidth)/2, 0, imageWidth, imageWidth)];
        _ImageView.image = [UIImage imageNamed:normalImageStr];
        [self addSubview:_ImageView];
        
        _TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _ImageView.frame.size.height + _ImageView.frame.origin.y, width, titleHigth)];
        _TitleLabel.text = titleStr;
        _TitleLabel.textColor = [UIColor blackColor];
        _TitleLabel.textAlignment = NSTextAlignmentCenter;
        _TitleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_TitleLabel];
        
        _NumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageWidth - numberLabelWidth/2, 0, numberLabelWidth, numberLabelWidth)];
        _NumberLabel.backgroundColor = [UIColor redColor];
        _NumberLabel.textColor = [UIColor whiteColor];
        _NumberLabel.textAlignment = NSTextAlignmentCenter;
        _NumberLabel.layer.cornerRadius = numberLabelWidth/2;
        _NumberLabel.layer.masksToBounds = YES;
        [_ImageView addSubview:_NumberLabel];
        if ([numberStr isEqualToString:@"0"] || numberStr == nil) {
            _NumberLabel.hidden = YES;
        }else{
            _NumberLabel.text = numberStr;
        }
        
    }
    return self;
}

/*  包含高亮图片
 *
 */
-(id)initWithFrame:(CGRect)frame normalImageStr:(NSString*)normalImageStr seleImageStr:(NSString *)seleImageStr   higligthImageStr:(NSString *)higligthImageStr titleStr:(NSString *)titleStr numberStr:(NSString *)numberStr ClickBlock:(void(^)(NSInteger numberIntData))success {
    CGFloat higth = frame.size.height;
    CGFloat width = frame.size.width;
    CGFloat imageWidth = (higth )*2/3;
    CGFloat titleHigth = (higth )/3;
    CGFloat numberLabelWidth = 20;
    self = [super initWithFrame:frame];
    if (self) {
        _normalStr = normalImageStr;
        _selectStr = seleImageStr;
        _higthLigthStr = higligthImageStr;
        _ClickActionBlock = success;

        _ImageView = [[UIImageView alloc]initWithFrame:CGRectMake((width - imageWidth)/2, 0, imageWidth, imageWidth)];
        _ImageView.image = [UIImage imageNamed:normalImageStr];
        [self addSubview:_ImageView];
        
        _TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _ImageView.frame.size.height + _ImageView.frame.origin.y, width, titleHigth)];
        _TitleLabel.text = titleStr;
        _TitleLabel.textColor = [UIColor blackColor];
        _TitleLabel.textAlignment = NSTextAlignmentCenter;
        _TitleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_TitleLabel];
        
        _NumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(imageWidth - numberLabelWidth/2, 0, numberLabelWidth, numberLabelWidth)];
        _NumberLabel.backgroundColor = [UIColor redColor];
        _NumberLabel.textColor = [UIColor whiteColor];
        _NumberLabel.textAlignment = NSTextAlignmentCenter;
        _NumberLabel.layer.cornerRadius = numberLabelWidth/2;
        _NumberLabel.layer.masksToBounds = YES;
        [_ImageView addSubview:_NumberLabel];
        if ([numberStr isEqualToString:@"0"] || numberStr == nil) {
            _NumberLabel.hidden = YES;
        }else{
            _NumberLabel.text = numberStr;
        }
        [self addTarget:self action:@selector(ClickAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
-(void)ClickAction{
    if (self.ClickActionBlock) {
        self.ClickActionBlock(self.tag);
    }
}
-(void)setSelected:(BOOL)selected{
    [super setSelected: selected];
    if (selected) {
        [_ImageView setImage:[UIImage imageNamed:_selectStr]];
    }else{
        [_ImageView setImage:[UIImage imageNamed:_normalStr]];
    }
}
-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        [_ImageView setImage:[UIImage imageNamed:_higthLigthStr]];
    }else{
        [_ImageView setImage:[UIImage imageNamed:_normalStr]];
    }
}
-(void)setNumber:(NSString*)numberStr {
    if ([numberStr isEqualToString:@"0"] || numberStr == nil) {
        _NumberLabel.hidden = YES;
    }else{
        _NumberLabel.text = numberStr;
        _NumberLabel.hidden = NO;
    }
}
@end
