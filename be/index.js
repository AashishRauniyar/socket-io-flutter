// import express from 'express';
// import http from 'http';
// import { Server } from 'socket.io';
// import cors from 'cors';


// const app = express();
// const server = http.createServer(app);
// app.use(cors());
// app.use(express.json());
// const io = new Server(server);


// // Serve a basic API endpoint for testing
// app.get('/', (req, res) => {

//     res.send('Socket.IO server is running!');

// });

// app.post('/api/send-message', (req, res) => {

//     const { message } = req.body;
//     console.log('Received message: ' + message);

//     io.emit('server_message', message); // Send the message to all connected clients
//     res.send('Message sent to client');

// });

// io.on('connection', (socket) => {
//     console.log('A user connected');

//     socket.on('chat_message', (msg) => {
//         console.log('Received message: ' + msg);
//         io.emit('chat_message', msg); // Send the message to all connected clients
//     });

//     socket.on('server_message', (msg) => {
//         console.log('Received server message: ' + msg);
//         socket.emit('server_message', msg); // Send the message back to the client
//     });

//     socket.on('disconnect', () => {
//         console.log('A user disconnected');
//     });
// });





// const PORT = 5000;
// server.listen(PORT, () => {
//     console.log(`Server running on port ${PORT}`);
// });



//? Testing a room

// import express from 'express';
// import http from 'http';
// import { Server } from 'socket.io';
// import cors from 'cors';

// const app = express();
// const server = http.createServer(app);
// app.use(cors());
// app.use(express.json());
// const io = new Server(server);

// app.get('/', (req, res) => {
//     res.send('Socket.IO server is running!');
// });

// // Room creation and joining endpoints
// app.post('/api/create-room', (req, res) => {
//     const roomName = req.body.roomName;
//     console.log(`Room created: ${roomName}`);
//     res.send('Room created');
// });

// io.on('connection', (socket) => {
//     console.log('A user connected');

//     // Join room
//     socket.on('join_room', (roomName) => {
//         socket.join(roomName);
//         console.log(`User joined room: ${roomName}`);
//         socket.emit('room_message', `Welcome to room: ${roomName}`);
//     });

//     // Create room
//     socket.on('create_room', (roomName) => {
//         socket.join(roomName);
//         console.log(`Room created and user joined: ${roomName}`);
//         socket.emit('room_message', `Room created: ${roomName}`);
//     });

//     // Send message to room
//     socket.on('send_message', (data) => {
//         const { room, message } = data;
//         console.log(`Message from room ${room}: ${message}`);
//         io.to(room).emit('receive_message', message);
//     });

//     socket.on('disconnect', () => {
//         console.log('A user disconnected');
//     });
// });

// const PORT = 5000;
// server.listen(PORT, () => {
//     console.log(`Server running on port ${PORT}`);
// });


//?? proper room
import express from 'express';
import http from 'http';
import { Server } from 'socket.io';

const app = express();
const server = http.createServer(app);
const io = new Server(server);

const PORT = process.env.PORT || 5000;

// Room data: a map to store rooms and their members
let rooms = {};

app.get('/', (req, res) => {
    res.send('Socket.IO Server is running');
});

io.on('connection', (socket) => {
    console.log('A user connected');

    // When a user creates a room
    socket.on('create_room', ({ room, username }) => {
        if (!rooms[room]) {
            rooms[room] = [];
            console.log(`Room created: ${room}`);
        }

        // Add the user to the room
        rooms[room].push(username);
        socket.join(room);
        console.log(`${username} joined the room: ${room}`);

        // Emit room creation to all users
        io.emit('room_created', room);
    });

    // When a user joins an existing room
    socket.on('join_room', ({ room, username }) => {
        if (rooms[room]) {
            rooms[room].push(username);
            socket.join(room);
            console.log(`${username} joined room: ${room}`);

            // Notify the room of the new user
            io.to(room).emit('room_message', `${username} has joined the room.`);
        } else {
            socket.emit('room_message', `Room ${room} does not exist.`);
        }
    });

    // Handle sending a message to a room
    socket.on('send_message', ({ room, username, message }) => {
        if (rooms[room]) {
            io.to(room).emit('receive_message', { username, message });
            console.log(`Message from ${username} in room ${room}: ${message}`);
        } else {
            socket.emit('room_message', `Room ${room} does not exist.`);
        }
    });

    // Disconnect event
    socket.on('disconnect', () => {
        console.log('A user disconnected');
    });
});

// Start the server
server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
