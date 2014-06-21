//
//  UIColor+Hex.m
//  MoodLight
//
//  Created by Stuart Buchbinder on 6/21/14.
//  Copyright (c) 2014 Nakkotech. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*) colorWithHex: (NSUInteger)hex {
	CGFloat red, green, blue, alpha;
    
	red = ((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF);
	green = ((CGFloat)((hex >> 8) & 0xFF)) / ((CGFloat)0xFF);
	blue = ((CGFloat)((hex >> 0) & 0xFF)) / ((CGFloat)0xFF);
	alpha = hex > 0xFFFFFF ? ((CGFloat)((hex >> 24) & 0xFF)) / ((CGFloat)0xFF) : 1;
    
	return [UIColor colorWithRed: red green:green blue:blue alpha:1];
}

- (uint)hex
{
    CGFloat red, green, blue, alpha;
    if (![self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        [self getWhite:&red alpha:&alpha];
        green = red;
        blue = red;
    }
    
    red = roundf(red * 255.f);
    green = roundf(green * 255.f);
    blue = roundf(blue * 255.f);
    alpha = roundf(alpha * 255.f);
    
    //    return ((uint)alpha << 24) | ((uint)red << 16) | ((uint)green << 8) | ((uint)blue);
    
    return ((uint)red << 16) | ((uint)green << 8) | ((uint)blue);
    
}

- (NSString*)hexString {
    return [NSString stringWithFormat:@"#%06x", [self hex]];
}

@end
