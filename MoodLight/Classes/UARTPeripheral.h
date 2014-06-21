//
//  UARTPeripheral.h
//  MoodLight
//
//  Created by Stuart Buchbinder on 6/20/14.
//  Copyright (c) 2014 Nakkotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol UARTPeripheralDelegate

- (void) didReceiveData:(NSData*)newData;
- (void) didReadHardwareRevisionString:(NSString*) string;
- (void) uartDidEncounterError:(NSString*) error;

@end


@interface UARTPeripheral : NSObject <CBPeripheralDelegate>

@property CBPeripheral *peripheral;
@property id<UARTPeripheralDelegate> delegate;

+ (CBUUID*)uartServiceUUID;
- (UARTPeripheral*)initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<UARTPeripheralDelegate>) delegate;
- (void) writeString:(NSString*) string;
- (void) writeRawData:(NSData*)data;
- (void) didConnect;
- (void) didDisconnect;

@end
