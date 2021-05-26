//
//  MLSuspendingView.m
//  MoonLightDemo_iOS
//
//  Created by LJJ on 2021/5/20.
//  Copyright © 2021 Agora. All rights reserved.
//

#import "MLSuspendingView.h"

@interface MLSuspendingView ()

@property (nonatomic, strong) UIWindow * window;

@end


@implementation MLSuspendingView
+ (MLSuspendingView *)sharedSuspendingView{
    static dispatch_once_t onceToken;
    static MLSuspendingView *suspendingView;
    dispatch_once(&onceToken, ^{
        suspendingView = [[MLSuspendingView alloc] init];
    });
    return suspendingView;
}

- (instancetype)init{
    if (self == [super init]) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 95, 85)];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.backgroundColor = [UIColor colorWithRed:92.0/255 green:201.0/255 blue:243.0/255 alpha:0.5];
        _infoLabel.font = [UIFont systemFontOfSize:10];
        _infoLabel.alpha = 1;
        _infoLabel.numberOfLines = 0;
        
        UIViewController * viewc = [[UIViewController alloc] init];
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 95, 85)];
        _window.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, 80);
        _window.windowLevel = UIWindowLevelAlert + 1;
        _window.layer.cornerRadius = 10;
        _window.clipsToBounds = YES;
        _window.rootViewController = viewc;
        [_window addSubview:_infoLabel];
        [_window makeKeyAndVisible];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        _window.userInteractionEnabled = YES;
        [_window addGestureRecognizer:pan];
    }
    return self;
}

- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    CGPoint translation = [panGesture translationInView:_window];
    _window.center = CGPointMake(_window.center.x + translation.x, _window.center.y + translation.y);
    [panGesture setTranslation:CGPointZero inView:_window];
}

- (void)closeSuspendingView{
    [_window resignKeyWindow];
    _window = nil;
}
@end
