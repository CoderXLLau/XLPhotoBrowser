//
//  XLZoomingScrollView.m
//  XLPhotoBrowserDemo
//
//  Created by Liushannoon on 16/7/15.
//  Copyright © 2016年 LiuShannoon. All rights reserved.
//

#import "XLZoomingScrollView.h"
#import "XLProgressView.h"

#import "UIImageView+WebCache.h"

@interface XLZoomingScrollView () <UIScrollViewDelegate>

@property (nonatomic , strong) UIImageView  *photoImageView;
@property (nonatomic , weak) XLProgressView *progressView;

@end

@implementation XLZoomingScrollView

#pragma mark    -   set / get

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressView.progress = progress;
}

- (UIImageView *)imageView
{
    return self.photoImageView;
}

- (UIImage *)currentImage
{
    return self.photoImageView.image;
}

/**
 *  懒加载成员属性
 */
- (UIImageView *)photoImageView
{
    if (_photoImageView == nil) {
        _photoImageView = [[UIImageView alloc] init];
    }
    
    return _photoImageView;
}

#pragma mark    -   initial UI

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initial];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

/**
 *  初始化
 */
- (void)initial
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.backgroundColor= [UIColor clearColor];
    self.photoImageView.userInteractionEnabled = YES;
    self.photoImageView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    // 分隔开单击和双击手势冲突
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.photoImageView addGestureRecognizer:singleTap];
    [self.photoImageView addGestureRecognizer:doubleTap];
    [self addSubview:self.photoImageView];

    UITapGestureRecognizer *singleTapBackgroundView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapBackgroundView:)];
    UITapGestureRecognizer *doubleTapBackgroundView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapBackgroundView:)];
    doubleTapBackgroundView.numberOfTapsRequired = 2;
    // 分隔开单击和双击手势冲突
    [singleTapBackgroundView requireGestureRecognizerToFail:doubleTapBackgroundView];
    [self addGestureRecognizer:singleTapBackgroundView];
    [self addGestureRecognizer:doubleTapBackgroundView];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.photoImageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width) { // 长图才会出现这种情况
        frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(self.photoImageView.frame, frameToCenter)){
        self.photoImageView.frame = frameToCenter;
    }
}

#pragma mark    -   UIScrollViewDelegate
    
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoImageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    self.scrollEnabled = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.userInteractionEnabled = YES;
}

#pragma mark    -   private method - other

- (void)removeProgressView
{
    [self.progressView removeFromSuperview];
}

#pragma mark    -   private method - 手势处理,缩放图片

