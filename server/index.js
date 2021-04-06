const app = require("express")();
const http = require("http").Server(app);
const io = require("socket.io")(http);
const mouseApi = require("./Controls/mouse");

app.get("/", (req, res) => {
  res.sendFile(__dirname + "/index.html");
});

http.listen(1978, () => {
  console.log("listening on *:1978");
});

io.on("connection", (socket) => {
  console.log("Socket conectado, id:", socket.id);

  socket.on("moveMouse", (obj) => {
    console.log("Coordenadas:", obj);
    let x = parseInt(obj.x) * 2; 
    let y = parseInt(obj.y) * 2;
    mouseApi.mouseMovement(x, y);
  });

  socket.on("clickMouse", (obj) => {
    console.log("Coordenadas:", obj);
    let button = obj.button;
    mouseApi.mouseClick(button);
  });

  socket.on("typeKey", (obj) => {
    let key = obj.key;
    let moddifier = obj.moddifier;
    console.log("KEY PRESSED", key);
    mouseApi.typeKey(key, moddifier);
  });

  socket.on("typeOnScreen", (obj) => {
    console.log("string:", obj);
    let text = obj.text;
    mouseApi.typeOnscreen(text);
  });
});
