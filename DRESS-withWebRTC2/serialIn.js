
var SerialPort = require('serialport'),			// include the serialport library
	portName =  process.argv[2],								// get the port name from the command line
	portConfig = {
		baudRate: 9600,
		// call myPort.on('data') when a newline is received:
		parser: SerialPort.parsers.readline('\r\n')
	};

// open the serial port:
var myPort = new SerialPort(portName, portConfig);

myPort.on('open', openPort);			// called when the serial port opens
myPort.on('close', closePort);		// called when the serial port closes
myPort.on('error', serialError);	// called when there's an error with the serial port
myPort.on('data', listen);				// called when there's new incoming serial data

function openPort() {
	console.log('port open');
	console.log('baud rate: ' + myPort.options.baudRate);
}

function closePort() {
	console.log('port closed');
}

function serialError(error) {
	console.log('there was an error with the serial port: ' + error);
	myPort.close();
}

function listen(data) {
	console.log(data);
	myPort.write('x');
}
