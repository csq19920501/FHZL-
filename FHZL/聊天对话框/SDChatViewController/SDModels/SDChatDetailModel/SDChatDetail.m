//
//  SDChatDetail.m
//  SDChat
//
//  Created by Megatron Joker on 2017/5/18.
//  Copyright © 2017年 SlowDony. All rights reserved.
//

#import "SDChatDetail.h"
#import "SDChatMessage.h"
#import "Header.h"
@interface SDChatDetail()



/** 文字聊天内容 */
@property (nonatomic, copy) NSString *contentText;
/**
 聊天文字背景图
 */
@property (nonatomic,strong)UIImage *contectTextBackgroundIma;
@property (nonatomic,strong)UIImage *contectTextBackgroundHLIma;


/**
 头像url
 */
@property (nonatomic,copy)NSString *iconHead;


/**
 时间str
 */
@property (nonatomic,copy)NSString *timeStr;


/**
 姓名
 */
@property (nonatomic,copy)NSString *nameStr;


/**
 是否显示时间
 */
@property (nonatomic,assign,getter=isShowTime) BOOL showTime;


/**
 是否显示名字
 */
@property (nonatomic,assign,getter=isMe)BOOL me;


/**
 是否是患者
 */
@property (nonatomic,assign,getter=isPatient)BOOL patient;

/**
 聊天类型
 */
@property (nonatomic,assign)SDChatDetailType chatType;
@end

@implementation SDChatDetail
+ (instancetype)sd_chatWith:(SDChatMessage *)chatMsg {
    SDChatDetail *chat =[[self alloc]init];
    chat.chatMsg=chatMsg;
    return chat;
}

-(void)setChatMsg:(SDChatMessage *)chatMsg{
    _chatMsg =chatMsg;
    self.patient=[chatMsg.sender boolValue];
    if (!self.patient) { //0患者1客服
        self.iconHead = @"120*120.png";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            self.contectTextBackgroundIma = [UIImage imageNamed: @"chatSickMessage_Normal.png"];
            self.contectTextBackgroundHLIma = [UIImage imageNamed: @"chatSickMessage_Highlighted.png"];
        }else{
            self.contectTextBackgroundIma = [UIImage imageNamed: @"liaotian1.png"];
            self.contectTextBackgroundHLIma = [UIImage imageNamed: @"liaotian2.png"];
        }

        self.timeStr=chatMsg.sendTime;
        self.showTime = NO;
        self.nameStr=@"slowdony";
        self.me=YES;
    }else {
        
     
        if ([[UserManager sharedInstance].user.iconId integerValue] >= 1 && [[UserManager sharedInstance].user.iconId integerValue] <= 12) {
            
            self.iconHead = [NSString stringWithFormat:@"ui2_user_icon%ld.png",(long)[USERMANAGER.user.iconId integerValue]];
            
        }else if([[UserManager sharedInstance].user.iconId integerValue] == 13 ){
            if (!headImageIsEmpty(USERMANAGER.user.headPicPath) ) {
               
                self.iconHead = USERMANAGER.user.headPicPath;
            }else{
                
                self.iconHead = @"微众世界_头像0";
            }
        }
        else if([[UserManager sharedInstance].user.iconId integerValue] == 14){
            if (!headImageIsEmpty(USERMANAGER.user.headPicPath) ) {
                
                self.iconHead = USERMANAGER.user.upPicPath;
            }else{
                
                self.iconHead = @"微众世界_头像0";
            }
        }else
        {
            self.iconHead = @"微众世界_头像0";
        }
        
        
        
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            self.contectTextBackgroundIma = [UIImage imageNamed: @"meChatMessage.png"];
            self.contectTextBackgroundHLIma = [UIImage imageNamed: @"meChatMessage.png"];
        }else{
            self.contectTextBackgroundIma = [UIImage imageNamed: @"liaotian3.png"];
            self.contectTextBackgroundHLIma = [UIImage imageNamed: @"liaotian3.png"];
        }
        self.timeStr=chatMsg.sendTime;
        self.me=YES;
        self.nameStr =@"";
    }
    self.timeStr=chatMsg.sendTime;
    self.contentText=chatMsg.msg;
    self.showTime=YES;
    self.chatType=chatMsg.msgType;
}

@end
