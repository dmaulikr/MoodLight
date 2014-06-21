//
//  NTViewController.m
//  MoodLight
//
//  Created by Stuart Buchbinder on 6/20/14.
//  Copyright (c) 2014 Nakkotech. All rights reserved.
//

#import "NTViewController.h"
#import "UIColor+Hex.h"

@interface NTViewController ()
{
    CBCentralManager    *centralManager;
    UARTPeripheral      *currentPeripheral;
}

@end

@implementation NTViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuNotification:) name:kNotificationMenu object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorNotification:) name:kNotificationColor object:nil];
    
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _connectionStatus = ConnectionStatusDisconnected;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self scanForPeripherals];
}


#pragma mark - Notifications

- (void)menuNotification:(NSNotification *)note
{
    NSLog(@"menu notification");
}

- (void)colorNotification:(NSNotification *)note
{
    UIColor *color = (UIColor *)note.object;
    NSString *hexString = [color hexString];
    [self dispatchMessageToPeripherals:hexString];
}

#pragma mark - Private Methods

- (void)dispatchMessageToPeripherals:(NSString *)message
{
    [currentPeripheral writeString:message];
}

#pragma mark - CoreBluetooth Methods

- (void)scanForPeripherals
{
    NSArray *connectedPeripherals = [centralManager retrieveConnectedPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID]];
    
    if ([connectedPeripherals count]) {
        [self connectPeripheral:connectedPeripherals[0]];
    } else {
        [centralManager scanForPeripheralsWithServices:@[UARTPeripheral.uartServiceUUID] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @0}];
    }
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"connecting peripheral: %@", peripheral.name);
    
    // Clear any pending connections
    [centralManager cancelPeripheralConnection:peripheral];
    
    // Connect
    currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    [centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: @1}];
}

- (void)disconnectPeripheral:(CBPeripheral *)peripheral
{
    _connectionStatus = ConnectionStatusDisconnected;
    [centralManager cancelPeripheralConnection:currentPeripheral.peripheral];
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        // respond to powered on
        NSLog(@"central manager is powered on");
    } else if (central.state == CBCentralManagerStatePoweredOff ) {
        // respond to powered off
        NSLog(@"central manager is powered off");
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Did discover peripheral: %@", peripheral.name);
    [centralManager stopScan];
    [self connectPeripheral:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if ([currentPeripheral.peripheral isEqual:peripheral]) {
        if (peripheral.services) {
            NSLog(@"Did connect to existing peripheral: %@", peripheral.name);
            [currentPeripheral peripheral:peripheral didDiscoverServices:nil];
        } else {
            NSLog(@"Did connect to peripheral: %@", peripheral.name);
            [currentPeripheral didConnect];
        }
    }
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral: %@", peripheral.name);
    
    // respond to disconnected
    [self disconnectPeripheral:peripheral];
    if ([currentPeripheral.peripheral isEqual:peripheral]) {
        [currentPeripheral didDisconnect];
    }
    
    [self scanForPeripherals];
}

#pragma mark - UARTPeripheralDelegate

// Once hardware revision string is read, connection to Bluefruit is complete
- (void)didReadHardwareRevisionString:(NSString *)string
{
    NSLog(@"HW Revision: %@", string);
}

// Data incoming from UART peripheral
- (void)didReceiveData:(NSData *)newData
{
    if (_connectionStatus == ConnectionStatusConnected || _connectionStatus == ConnectionStatusScanning) {
        NSLog(@"data: %@", [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding]);
    }
}

- (void)uartDidEncounterError:(NSString *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}

@end
