/*
 ============================================================================
 Name        : HotlineViewController.m
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */
#import "Header.h"
#import <QuartzCore/QuartzCore.h>
#import "ShowCarView.h"
#import "UIUtil.h"
#import "LocalizedStringTool.h"


@interface ShowCarView ()<UITextFieldDelegate>
{
}


@end

@implementation ShowCarView


-(void)setLocationModel:(LocationModel *)model{
    float width = kScreenWidth - 20   ;
    self.macIdLable.text = model.macName; //设备名称
    
    CGFloat widthF = autoWidthFrame(model.macName,16,13).size.width + 15;
    self.nameWidthConstraint.constant = widthF >= 160?160:widthF;
    
    
    self.speedLabel.text = [NSString stringWithFormat:@"%ldkm/h",[model.speed integerValue]];
    self.LocationTypeLabel.text = [NSString stringWithFormat:@"%@%%",model.battery];
    
    
    self.batteryLabel.text = [NSString stringWithFormat:@"%@",[model.bvalid intValue] ==1?@"GPS":[model.bvalid intValue] ==2 || [model.bvalid intValue] ==3?@"LBS":[model.bvalid intValue] ==4 ?@"WIFI":L(@"Not locate")];//设备定位方式
    
    if ([model.gpsTime longLongValue] == 0) {
        self.gpsTimeLabel.text = @"";
    }else{
        self.gpsTimeLabel.text = [UserManager getDateDisplayString:[model.gpsTime longLongValue]];
    }
    
    
    if ([model.gsmTime longLongValue] == 0) {
        self.gsmTimeLabel.text = @"";
    }else{
        self.gsmTimeLabel.text = [UserManager getDateDisplayString:[model.gsmTime longLongValue]];
    }
    
    self.statusLabel.text = [NSString stringWithFormat:@"%@",[model.status intValue] == 0?L(@"Ignition"):L(@"Flameout")];
    self.stopLabel.text = [model.online intValue] ==1?L(@"On-line"):L(@"Off-line");
    self.carDoorLabel.text = [NSString stringWithFormat:@"%@",[model.door intValue] == 0?L(@"Close"):L(@"Open")];//
    if ([model.macType isEqualToString:DR_30] || [model.macType isEqualToString:GT51] || [model.macType isEqualToString:GT52]) {
        self.carDoorLabel.hidden = YES;
        self.carDoorImage.hidden = YES;
        self.GpsImageLeadingContast.constant = width/4 - 40;
        self.batteryImageLeadingContast.constant = width/4 - 10;
    }
    if ([model.macType isEqualToString:GT31] || [model.macType isEqualToString:GT121]) {
        self.carDoorLabel.hidden = YES;
        self.carDoorImage.hidden = YES;
        self.statusImageV.hidden = YES;
        self.statusLabel.hidden = YES;
        self.GpsImageLeadingContast.constant = - width/4 + 7.5;
        self.batteryImageLeadingContast.constant = 6;
    }
}

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ShowCarView" owner:self options:nil] objectAtIndex:0];
    self.macIdLable.layer.cornerRadius = 4;
    self.macIdLable.layer.masksToBounds = YES;
     [self.getAddressButton setTitle:L(@"View Address") forState:UIControlStateNormal];
    return self;
}

- (void)showInView:(UIView*) view
{
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [view addSubview:self];
}

- (void)showInView:(UIView*) view  withFrame:(CGRect)rect
{
    self.frame = rect;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [view addSubview:self];
}

- (void)showOneTFInView:(UIView*) view{
    self.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [view addSubview:self];
    
//    CGRect rect = _backView.frame;
//    rect.size.height = 150;
//    _backView.frame =  rect;
//    _textFile2.hidden = YES;
//    _textFile3.hidden = YES;
    
}
- (void)dismiss{
    [self removeFromSuperview];
}
- (IBAction)openView:(id)sender {
//    UIButton *but = sender;
//    but.selected = !but.selected;
//    if (but.selected) {
//        
//    }
    NSLog(@"偷偷的执行方法");
}

- (IBAction)cancelButton:(id)sender {
    
    [self dismiss];
}

- (IBAction)phoneButtonClicked:(id)sender
{
    
    
    [self dismiss];
}

@end
