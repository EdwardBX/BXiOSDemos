//
//  BXCoreTextView.m
//  BXCoreText
//
//  Created by bx_1512 on 16/1/10.
//  Copyright © 2016年 bx_1512. All rights reserved.
//

#import "BXCoreTextView.h"
#import <CoreText/CoreText.h>
#import <float.h>

@implementation BXCoreTextView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setUp];
    }
    
    return self;
}

- (void)setUp {
    self.font = [UIFont systemFontOfSize:18];
    self.text = @"Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.";
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = [self initContext];
    
    if (self.drawType == DrawPureText) {
        [self drawPureTextWithContext:context];
    } else if (self.drawType == DrawColumnarText){
        CFMutableAttributedStringRef attrString =
        [self initAttrStringWithTextString:self.text];
        [self columnarTextLayoutWithContext:context
                           attributedString:attrString
                                columnCount:2];
    } else if (self.drawType == DrawTextLabel) {
        NSString *labelString = @"Hello, world!";
        CFStringRef aString = (__bridge CFStringRef)labelString;
        CTFontDescriptorRef aFontDes =
        [self CreateFontDescriptorFromFamilyName:@"Papyrus"
                                      fontTraits:kCTFontTraitCondensed
                                            size:24.0];
        CTFontRef aFont = CTFontCreateWithFontDescriptor(aFontDes,
                                                         0.0, NULL);
        [self TypesettingTextLabelWithContext:context
                                       string:aString
                                         font:aFont];
        CFRelease(aFont);
        CFRelease(aFontDes);
    } else if (self.drawType == DrawStyledParagraph){
        [self drawStyledParagraphWithRect:rect
                                  context:context];
    } else {
        CFMutableAttributedStringRef attrString =
        [self initAttrStringWithTextString:self.text];
        [self drawDonutWithContext:context attributedString:attrString];
    }
}

#pragma mark - ----绘制方法
/**
 *  基本的文本绘制
 *
 *  @param context 上下文
 */
-(void)drawPureTextWithContext:(CGContextRef)context{
    // 创建一个 path, 在它的 bounds 内绘制文本.
    CGMutablePathRef path = CGPathCreateMutable();
    // 初始化一个矩形的 path.
    CGRect bounds = CGRectMake(10.0, 0,
                               self.bounds.size.width,
                               self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    // 初始化一个 CFAttributedStringRef
    CFAttributedStringRef attrString =
    [self initAttrStringWithTextString:self.text];
    
    // 用属性字符串创建一个 framesetter.
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);
    
    // 根据 framesetter 和 path 创建一个 frame.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0),
                                                path, NULL);
    
    // 根据 context 绘制 frame.
    CTFrameDraw(frame, context);
    
    // Release.
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

/**
 *  绘制一行文字的label
 *
 *  @param context 上下文
 *  @param string  要绘制的字符串
 *  @param font    字体
 */
-(void)TypesettingTextLabelWithContext:(CGContextRef)context
                                string:(CFStringRef)string
                                  font:(CTFontRef)font {
    
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    
    CFDictionaryRef attributes =
    CFDictionaryCreate(kCFAllocatorDefault, (const void**)&keys,
                       (const void**)&values, sizeof(keys) / sizeof(keys[0]),
                       &kCFTypeDictionaryKeyCallBacks,
                       &kCFTypeDictionaryValueCallBacks);
    
    CFAttributedStringRef attrString =
    CFAttributedStringCreate(kCFAllocatorDefault,
                             string, attributes);
    CFRelease(attributes);
    
    CTLineRef line = CTLineCreateWithAttributedString(attrString);
    
    CGFloat lineAscent;
    CGFloat lineDescent;
    CGFloat lineLeading;
    // 该函数除了会设置好ascent,descent,leading之外，还会返回这行的宽度
    CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
    CGContextSetTextPosition(context, 0, self.bounds.size.height - lineAscent - lineDescent - lineLeading);
    CTLineDraw(line, context);
    
    CFRelease(line);
    CFRelease(attrString);
}

