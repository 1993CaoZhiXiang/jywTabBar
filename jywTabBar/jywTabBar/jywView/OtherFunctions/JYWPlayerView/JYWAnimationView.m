//
//  JYWAnimationView.m
//  jywTabBar
//
//  Created by 姜益伟 on 2020/6/13.
//  Copyright © 2020 姜益伟. All rights reserved.
//

#import "JYWAnimationView.h"

@implementation JYWAnimationViewConfig

+ (instancetype)defaultConfig {
    JYWAnimationViewConfig *configure = [[JYWAnimationViewConfig alloc] init];
    configure.startAngle = - M_PI_2;
    configure.endAngle = M_PI + M_PI_2;
    configure.number = 5;
    configure.intervalDuration = 0.12;
    configure.duration = 2;
    configure.diameter = 8;
    configure.backgroundColor = [UIColor redColor];
    return configure;
}

@end

@interface JYWAnimationView ()

///默认配置
@property (nonatomic, strong) JYWAnimationViewConfig *defaultConfig;
///是否开始动画
@property (nonatomic, assign) BOOL isStart;
///是否暂停
@property (nonatomic, assign) BOOL isPause;
///layer数组
@property (nonatomic, strong) NSMutableArray<CALayer *> *layerArray;

@end
@implementation JYWAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layerArray = [NSMutableArray array];
    }
    return self;
}
- (void)animation {
    CGFloat origin_x = self.frame.size.width * 0.5;
    CGFloat origin_y = self.frame.size.height * 0.5;
    for (NSInteger i = 0; i < self.defaultConfig.number; i++) {
        CGFloat scale = (CGFloat)(self.defaultConfig.number + 1 - i) / (CGFloat)(self.defaultConfig.number + 1);
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = self.defaultConfig.backgroundColor.CGColor;
        layer.frame = CGRectMake(-500, -500, scale * self.defaultConfig.diameter, scale * self.defaultConfig.diameter);
        layer.cornerRadius = scale * self.defaultConfig.diameter * 0.5;
        //创建运动的轨迹动画
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.duration = self.defaultConfig.duration - self.defaultConfig.intervalDuration * self.defaultConfig.number;
        pathAnimation.beginTime = i * self.defaultConfig.intervalDuration;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(origin_x, origin_y) radius:(self.frame.size.width - self.defaultConfig.diameter) * 0.5 startAngle:self.defaultConfig.startAngle endAngle:self.defaultConfig.endAngle  clockwise:YES].CGPath;
        //组动画
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[pathAnimation];
        group.duration = self.defaultConfig.duration;
        group.removedOnCompletion = NO;
        group.fillMode = kCAFillModeForwards;
        group.repeatCount = INTMAX_MAX;
        //设置运转的动画
        [layer addAnimation:group forKey:@"moveTheCircleOne"];
        [self.layerArray addObject:layer];
    }
}
//MARK:JmoVxia---更新配置
- (void)updateWithConfigure:(void(^)(JYWAnimationViewConfig *configure))configBlock {
    if (configBlock) {
        configBlock(self.defaultConfig);
    }
    CGFloat intervalDuration = (CGFloat)(self.defaultConfig.duration / 2.0 / (CGFloat)self.defaultConfig.number);
    self.defaultConfig.intervalDuration = MIN(self.defaultConfig.intervalDuration, intervalDuration);
    if (self.isStart) {
        [self stopAnimation];
        [self startAnimation];
    }
}
//MARK:JmoVxia---开始动画
- (void)startAnimation {
    [self animation];
    for (CALayer *layer in self.layerArray) {
        [self.layer addSublayer:layer];
    }
    self.isStart = YES;
}
//MARK:JmoVxia---结束动画
- (void)stopAnimation {
    for (CALayer *layer in self.layerArray) {
        [layer removeFromSuperlayer];
    }
    [self.layerArray removeAllObjects];
    self.isStart = NO;
}
//MARK:JmoVxia---暂停动画
- (void)pauseAnimation {
    if (self.isPause) {
        return;
    }
    self.isPause = YES;
    CFTimeInterval time = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0;
    self.layer.timeOffset = time;
}
//MARK:JmoVxia---恢复动画
- (void)resumeAnimation {
    if (!self.isPause) {
        return;
    }
    self.isPause = NO;
    CFTimeInterval pausedTime = self.layer.timeOffset;
    self.layer.speed = 1;
    self.layer.timeOffset = 0;
    self.layer.beginTime = 0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}
//MARK:JmoVxia---默认配置
- (JYWAnimationViewConfig *) defaultConfig {
    if (_defaultConfig == nil) {
        _defaultConfig = [JYWAnimationViewConfig defaultConfig];
    }
    return _defaultConfig;
}

@end