/** 
 Assignment 6
 Author:          Bao Yuchen
 Student Number:  103254021
 Update:          2015/12/14
 */

final int MOUSE_LEFT = 37, MOUSE_RIGHT = 39, MOUSE_MID = 3;

private ResourcesManager resourcesManager = null;

private GamePlayScene gameMain = null;

void setup () {
  size(640, 480) ;
  resourcesManager = new ResourcesManager();
  gameMain = new GamePlayScene();
}

void draw() {
  gameMain.drawFrame();
}

void mouseMoved() {
  gameMain.mouseMovedFun(mouseX, mouseY);
}

void mousePressed() {
  gameMain.mousePressedFun(mouseButton);
}

void mouseReleased() {
  gameMain.mouseReleasedFun(mouseButton);
}

void keyPressed() {
  gameMain.keyPressedFun(keyCode);
}

void keyReleased() {
  gameMain.keyReleasedFun(keyCode);
}
