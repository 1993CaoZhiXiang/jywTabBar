//
//  JYWFireworks.h
//  jywTabBar
//
//  Created by 姜益伟 on 2020/6/19.
//  Copyright © 2020 姜益伟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//烟花动画
@interface JYWFireworks : UIView
{
    CAEmitterLayer *emitterLayer;
}
-(void)play;//播放动画
-(void)stop;//停止动画
@end

NS_ASSUME_NONNULL_END