/**
 *  创建分栏排版
 *
 *  @param columnCount 纵向分栏数
 *
 *  @return 一组分栏绘制路径
 */
- (CFArrayRef)createColumnsWithColumnCount:(int)columnCount
{
    int column;
    
    CGRect* columnRects = (CGRect*)calloc(columnCount,
                                          sizeof(*columnRects));
    // 第一列覆盖全部视图
    columnRects[0] = self.bounds;
    
    // 计算每一个纵行的宽度
    CGFloat columnWidth = CGRectGetWidth(self.bounds) / columnCount;
    for (column = 0; column < columnCount - 1; column++) {
        CGRectDivide(columnRects[column], &columnRects[column],
                     &columnRects[column + 1], columnWidth, CGRectMinXEdge);
    }
    
    // 设置行间距
    for (column = 0; column < columnCount; column++) {
        columnRects[column] = CGRectInset(columnRects[column], 10.0, 15.0);
    }
    
    // 为每列创建绘制路径
    CFMutableArrayRef array = CFArrayCreateMutable(kCFAllocatorDefault,
                                                   columnCount, &kCFTypeArrayCallBacks);
    for (column = 0; column < columnCount; column++) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, columnRects[column]);
        CFArrayInsertValueAtIndex(array, column, path);
        CFRelease(path);
    }
    free(columnRects);
    return array;
}

/**
 *  分栏排版
 *
 *  @param context    上下文
 *  @param attrString 属性字符串
 *  @param count      分栏列数
 */
- (void)columnarTextLayoutWithContext:(CGContextRef)context
                     attributedString:(CFMutableAttributedStringRef)attrString
                          columnCount:(int)count {
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString(attrString);
    // 分成3列
    CFArrayRef columnPaths =
    [self createColumnsWithColumnCount:count];
    
    CFIndex pathCount = CFArrayGetCount(columnPaths);
    CFIndex startIndex = 0;
    int column;
    
    // 为每一个列创建一个 frame.
    for (column = 0; column < pathCount; column++) {
        // 得到该列的 path
        CGPathRef path =
        (CGPathRef)CFArrayGetValueAtIndex(columnPaths, column);
        
        // 用 path 创建一个 frame
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                    CFRangeMake(startIndex, 0),
                                                    path, NULL);
        CTFrameDraw(frame, context);
        
        // 开始创建下一列的 frame.
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
    }
    
    CFRelease(columnPaths);
    CFRelease(framesetter);
    CFRelease(attrString);
}

/**
 *  属性字符串应用段落样式
 *
 *  @param fontName     字体名称
 *  @param pointSize    大小
 *  @param plainText    文本字符串
 *  @param lineSpaceInc 行间距
 *
 *  @return 应用了段落样式的字符串
 */
NSAttributedString* applyParaStyle(CFStringRef fontName,
                                   CGFloat pointSize,
                                   NSString *plainText,
                                   CGFloat lineSpaceInc) {
    // 创建一个字体，后续用它的高度
    CTFontRef font = CTFontCreateWithName(fontName, pointSize, NULL);
    
    // 设置行距
    CGFloat lineSpacing = (CTFontGetLeading(font) + lineSpaceInc) * 2;
    
    // 创建段落排版设置
    CTParagraphStyleSetting setting;
    setting.spec = kCTParagraphStyleSpecifierLineSpacing;
    setting.valueSize = sizeof(CGFloat);
    setting.value = &lineSpacing;
    CTParagraphStyleRef paragraphStyle =
    CTParagraphStyleCreate(&setting, 1);
    
    // 把段落的设置加入字典
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                (__bridge id)font, (id)kCTFontNameAttribute,
                                (__bridge id)paragraphStyle,
                                (id)kCTParagraphStyleAttributeName, nil];
    CFRelease(font);
    CFRelease(paragraphStyle);
    
    // 用段落排版的设置初始化属性字符串
    NSAttributedString *attrString = [[NSAttributedString alloc]
                                      initWithString:(NSString*)plainText
                                          attributes:attributes];
    return attrString;
}

/**
 *  绘制样式段落
 *
 *  @param rect    drawRect 中 rect
 *  @param context 上下文
 */
