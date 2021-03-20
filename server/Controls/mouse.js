var robot = require("robotjs");

function mouseMovement(x, y) {
  let mouse = robot.getMousePos();

  robot.moveMouseSmooth(mouse.x + x, mouse.y + y);
}

function mouseClick(button) {
  robot.mouseClick(button, false);
}

function typeOnscreen(text) {
  robot.typeString(text);
}

function typeKey(key, moddifier){

  if(moddifier != ''){
    robot.keyTap(key,moddifier);
  }else{
    robot.keyTap(key);
  }

  console.log('KEY PRESSED',key);

}

module.exports = {
  mouseMovement,
  mouseClick,
  typeOnscreen,
  typeKey,
};
