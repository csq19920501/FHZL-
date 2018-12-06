//
//  TopSwitchCsqView.h
//  FHZL
//
//  Created by hk on 17/11/24.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopSwitchDele <NSObject>
-(void)topButtonClick:(int )tag categryStr:(NSString*)categryStr;
@end
@interface TopSwitchCsqView : UIView
@property(nonatomic, strong)UIView *bottonView;
@property(nonatomic, copy)NSString *CategryStr;
@property(nonatomic, copy)NSArray *titleArray;
@property(nonatomic,weak)id<TopSwitchDele>topSwitchDele;
-(id)initWithFrame:(CGRect)frame :(NSArray*)titleArray categryStr:(NSString*)categryStr;
-(void)codered:(CGRect)frame :(NSArray*)titleArray categryStr:(NSString*)categryStr;
-(void)setSelectButton:(int)tag;
-(void)reSetTitleStr:(NSArray *)array;
@end