-(void)drawStyledParagraphWithRect:(CGRect)rect
                           context:(CGContextRef)context{
    CFStringRef fontName = CFSTR("Didot-Italic");
    CGFloat pointSize = 25.0;
    
    CFStringRef string = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Sometimes I write one, and I look at it, until it begins to shine.");
                               
    // 应用段落样式
    NSAttributedString *attrString =
    applyParaStyle(fontName, pointSize,
                   (__bridge NSString*)string, 10.0);
    
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                CFRangeMake(0, 0),
                                                path, NULL);
    CTFrameDraw(frame, context);
    CFRelease(frame);
    CFRelease(framesetter);
    CGPathRelease(path);
}

// 创建非矩形绘制路径实例
static void AddSquashedDonutPath(CGMutablePathRef path,
                                 const CGAffineTransform *m, CGRect rect) {
    CGFloat width = CGRectGetWidth(rect);
    CGFloat height = CGRectGetHeight(rect);
    
    CGFloat radiusH = width / 3.0;
    CGFloat radiusV = height / 3.0;
    
    CGPathMoveToPoint(path, m, rect.origin.x,
                      rect.origin.y + height - radiusV);
    CGPathAddQuadCurveToPoint(path, m, rect.origin.x,
                              rect.origin.y + height,
                              rect.origin.x + radiusH,
                              rect.origin.y + height);
    CGPathAddLineToPoint(path, m, rect.origin.x + width - radiusH,
                         rect.origin.y + height);
    CGPathAddQuadCurveToPoint(path, m, rect.origin.x + width,
                              rect.origin.y + height,
                              rect.origin.x + width,
                              rect.origin.y + height - radiusV);
    CGPathAddLineToPoint(path, m, rect.origin.x + width,
                         rect.origin.y + radiusV);
    CGPathAddQuadCurveToPoint(path, m, rect.origin.x + width,
                              rect.origin.y,
                              rect.origin.x + width - radiusH,
                              rect.origin.y);
    CGPathAddLineToPoint(path, m, rect.origin.x + radiusH, rect.origin.y);
    CGPathAddQuadCurveToPoint(path, m, rect.origin.x, rect.origin.y,
                              rect.origin.x, rect.origin.y + radiusV);
    CGPathCloseSubpath(path);
    CGPathAddEllipseInRect(path, m,
                           CGRectMake(rect.origin.x + width / 2.0 - width / 5.0,
                                      rect.origin.y + height / 2.0 - height / 5.0,
                                      width / 5.0 * 2.0, height / 5.0 * 2.0));
}

- (NSArray *)paths {
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = self.bounds;
    bounds = CGRectInset(bounds, 10.0, 10.0);
    AddSquashedDonutPath(path, NULL, bounds);
    
    NSMutableArray *result =
    [NSMutableArray arrayWithObject:CFBridgingRelease(path)];
    return result;
}

-(void)drawDonutWithContext:(CGContextRef)context
           attributedString:(CFMutableAttributedStringRef)attrString {
    NSArray *paths = [self paths];
    CFIndex startIndex = 0;
    CTFramesetterRef framesetter =
    CTFramesetterCreateWithAttributedString(attrString);
    
    for (id object in paths) {
        CGPathRef path = (__bridge CGPathRef)object;
        
        // path 的背景设为黄色
        CGContextSetFillColorWithColor(context, [[UIColor yellowColor] CGColor]);
        
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        
        CGContextDrawPath(context, kCGPathStroke);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                                                    CFRangeMake(startIndex, 0), path, NULL);
        CTFrameDraw(frame, context);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        startIndex += frameRange.length;
        CFRelease(frame);
    }
    
    CFRelease(attrString);
    CFRelease(framesetter);
}


