//
//  ZKMainViewController.m
//  ZKImageZoomAnimation
//
//  Created by ZK on 16/2/17.
//  Copyright © 2016年 ZK. All rights reserved.
//

#define ScreenWith [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define TimeInterval 0.01666667 //CADisplayLink刷新频率
#define kAnimationDuration 1.f
#define DefaultSharpLength 15.f
#define DefaultCornerWidth 12.f

#import "ZKMainViewController.h"
#import "CAShapeLayer+ViewMask.h"

@interface ZKMainViewController () {
    CGRect _originalFrame;
    CGRect _finalFrame;
    CGRect _originalBounds;
    CGRect _finalBounds;
    CGFloat _widthGap;       // 原始尺寸和最后尺寸的宽的差
    CGFloat _heightGap;      // 原始尺寸和最后尺寸的高的差
    CGFloat _sharpWidth;     // 尖角的长度
    CGFloat _cornerWidth;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UIView *blackMaskView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation ZKMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化数据
    [self setupData];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
    self.blackMaskView = ({
        self.blackMaskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.blackMaskView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:self.blackMaskView belowSubview:self.imageView];
        self.blackMaskView.alpha = 0;
        self.blackMaskView;
    });
}

- (void)setupData
{
    _originalBounds = self.imageView.bounds;
    _originalFrame = self.imageView.frame;
    _cornerWidth = DefaultCornerWidth;
    _sharpWidth = DefaultSharpLength;
    
    _shapeLayer = [CAShapeLayer createMaskLayerWithbounds:_originalBounds sharpLength:_sharpWidth cornerWidth:_cornerWidth];
    self.imageView.layer.mask = _shapeLayer;
    
    CGFloat imageWith = _originalBounds.size.width;
    CGFloat imageHeight = _originalBounds.size.height;
    _finalFrame = CGRectMake(0, (ScreenHeight - imageHeight * ScreenWith / imageWith) * 0.5,
                           ScreenWith, imageHeight * ScreenWith / imageWith);
    
    _widthGap = _finalFrame.size.width - _originalFrame.size.width;
    _heightGap = _finalFrame.size.height - _originalFrame.size.height;
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer
{
    _finalBounds = CGRectMake(0, 0, _finalFrame.size.width, _finalFrame.size.height);
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleTimerStretchImage)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:kAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear animations:^{
        self.imageView.frame = _finalFrame;
        self.blackMaskView.alpha = 1;
    } completion:nil];
}

- (IBAction)backBtnClick:(id)sender
{
    if (self.displayLink) {
        return;
    }
    _originalBounds = CGRectMake(0, 0, _originalFrame.size.width, _originalFrame.size.height);
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleTimerShrinkImage)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    [UIView animateWithDuration:kAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveLinear animations:^{
                            
        self.imageView.frame = _originalFrame;
        self.blackMaskView.alpha = 0;
    } completion:nil];
}

/** 缩小图片timer */
- (void)handleTimerShrinkImage
{
    _finalBounds.size.width  -= _widthGap*TimeInterval/kAnimationDuration;
    _finalBounds.size.height -= _heightGap*TimeInterval/kAnimationDuration;
    if (_sharpWidth<=DefaultSharpLength) {
        _sharpWidth += DefaultSharpLength*TimeInterval/kAnimationDuration;
    }
    if (_cornerWidth<=DefaultCornerWidth) {
        _cornerWidth += DefaultCornerWidth*TimeInterval/kAnimationDuration;
    }
    
    CGRect bounds = CGRectMake(0, 0, _finalBounds.size.width, _finalBounds.size.height);
    _shapeLayer = [CAShapeLayer createMaskLayerWithbounds:bounds sharpLength:_sharpWidth cornerWidth:_cornerWidth];
    self.imageView.layer.mask = _shapeLayer;
    
    CGFloat wx = _finalBounds.size.width - _originalBounds.size.width;
    CGFloat hx = _finalBounds.size.height - _originalBounds.size.height;
    
    if (wx <= 0 || hx <= 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

/** 放大图片timer */
- (void)handleTimerStretchImage
{
    _originalBounds.size.width  += _widthGap*TimeInterval/kAnimationDuration;
    _originalBounds.size.height += _heightGap*TimeInterval/kAnimationDuration;

    if (_sharpWidth>=0) {
        _sharpWidth -= DefaultSharpLength*TimeInterval/kAnimationDuration;
    }
    if (_cornerWidth>=1.f) {
        _cornerWidth -= DefaultCornerWidth*TimeInterval/kAnimationDuration;
    }
    
    CGRect bounds = CGRectMake(0, 0, _originalBounds.size.width, _originalBounds.size.height);
    _shapeLayer = [CAShapeLayer createMaskLayerWithbounds:bounds sharpLength:_sharpWidth cornerWidth:_cornerWidth];
    self.imageView.layer.mask = _shapeLayer;
    
    CGFloat wx = _finalBounds.size.width - _originalBounds.size.width;
    CGFloat hx = _finalBounds.size.height - _originalBounds.size.height;
    
    if (wx <= 0 || hx <= 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

@end
