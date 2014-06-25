//
//  NTColorController.m
//  MoodLight
//
//  Created by Stuart Buchbinder on 6/25/14.
//  Copyright (c) 2014 Nakkotech. All rights reserved.
//

#import "NTColorController.h"
#import "NKOColorPickerView.h"

@interface NTColorController ()
{
    UIColor *currentColor;
    UIColor *lastColor;
    PowerState powerState;
}
@property (weak, nonatomic) IBOutlet NKOColorPickerView *colorPickerView;
@property (weak, nonatomic) IBOutlet UILabel *powerStateLabel;

@end

@implementation NTColorController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    powerState = POWER_ON;
    
    currentColor = [UIColor whiteColor];
    lastColor = [UIColor whiteColor];
    
    self.powerStateLabel.text = @"Power is ON";
    
    [self.colorPickerView setDidChangeColorBlock:^(UIColor *color){
        currentColor = color;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationColor object:currentColor];
    }];
}


#pragma mark - Private Methods


#pragma mark - UITableView Methods

// User wants to turn on/off the lights
//   turn off the lights by setting currentColor to black
//   turn on the lights by setting currentColor to the last color set

- (void)togglePower
{
    if (powerState == POWER_ON) {
        powerState = POWER_OFF;
        lastColor = currentColor;
        currentColor = [UIColor blackColor];
        self.powerStateLabel.text = @"Power is OFF";
        
        self.colorPickerView.userInteractionEnabled = NO;
        self.colorPickerView.alpha = 0.5;

    } else if (powerState == POWER_OFF) {
        powerState = POWER_ON;
        currentColor = lastColor;
        self.powerStateLabel.text = @"Power is ON";
        
        self.colorPickerView.userInteractionEnabled = YES;
        self.colorPickerView.alpha = 1.0;
    }
    
     [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationColor object:currentColor];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self togglePower];
    }
}


@end
