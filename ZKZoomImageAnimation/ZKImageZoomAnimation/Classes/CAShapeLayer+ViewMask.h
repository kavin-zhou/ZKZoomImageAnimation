//
//  CAShapeLayer+ViewMask.h
//  ZKImageZoomAnimation
//
//  Created by ZK on 16/2/17.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CAShapeLayer (ViewMask)
// sharpLength:尖角长度  等于CGPathAddRoundedRect中的dx宽度
+ (instancetype)createMaskLayerWithbounds:(CGRect)bounds sharpLength:(CGFloat)sharpLength cornerWidth:(CGFloat)cornerWidth;

@end
