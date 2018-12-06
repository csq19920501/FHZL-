//
//  UITableView+WFEmpty.m
//  WFEmptyTableView
//
//  Created by wanawt on 2016/11/11.
//  Copyright © 2016年 wanawt. All rights reserved.
//

#import "UITableView+WFEmpty.h"
#import <objc/runtime.h>

static char UITableViewEmptyView;

@implementation UITableView (WFEmpty)

@dynamic emptyView;
@dynamic refreshButton;
- (UIView *)emptyView
{
    return objc_getAssociatedObject(self, &UITableViewEmptyView);
}
- (UIButton *)refreshButton
{
    return objc_getAssociatedObject(self, &UITableViewEmptyView);
}
- (void)setEmptyView:(UIView *)emptyView
{
    [self willChangeValueForKey:@"HJEmptyView"];
    objc_setAssociatedObject(self, &UITableViewEmptyView,
                             emptyView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"HJEmptyView"];
}
- (void)setRefreshButton:(UIButton *)refreshButton
{
    [self willChangeValueForKey:@"HJRefreshButton"];
    objc_setAssociatedObject(self, &UITableViewEmptyView,
                             refreshButton,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"HJRefreshButton"];
}

-(void)addEmptyViewWithImageName:(NSString*)imageName title:(NSString*)title
{
    if (!self.emptyView)
    {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        UIImage* image = [UIImage imageNamed:imageName];
        NSString* text = title;
        
        UIView* noMessageView = [[UIView alloc] initWithFrame:frame];
        noMessageView.backgroundColor = [UIColor clearColor];
        UIImageView* carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, 60, image.size.width, image.size.height)];
        [carImageView setImage:image];
        [noMessageView addSubview:carImageView];
        
        UILabel* noInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-112)/2, frame.size.width, 40)];
        noInfoLabel.textAlignment = NSTextAlignmentCenter;
        noInfoLabel.textColor = [UIColor blackColor];
        noInfoLabel.text = text;
        noInfoLabel.numberOfLines = 0;
        noInfoLabel.backgroundColor = [UIColor clearColor];
        noInfoLabel.font = [UIFont systemFontOfSize:15];
        [noMessageView addSubview:noInfoLabel];
        
        
        
        [self addSubview:noMessageView];
        
        self.emptyView = noMessageView;
    }else{
        for (UIView *view in self.emptyView.subviews) {
//            if (![view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
//            }

        }
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        UIImage* image = [UIImage imageNamed:imageName];
        NSString* text = title;
        
        UIImageView* carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, 60, image.size.width, image.size.height)];
        [carImageView setImage:image];
        [self.emptyView addSubview:carImageView];
        
        UILabel* noInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-112)/2, frame.size.width, 40)];
        noInfoLabel.textAlignment = NSTextAlignmentCenter;
        noInfoLabel.numberOfLines = 0;
        noInfoLabel.textColor = [UIColor blackColor];
        noInfoLabel.text = text;
        noInfoLabel.backgroundColor = [UIColor clearColor];
        noInfoLabel.font = [UIFont systemFontOfSize:15];
        [self.emptyView addSubview:noInfoLabel];
        
    }
    
}
-(void)addEmptyViewHaveButtonWithImageName:(NSString*)imageName title:(NSString*)title
{
    if (!self.emptyView)
    {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        UIImage* image = [UIImage imageNamed:imageName];
        NSString* text = title;
        
        UIView* noMessageView = [[UIView alloc] initWithFrame:frame];
        noMessageView.backgroundColor = [UIColor clearColor];
        UIImageView* carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, 60, image.size.width, image.size.height)];
        [carImageView setImage:image];
        [noMessageView addSubview:carImageView];
        
        UILabel* noInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-112)/2, frame.size.width, 40)];
        noInfoLabel.textAlignment = NSTextAlignmentCenter;
        noInfoLabel.textColor = [UIColor blackColor];
        noInfoLabel.text = text;
        noInfoLabel.numberOfLines = 0;
        noInfoLabel.backgroundColor = [UIColor clearColor];
        noInfoLabel.font = [UIFont systemFontOfSize:15];
        [noMessageView addSubview:noInfoLabel];
        
//        if (!self.refreshButton) {
            UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
            refreshButton.frame = CGRectMake(30, noInfoLabel.frame.size.height + noInfoLabel.frame.origin.y, frame.size.width - 60, 30);
            [refreshButton setTitle:@"点击重新加载U盘" forState:UIControlStateNormal];
            refreshButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [refreshButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [refreshButton setBackgroundColor:[UIColor clearColor]];
            [refreshButton addTarget:self action:@selector(newMusicRefresh) forControlEvents:UIControlEventTouchUpInside];
            
            [noMessageView addSubview:refreshButton];
//            self.refreshButton =  refreshButton;
//        }

        
        [self addSubview:noMessageView];
        
        self.emptyView = noMessageView;
    }else{
        for (UIView *view in self.emptyView.subviews) {
//            if (![view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
//            }

        }
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        UIImage* image = [UIImage imageNamed:imageName];
        NSString* text = title;
        
        UIImageView* carImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-image.size.width)/2, 60, image.size.width, image.size.height)];
        [carImageView setImage:image];
        [self.emptyView addSubview:carImageView];
        
        UILabel* noInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-112)/2, frame.size.width, 40)];
        noInfoLabel.textAlignment = NSTextAlignmentCenter;
        noInfoLabel.numberOfLines = 0;
        noInfoLabel.textColor = [UIColor blackColor];
        noInfoLabel.text = text;
        noInfoLabel.backgroundColor = [UIColor clearColor];
        noInfoLabel.font = [UIFont systemFontOfSize:15];
        [self.emptyView addSubview:noInfoLabel];
        
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        refreshButton.frame = CGRectMake(30, noInfoLabel.frame.size.height + noInfoLabel.frame.origin.y, frame.size.width - 60, 30);
        [refreshButton setTitle:@"点击重新加载U盘" forState:UIControlStateNormal];
        refreshButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [refreshButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [refreshButton setBackgroundColor:[UIColor clearColor]];
        [refreshButton addTarget:self action:@selector(newMusicRefresh) forControlEvents:UIControlEventTouchUpInside];
        
        [self.emptyView  addSubview:refreshButton];
        
    }
    
}

-(void)newMusicRefresh{
    
}
@end
