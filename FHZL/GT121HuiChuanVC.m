//
//  GT121HuiChuanVC.m
//  FHZL
//
//  Created by hk on 2018/7/6.
//  Copyright © 2018年 hk. All rights reserved.
//  c0

#import "GT121HuiChuanVC.h"
#import "TimePickView.h"
#import "Header.h"
typedef NS_ENUM(NSInteger,gt121TimeType) {
  weekMode = 302,
    alarmMode1 = 406,
    alarmMode2 = 407,
    alarmMode3 = 408,
    alarmMode4 = 409,
};

@interface GT121HuiChuanVC ()<UITextFieldDelegate>
{
    NSString *beginEditText;
}
@property (weak, nonatomic) IBOutlet UITextField *timingModeTF;

@end

@implementation GT121HuiChuanVC
- (IBAction)sendTipClick:(id)sender {
    NSDictionary *instructions = @{
                                   @"mode":self.gt121Model.mode,
                                   @"timing":self.gt121Model.timing,
                                   @"week":self.gt121Model.week,
                                   @"weekSel":self.gt121Model.weekSel,
                                   @"weekTime":self.gt121Model.weekTime,
                                   @"alarmClock":self.gt121Model.alarmClock,
                                   @"alarmClockTime":self.gt121Model.alarmClockTime,
                                   @"removeAl":self.gt121Model.removeAl,
                                   };
    NSString *instrStr = [ZZXDataService convertToJsonData:instructions];
    NSDictionary *dic = @{@"macType":CsqStringIsEmpty(USERMANAGER.seleCar.macType),
                          @"macId":CsqStringIsEmpty(USERMANAGER.seleCar.macId),//
                          @"instructions":instrStr
                          };
    [ZZXDataService HFZLRequest:@"instruction/send-dispatch-A5" httpMethod:@"POST" params1:dic   file:nil success:^(id data)
     {
         if([data[@"code"]integerValue] == 0 ){
             [UIUtil showToast:L(@"Success") inView:[AppData theTopView]];
             if (self.changeGT121) {
                 self.changeGT121(self.gt121Model);
             }
         }else if([data[@"code"]integerValue] == 101057 ){
             [UIUtil showToast:L(@"Send offline instruction, set up successfully") inView:[AppData theTopView]];
             if (self.changeGT121) {
                 self.changeGT121(self.gt121Model);
             }
         }else{
             [UIUtil showToast:L(@"Setup failed") inView:[AppData theTopView]];
            
         }
     } fail:^(NSError *error)
     {
//         [UIUtil showToast:@"网络异常" inView:[AppData theTopView]];
     }];
    
}

