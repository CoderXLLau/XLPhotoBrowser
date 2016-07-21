//
//  Test3ViewController.m
//  XLPhotoBrowserDemo
//
//  Created by Liushannoon on 16/7/20.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import "Test3ViewController.h"

@interface Test3ViewController ()

@end

@implementation Test3ViewController

/**
 *  浏览图片
 *
 */
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:tap.view.tag imageCount:self.images.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleIndexLabel;
    
    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
    [browser setActionSheetWithTitle:@"这是一个类似微信/微博的图片浏览器组件" delegate:self cancelButtonTitle:nil deleteButtonTitle:@"删除" otherButtonTitles:@"发送给朋友",@"保存图片",@"收藏",@"投诉",nil];
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
