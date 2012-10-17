SocketController
================

SocketController is a collection of software - an iPhone app, a node.js server, and an example client - which works together
to pass motion events from an iPhone through to a client registered to receive those events. It uses node.js and socket connections
to pass the events in as close to realtime as possible.

Installation
------------
*iPhone app*

Located under iphone/Controller is an .xcodeproj file which you can use with xcode to install the iPhone app.
You will want to open controllerViewController.m and change the value for the node ip from 10.0.1.62 to wherever you are running
your node server from.

*Node server*
* Have node and npm already installed
* Open server.js and change the host variable from 10.0.1.62 to the ip where the server is being hosted.
* `npm install`
* `node server.js`

*Example client*
* Open web browser
* Navigate to http://*node server ip*/example.html