//换行
- (CFIndex)manualLineBreakingWithContext:(CGContextRef)context
                                   index:(CFIndex)index{
    // 初始化，这几个变量可设为参数
    double width = 300.0;
    CGPoint textPosition = CGPointMake(10.0, 20.0);
    CFAttributedStringRef attrString =
    [self initAttrStringWithTextString:self.text];
    
    // 用属性字符串创建 typesetter.
    CTTypesetterRef typesetter =
    CTTypesetterCreateWithAttributedString(attrString);
    
    // 根据宽度计算换行的 index.
    CFIndex count =
    CTTypesetterSuggestLineBreak(typesetter, index, width);
    
    // 用字符串范围创建一行 CTLine
    CTLineRef line = CTTypesetterCreateLine(typesetter,
                                            CFRangeMake(index, count));
    
    // 居中
    float flush = 0.5;
    double penOffset = CTLineGetPenOffsetForFlush(line, flush, width);
    
    // 计算绘制位置
    CGContextSetTextPosition(context,
                             textPosition.x + penOffset, textPosition.y);
    CTLineDraw(line, context);
    
    index += count;
    return index;
}

#pragma mark - ----common function
/**
 *  转换坐标系
 *
 *  @return 转换后的 context
 */
- (CGContextRef)initContext {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 在 iOS 中要转换坐标系
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    return context;
}

-(CFMutableAttributedStringRef)initAttrStringWithTextString:(NSString*)textString {
    // 创建一个最大长度为0的 mutable attributed string.
    CFMutableAttributedStringRef attrString =
    CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    // 把 textString 拷贝至 attrString.
    CFAttributedStringReplaceString(attrString,
                                    CFRangeMake(0, 0),
                                    (__bridge CFStringRef)textString);
    
    // 为 attrString 创建一个属性颜色 red.
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = { 1.0, 0.0, 0.0, 0.8 };
    CGColorRef red = CGColorCreate(rgbColorSpace, components);
    CGColorSpaceRelease(rgbColorSpace);
    
    // 把头 12 个字符设置为 red.
    CFAttributedStringSetAttribute(attrString,
                                   CFRangeMake(0, 12),
                                   kCTForegroundColorAttributeName,
                                   red);
    return attrString;
}

#pragma mark - ----font related
/**
 *  用名称创建一个 FontDescriptor
 *
 *  @param postScriptName postScript 名称
 *  @param size           大小
 *
 *  @return FontDescriptor
 */
CTFontDescriptorRef CreateFontDescriptorFromName(CFStringRef postScriptName,
                                                 CGFloat size) {
    return CTFontDescriptorCreateWithNameAndSize(postScriptName, size);
}

/**
 *  用 familyName 和 symbolic traits 创建一个 FontDescriptor
 *
 *  @param familyName
 *  @param symbolicTraits
 *  @param size           大小
 *
 *  @return FontDescriptor
 */
- (CTFontDescriptorRef)CreateFontDescriptorFromFamilyName:(NSString *)familyName
                                               fontTraits:(CTFontSymbolicTraits)symbolicTraits
                                                     size:(CGFloat)size {
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    [attributes setObject:familyName
                   forKey:(id)kCTFontFamilyNameAttribute];

    // attributes 字典包含另外一个 traits 字典，
    NSMutableDictionary* traits = [NSMutableDictionary dictionary];
    [traits setObject:[NSNumber numberWithUnsignedInt:symbolicTraits]
               forKey:(id)kCTFontSymbolicTrait];
    
    [attributes setObject:traits forKey:(id)kCTFontTraitsAttribute];
    [attributes setObject:[NSNumber numberWithFloat:size]
                   forKey:(id)kCTFontSizeAttribute];

    CTFontDescriptorRef descriptor =
    CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attributes);
    return descriptor;
}

/**
 *  创建粗体字体
 *
 *  @param font     字体
 *  @param makeBold 是否粗体
 *
 *  @return 加粗体 trait 的字体
 */
CTFontRef CreateBoldFont(CTFontRef font, Boolean makeBold) {
    CTFontSymbolicTraits desiredTrait = 0;
    CTFontSymbolicTraits traitMask;
    
    if (makeBold) desiredTrait = kCTFontBoldTrait;
    traitMask = kCTFontBoldTrait;
    
    return CTFontCreateCopyWithSymbolicTraits(font, 0.0, NULL,
                                              desiredTrait, traitMask);
}

@end
