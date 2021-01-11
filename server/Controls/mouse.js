var robot = require("robotjs");

function mouseMovement(x, y) {
  let mouse = robot.getMousePos();
  console.log(`entrou aqui`);

  robot.moveMouseSmooth(mouse.x + x, mouse.y + y);
}

function mouseClick(button) {
  robot.mouseClick(button, false);
}

module.exports = {
  mouseMovement,
  mouseClick,
};
