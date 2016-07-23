//
//  BaseTestViewController.h
//  XLPhotoBrowserDemo
//
//  Created by Liushannoon on 16/7/20.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XLExtension.h"
#import "XLPhotoBrowser.h"

@interface BaseTestViewController : UIViewController <XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>

/**
 * scrollView
 */
@property (nonatomic , strong) UIScrollView  *scrollView;
/**
 * 图片数组
 */
@property (nonatomic , strong) NSMutableArray  *images;
/**
 *  url strings
 */
@property (nonatomic , strong) NSArray  *urlStrings;

/**
 *  浏览图片
 */
- (void)clickImage:(UITapGestureRecognizer *)tap;
- (void)resetScrollView;

@end
