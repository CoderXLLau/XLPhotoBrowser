//
//  XLPhotoBrowserConfig.h
//  XLPhotoBrowserDemo
//
//  Created by Liushannoon on 16/7/16.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import "UIView+XLExtension.h"

/**
 *  进度视图类型类型
 */
typedef NS_ENUM(NSUInteger, XLProgressViewMode){
    /**
     *  圆环形
     */
    XLProgressViewModeLoopDiagram = 1,
    /**
     *  圆饼型
     */
    XLProgressViewModePieDiagram = 2
};

// 图片保存成功提示文字
#define XLPhotoBrowserSaveImageSuccessText @" ^_^ 保存成功 ";

// 图片保存失败提示文字
#define XLPhotoBrowserSaveImageFailText @" >_< 保存失败 ";

// browser背景颜色
#define XLPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define XLPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define XLPhotoBrowserShowImageAnimationDuration 0.4f

// browser中显示图片动画时长
#define XLPhotoBrowserHideImageAnimationDuration 0.4f

// 图片下载进度指示进度显示样式（XLProgressViewModeLoopDiagram 环形，XLProgressViewModePieDiagram 饼型）
#define XLProgressViewProgressMode XLProgressViewModeLoopDiagram
// 图片下载进度指示器背景色
#define XLProgressViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
// 图片下载进度指示器内部控件间的间距
#define XLProgressViewItemMargin 10
