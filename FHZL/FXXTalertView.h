/*
 ============================================================================
 Name        : HotlineViewController.h
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */

#import <UIKit/UIKit.h>


@interface FXXTalertView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *textFile1;
@property (weak, nonatomic) IBOutlet UITextField *textFile2;
@property (weak, nonatomic) IBOutlet UITextField *textFile3;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (id)init;
- (void)showInView:(UIView*)view;
- (void)dismiss;
- (void)showOneTFInView:(UIView*) view;
@end
