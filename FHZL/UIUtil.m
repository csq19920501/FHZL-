/*
 ============================================================================
 Name        : UIUtil.m
 Version     : 1.0.0
 Copyright   :
 Description : 工具类
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "UIUtil.h"
#import "MBProgressHUD.h"
#import "LocalizedStringTool.h"


@implementation UIUtil

static MBProgressHUD* _hud = nil;





/***********************************************************************
 * 方法名称： showToast
 * 功能描述： 弹出toast
 * 输入参数： text 内容
 inView 现在在哪个view
 * 输出参数：
 * 返回值：
 ***********************************************************************/
+ (void)showToast:(NSString*)text inView:(UIView*)view
{
    //MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //hud.mode = MBProgressHUDModeText;
    //hud.labelText = text;
    //hud.removeFromSuperViewOnHide = YES;
    //[hud hide:YES afterDelay:2.0f];
    [self hideProgressHUD];
    if (nil == _hud)
    {
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.removeFromSuperViewOnHide = YES;
        //        hud.minSize = CGSizeMake(228.0f, 138.0f);
        //        hud.color = [UIColor whiteColor];
        hud.dimBackground = YES;
        
        hud.detailsLabelText = text;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5f];
    }
    else
    {
        _hud.mode = MBProgressHUDModeText;
        _hud.detailsLabelText = text;
        _hud.removeFromSuperViewOnHide = YES;
        [_hud hide:YES afterDelay:1.5f];
        
        _hud = nil;
    }
}



/***********************************************************************
 * 方法名称： showProgressHUD
 * 功能描述： 弹出等待框
 * 输入参数： text 内容
 inView 现在在哪个view
 * 输出参数：
 * 返回值：
 ***********************************************************************/
+ (void)showProgressHUD:(NSString*)text inView:(UIView*)view
{
    [self hideProgressHUD];
    
    _hud = [[MBProgressHUD alloc] initWithView:view];
    _hud.mode = MBProgressHUDModeIndeterminate;//MBProgressHUDModeCustomView
    _hud.detailsLabelText = text;
    
    _hud.removeFromSuperViewOnHide = YES;
    //    _hud.minSize = CGSizeMake(228.0f, 138.0f);
    //    _hud.color = [UIColor whiteColor];
    _hud.dimBackground = YES;
    
    //    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 32.0f)];
    //    imageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"pub_salver_loading_1"], [UIImage imageNamed:@"pub_salver_loading_2"], [UIImage imageNamed:@"pub_salver_loading_3"], [UIImage imageNamed:@"pub_salver_loading_4"], [UIImage imageNamed:@"pub_salver_loading_5"], [UIImage imageNamed:@"pub_salver_loading_6"], [UIImage imageNamed:@"pub_salver_loading_7"], [UIImage imageNamed:@"pub_salver_loading_8"], [UIImage imageNamed:@"pub_salver_loading_9"], [UIImage imageNamed:@"pub_salver_loading_10"], [UIImage imageNamed:@"pub_salver_loading_11"], [UIImage imageNamed:@"pub_salver_loading_12"], nil];
    //    imageView.animationDuration = 1.0f;
    //    _hud.customView = imageView;
    //    [imageView startAnimating];
    //
    [view addSubview:_hud];
    [_hud show:YES];
}

/***********************************************************************
 * 方法名称： hideProgressHUD
 * 功能描述： 隐藏等待框
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
+ (void)hideProgressHUD
{
    if (nil != _hud)
    {
        [_hud hide:YES];
        
        _hud = nil;
    }
}

@end
