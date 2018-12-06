/*
 ============================================================================
 Name        : ShareChooseViewController.m
 Version     : 1.0.0
 Copyright   : 
 Description : 选择分享类型界面
 ============================================================================
 */
#import <UIKit/UIKit.h>
#import "ShareChooseViewController.h"
#import "LocalizedStringTool.h"
#import "SocialShareManager.h"
//#import "UIViewController+KNSemiModal.h"
#import "AppDelegate.h"


@interface ShareChooseViewController ()
{
    UIDocumentInteractionController* _docInteractionController;
}
@end

@implementation ShareChooseViewController

/***********************************************************************
 * 方法名称： initWithNibName
 * 功能描述： 初始化控制器，初始化收支明细列表
 * 输入参数： nibNameOrNil    xib文件名称
            nibBundleOrNil  传递的参数
 * 输出参数：
 * 返回值：   控制器对象
 ***********************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    
    return self;
}

/***********************************************************************
 * 方法名称： viewDidLoad
 * 功能描述： 视图加载完毕回调
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.weiXLabel.text = L(@"WeiXin");
    self.moreLabel.text = L(@"More");
}

/***********************************************************************
 * 方法名称： didReceiveMemoryWarning
 * 功能描述： 内存不足回调
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***********************************************************************
 * 方法名称： qqButtonClicked
 * 功能描述： 分享到QQ
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
- (IBAction)qqButtonClicked:(id)sender
{
    if (self.filePath.length > 0)
    {
        [[SocialShareManager sharedInstance] sendShareFile:self.filePath toApp:ShareToApp_QQ];
    }
    else
    {
        
        
        [[SocialShareManager sharedInstance] sendShareText:self.text toApp:ShareToApp_QQ];
    }
    
    [self dismissSemiModalView];
}

/***********************************************************************
 * 方法名称： qqButtonClicked
 * 功能描述： 分享到微信
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
- (IBAction)weixinButtonClicked:(id)sender
{
    if (self.filePath.length > 0)
    {
        [[SocialShareManager sharedInstance] sendShareFile:self.filePath toApp:ShareToApp_WeChat];
    }
    else
    {
        [[SocialShareManager sharedInstance] sendShareText:self.text toApp:ShareToApp_WeChat];
    }
    
    [self dismissSemiModalView];
}

/***********************************************************************
 * 方法名称： qqButtonClicked
 * 功能描述： 分享到其他方式
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
- (IBAction)otherButtonClicked:(id)sender
{
    NSMutableArray* activityItems = nil;
    if (self.filePath.length > 0)
    {
        _docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.filePath]];
        [_docInteractionController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
    }
    else
    {
        activityItems = [NSMutableArray arrayWithObject:self.text];
        
        UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
//        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        [appDelegate.window.rootViewController presentViewController:activityViewController animated:YES completion:nil];
        
        UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
        
        UIViewController *parent = rootVC;
        
        while ((parent = rootVC.presentedViewController) != nil ) {
            rootVC = parent;
        }
        
        while ([rootVC isKindOfClass:[UINavigationController class]]) {
            rootVC = [(UINavigationController *)rootVC topViewController];
        }
        [rootVC presentViewController:activityViewController animated:YES completion:nil];
        [self dismissSemiModalView];
    }
}

@end
