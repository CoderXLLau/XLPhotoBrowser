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
#import "SDImageCache.h"

@interface XLZoomingScrollView () <UIScrollViewDelegate>

@property (nonatomic , strong) UIImageView  *photoImageView;
@property (nonatomic , strong) XLProgressView *progressView;
@property(nonatomic, strong) UILabel *stateLabel;

@end

@implementation XLZoomingScrollView

#pragma mark    -   set / get

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressView.progress = progress;
    if ([self.zoomingScrollViewdelegate respondsToSelector:@selector(zoomingScrollView:imageLoadProgress:)]) {
        [self.zoomingScrollViewdelegate zoomingScrollView:self imageLoadProgress:progress];
    }
}

- (UIImageView *)imageView
{
    return self.photoImageView;
}

- (UIImage *)currentImage
{
    return self.photoImageView.image;
}

- (UIImageView *)photoImageView
{
    if (_photoImageView == nil) {
        _photoImageView = [[UIImageView alloc] init];
    }
    
    return _photoImageView;
}

- (UILabel *)stateLabel
{
    if (_stateLabel == nil) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.text = XLPhotoBrowserLoadNetworkImageFail;
        _stateLabel.font = [UIFont systemFontOfSize:16];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _stateLabel.layer.cornerRadius = 5;
        _stateLabel.clipsToBounds = YES;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

- (XLProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[XLProgressView alloc] init];
    }
    return _progressView;
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
    self.photoImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.photoImageView];

    UITapGestureRecognizer *singleTapBackgroundView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapBackgroundView:)];
    UITapGestureRecognizer *doubleTapBackgroundView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapBackgroundView:)];
    doubleTapBackgroundView.numberOfTapsRequired = 2;
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
    
    self.stateLabel.bounds = CGRectMake(0, 0, 160, 30);
    self.stateLabel.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    self.progressView.bounds = CGRectMake(0, 0, 100, 100);
    self.progressView.xl_centerX = self.xl_width * 0.5;
    self.progressView.xl_centerY = self.xl_height * 0.5;
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
#warning TODO 需要再优化这里的算法

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

- (void)resetZoomScale
{
    self.maximumZoomScale = 1.0;
    self.minimumZoomScale = 1.0;
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
    self.progress = 1.0;
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
        self.progress = 1.0f;
        return;
    }
    
    UIImage *showImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[url absoluteString]];
    if (showImage) {
        XLFormatLog(@"已经下载过图片,直接从缓存中获取");
        self.photoImageView.image = showImage;
        [self setMaxAndMinZoomScales];
        self.progress = 1.0f;
        return;
    }
    
    self.photoImageView.image = placeholder;
    [self setMaxAndMinZoomScales];
    
    __weak typeof(self) weakSelf = self;
    //初始化进度条
    self.progress = 0.01;
    [self addSubview:self.progressView];;
    self.progressView.mode = XLProgressViewProgressMode;

    [weakSelf.photoImageView sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed| SDWebImageLowPriority| SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (expectedSize>0) {
            // 修改进度
            weakSelf.progress = (CGFloat)receivedSize / expectedSize ;
        }
        [self resetZoomScale];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.progressView removeFromSuperview];
        if (error) {
            [self setMaxAndMinZoomScales];
            [weakSelf addSubview:weakSelf.stateLabel];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [weakSelf.stateLabel removeFromSuperview];
//            });
            XLFormatLog(@"加载图片失败 , 图片链接imageURL = %@ , 检查是否开启允许HTTP请求",imageURL);
        } else {
            [weakSelf.stateLabel removeFromSuperview];
            weakSelf.photoImageView.image = image;
            [weakSelf.photoImageView setNeedsDisplay];
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf setMaxAndMinZoomScales];
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
    if (image == nil || image.size.height==0) {
        return;
    }
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
    self.progress = 0;
    self.photoImageView.image = nil;
    self.hasLoadedImage = NO;
    [self.stateLabel removeFromSuperview];
    [self.progressView removeFromSuperview];
}

@end
