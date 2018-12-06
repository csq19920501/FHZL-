//
//  CSQPhotoPreviewController.m
//  FHZL
//
//  Created by hk on 2018/2/6.
//  Copyright © 2018年 hk. All rights reserved.
//
#import "LPDPhotoPreviewController.h"
#import "LPDPhotoPreviewCell.h"
#import "LPDAssetModel.h"
#import "UIView+HandyValue.h"
#import "LPDImagePickerController.h"
#import "LPDImageManager.h"
#import "UIImage+MyBundle.h"
#import "CSQPhotoPreviewController.h"
#import "Header.h"
@interface CSQPhotoPreviewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
    NSArray *_photosTemp;
    NSArray *_assetsTemp;
    
    UIView *_naviBar;
    UIButton *_backButton;
    UIButton *_selectButton;
    
    UIView *_toolBar;
    UIButton *_doneButton;
    UIImageView *_numberImageView;
    UILabel *_numberLable;
    UIButton *_originalPhotoButton;
    UILabel *_originalPhotoLable;
}
@property (nonatomic, assign) BOOL isHideNaviBar;
@end

@implementation CSQPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configCollectionView];
    [self configCustomNaviBar];
    self.view.clipsToBounds = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
    if (_currentIndex) [_collectionView setContentOffset:CGPointMake((self.view.lpd_width + 20) * _currentIndex, 0) animated:NO];
//    [self refreshNaviBarAndBottomBarState];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = NO;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.lpd_width + 20, self.view.lpd_height);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-10, 0, self.view.lpd_width + 20, self.view.lpd_height) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.scrollsToTop = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentOffset = CGPointMake(0, 0);
    _collectionView.contentSize = CGSizeMake(self.photos.count * (self.view.lpd_width + 20), 0);
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[LPDPhotoPreviewCell class] forCellWithReuseIdentifier:@"LPDPhotoPreviewCell"];
}
- (void)configCustomNaviBar {
//    LPDImagePickerController *lpdImagePickerVc = (LPDImagePickerController *)self.navigationController;
    
    _naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, self.view.lpd_width, 44)];
    _naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    [_backButton setImage:[UIImage imageNamedFromMyBundle:@"navi_back.png"] forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
//    _selectButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.lpd_width - 54, 10, 42, 42)];
//    [_selectButton setImage:[UIImage imageNamedFromMyBundle:lpdImagePickerVc.photoDefImageName] forState:UIControlStateNormal];
//    [_selectButton setImage:[UIImage imageNamedFromMyBundle:lpdImagePickerVc.photoSelImageName] forState:UIControlStateSelected];
//    [_selectButton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
//    _selectButton.hidden = !lpdImagePickerVc.showSelectBtn;
    
//    [_naviBar addSubview:_selectButton];
    [_naviBar addSubview:_backButton];
    [self.view addSubview:_naviBar];
}
- (void)backButtonClick {
    if (self.navigationController.childViewControllers.count < 2) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.didDismiss) {
        self.didDismiss();
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.lpd_width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.lpd_width + 20);
    
    if (currentIndex < _photos.count && _currentIndex != currentIndex) {
        _currentIndex = currentIndex;
//        [self refreshNaviBarAndBottomBarState];
    }
}
#pragma mark - UICollectionViewDataSource && Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPDPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LPDPhotoPreviewCell" forIndexPath:indexPath];
//    cell.model = _photos[indexPath.row];
    [cell csqSetImag:_photos[indexPath.row]];
    
    __weak typeof(self) weakSelf = self;
    if (!cell.singleTapGestureBlock) {
        __weak typeof(_naviBar) weakNaviBar = _naviBar;
//        __weak typeof(_toolBar) weakToolBar = _toolBar;
        cell.singleTapGestureBlock = ^(){
            // show or hide naviBar / 显示或隐藏导航栏
            weakSelf.isHideNaviBar = !weakSelf.isHideNaviBar;
            weakNaviBar.hidden = weakSelf.isHideNaviBar;
//            weakToolBar.hidden = weakSelf.isHideNaviBar;
        };
    }
//    [cell setImageProgressUpdateBlock:^(double progress) {
//        weakSelf.progress = progress;
//    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[LPDPhotoPreviewCell class]]) {
        [(LPDPhotoPreviewCell *)cell recoverSubviews];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[LPDPhotoPreviewCell class]]) {
        [(LPDPhotoPreviewCell *)cell recoverSubviews];
    }
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
