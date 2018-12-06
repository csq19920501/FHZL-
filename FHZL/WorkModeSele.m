/*
 ============================================================================
 Name        : HotlineViewController.m
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */
#import "Header.h"
#import <QuartzCore/QuartzCore.h>
#import "WorkModeSele.h"
#import "UIUtil.h"
#import "LocalizedStringTool.h"


@interface WorkModeSele ()<UITextFieldDelegate>
{
}
@property (weak, nonatomic) IBOutlet UIView *BigBackView;


@end

@implementation WorkModeSele

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"WorkModeSele" owner:self options:nil] objectAtIndex:0];
    
    _backView.layer.cornerRadius = 4.0f;
    if (IOS_VERSION >= 10.0) {
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [_BigBackView addGestureRecognizer:tap];
    self.titleLabel.text = L(@"Please select the working mode:");
    [self.SetButton setTitle:L(@"Set") forState:UIControlStateNormal];
    return self;
}

- (void)showInView:(UIView*) view
{
    self.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [view addSubview:self];
}
- (void)showOneTFInView:(UIView*) view{
    self.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [view addSubview:self];
    
//    CGRect rect = _backView.frame;
//    rect.size.height = 150;
//    _backView.frame =  rect;
//    _textFile2.hidden = YES;
//    _textFile3.hidden = YES;
    
}
-(void)setH:(NSString*)str{
    if ([str isEqualToString:@"ONE"]) {
            CGRect rect = _backView.frame;
            rect.size.height = 291;
            _backView.frame =  rect;
        
//            CGRect rect2 = _tipLabel.frame;
//            rect2.origin.y = 191;
//            _tipLabel.frame =  rect2;
    }else if([str isEqualToString:@"TWO"]){
        CGRect rect = _backView.frame;
        rect.size.height = 155;
        _backView.frame =  rect;
    }
}

- (void)dismiss{
    [self removeFromSuperview];
}
- (IBAction)backgroundButtonClicked:(id)sender
{
    
}
- (IBAction)cancelButton:(id)sender {
    
    [self dismiss];
}

- (IBAction)phoneButtonClicked:(id)sender
{
    
    
    [self dismiss];
}


@end
