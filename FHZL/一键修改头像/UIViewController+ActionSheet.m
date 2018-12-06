//
//  UIViewController+ActionSheet.m
//  蓝媒智能家居系统
//
//  Created by 英赛智能 on 16/6/9.
//  Copyright © 2016年 BlueMedia. All rights reserved.
//

#import "UIViewController+ActionSheet.h"

@implementation UIViewController (ActionSheet)

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(takePhoto)tpBlock ppBlock:(pickPhoto)pkBlock{
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
         if (tpBlock) {
             tpBlock();
         }
     }];
     UIAlertAction *pickPhoto = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
         if (pkBlock) {
             pkBlock();
         }
     }];
     UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
     }];
     [alertCtl addAction:takePhoto];
     [alertCtl addAction:pickPhoto];
     [alertCtl addAction:cancle];
     [self presentViewController:alertCtl animated:YES completion:nil];
    
}
- (void)csqActionSheet:(takePhoto)tpBlock ppBlock:(pickPhoto)pkBlock csqBlock:(csqBlock)csqBlock{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"Photo upload", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (tpBlock) {
            tpBlock();
        }
    }];
    UIAlertAction *pickPhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"Select from album", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (pkBlock) {
            pkBlock();
        }
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *csqPhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"System image", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (csqBlock) {
            csqBlock();
        }
    }];
    
    [alertCtl addAction:csqPhoto];
    [alertCtl addAction:takePhoto];
    [alertCtl addAction:pickPhoto];
    [alertCtl addAction:cancle];
    [self presentViewController:alertCtl animated:YES completion:nil];
}
@end
