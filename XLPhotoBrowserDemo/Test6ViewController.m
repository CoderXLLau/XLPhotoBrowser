//
//  Test6ViewController.m
//  XLPhotoBrowserDemo
//
//  Created by ehang on 2016/11/3.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import "Test6ViewController.h"

@interface Test6ViewController ()

@end

@implementation Test6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)clickImage:(UITapGestureRecognizer *)tap
{
    // 传入图片数据源,直接进行图片浏览
    // 传入图片数据源数组 : 是UIImage对象数组 ,ALAsset对象也可以, 也可以是图片的NSURL链接 , 或者是可以变成NSURL链接的NSString对象数组
    
    // 1.UIImage数组
//    [XLPhotoBrowser showPhotoBrowserWithImages:self.images currentImageIndex:0];
   
    // 2. NSURL数组
//    NSMutableArray *URLArray = [NSMutableArray array];
//    for (NSString *urlString in self.urlStrings) {
//        NSURL *URL = [NSURL URLWithString:urlString];
//        [URLArray addObject:URL];
//    }
//    [XLPhotoBrowser showPhotoBrowserWithImages:URLArray currentImageIndex:0];
    
    // 3.可以变成NSURL链接的NSString对象数组
    [XLPhotoBrowser showPhotoBrowserWithImages:self.urlStrings currentImageIndex:0];
    
}

@end
