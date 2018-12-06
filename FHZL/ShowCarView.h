/*
 ============================================================================
 Name        : HotlineViewController.h
 Version     : 1.0.0
 Copyright   : 
 Description : 情感热线界面
 ============================================================================
 */

#import <UIKit/UIKit.h>
#import "LocationModel.h"

@interface ShowCarView : UIView

@property (weak, nonatomic) IBOutlet UILabel *macIdLable;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *carDoorLabel;
@property (weak, nonatomic) IBOutlet UILabel *gpsTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gsmTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *stopLabel;
@property (weak, nonatomic) IBOutlet UIView *midView;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *isOpenButton;
@property (weak, nonatomic) IBOutlet UIButton *getAddressButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabelGetAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GpsImageLeadingContast;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *batteryImageLeadingContast;
@property (weak, nonatomic) IBOutlet UIImageView *carDoorImage;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewConstraint;

- (id)init;
- (void)showInView:(UIView*)view;
- (void)dismiss;
- (void)showOneTFInView:(UIView*) view;
- (void)showInView:(UIView*) view  withFrame:(CGRect)rect;
-(void)setLocationModel:(LocationModel *)model;
@end
