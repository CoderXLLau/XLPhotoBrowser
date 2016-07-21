
# 1.XLPhotoBrowser描述
  -  一个优雅的图片浏览器,效果类似微信多图片浏览器(同时包含微博多图片浏览效果),支持弹出动画和回缩动画.
  -  效果图:
  
![XLPhotoBrowserDemo.gif](http://upload-images.jianshu.io/upload_images/1455933-597296ec3f5594a0.gif?imageMogr2/auto-orient/strip)


![XLPhotoBrowserDemo2.gif](http://upload-images.jianshu.io/upload_images/1455933-1b3f77d0f122d42e.gif?imageMogr2/auto-orient/strip)

#2. 安装方法
*	下载示例Demo,把里面的XLPhotoBrowser文件夹拖到你的项目中即可(注意: 里面用到了一些第三方的类,如果你的项目中已经使用了这些库,可以视情况删除)

# 3. 使用说明 : 

-     3.1 快速创建并进入浏览模式

```

    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:tap.view.tag imageCount:self.images.count datasource:self];

```


-	 3.2 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势

```

    [browser setActionSheetWithTitle:@"这是一个类似微信/微博的图片浏览器组件" delegate:self cancelButtonTitle:nil deleteButtonTitle:@"删除" otherButtonTitles:@"发送给朋友",@"保存图片",@"收藏",@"投诉",nil];

```


-    3.3 自定义一些属性

```

    browser.pageDotColor = [UIColor purpleColor]; ///< 此属性针对动画样式的pagecontrol无效

    browser.currentPageDotColor = [UIColor greenColor];

    browser.pageControlStyle = XLPhotoBrowserPageControlStyleAnimated;///< 修改底部pagecontrol的样式为系统样式,默认是弹性动画的样式
    
```

-    3.4 必须实现数据源

```

#pragma mark    -   XLPhotoBrowserDatasource

/**

 *  数据源方法

 */

- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index

{

    return self.images[index];

}

- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index

{

    return self.scrollView.subviews[index];

}
```


* 3.5  代理方法,按需实现即可,在这里可以监听ActionSheet的点击事件

```

#pragma mark    -   XLPhotoBrowserDelegate

- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex

{

    // do something yourself

    switch (actionSheetindex) {

        case 4: // 删除

        {

            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);

            [self.images removeObjectAtIndex:currentImageIndex];

            [self resetScrollView];

        }

            break;

        case 1: // 保存

        {

            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);

            [browser saveCurrentShowImage];

        }

            break;

        default:

        {

            NSLog(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);

        }
           break;
    }
}
```

## 4. 喜欢的话,就给作者一个star. 有什么问题,欢迎进群讨论提问
-  QQ群: 579572313