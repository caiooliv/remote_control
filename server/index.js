const app = require("express")();
const http = require("http").Server(app);
const io = require("socket.io")(http);
const mouseApi = require("./Controls/mouse");

var robot = require("robotjs");

app.get("/", (req, res) => {
  res.sendFile(__dirname + "/index.html");
});

http.listen(3000, () => {
  console.log("listening on *:3000");
});

io.on("connection", (socket) => {
  console.log("Socket conectado, id:", socket.id);

  socket.on("moveMouse", (obj) => {
    console.log(obj);
    mouseApi.mouseMovement(obj.x, obj.y);
    mouseApi.mouseClick("right");
  });
});
