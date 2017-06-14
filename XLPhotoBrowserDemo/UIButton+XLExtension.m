//
//  UIButton+XLExtension.m
//  EHGhostDrone3
//
//  Created by XL on 2017/4/21.
//  Copyright © 2017年 Ehang. All rights reserved.
//

#import "UIButton+XLExtension.h"
#import <objc/runtime.h>

@implementation UIButton (XLExtension)


#pragma mark    -   统一处理按钮不同状态的背景色边框等属性

static char DisabledCustomEnableUIKey;
static char DisabledCustomHighlightedUIKey;

- (BOOL)disabledCustomEnableUI
{
    return [objc_getAssociatedObject(self,&DisabledCustomEnableUIKey) boolValue];
}

- (void)setDisabledCustomEnableUI:(BOOL)disabledCustomEnableUI
{
    objc_setAssociatedObject(self, &DisabledCustomEnableUIKey, @(disabledCustomEnableUI),OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)disabledCustomHighlightedUI
{
    return [objc_getAssociatedObject(self, &DisabledCustomHighlightedUIKey) boolValue];
}

- (void)setDisabledCustomHighlightedUI:(BOOL)disabledCustomHighlightedUI
{
    objc_setAssociatedObject(self, &DisabledCustomHighlightedUIKey, @(disabledCustomHighlightedUI), OBJC_ASSOCIATION_RETAIN);
}

#pragma mark    -   方法交换系列

- (void)xl_setEnabled:(BOOL)enabled
{
    [self xl_setEnabled:enabled];

    if (self.disabledCustomEnableUI) {
        return;
    }
    if (enabled) {// 可点击状态下的属性
        self.titleLabel.alpha = 1;
        self.imageView.alpha = 1;
        self.alpha = 1;
    } else { // 不可点击状态下的属性
        self.titleLabel.alpha = 0.3;
        self.imageView.alpha = 0.3;
        self.alpha = 0.9;
    }
}

/**
 *  在运行时替换UIButton的highlighted图片
 */

- (void)xl_setHighlighted:(BOOL)highlighted
{
    [self xl_setHighlighted:highlighted];
    if (self.currentImage) {
        return;
    }
    if (self.disabledCustomHighlightedUI) {
        return;
    }
    if (highlighted) { // 高亮状态下的UI
        self.titleLabel.alpha = 0.5;
        self.imageView.alpha = 0.5;
        self.alpha = 0.8;
    } else {
        self.titleLabel.alpha = 1.0;
        self.imageView.alpha = 1.0;
        self.alpha = 1.0;
    }
    
}

+ (void)load
{
    [self xl_exchangeInstanceMethod1:@selector(setEnabled:) method2:@selector(xl_setEnabled:)];
    [self xl_exchangeInstanceMethod1:@selector(setHighlighted:) method2:@selector(xl_setHighlighted:)];
}

+ (void)xl_exchangeInstanceMethod1:(SEL)originalSelector method2:(SEL)swizzledSelector
{
    Class class = [self class]; // 这个地方要注意
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    //    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

@end
