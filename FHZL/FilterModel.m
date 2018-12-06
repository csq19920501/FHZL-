//
//  FilterModel.m
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init])
    {
        self.hasOil = [aDecoder decodeBoolForKey:@"hasOil"];
        self.hasZhengDong = [aDecoder decodeBoolForKey:@"hasZhengDong"];
        self.hasAccOpen = [aDecoder decodeBoolForKey:@"hasAccOpen"];
        self.hasAccClose = [aDecoder decodeBoolForKey:@"hasAccClose"];
        self.hasGoInMangQu = [aDecoder decodeBoolForKey:@"hasGoInMangQu"];
        self.hasGoOutMangQu = [aDecoder decodeBoolForKey:@"hasGoOutMangQu"];
        self.HasSpeed = [aDecoder decodeBoolForKey:@"HasSpeed"];
        self.HasCarDoor = [aDecoder decodeBoolForKey:@"HasCarDoor"];
        self.HasDropB = [aDecoder decodeBoolForKey:@"HasDropB"];
        self.HasSoS = [aDecoder decodeBoolForKey:@"HasSoS"];
        self.HasCarMove = [aDecoder decodeBoolForKey:@"HasCarMove"];
        self.HasDeviceClean = [aDecoder decodeBoolForKey:@"HasDeviceClean"];
        self.HasCarFence = [aDecoder decodeBoolForKey:@"HasCarFence"];
        self.HasCarFenceIn = [aDecoder decodeBoolForKey:@"HasCarFenceIn"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeBool:self.HasCarFenceIn forKey:@"HasCarFenceIn"];
    [aCoder encodeBool:self.HasDropB forKey:@"HasDropB"];
    [aCoder encodeBool:self.HasSoS forKey:@"HasSoS"];
    [aCoder encodeBool:self.HasCarMove forKey:@"HasCarMove"];
    [aCoder encodeBool:self.HasDeviceClean forKey:@"HasDeviceClean"];
    [aCoder encodeBool:self.HasCarFence forKey:@"HasCarFence"];
    [aCoder encodeBool:self.hasOil forKey:@"hasOil"];
    [aCoder encodeBool:self.hasZhengDong forKey:@"hasZhengDong"];
    [aCoder encodeBool:self.hasAccOpen forKey:@"hasAccOpen"];
    [aCoder encodeBool:self.hasAccClose forKey:@"hasAccClose"];
    [aCoder encodeBool:self.hasGoInMangQu forKey:@"hasGoInMangQu"];
    [aCoder encodeBool:self.hasGoOutMangQu forKey:@"hasGoOutMangQu"];
    [aCoder encodeBool:self.HasSpeed forKey:@"HasSpeed"];
    [aCoder encodeBool:self.HasCarDoor forKey:@"HasCarDoor"];
}
-(void)setAll{
    _hasOil = YES;
    _hasZhengDong = YES;
    _hasAccOpen = YES;
    _hasGoInMangQu = YES;
    _hasAccClose = YES;
    _hasGoOutMangQu = YES;
    _HasSpeed = YES;
    _HasCarDoor = YES;
    _HasDropB = YES;
    _HasSoS = YES;
    _HasCarMove = YES;
    _HasDeviceClean = YES;
    _HasCarFence = YES;
    _HasCarFenceIn = YES;
}
-(FilterModel *)csqCopy{
    FilterModel *model = [FilterModel new];
    model.hasOil = _hasOil;
    model.hasZhengDong = _hasZhengDong;
    model.hasAccOpen = _hasAccOpen;
    model.hasGoInMangQu = _hasGoInMangQu;
    model.hasAccClose = _hasAccClose;
    model.hasGoOutMangQu = _hasGoOutMangQu;
    model.HasSpeed = _HasSpeed;
    model.HasCarDoor = _HasCarDoor;
    model.HasDropB = _HasDropB;
    model.HasSoS = _HasSoS;
    model.HasCarMove = _HasCarMove;
    model.HasDeviceClean = _HasDeviceClean;
    model.HasCarFence = _HasCarFence;
    model.HasCarFenceIn = _HasCarFenceIn;
    return model;
}
-(NSArray*)getArray{
    NSMutableArray *filterArray = [NSMutableArray array];
    if (_hasOil) {
        [filterArray addObject:@"101"];
    }
    if (_hasZhengDong) {
        [filterArray addObject:@"109"];
    }
    if (_hasAccOpen) {
        [filterArray addObject:@"102"];
    }
    if (_hasGoInMangQu) {
        [filterArray addObject:@"108"];
    }
    if (_hasAccClose) {
        [filterArray addObject:@"103"];
    }
    if (_hasGoOutMangQu) {
        [filterArray addObject:@"111"];
    }
    if (_HasSpeed) {
        [filterArray addObject:@"106"];
    }
    if (_HasCarDoor) {
        [filterArray addObject:@"105"];
    }
    if (_HasDropB) {
        [filterArray addObject:@"104"];
    }
    if (_HasSoS) {
        [filterArray addObject:@"107"];
    }
    if (_HasCarMove) {
        [filterArray addObject:@"110"];
    }
    if (_HasDeviceClean) {
        [filterArray addObject:@"112"];
    }
    if (_HasCarFence) {
        [filterArray addObject:@"200"];
    }
    if (_HasCarFenceIn) {
        [filterArray addObject:@"201"];
    }
    return filterArray;
}
@end
