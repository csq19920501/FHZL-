//
//  ImageScrollView.m
//  car
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 xy. All rights reserved.
//

#import "XYImageScrollView.h"
#import "UIImageView+WebCache.h"
#import "NSTimer+Off.h"

@interface XYImageScrollView()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSMutableArray *views;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation XYImageScrollView

@synthesize images = _images;

-(void)layout{
    NSMutableArray *array = [self.images mutableCopy];
    [array insertObject:[self.images lastObject] atIndex:0];
    [array addObject:self.images[0]];
    CGRect frame = self.scrollView.bounds;
    NSInteger index = 0;
    for (NSString *image in array){
        frame.origin.x = self.frame.size.width * index;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        if ([image hasPrefix:@"http"]) {
            UIActivityIndicatorView *jh = [self addJh:index];
            [imageView sd_setImageWithURL:[NSURL URLWithString:image]placeholderImage:[UIImage imageNamed:@"音乐播放_2.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    [jh removeFromSuperview];
                }
            }];
        }else{
            imageView.image = [UIImage imageNamed:image];
        }
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        [self.views addObject:imageView];
        [self.scrollView addSubview:imageView];
        index ++;
    }
    _scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, -_scrollView.contentInset.top);
    [self initPageControl];
    if (self.aoutScroll) {
        [self removeOldTimer];
        [self setTimer];
    }
}


-(void)setTimer{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(scroll) userInfo:nil repeats:YES];
}
-(void)removeOldTimer{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)scroll{
    [UIView animateWithDuration:.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + self.frame.size.width, -self.scrollView.contentInset.top);
    }];
}

-(UIActivityIndicatorView *)addJh:(NSInteger)index{
    if (index == 0) {
        index = self.images.count;
    }else if (index == self.images.count + 2){
        index = 1;
    }
    UIActivityIndicatorView *jh = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width/2 - 20, self.scrollView.frame.size.height/2 - 20, 40, 40)];
    jh.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.scrollView addSubview:jh];
    return jh;
}

-(void)initPageControl{
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
        self.pageControl = nil;
    }
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.scrollView.frame.size.width-10*self.images.count)/2 , self.scrollView.frame.size.height-30, 10*self.images.count, 20)];
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.enabled = NO;
    self.pageControl.hidesForSinglePage = YES;
    [self addSubview:self.pageControl];
}

-(void)tap{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.pageControl.currentPage);
    }
}

-(void)setImages:(NSArray *)images{
    if (images) {
        [self.views makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _images = images;
        [self layout];
    }
}

-(NSMutableArray *)views{
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.timer pause];
    NSInteger page = scrollView.contentOffset.x/self.scrollView.frame.size.width;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if(scrollView.contentOffset.x == self.scrollView.frame.size.width*(self.images.count +1)){
        page = 0;
        scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * (page + 1), -self.scrollView.contentInset.top);
       // NSLog(@"self.scrollView.contentOffset.x:%f",self.scrollView.contentOffset.x);
    }else if (scrollView.contentOffset.x == 0) {
        page = self.images.count;
        scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*(page), -self.scrollView.contentInset.top);
    }
    self.pageControl.currentPage = page - 1;
    [self.timer resumeWithTimeInterval:(self.time)];
    [CATransaction commit];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer pause];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.timer resumeWithTimeInterval:(self.time)];
}


-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * (self.images.count+2), 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

-(NSTimeInterval)time{
    if (!_time) {
        return 3;
    }
    return _time;
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    self.images = nil;
}

@end
