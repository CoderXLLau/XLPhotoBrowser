//
//  TestViewController.m
//  XLPhotoBrowserDemo
//
//  Created by Liushannoon on 16/7/16.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import "Test1ViewController.h"
#import "UIView+XLExtension.h"
#import "XLPhotoBrowser.h"

@interface Test1ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate , XLPhotoBrowserDatasource>

/**
 * scrollView
 */
@property (nonatomic , strong) UIScrollView  *scrollView;
/**
 *
 */
@property (nonatomic , strong) NSMutableArray  *images;

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.xl_width = XLScreenW - 30;
    self.scrollView.xl_height = 100;
    self.scrollView.xl_x = 15;
    self.scrollView.xl_y = 100;
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor grayColor];
    
    // 1. 设置导航条右边item
    UIButton *btn = [[UIButton alloc] init];
    btn.xl_width = 120;
    btn.xl_height = 44;
    [btn setTitle:@"添加图片" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [btn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItems = @[negativeSpacer ,rightItem];
}

- (void)addPhoto
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType           = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing        = YES;
    imagePicker.delegate             = self;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
}

/**
 *  选取完图片以后 ,从图库选取的图片
 *  images 是选中的所有图片
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    [self.images addObject:image];
    CGFloat imageWidth = 100;
    CGFloat margin = 10;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0 ; i < self.images.count; i ++) {
        UIImageView *headerImageView = [[UIImageView alloc] init];
        headerImageView.tag = i;
        headerImageView.userInteractionEnabled = YES;
        [headerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
        headerImageView.xl_x = (imageWidth + margin) * i;
        headerImageView.xl_y = 0;
        headerImageView.xl_width = imageWidth;
        headerImageView.xl_height = imageWidth;
        headerImageView.image = self.images[i];
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        headerImageView.layer.masksToBounds = YES;
        [self.scrollView addSubview:headerImageView];
    }
    self.scrollView.contentSize = CGSizeMake((imageWidth + margin) * self.images.count , 100);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:true completion:nil];
}

/**
 进入图片浏览器
 */
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:tap.view.tag imageCount:self.images.count datasource:self];
}

#pragma mark    -   XLPhotoBrowserDatasource

- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.images[index];
}

- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
{
    return self.scrollView.subviews[index];
}

@end
