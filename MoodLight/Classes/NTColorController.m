//
//  NTColorController.m
//  MoodLight
//
//  Created by Stuart Buchbinder on 6/20/14.
//  Copyright (c) 2014 Nakkotech. All rights reserved.
//

#import "NTColorController.h"
#import "NTColorView.h"

@interface NTColorController ()
{
    CGFloat rValue;
    CGFloat gValue;
    CGFloat bValue;
    CGFloat aValue;
}

@property (weak, nonatomic) IBOutlet NTColorView *colorView;
@property (weak, nonatomic) IBOutlet UISlider *rSlider;
@property (weak, nonatomic) IBOutlet UISlider *gSlider;
@property (weak, nonatomic) IBOutlet UISlider *bSlider;
@property (weak, nonatomic) IBOutlet UITextField *rTextField;
@property (weak, nonatomic) IBOutlet UITextField *gTextField;
@property (weak, nonatomic) IBOutlet UITextField *bTextField;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UISwitch *powerSwitch;
@end

@implementation NTColorController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusNotification:) name:kNotificationStatus object:nil];
    
    [self powerOn];
    
}

#pragma mark - Notifications

- (void)statusNotification:(NSNotification *)note
{
    NSInteger status = (NSInteger)note.object;
    
    NSLog(@"statusNotification: %d", status);
}
#pragma mark - IBActions
- (IBAction)pressedStatusButton:(id)sender
{
}

- (IBAction)pressedPowerSwitch:(UISwitch *)sender
{
    if (sender.isOn) {
        [self powerOn];
    } else {
        [self powerOff];
    }
}

- (IBAction)pressedMenuButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMenu object:nil];
}

- (IBAction)pressedColorButton:(UIButton *)sender
{
    
    [_powerSwitch setOn:YES];
    
    UIColor *color = sender.backgroundColor;
    _colorView.backgroundColor = color;
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    rValue = components[0] * 255;
    gValue = components[1] * 255;
    bValue = components[2] * 255;
    
    self.rTextField.text = [NSString stringWithFormat:@"%1.0f", rValue];
    self.gTextField.text = [NSString stringWithFormat:@"%1.0f", gValue];
    self.bTextField.text = [NSString stringWithFormat:@"%1.0f", bValue];
    
    self.rSlider.value = rValue;
    self.gSlider.value = gValue;
    self.bSlider.value = bValue;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationColor object:color];
 
}


- (IBAction)sliderValueChanged:(UISlider *)sender
{
    [_powerSwitch setOn:YES];
    
    if (sender == _rSlider) {
        rValue = _rSlider.value;
    } else if (sender == _gSlider) {
        gValue = _gSlider.value;
    } else if (sender == _bSlider) {
        bValue = _bSlider.value;
    }
 
    self.rTextField.text = [NSString stringWithFormat:@"%1.0f", rValue];
    self.gTextField.text = [NSString stringWithFormat:@"%1.0f", gValue];
    self.bTextField.text = [NSString stringWithFormat:@"%1.0f", bValue];
    
    UIColor *color = [UIColor colorWithRed:rValue/255. green:gValue/255. blue:bValue/255. alpha:1.0];
    _colorView.backgroundColor = color;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationColor object:color];
}


#pragma mark - Private Methods

// User turned the power switch on. Initialize to white light
- (void)powerOn
{
    // init to White
    rValue = 255;
    gValue = 255;
    bValue = 255;
    
    _rSlider.value = rValue;
    _gSlider.value = gValue;
    _bSlider.value = bValue;
    
    self.rTextField.text = [NSString stringWithFormat:@"%1.0f", rValue];
    self.gTextField.text = [NSString stringWithFormat:@"%1.0f", gValue];
    self.bTextField.text = [NSString stringWithFormat:@"%1.0f", bValue];
    
     UIColor *color = [UIColor colorWithRed:rValue/255. green:gValue/255. blue:bValue/255. alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationColor object:color];
}

// User turned the power switch off. Turn LED off by setting color to black
- (void)powerOff
{
    // init to White
    rValue = 0;
    gValue = 0;
    bValue = 0;
    
    _rSlider.value = rValue;
    _gSlider.value = gValue;
    _bSlider.value = bValue;
    
    self.rTextField.text = [NSString stringWithFormat:@"%1.0f", rValue];
    self.gTextField.text = [NSString stringWithFormat:@"%1.0f", gValue];
    self.bTextField.text = [NSString stringWithFormat:@"%1.0f", bValue];
    
     UIColor *color = [UIColor colorWithRed:rValue/255. green:gValue/255. blue:bValue/255. alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationColor object:color];
}

@end
