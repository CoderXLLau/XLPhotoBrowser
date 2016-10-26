//
//  ViewController.m
//  XLPhotoBrowserDemo
//
//  Created by Liushannoon on 16/7/16.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import "ViewController.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"

#import "UIView+XLExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"示例Demo";
    NSArray *titles = @[@"1 选择自己的照片",@"2 XLPhotoBrowserStylePageControl --> 微信样式",@"3 XLPhotoBrowserStyleIndexLabel --> 微博样式",@"4 XLPhotoBrowserStyleSimple --> 简单样式,无长按手势",@"加载网络图片"];
    
    CGFloat buttonWidth = self.view.xl_width;
    CGFloat buttonHeight = 50 * xl_autoSizeScaleY;
    CGFloat margin = 5;
    for (int i = 0 ; i < titles.count; i ++) {
        NSString *title = titles[i];
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor greenColor];
        button.tag = i + 1;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        
        button.frame = CGRectMake(0, 80 + (buttonHeight + margin) * i, buttonWidth, buttonHeight);
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)clickButton:(UIButton *)button
{
    Class vc = NSClassFromString([NSString stringWithFormat:@"Test%zdViewController",button.tag]);
    [self.navigationController pushViewController:[[vc alloc] init] animated:YES];
}

@end
