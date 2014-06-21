//
//  UIColor+Hex.h
//  MoodLight
//
//  Created by Stuart Buchbinder on 6/21/14.
//  Copyright (c) 2014 Nakkotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(NSUInteger)hex;

- (uint)hex;
- (NSString *)hexString;

@end
