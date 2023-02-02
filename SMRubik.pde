/* Thanks to The Coding Train for motivating this project */

import peasy.*;

PeasyCam cam;

Cube cube;             // The Rubik's Cube

char[] solAlg;         // The algorithm to solve the cube 

int cMove;             // Index of the current move in solAlg

// Images of the HUD
PImage hugImgU, hugImgD, hugImgR, hugImgL, hugImgF, hugImgB;

// SetUp cam and creating the cube
void setup() {
  size(500, 600, P3D);
  surface.setLocation(440, 50);  // Window shows in "the middle" of the screen
  cam = new PeasyCam(this, 450);
  cube = new Cube(1, 0.05);
  hugImgU = loadImage("images/U.png");
  hugImgL = loadImage("images/L.png");
  hugImgF = loadImage("images/F.png");
  hugImgR = loadImage("images/R.png");
  hugImgB = loadImage("images/B.png");
  hugImgD = loadImage("images/D.png");
  PFont font = createFont("fonts/font.ttf", 128);
  textFont(font);
}

// If key is pressed, it applies the action
void keyPressed() {
  switch(keyCode) {
    case UP: cam.reset(); break;
    case DOWN: cam.rotateX(PI/4); break;
    case ENTER: solAlg = null; scrambleCube(cube); break;
    case RIGHT: 
      if (solAlg != null && cMove < solAlg.length) {
        applyKey(solAlg[cMove], cube);    // Controls function
        cMove++;
      }
      break;
    case LEFT:
      if (solAlg != null && cMove > 0) {
        cMove--;
        applyKey(oppMove(solAlg[cMove]), cube);    // Controls function
      }
      break;
    case ' ': 
      if (solAlg == null) {;
        String solMoves = cube.solveCube();
        if (solMoves != null) {
          solAlg = solMoves.toCharArray();
          cMove = 0;
        }
      } else {
        applyAlgorithm(subset(solAlg, cMove), cube);  // Controls function
        solAlg = null;
      }
      break;
    default:
      solAlg = null;
      applyKey(key, cube);    // Controls function
  }
}

// Draw function
void draw() {
  background(30);
  rotateX(-0.45);
  rotateY(-0.7);
  scale(50); 
  cube.show();
  // Images in Centers
  imageMode(CENTER);
  pushMatrix(); translate(0, -1.51, 0);  rotateX(HALF_PI);
  image(hugImgU, 0, 0, 0.5, 0.5); popMatrix();
  pushMatrix(); translate(-1.51, 0, 0);  rotateY(-HALF_PI);
  image(hugImgL, 0, 0, 0.5, 0.5); popMatrix();
  pushMatrix(); translate(0, 0, 1.51);
  image(hugImgF, 0, 0, 0.5, 0.5); popMatrix();
  pushMatrix(); translate(1.51, 0, 0);  rotateY(HALF_PI);
  image(hugImgR, 0, 0, 0.5, 0.5); popMatrix();
  pushMatrix(); translate(0, 0, -1.51);  rotateY(PI);
  image(hugImgB, 0, 0, 0.5, 0.5); popMatrix();
  pushMatrix(); translate(0, 1.51, 0);  rotateX(-HALF_PI);
  image(hugImgD, 0, 0, 0.5, 0.5); popMatrix();
  // Draw the HUD
  cam.beginHUD();
  textSize(22);
  text("Use the keyboard keys to rotate each face", 90, 25);
  text(" (Lowercase letters to rotate counter-clockwise)", 60, 50);
  if (cube.isSolved()) {
    textSize(42);
    text("Solved!",  360, 535);
  } else {
      if (solAlg != null) {
        textSize(20);
        textSize(map(textWidth(String.valueOf(solAlg)), 0, width-20, 50, 10));
        text("Solution: " + String.valueOf(solAlg), 10, 585);
        textSize(25); 
        text("[<] & [>] for prev or next move", 210, 500); 
        text("[SPACE]  to autosolve the cube", 210, 530); 
      } else if (!cube.isMoving()) { 
        textSize(25); 
        text("[SPACE] to search for the solution", 172, 530); 
      }
  }
  cam.endHUD();
}
