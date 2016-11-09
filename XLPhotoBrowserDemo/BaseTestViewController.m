//
//  BaseTestViewController.m
//  XLPhotoBrowserDemo
//
//  Created by Liushannoon on 16/7/20.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import "BaseTestViewController.h"
#import "SDImageCache.h"

@interface BaseTestViewController ()

@end

@implementation BaseTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.urlStrings = @[
                        @"http://upload-images.jianshu.io/upload_images/1455933-e20b26b157626a5d.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-cb2abcce977a09ac.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-92be2b34e7e9af61.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-edd183910e826e8c.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-198c3a62a30834d6.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-e9e2967f4988eb7f.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-ce55e894fff721ed.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-5d3417fa034eafab.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-642e217fcdf15774.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-7245174910b68599.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-e74ae4df495938b7.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-ee53be08d63a0d22.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-412255ddafdde125.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-cee5618e9750de12.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-5d5d6ba05853700a.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-6dd4d281027c7749.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-5d3417fa034eafab.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-642e217fcdf15774.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-7245174910b68599.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-e74ae4df495938b7.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-ee53be08d63a0d22.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-412255ddafdde125.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-cee5618e9750de12.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        @"http://upload-images.jianshu.io/upload_images/1455933-5d5d6ba05853700a.JPG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                        
                        ];
    
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
    
    for (int i = 1 ; i < 11 ; i ++) {
        NSString *string = [NSString stringWithFormat:@"photo%zd.jpg",i];
        UIImage *image = [UIImage imageNamed:string];
        [self.images addObject:image];
    }
    
    [self resetScrollView];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"清除图片缓存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearImageCache) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 120, 40);
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)clearImageCache
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}
- (void)resetScrollView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat imageWidth = 100;
    CGFloat margin = 10;
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
    self.scrollView.contentSize = CGSizeMake((imageWidth + margin) * self.images.count,0 );
}

/**
 *  交给子类去重载
 */
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    
}

@end
