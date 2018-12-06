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
#import "FXXTalertView.h"
#import "UIUtil.h"
#import "LocalizedStringTool.h"


@interface FXXTalertView ()<UITextFieldDelegate>
{
}


@end

@implementation FXXTalertView

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"FXXTalertView" owner:self options:nil] objectAtIndex:0];
    
    _backView.layer.cornerRadius = 4.0f;
    if (IOS_VERSION >= 10.0) {
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
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
    
    CGRect rect = _backView.frame;
    rect.size.height = 150;
    _backView.frame =  rect;
    _textFile2.hidden = YES;
    _textFile3.hidden = YES;
    
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
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (_textFile1 == textField)
//    {
//        
//        [_textFile2 becomeFirstResponder];
//    }
//    else if (_textFile2 == textField)
//    {
//        [_textFile3 becomeFirstResponder];
//    }
//    else if (_textFile3 == textField)
//    {
//        [textField resignFirstResponder];
//    }
//    return YES;
//}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    if (_textFile1 == textField || _textFile2 == textField || _textFile3 == textField)
//    {
//        if (string.length > 0 && _textFile1.text.length > 14)
//        {
//            
//            [UIUtil showToast:L(@"cannot exceed 15") inView:self];
//            return NO;
//        }
//    }
//    return YES;
//}
//

@end
