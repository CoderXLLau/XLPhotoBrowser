//
//  Test5ViewController.m
//  XLPhotoBrowserDemo
//
//  Created by ehang on 2016/10/26.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import "Test5ViewController.h"
#import "SDWebImageManager.h"

@interface Test5ViewController ()

@end

@implementation Test5ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 *  浏览图片
 *
 */
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    // 快速创建并进入浏览模式
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:tap.view.tag imageCount:self.images.count datasource:self];
    
    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    [browser setActionSheetWithTitle:@"这是一个类似微信/微博的图片浏览器组件" delegate:self cancelButtonTitle:nil deleteButtonTitle:@"删除" otherButtonTitles:@"发送给朋友",@"保存图片",@"收藏",@"投诉",nil];
    
    // 自定义一些属性
    browser.pageDotColor = [UIColor purpleColor]; ///< 此属性针对动画样式的pagecontrol无效
    browser.currentPageDotColor = [UIColor greenColor];
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
}

#pragma mark    -   XLPhotoBrowserDatasource

/**
 *  返回这个位置的占位图片 , 也可以是原图(如果不实现此方法,会默认使用placeholderImage)
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 占位图片
 */
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return self.images[index];
}

/**
 *  返回指定位置图片的UIImageView,用于做图片浏览器弹出放大和消失回缩动画等
 *  如果没有实现这个方法,没有回缩动画,如果传过来的view不正确,可能会影响回缩动画效果
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 展示图片的容器视图,如UIImageView等
 */
- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
{
    return self.scrollView.subviews[index];
}

/**
 *  返回指定位置的高清图片URL
 *
 *  @param browser 浏览器
 *  @param index   位置索引
 *
 *  @return 返回高清大图索引
 */
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    return [NSURL URLWithString:self.urlStrings[index]];
}

#pragma mark    -   XLPhotoBrowserDelegate

- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    // do something yourself
    switch (actionSheetindex) {
        case 4: // 删除
        {
            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
            [self.images removeObjectAtIndex:currentImageIndex];
            [self resetScrollView];
        }
            break;
        case 1: // 保存
        {
            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
            [browser saveCurrentShowImage];
        }
            break;
        default:
        {
            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
        }
            break;
    }
}

@end
