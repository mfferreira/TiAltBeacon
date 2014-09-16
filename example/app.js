// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

if (Ti.Platform.name == "android") {
	Ti.API.warn("This module is only for iOS");
}
else {
	// load the module
	var altbeacon = require('co.altitude.altbeacon');
	Ti.API.info("module is => " + altbeacon);

	// set our beacon id
	altbeacon.initialize "45E30186-1BDF-4333-B0A6-0C994CC3B890"

	// configure the module - this is optional
	altbeacon.configure
		debugCentral: true 				// default: false
		debugPeripheral: true 			// default: false
		debugProximity: true 			// default: false
		updateInterval: 1.0 			// default: 1.0
		processPeripheralInterval: 2.0 	// default: 2.0
		restartScanInterval: 3.0 		// default: 3.0
		// service: <UUID>				// default: "2F234454-CF6D-A40F-ADF2-F4911BA9FFA6"
		// characteristic: <UUID>		// default: "A05F9DF4-9D54-4600-9224-983B75B9D154"

	// start beacon - will broacast and discover other beacons
	altbeacon.startBeacon()
}
