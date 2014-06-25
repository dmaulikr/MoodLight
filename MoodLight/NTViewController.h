//
//  NTViewController.h
//  MoodLight
//
//  Created by Stuart Buchbinder on 6/20/14.
//  Copyright (c) 2014 Nakkotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "UARTPeripheral.h"

typedef enum
{
    ConnectionStatusDisconnected = 0,
    ConnectionStatusScanning,
    ConnectionStatusConnected,
}ConnectionStatus;

@interface NTViewController : UIViewController <CBCentralManagerDelegate, UARTPeripheralDelegate>

@property (nonatomic) ConnectionStatus      connectionStatus;

@end
