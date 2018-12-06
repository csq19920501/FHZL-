/*
 ============================================================================
 Name        : AboutUsItemCell.m
 Version     : 1.0.0
 Copyright   : 
 Description : 关于我们Cell
 ============================================================================
 */
#import "Header.h"
#import "AboutUsItemCell.h"

//cell
@interface AboutUsItemCell ()
{
    IBOutlet UILabel* __weak _titleLabel;
    IBOutlet UILabel* __weak _valueLabel;
 
}

@end

@implementation AboutUsItemCell

@synthesize titleLabel = _titleLabel;
@synthesize valueLabel = _valueLabel;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//头部cell
@interface AboutUsHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *appVersionStr;
@property (weak, nonatomic) IBOutlet UILabel *appName;

@end

@implementation AboutUsHeaderCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _appVersionStr.text = [NSString stringWithFormat:@"HKFHZL%@",appMPVersion];
    self.appName.text = L(@"FHZL");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
