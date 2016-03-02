//
//  CAShapeLayer+ViewMask.m
//  ZKImageZoomAnimation
//
//  Created by ZK on 16/2/17.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "CAShapeLayer+ViewMask.h"

@implementation CAShapeLayer (ViewMask)

+ (instancetype)createMaskLayerWithbounds:(CGRect)bounds sharpLength:(CGFloat)sharpLength cornerWidth:(CGFloat)cornerWidth
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    CGMutablePathRef maskPath = CGPathCreateMutable();
    
    CGPathAddRoundedRect(maskPath, nil, CGRectInset(bounds, sharpLength, 0),cornerWidth,cornerWidth);
    
    //创建Path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, sharpLength, 21+(15-sharpLength)*0.5);
    CGPathAddLineToPoint(path, NULL, 0, 30); // 中间尖角坐标
    CGPathAddLineToPoint(path, NULL, sharpLength,39-(15-sharpLength)*0.5);
    
    CGPathAddPath(maskPath, nil, path);
    
//    layer.fillColor = [UIColor blackColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.path = maskPath;
    return layer;
}

@end

