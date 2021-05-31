//
//  MLSuspendingView.h
//  MoonLightDemo_iOS
//
//  Created by LJJ on 2021/5/20.
//  Copyright © 2021 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLSuspendingView : NSObject

@property (nonatomic, strong) UILabel * infoLabel;

- (void)closeSuspendingView;

@end

NS_ASSUME_NONNULL_END
