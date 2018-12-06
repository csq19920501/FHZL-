/*
 ============================================================================
 Name        : ShareChooseViewController.h
 Version     : 1.0.0
 Copyright   : 
 Description : 选择分享类型界面
 ============================================================================
 */


#import "UIViewController+KNSemiModal.h"
#import "Header.h"
@interface ShareChooseViewController : UIViewController
{
}

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSString* filePath;
@property (weak, nonatomic) IBOutlet UILabel *weiXLabel;
@property (weak, nonatomic) IBOutlet UILabel *QQLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@end
