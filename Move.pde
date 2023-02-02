enum Coord {
  x, y, z
};

class Move {
  Coord coord;    // Coord of the edge of turn
  int layer;      // Layer of the turn
  float angle;    // Angle of the animation of the turn
  int dir;        // Direction of the move
  float speed;    // Speed of the turn

  boolean finished;   // The move has finished

  // Move constructor
  Move(Coord coord, int layer, int dir, float moveSpeed) {
    this.coord=coord;
    this.layer = layer;
    this.dir = dir;
    angle = 0;
    speed = moveSpeed;
    finished = false;
  }

  void updateAngle() {
    if (!finished) {
      angle += dir*speed;
      if (abs(angle) > HALF_PI) {
        angle = 0;
        finished = true;
      }
    }
  }
  
  boolean isFinished() {
    return finished;
  }
  
  /*****  Getters  *****/
  int getDir() {
    return dir;
  }

  float getAngle() {
    return angle;
  }

  Coord getCoord() {
    return coord;
  }
}
