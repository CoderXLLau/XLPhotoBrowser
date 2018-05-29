//
//  Test4ViewController.m
//  XLPhotoBrowserDemo
//
//  Created by Liushannoon on 16/7/20.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import "Test4ViewController.h"

@interface Test4ViewController ()

@end

@implementation Test4ViewController


/**
 *  浏览图片
 *
 */
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:tap.view.tag imageCount:self.images.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleSimple;
    
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