- (IBAction)changeYearClick:(id)sender {
    UIButton *but = (UIButton*)sender;
    but.selected = YES;
    self.gt121Model.mode = [NSString stringWithFormat:@"%d",(int)but.tag - 99];
    
    for (int i = 100; i <= 101; i++) {
        UIButton *but1 = (UIButton *)[self.view viewWithTag:i];
        if (![but1 isEqual:but]) {
            but1.selected = NO;
        }
    }
}
- (IBAction)weekModeClick:(id)sender {
    UIButton *but = (UIButton*)sender;
    but.selected = YES;
    if (but.tag == 300) {
        self.gt121Model.week = @"1";
    }else if (but.tag == 301){
        self.gt121Model.week = @"0";
    }
    
    for (int i = 300; i <= 301; i++) {
        UIButton *but1 = (UIButton *)[self.view viewWithTag:i];
        if (![but1 isEqual:but]) {
            but1.selected = NO;
        }
    }
}
- (IBAction)weekSelect:(id)sender {
    
    UIButton *but = (UIButton*)sender;
    but.selected = !but.selected;
    NSMutableArray *seleArray = [NSMutableArray arrayWithArray:(NSArray*)self.gt121Model.weekSel];
    if (but.selected) {
        int seleInt = (int)but.tag - 302;
        [seleArray addObject:[NSString stringWithFormat:@"%d",seleInt]];
        
        [seleArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [obj1 integerValue] > [obj2 integerValue];
        }];
        self.gt121Model.weekSel = seleArray;
    }else{
        int seleInt = (int)but.tag - 302;
        NSString *seleStr = [NSString stringWithFormat:@"%d",seleInt];
        NSArray *seleArrayCopy = [seleArray copy];
        for (NSString *str in seleArrayCopy) {
            if ([str isEqualToString:seleStr]) {
                [seleArray removeObject:str];
            }
        }
        self.gt121Model.weekSel = seleArray;
    }
    SDLog(@"self.gt121Model.weekSel = %@",self.gt121Model.weekSel);
}
- (IBAction)AlarmModeClick:(id)sender {
    UIButton *but = (UIButton*)sender;
    but.selected = YES;
    if (but.tag == 400) {
        self.gt121Model.alarmClock = @"1";
    }else if (but.tag == 401){
        self.gt121Model.week = @"0";
    }
    
    for (int i = 400; i <= 401; i++) {
        UIButton *but1 = (UIButton *)[self.view viewWithTag:i];
        if (![but1 isEqual:but]) {
            but1.selected = NO;
        }
    }
}
- (IBAction)alarmSelect:(id)sender {
    UIButton *but = (UIButton*)sender;
    but.selected = !but.selected;
    int tag = (int)but.tag - 402;
    NSMutableArray *seleArray = [NSMutableArray arrayWithArray:(NSArray*)self.gt121Model.alarmClockTime];
    if(seleArray.count < 4){
        while (seleArray.count != 4) {
            [seleArray addObject:[NSNull null]];
        }
    }
    if (seleArray.count == 4) {
        if ( but.selected) {
            UIButton *titleButton = (UIButton *)[self.view viewWithTag:tag + 406];
            NSString *titleStr = [titleButton.titleLabel.text stringByReplacingOccurrencesOfString:@":" withString:@""];
            [seleArray replaceObjectAtIndex:tag withObject:titleStr];
            SDLog(@"titleButton.text = %@  , titleStr = %@",titleButton.titleLabel.text,titleStr);
            self.gt121Model.alarmClockTime = seleArray;
        }else{
            [seleArray replaceObjectAtIndex:tag withObject:[NSNull null]];
            self.gt121Model.alarmClockTime = seleArray;
        }
    }
    
}
- (IBAction)timeChangeClick:(id)sender {
    UIButton *but = (UIButton*)sender;
    NSInteger hourInt ;
    NSInteger minInt ;
    NSArray * array = [but.titleLabel.text componentsSeparatedByString:@":"];
    if (array.count >= 2) {
        hourInt = [array[0] integerValue];
        minInt = [array[1] integerValue];
    }else{
        hourInt = 0;
        minInt = 0;
    }
    
    
    TimePickView *pickView = [[TimePickView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) Hour:hourInt Min:minInt];
    [pickView setConfirmClick:^(NSInteger hour,NSInteger min){
        [but setTitle:[NSString stringWithFormat:@"%02d:%02d",(int)hour,(int)min] forState:UIControlStateNormal];
        if (but.tag == 302) {
            self.gt121Model.weekTime = [NSString stringWithFormat:@"%02d%02d",(int)hour,(int)min];
        }else{
            if (but.tag >= 406 && but.tag <= 409) {
                UIButton *seleBut = (UIButton*)[self.view viewWithTag:but.tag - 4];
                if (seleBut.selected) {
                    NSMutableArray *seleArray = [NSMutableArray arrayWithArray:(NSArray*)self.gt121Model.alarmClockTime];
                        [seleArray replaceObjectAtIndex:but.tag - 406 withObject:[NSString stringWithFormat:@"%02d%02d",(int)hour,(int)min]];
                    self.gt121Model.alarmClockTime = seleArray;
                }
            }
        }
    }];
    [[AppData theTopView] addSubview:pickView];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavi];
    SDLog(@"self.gt121Model = %@",self.gt121Model);
    
    [self.twoYearButt setTitle:L(@"2-year mode (Wifi+ GPS+ LBS)") forState:UIControlStateNormal];
    [self.threeYearButt setTitle:L(@"3-year mode (Wifi+ LBS)") forState:UIControlStateNormal];
    [self.weekOpenButt setTitle:L(@"Open") forState:UIControlStateNormal];
    [self.weekCloseButt setTitle:L(@"Close") forState:UIControlStateNormal];
    [self.weekOneBut setTitle:L(@"Monday") forState:UIControlStateNormal];
    [self.weekTwoButt setTitle:L(@"Tuesday") forState:UIControlStateNormal];
    [self.weekThreeButt setTitle:L(@"Wednesday") forState:UIControlStateNormal];
    [self.weekFourButt setTitle:L(@"Thursday") forState:UIControlStateNormal];
    [self.weekFiveButt setTitle:L(@"Friday") forState:UIControlStateNormal];
    [self.weekSixButt setTitle:L(@"Saturday") forState:UIControlStateNormal];
    [self.weekSevenButt setTitle:L(@"Sunday") forState:UIControlStateNormal];
    [self.alarmOpenBUtt setTitle:L(@"Open") forState:UIControlStateNormal];
    [self.alarmCloseBut setTitle:L(@"Close") forState:UIControlStateNormal];
    [self.oneGroupBut setTitle:L(@"first groups") forState:UIControlStateNormal];
    [self.twoGroupBut setTitle:L(@"Second groups") forState:UIControlStateNormal];
    [self.threeGroupBut setTitle:L(@"Third groups") forState:UIControlStateNormal];
    [self.fourGroupBUt setTitle:L(@"Fourth groups") forState:UIControlStateNormal];
    [self.sendBut setTitle:L(@"Send instruction") forState:UIControlStateNormal];
    
    self.timeModeLabel.text = L(@"Timing mode");
    self.timeRangeLabel.text = L(@"The range is 0-999 minutes");
    self.weekModeLabel.text = L(@"Week mode");
    self.alarmLabel.text = L(@"Alarm clock mode");
    self.tipLabel.text = L(@"Priority: Timing mode >Week mode > Alarm clock mode, if multiple modes are set, the first one takes effect according to priority");
    
    if ([self.gt121Model.mode intValue] == 1) {
        UIButton *but = (UIButton *)[self.view viewWithTag:100];
        but.selected = YES;
        UIButton *but2 = (UIButton *)[self.view viewWithTag:101];
        but2.selected = NO;
    }else{
        UIButton *but = (UIButton *)[self.view viewWithTag:101];
        but.selected = YES;
        UIButton *but2 = (UIButton *)[self.view viewWithTag:100];
        but2.selected = NO;
    }
    UITextField *tf = (UITextField*)[self.view viewWithTag:200];
    self.gt121Model.timing = ([self.gt121Model.timing intValue]>= 0 && [self.gt121Model.timing intValue]<=999)?  self.gt121Model.timing:@"0";
    tf.text = self.gt121Model.timing;
    
    if ([self.gt121Model.week intValue] == 1) {
        UIButton *but = (UIButton *)[self.view viewWithTag:300];
        but.selected = YES;
        UIButton *but2 = (UIButton *)[self.view viewWithTag:301];
        but2.selected = NO;
    }else{
        UIButton *but = (UIButton *)[self.view viewWithTag:301];
        but.selected = YES;
        UIButton *but2 = (UIButton *)[self.view viewWithTag:300];
        but2.selected = NO;
    }
    NSMutableString *str = [NSMutableString string];
    if (self.gt121Model.weekTime.length == 4) {
        SDLog(@"self.gt121Model.weekTime = %@",self.gt121Model.weekTime);
        [str appendString:self.gt121Model.weekTime];
        [str insertString:@":" atIndex:2];
    }else{
        
        [str appendString:@"00:00"];
    }
    UIButton *weekTimeButton = (UIButton*)[self.view viewWithTag:302];
    [weekTimeButton setTitle:str forState:UIControlStateNormal];
    SDLog(@"str = %@",str);
    
    if ([self.gt121Model.weekSel isKindOfClass:[NSArray class]]) {
        for(NSObject *daySele in (NSArray*)self.gt121Model.weekSel) {
            if ([daySele isKindOfClass:[NSString class]]) {
                int daySeleInt = [(NSString*)daySele intValue];
                if (daySeleInt >= 1 && daySeleInt <= 7) {
                    UIButton * seleBut = (UIButton*)[self.view viewWithTag:daySeleInt + 302];
                    seleBut.selected = YES;
                }
            }
            
        }
    }
    if ([self.gt121Model.alarmClock intValue] == 1) {
        UIButton *but = (UIButton *)[self.view viewWithTag:400];
        but.selected = YES;
        UIButton *but2 = (UIButton *)[self.view viewWithTag:401];
        but2.selected = NO;
    }else{
        UIButton *but = (UIButton *)[self.view viewWithTag:401];
        but.selected = YES;
        UIButton *but2 = (UIButton *)[self.view viewWithTag:400];
        but2.selected = NO;
    }
    if ([self.gt121Model.alarmClockTime isKindOfClass:[NSArray class]]) {
//        for(NSObject *daySele in (NSArray*)self.gt121Model.alarmClockTime) {
//            if ([daySele isKindOfClass:[NSString class]]) {
//                int daySeleInt = [(NSString*)daySele intValue];
//                if (daySeleInt >= 1 && daySeleInt <= 7) {
//                    UIButton * seleBut = (UIButton*)[self.view viewWithTag:daySeleInt + 302];
//                    seleBut.selected = YES;
//                }
//            }
//
//        }
        NSArray *array = (NSArray*)self.gt121Model.alarmClockTime;
        for (int i = 0; i<array.count;  i++) {
            if (kStringIsEmpty(array[i])) {
                UIButton *seleButton = (UIButton *)[self.view viewWithTag:402 + i];
                seleButton.selected = NO;
                
                UIButton *titleButton = (UIButton *)[self.view viewWithTag:406 + i];
                [titleButton setTitle:@"00:00" forState:UIControlStateNormal];
            }else{
                UIButton *seleButton = (UIButton *)[self.view viewWithTag:402 + i];
                seleButton.selected = YES;
                
                UIButton *titleButton = (UIButton *)[self.view viewWithTag:406 + i];
                NSMutableString *titleStr = [NSMutableString string];
                NSString *contentStr = array[i];
                if (contentStr.length == 4) {
                    [titleStr appendString:contentStr];
                    [titleStr insertString:@":" atIndex:2];
                }else{
                    [titleStr appendString:@"00:00"];
                }
                [titleButton setTitle:titleStr forState:UIControlStateNormal];
            }
        }
    }
}
-(void)setNavi{
    self.navigationController.navigationBar.translucent = NO;
    self.title = L(@"GT121 backpass settings");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{

    int a = [textField.text intValue];
    if (a <= 0 || a > 999) {
        textField.text = @"";
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text intValue] < 1 || [textField.text intValue] > 999) {
    }
    int a = [textField.text intValue];
    NSLog(@"a = %d",a);
    if (a < 1) {
        textField.text = @"0";
    }
    self.gt121Model.timing = textField.text;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!([string isEqualToString:@"0"]
        || [string isEqualToString:@"1"]
        || [string isEqualToString:@"2"]
        || [string isEqualToString:@"3"]
        || [string isEqualToString:@"4"]
        || [string isEqualToString:@"5"]
        || [string isEqualToString:@"6"]
        || [string isEqualToString:@"7"]
        || [string isEqualToString:@"8"]
        || [string isEqualToString:@"9"]) && string.length > 0) {
        return NO;
    }
    
    
    int a = [textField.text intValue];
    if ((a >= 999 || a < 0) && string.length > 0) {
        return NO;
    }

    if (textField.text.length == 3  && string.length > 0) {
        return NO;
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
