//
//  BXCoreTextView.h
//  BXCoreText
//
//  Created by bx_1512 on 16/1/10.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BXDrawType){
    DrawPureText,                // 绘制文本段落
    DrawColumnarText,            // 绘制纵排文本
    DrawTextLabel,               // 绘制文本按钮
    DrawStyledParagraph          // 绘制样式段落
};

@interface BXCoreTextView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) BXDrawType drawType;

@end