- (void)singleTap:(UITapGestureRecognizer *)singleTap
{
    if (self.zoomingScrollViewdelegate && [self.zoomingScrollViewdelegate respondsToSelector:@selector(zoomingScrollView:singleTapDetected:)]) {
        [self.zoomingScrollViewdelegate zoomingScrollView:self singleTapDetected:singleTap];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)doubleTap
{
    [self handleDoubleTap:[doubleTap locationInView:doubleTap.view]];
}

- (void)handleDoubleTap:(CGPoint)point
{
    self.userInteractionEnabled = NO;
    CGRect zoomRect = [self zoomRectForScale:[self willBecomeZoomScale] withCenter:point];
//    NSLog(@"1111111  zoomRect = %@",NSStringFromCGRect(zoomRect));
    [self zoomToRect:zoomRect animated:YES];
}

/**
 *  计算要伸缩到的目的比例
 */
- (CGFloat)willBecomeZoomScale
{
    if (self.zoomScale > self.minimumZoomScale) {
        return self.minimumZoomScale;
    } else {
        return self.maximumZoomScale;
    }
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center
{
    CGFloat height = self.frame.size.height / scale;
    CGFloat width  = self.frame.size.width  / scale;
    CGFloat x = center.x - width * 0.5;
    CGFloat y = center.y - height * 0.5;
    return CGRectMake(x, y, width, height);
}

- (void)singleTapBackgroundView:(UITapGestureRecognizer *)singleTap
{
    if (self.zoomingScrollViewdelegate && [self.zoomingScrollViewdelegate respondsToSelector:@selector(zoomingScrollView:singleTapDetected:)]) {
        [self.zoomingScrollViewdelegate zoomingScrollView:self singleTapDetected:singleTap];
    }
}

- (void)doubleTapBackgroundView:(UITapGestureRecognizer *)doubleTap
{
    self.userInteractionEnabled = NO;
    CGPoint point = [doubleTap locationInView:doubleTap.view];
    CGFloat touchX = point.x;
    CGFloat touchY = point.y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleDoubleTap:CGPointMake(touchX, touchY)];
}

#pragma mark    -   public method

/**
 *  显示图片
 *
 *  @param image 图片
 */
- (void)setShowImage:(UIImage *)image
{
    self.photoImageView.image = image;
    [self setMaxAndMinZoomScales];
    [self setNeedsLayout];
}

/**
 *  显示图片
 *
 *  @param url         图片的高清大图链接
 *  @param placeholder 占位的缩略图 / 或者是高清大图都可以
 */
- (void)setShowHighQualityImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    if (!url) {
        [self setShowImage:placeholder];
        return;
    }
    XLProgressView *progressView = [[XLProgressView alloc] init];
    progressView.bounds = CGRectMake(0, 0, 100, 100);
    progressView.mode = XLProgressViewProgressMode;
    self.progressView = progressView;
    [self addSubview:progressView];
    
    self.photoImageView.image = placeholder;
    [self setMaxAndMinZoomScales];
//    self.photoImageView.xl_width *= 0.5;
//    self.photoImageView.xl_height *= 0.5;
//    self.photoImageView.xl_centerX = self.xl_width * 0.5;
//    self.photoImageView.xl_centerY = self.xl_height * 0.5;
//    [self setNeedsLayout];
    
    // 弱引用,防止循环引用
    __weak typeof(self) weakSelf = self;
    
    [weakSelf.photoImageView sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // 修改进度
        weakSelf.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf removeProgressView];
        if (error) {
            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, 160, 30);
            label.center = CGPointMake(weakSelf.bounds.size.width * 0.5, weakSelf.bounds.size.height * 0.5);
            label.text = @"图片加载失败";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [weakSelf addSubview:label];
        } else {
            weakSelf.photoImageView.image = image;
            [weakSelf.photoImageView setNeedsDisplay];
            [UIView animateWithDuration:0.25 animations:^{
                [self setMaxAndMinZoomScales];
            }];
        }
    }];
}

/**
 *  根据图片和屏幕比例关系,调整最大和最小伸缩比例
 */
- (void)setMaxAndMinZoomScales
{
    // self.photoImageView的初始位置
    UIImage *image = self.photoImageView.image;
    CGFloat imageWidthHeightRatio = image.size.width / image.size.height;
    self.photoImageView.xl_width = XLScreenW;
    self.photoImageView.xl_height = XLScreenW / imageWidthHeightRatio;
    self.photoImageView.xl_x = 0;
    if (self.photoImageView.xl_height > XLScreenH) {
        self.photoImageView.xl_y = 0;
        self.scrollEnabled = YES;
    } else {
        self.photoImageView.xl_y = (XLScreenH - self.photoImageView.xl_height ) * 0.5;
        self.scrollEnabled = NO;
    }
    self.maximumZoomScale = MAX(XLScreenH / self.photoImageView.xl_height, 3.0);
    self.minimumZoomScale = 1.0;
    self.zoomScale = 1.0;
    self.contentSize = CGSizeMake(self.photoImageView.xl_width, MAX(self.photoImageView.xl_height, XLScreenH));
}

/**
 *  重用，清理资源
 */
- (void)prepareForReuse
{
    [self setMaxAndMinZoomScales];
    self.photoImageView.image = nil;
    self.hasLoadedImage = NO;
}

@end
