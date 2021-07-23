//
//  MLSuspendingView.m
//  MoonLightDemo
//
//  Created by LJJ on 2021/7/23.
//  Copyright © 2021 Agora. All rights reserved.
//

#import "MLSuspendingView.h"

@implementation MLSuspendingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _infoLabel = [[NSTextField alloc] init];
        _infoLabel.frame = CGRectMake(0, 0, 95, 70);
        _infoLabel.stringValue = @"Agora Label!";
        _infoLabel.font = [NSFont systemFontOfSize:10];
        _infoLabel.alphaValue = 1;
        _infoLabel.wantsLayer = true;
        _infoLabel.backgroundColor = [NSColor colorWithRed:92.0/255 green:201.0/255 blue:243.0/255 alpha:0.5];
        _infoLabel.editable = NO;
        _infoLabel.bezeled = NO;
        _infoLabel.alignment = NSTextAlignmentCenter;
        _infoLabel.layer.cornerRadius = 10;
        _infoLabel.maximumNumberOfLines = 0;
    }
    return self;
}

- (void)closeSuspendingView {
    [_infoLabel removeFromSuperview];
    _infoLabel = nil;
}

@end
