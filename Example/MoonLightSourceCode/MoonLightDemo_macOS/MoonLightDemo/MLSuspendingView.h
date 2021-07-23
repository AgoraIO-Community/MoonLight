//
//  MLSuspendingView.h
//  MoonLightDemo
//
//  Created by LJJ on 2021/7/23.
//  Copyright © 2021 Agora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
NS_ASSUME_NONNULL_BEGIN

@interface MLSuspendingView : NSObject

@property (nonatomic, strong) NSTextField *infoLabel;

- (void)closeSuspendingView;

@end

NS_ASSUME_NONNULL_END
