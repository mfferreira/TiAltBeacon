AltBeacon for Appcelerator Titanium
===================================
---

This module will enable your iOS app to use [AtlBeacon](http://altbeacon.org/), an open alternative to [iBeacon](https://developer.apple.com/ibeacon/).

Note that this beacon spec doesn't integrate with iOS as good as iBeacon. In other words, it won't work if your app is not running (foreground or background)

This module code is based [CharruaLab/AltBeacon](https://github.com/CharruaLab/AltBeacon).

# <a name="add">Add Module</a>
---

    <modules>
        <module platform="iphone">co.altitude.altbeacon</module>
    </modules>


# <a name="usage">Basic Example</a>
---

	var altbeacon = require('co.altitude.altbeacon');
	
	altbeacon.initialize("079106D1-D6CC-442A-8D1D-E7A89599786B");
	altbeacon.configure({
		debugCentral: true,
		debugPeripheral: true,
		debugProximity: true
	});
		
	altbeacon.addEventListener('foundDevice', function(e){
	    Ti.API.debug("Device '+"e.device"+' is in range: "+ e.range);
	});

	altbeacon.addEventListener('lostDevice', function(e){
	    Ti.API.debug("Device '+"e.device"+' is out of range");
	});

	altbeacon.startBroadcasting();
	altbeacon.startDetecting();


# <a name="reference">Reference</a>
---

## altbeacon.initialize(uuid)

Initialize the beacon with the specified UUID.

#### Parameters
* **uuid**: this will be your beacon UUID

#### Returns
* null

## altbeacon.configure(options)

Configure the beacon and debug options.

#### Parameters
* options
    * **debugCentral**: Boolean
    * **debugPeripheral**: Boolean
    * **debugProximity**: Boolean
    * **updateInterval**: Float
    * **processPeripheralInterval**: Float
    * **restartScanInterval**: Float
    * **service**: UUID
    * **characteristic**: UUID

#### Returns
* null
 
## altbeacon.startBroadcasting()

Start broadcasting the beacon.

#### Returns
* null

## altbeacon.startDetecting()

Start broadcasting the beacon.

#### Returns
* null

## altbeacon.startBeacon()

Shortcut that will call startBroadcasting() and startDetecting().

#### Returns
* null

## altbeacon.stopBroadcasting()

Stop broadcasting the beacon.

#### Returns
* null

## altbeacon.stopDetecting()

Stop broadcasting the beacon.

#### Returns
* null

## altbeacon.stopBeacon()

Shortcut that will call stopBroadcasting() and stopDetecting().

#### Returns
* null


## Events

### `foundDevices`

A list with all devices found. Will be fired for every scan if any devices are found.

#### Returns

    {
        devices: [{<device_uuid>: <range>}]
    }


### `foundDevice`

Will be fired every time a device is in range

#### Returns

    {
        device: <uuid>,
        range: [0-3]
    }


### `lostDevice`

Will be fired every time a device is in range

#### Returns

    {
        device: <uuid>
    }


# <a name="license">License</a>
---

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


# <a name="copyright">Copyright</a>
---

Copyright (c) 2014 Marco Ferreira

Cheers!
