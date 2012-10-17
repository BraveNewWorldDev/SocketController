var http = require('http');
var net = require('net');
var connect = require('connect');
var static = require('node-static')
var socketIO = require('socket.io');

var ios_devices = {};
var host = '10.0.1.62';

var clientFiles = new static.Server('./client');
var httpServer = http.createServer(function(request, response) {
    request.addListener('end', function () {
        clientFiles.serve(request, response);
    });
});
httpServer.listen(2000);

var io = socketIO.listen(httpServer);
io.sockets.on('connection', function (socket) {
    socket.on('register', function(c){
        var device_id = JSON.parse(c).id;
        try{
            ios_devices[device_id].sockets.push(socket);
        } catch(err){
            ios_devices[device_id] = {sockets: [], normal: null};
            ios_devices[device_id].sockets.push(socket);
        }
    });
});

var server = net.createServer(function(c) {
    c.setEncoding();
    c.on('data', function(data){
        try{
            var data_obj = JSON.parse(data);
        } catch(err){
            return;
        }

        var device_id = data_obj.data.id;
        var device = null, normal = null;
        try {
            device = ios_devices[device_id];
            normal = device.normal;
        } catch(err){
            ios_devices[device_id] = {sockets: [], normal: data_obj.data};
            device = ios_devices[device_id];
            normal = data_obj.data;
        }

        if (data_obj.action == 'reset'){
            ios_devices[device_id].normal = data_obj.data;
        }
        else if (data_obj.action=='motion'){
            var roll, pitch, yaw;
            roll = data_obj.data.roll - normal.roll;
            yaw = data_obj.data.yaw - normal.yaw;
            pitch = data_obj.data.pitch - normal.pitch;
            if (roll < -Math.PI){
                roll += 2 * Math.PI;
            } else if (roll > Math.PI){
                roll -= 2 * Math.PI;
            }
            if (yaw < -Math.PI){
                yaw += 2 * Math.PI;
            } else if (yaw > Math.PI){
                yaw -= 2 * Math.PI;
            }
            if (pitch < -Math.PI){
                pitch += 2 * Math.PI;
            } else if (pitch > Math.PI){
                pitch -= 2 * Math.PI;
            }
            var response = {
                roll: roll,
                yaw: yaw,
                pitch: pitch,
                device_id: device_id
            }
            var socket_list = device.sockets;
            if (socket_list){
                for (var i=0; i<socket_list.length; i++){
                    socket_list[i].emit('motion', JSON.stringify(response));
                }
            }
        }
    });
});
server.listen(8124, host);