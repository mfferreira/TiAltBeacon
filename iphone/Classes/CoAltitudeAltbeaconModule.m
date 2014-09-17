/**
 * AltBeacon
 *
 * Created by Marco Ferreira
 * Copyright (c) 2014 Altitude Co. All rights reserved.
 */

#import "CoAltitudeAltbeaconModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "CBUUID+Ext.h"

// contanst
// #define kUuidBeaconOne @"5F22CA05-8F6C-49B6-AEAE-B278FDFE9287"
#define kUuidBeaconOne @"2F234454-CF6D-A40F-ADF2-F4911BA9FFA6"


@implementation CoAltitudeAltbeaconModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"51776916-3136-460e-a9d1-cf869cc09aae";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"co.altitude.altbeacon";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
    _didStartAltBOne=NO;
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

#pragma mark Init

-(void)initialize:(id)name {
    ENSURE_SINGLE_ARG(name, NSString);
    _myID = [[NSString alloc] initWithString: name];;
    
    // Initialize the IBeacon UUDI@
    _beaconOne =  [[AltBeacon alloc ] initWithIdentifier:_myID];
    
    [_beaconOne addDelegate:self];
}

-(void)configure:(id)args {
    ENSURE_SINGLE_ARG(args, NSDictionary);

    if ([args objectForKey:@"debugCentral"])
        _beaconOne.debugCentral = [TiUtils boolValue:[args objectForKey:@"debugCentral"]];
    if ([args objectForKey:@"debugPeripheral"])
        _beaconOne.debugPeripheral = [TiUtils boolValue:[args objectForKey:@"debugPeripheral"]];
    if ([args objectForKey:@"debugProximity"])
        _beaconOne.debugProximity = [TiUtils boolValue:[args objectForKey:@"debugProximity"]];
    
    if ([args objectForKey:@"updateInterval"])
        _beaconOne.updateInterval = [TiUtils floatValue:[args objectForKey:@"updateInterval"]];
    if ([args objectForKey:@"processPeripheralInterval"])
        _beaconOne.processPeripheralInterval = [TiUtils floatValue:[args objectForKey:@"processPeripheralInterval"]];
    if ([args objectForKey:@"restartScanInterval"])
        _beaconOne.restartScanInterval = [TiUtils floatValue:[args objectForKey:@"restartScanInterval"]];
    
    if ([args objectForKey:@"service"])
        _beaconOne.altBeaconService = (NSString*)[args objectForKey:@"service"] ;
    if ([args objectForKey:@"characteristic"])
        _beaconOne.altBeaconCharacteristic = (NSString*)[args objectForKey:@"characteristic"] ;

    if (_beaconOne.debugCentral)
        NSLog(@"[INFO] configure %@",args);

}

#pragma mark Start

- (void)startBeacon:(id)arg {
    // start broadcasting
    [_beaconOne startBroadcasting];
    [_beaconOne startDetecting];
}

- (void)startBroadcasting:(id)arg {
    // start broadcasting
    [_beaconOne startBroadcasting];
}

- (void)startDetecting:(id)arg {
    // start detecting
    [_beaconOne startDetecting];
}

#pragma mark Stop

- (void)stopBeacon:(id)arg {
    // start broadcasting
    [_beaconOne stopBroadcasting];
    [_beaconOne stopDetecting];
}

- (void)stopBroadcasting:(id)arg {
    // stop broadcasting
    [_beaconOne stopBroadcasting];
}

- (void)stopDetecting:(id)arg {
    // stop detecting
    [_beaconOne stopDetecting];
}

#pragma mark Other

- (NSString*) convertToString:(NSNumber *)number {
    NSString *result = nil;
    
    switch(number.intValue) {
        case INDetectorRangeFar:
            result = @"Up to 100 meters";
            break;
        case INDetectorRangeNear:
            result = @"Up to 15 meters";
            break;
        case INDetectorRangeImmediate:
            result = @"Up to 5 meters";
            break;
            
        default:
            result = @"Unknown";
    }
    
    return result;
}

// Delegate methods
- (void)service:(AltBeacon *)service foundDevices:(NSMutableDictionary *)devices {
    
    // devices = {<device_id>: <range>}

    if (_beaconOne.debugProximity) {
        NSLog(@"foundDevices %@", devices);
    }
    
    // send found devices to Titanium land
    NSMutableDictionary* event = [TiUtils dictionaryWithCode:0 message:nil];
    [event setObject:devices forKey:@"devices"];
    [self fireEvent:@"foundDevices" withObject:event];
    
    // iterate over all found devices
    for(NSString *device in devices) {
    
        NSNumber * range = [devices objectForKey:device];

        if (range.intValue == INDetectorRangeUnknown) {
            
            NSLog(@"%@ %@", device, @"was lost");

            // send lost device to Titanium land
            NSMutableDictionary* event = [TiUtils dictionaryWithCode:0 message:nil];
            [event setObject:device forKey:@"device"];
            [self fireEvent:@"lostDevice" withObject:event];
            
        }
        
        else {
            
            NSString *result = [self convertToString:range];

            NSLog(@"%@ %@ %@ %@", device, @"was found", result, @"meters away");

            // send found device to Titanium land
            NSMutableDictionary* event = [TiUtils dictionaryWithCode:0 message:nil];
            [event setObject:device forKey:@"device"];
            [event setObject:range forKey:@"range"];
            [self fireEvent:@"foundDevice" withObject:event];

        }
    }
}


@end
