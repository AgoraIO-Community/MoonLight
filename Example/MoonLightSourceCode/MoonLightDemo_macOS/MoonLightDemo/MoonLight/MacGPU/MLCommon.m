//
//  MLCommon.m
//  MoonLightDemo
//
//  Created by LJJ on 2020/11/18.
//  Copyright © 2020 Agora. All rights reserved.
//

#import "MLCommon.h"

@implementation MLCommon

+ (NSString *)formattedStringForBytes:(double)bytes {
    if (bytes >= 109951162777600.)
        return [NSString stringWithFormat:@"%3.1fT", (bytes / 1099511627776.)];
    else if (bytes >= 1099511627776.)
        return [NSString stringWithFormat:@"%3.2fT", (bytes / 1099511627776.)];
    else if (bytes >= 107374182400.)
        return [NSString stringWithFormat:@"%3.1fG", (bytes / 1073741824.)];
    else if (bytes >= 1073741824.)
        return [NSString stringWithFormat:@"%3.2fG", (bytes / 1073741824.)];
    else if (bytes >= 104857600.)
        return [NSString stringWithFormat:@"%3.1fM", (bytes / 1048576.)];
    else if (bytes >= 1048576.)
        return [NSString stringWithFormat:@"%3.2fM", (bytes / 1048576.)];
    else if (bytes >= 102400.)
        return [NSString stringWithFormat:@"%4.0fK", (bytes / 1024.)];
    else if (bytes >= 1024.)
        return [NSString stringWithFormat:@"%4.1fK", (bytes / 1024.)];
    else
        return [NSString stringWithFormat:@"%ldB", (long)bytes];
}

@end

