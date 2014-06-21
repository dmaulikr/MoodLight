//
//  NTColorView.m
//  MoodLight
//
//  Created by Stuart Buchbinder on 6/20/14.
//  Copyright (c) 2014 Nakkotech. All rights reserved.
//

#import "NTColorView.h"

@implementation NTColorView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.layer.cornerRadius = 4;
    }
    
    return self;
}



@end
