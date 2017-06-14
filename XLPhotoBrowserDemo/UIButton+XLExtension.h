//
//  UIButton+XLExtension.h
//  EHGhostDrone3
//
//  Created by XL on 2017/4/21.
//  Copyright © 2017年 Ehang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (XLExtension)

/** 是否关闭自动处理enable状态的UI */
@property (nonatomic , assign) BOOL disabledCustomEnableUI;
/** 是否关闭自动处理高亮和普通状态下的UI , 默认不关闭 */
@property (nonatomic , assign) BOOL disabledCustomHighlightedUI;

+ (instancetype)xl_buttonIconFontButtonWithFontSize:(CGFloat)fontSize iconFontUnicode:(NSString *)iconFontUnicode target:(id)target action:(SEL)action;


@end
