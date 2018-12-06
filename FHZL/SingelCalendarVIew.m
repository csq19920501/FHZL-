//
//  SingelCalendarVIew.m
//  GT
//
//  Created by hk on 17/5/23.
//  Copyright © 2017年 hk. All rights reserved.
//
#import "LocalizedStringTool.h"
#import "SingelCalendarVIew.h"
#import "NSDate+Formatter.h"
#define WeekViewHeight 40
#define HeaderViewHeight 30
#define CellHeight  35
#define LL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define LL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define Iphone6Scale(x) ((x) * LL_SCREEN_WIDTH / 375.0f)
@implementation SingelCalendarVIew

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat CalendarViewWidth = frame.size.width;
//        CGFloat CalendarViewHeight = frame.size.height;
        
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CalendarViewWidth, 40)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        
        
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CalendarViewWidth/4, 0, CalendarViewWidth/2, 40)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLabel];
        
        UIButton *lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        lastButton.frame = CGRectMake(25, 5, 30, 30);
        [lastButton setBackgroundImage:[UIImage imageNamed:@"MAIN_日历_左翻_N.png"] forState:UIControlStateNormal];
        [lastButton addTarget:self action:@selector(lastCleck) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lastButton];
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(CalendarViewWidth - 55, 5, 30, 30);
        [nextButton setBackgroundImage:[UIImage imageNamed:@"MAIN_日历_右翻_N.png"] forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextCleck) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        
        [self addSubview:self.collectionView];
        self.tempDate = [NSDate date];
        self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
        
//        self.backgroundColor = [UIColor whiteColor];
        _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,frame.size.height -1, CalendarViewWidth, 1)];
        _lineLabel.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
        [self addSubview:_lineLabel];
        [self getDataDayModel:self.tempDate];
    }
    return self;
}

-(void)lastCleck{
    self.tempDate = [self getLastMonth:self.tempDate];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
}
-(void)nextCleck{
    self.tempDate = [self getNextMonth:self.tempDate];
    self.dateLabel.text = self.tempDate.yyyyMMByLineWithDate;
    [self getDataDayModel:self.tempDate];
}
- (void)getDataDayModel:(NSDate *)date{
    NSUInteger days = [self numberOfDaysInMonth:date];
    NSInteger week = [self startDayOfWeek:date];
    self.dayModelArray = [[NSMutableArray alloc] initWithCapacity:42];
    int day = 1;
    for (int i= 1; i<days+week; i++) {
        if (i<week) {
            [self.dayModelArray addObject:@""];
        }else{
            MonthModel *mon = [MonthModel new];
            mon.dayValue = day;
            NSDate *dayDate = [self dateOfDay:day];
            mon.dateValue = dayDate;
            if ([dayDate.yyyyMMddByLineWithDate isEqualToString:[NSDate date].yyyyMMddByLineWithDate]) {
                mon.isSelectedDay = YES;
            }
            [self.dayModelArray addObject:mon];
            day++;
        }
    }
    
    [self.collectionView reloadData];
    if (days+week > 36) {
        self.collectionView.frame = CGRectMake(0, WeekViewHeight, self.frame.size.width, HeaderViewHeight + CellHeight *6);
         _lineLabel.frame = CGRectMake(0,WeekViewHeight +  HeaderViewHeight + CellHeight *6 - 1, self.frame.size.width, 1);
    }else{
        self.collectionView.frame = CGRectMake(0, WeekViewHeight, self.frame.size.width, HeaderViewHeight + CellHeight *5);
        _lineLabel.frame = CGRectMake(0,WeekViewHeight +  HeaderViewHeight + CellHeight *5 - 1, self.frame.size.width, 1);
    }
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        NSInteger width = self.frame.size.width/7;
        NSInteger height = CellHeight;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.headerReferenceSize = CGSizeMake(LL_SCREEN_WIDTH, HeaderViewHeight);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,  WeekViewHeight, width * 7, self.frame.size.height - WeekViewHeight) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
        [_collectionView registerClass:[CalendarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CalendarHeaderView"];
        
    }
    return _collectionView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayModelArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    cell.dayLabel.backgroundColor = [UIColor whiteColor];
    cell.dayLabel.textColor = [UIColor blackColor];
    id mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        cell.monthModel = (MonthModel *)mon;
    }else{
        cell.dayLabel.text = @"";
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CalendarHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CalendarHeaderView" forIndexPath:indexPath];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSArray *array = [NSArray arrayWithArray:self.dayModelArray];
    
    
    
    
    MonthModel * mon = self.dayModelArray[indexPath.row];
    if ([mon isKindOfClass:[MonthModel class]]) {
        
        for (id model in self.dayModelArray) {
            if ([model isKindOfClass:[MonthModel class]]) {
                [model setIsSelectedDay:NO];
            }
        }
        
        self.dateLabel.text = [(MonthModel *)mon dateValue].yyyyMMddByLineWithDate;
        mon.isSelectedDay = YES;
        
        if (_buttonDele && [_buttonDele respondsToSelector:@selector(collectionCellClick:)] ) {
            [_buttonDele collectionCellClick:mon.dateValue];
        }
    }
    
    [self.collectionView reloadData];
    
    
}

#pragma mark -Private
- (NSUInteger)numberOfDaysInMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    return [greCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
}

- (NSDate *)firstDateOfMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:date];
    comps.day = 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSUInteger)startDayOfWeek:(NSDate *)date
{
    NSCalendar *greCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//Asia/Shanghai
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekday | NSCalendarUnitDay
                               fromDate:[self firstDateOfMonth:date]];
    return comps.weekday;
}

- (NSDate *)getLastMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month -= 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)getNextMonth:(NSDate *)date{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:date];
    comps.month += 1;
    return [greCalendar dateFromComponents:comps];
}

- (NSDate *)dateOfDay:(NSInteger)day{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [greCalendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSDateComponents *comps = [greCalendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                               fromDate:self.tempDate];
    comps.day = day;
    return [greCalendar dateFromComponents:comps];
}

@end

@implementation CalendarHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        NSArray *weekArray = [[NSArray alloc] initWithObjects:L(@"SUN"),L(@"MON"),L(@"TUE"),L(@"WED"),L(@"THU"),L(@"FRI"),L(@"SAT"), nil];
       
               
        for (int i=0; i<weekArray.count; i++) {
            UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*Iphone6Scale(54), 0, Iphone6Scale(54), HeaderViewHeight)];
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.textColor = [UIColor blackColor];
            weekLabel.font = [UIFont systemFontOfSize:13.f];
            weekLabel.text = weekArray[i];
            [self addSubview:weekLabel];
        }
        self.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
        
    }
    return self;
}
@end


@implementation CalendarCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGFloat width = self.contentView.frame.size.width*0.6;
        CGFloat height = self.contentView.frame.size.height*0.6;
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.contentView.frame.size.width*0.5-width*0.5,  self.contentView.frame.size.height*0.5-height*0.5, width, height )];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.layer.masksToBounds = YES;
        dayLabel.layer.cornerRadius = height * 0.5;
        
        [self.contentView addSubview:dayLabel];
        self.dayLabel = dayLabel;
        
    }
    return self;
}

- (void)setMonthModel:(MonthModel *)monthModel{
    _monthModel = monthModel;
    self.dayLabel.text = [NSString stringWithFormat:@"%02ld",monthModel.dayValue];
    if (monthModel.isSelectedDay) {
        self.dayLabel.backgroundColor = [UIColor redColor];
        self.dayLabel.textColor = [UIColor whiteColor];
    }
}
@end


@implementation MonthModel


@end
