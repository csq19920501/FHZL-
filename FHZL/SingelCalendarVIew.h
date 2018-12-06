//
//  SingelCalendarVIew.h
//  GT
//
//  Created by hk on 17/5/23.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MonthModel;
@protocol cellClickDele <NSObject>
-(void)collectionCellClick:(NSDate*)date;
@end
@interface SingelCalendarVIew : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dayModelArray;
@property (strong, nonatomic) NSDate *tempDate;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *lineLabel;
@property(nonatomic,weak)id<cellClickDele >buttonDele;
@end

@interface CalendarHeaderView : UICollectionReusableView
@end

//UICollectionViewCell
@interface CalendarCell : UICollectionViewCell
@property (weak, nonatomic) UILabel *dayLabel;

@property (strong, nonatomic) MonthModel *monthModel;
@end

//存储模型
@interface MonthModel : NSObject
@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) BOOL isSelectedDay;
@end
