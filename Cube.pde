import java.util.Map;

class Cube {
  int dim;            // Dimension of the cube
  Cubie[] cubies;     // Collection of cubies (pieces of the cube)

  float moveSpeed;
  ArrayList<Move> moves;
  
  boolean solved;     // True if cube is solved

  // Cube constructor
  Cube(int cubieLen, float moveSpeed) {
    dim = 3;   // At this moment it only works for 3x3x3 cubes
    solved = true;
    cubies = new Cubie[dim*dim*dim];
    this.moveSpeed = moveSpeed;
    moves = new ArrayList<Move>();
    int index = 0;
    for (int x=-1; x<=1; x++) {      // This construction method just works with 3x3 cubes
      for (int y=-1; y<=1; y++) {
        for (int z=-1; z<=1; z++) {
          cubies[index] = new Cubie(x, y, z, cubieLen);  // Cubes have len=1
          index++;
        }
      }
    }
  }

  /* ROTATION FUNCTION
   * Each coordinate has associated three layers of the cube.
   * Layers are labeled from -1 to 1.
   */
  /* This function turns the layer numbered "layer" associated with the
   * "cord" coordinate. Param "dir" indicates the sense of the rotation
   * Cordinates {x, y, z} matches with {0, 1, 2} values
   */
  void applyMove(Coord coord, int layer, int dir) {
    Move newMove = new Move(coord, layer, dir, moveSpeed);
    moves.add(newMove);
  }

  /***** Show function  *****/
  void show() {
    // Update the angle and check if cube is moving
    if (!moves.isEmpty()) {
      if (moves.get(0).isFinished()) {
        moves.remove(0);
        updateSolved();
      } else {
        moves.get(0).updateAngle();
      }
    }
    // Move the cube
    Coord moveCoord;
    Move currentMove;
    for (Cubie qb : cubies) {
      push();
      if (!moves.isEmpty() && qb.getValueOfCoord(moves.get(0).getCoord()) == moves.get(0).layer) {
        currentMove = moves.get(0);
        moveCoord = currentMove.getCoord();
        // Rotation
        if (moveCoord == Coord.x) {
          rotateX(currentMove.angle);
        } else if (moveCoord == Coord.y) {
          rotateY(-currentMove.angle);    // y rotation is flipped
        } else {
          rotateZ(currentMove.angle);
        }
        if (currentMove.isFinished()) {
          // Update the cubies if the moved has finished
          qb.applyMove(moveCoord, currentMove.getDir());
        }
      }
      qb.show();
      pop();
    }
  }
  
  // Return true if cube is solved
  void updateSolved() {
    for (Cubie qb : cubies) {
     if (!qb.isInPlace()) {
       solved = false;
       return;
      }
    }
    solved = true;
  }
  
  // Returns a string of the moves to solve the cube
  // Uses Python script solveCube.py which uses https://pypi.org/project/rubik-solver
  String solveCube() {
    if (this.isMoving() || this.isSolved()) return null;  // If cube is moving or solved, return
    // Get the string of the cube
    String scube = cube.cubeToString();
    StringList stdoutt = new StringList(), stderrr = new StringList();
    int r = exec(stdoutt, stderrr, "python3.8", sketchPath()+"/python/solveCube.py", scube);
    if (r != 0) {
      println("Error while calling solveCube.py");
      return null;
    }
    if (stderrr.size() != 0) {
      println("Errors while solving the cube:");
      println(stderrr);
      return null;
    }
    return stdoutt.get(0);
  }
  
  // Scans the cube with the camera as input. Returns a string of the moves to solve the cube.
  // Uses Python script scanCube.py
  String scanCube() {
    if (this.isMoving()) return null;  // If cube is moving, return
    StringList stdoutt = new StringList(), stderrr = new StringList();
    int r = exec(stdoutt, stderrr, "python3.8", sketchPath()+"/python/scanCube.py", 
                "--model=" + sketchPath() + "/python/models/model1.png");
    if (r != 0) {
      println("Error while calling scanCube.py:"); 
      println(stderrr);
      println(stdoutt);
      return null;
    }
    if (stderrr.size() != 0) {
      println("Errors while solving the cube:");
      println(stderrr);
      return null;
    }
    if (stdoutt.size() > 1) {
      String solutionAlg = stdoutt.get(stdoutt.size() - 1);
      if (solutionAlg.equals("Scan error") 
        || solutionAlg.equals("Program terminated")) return null;
      // To take the cube to this state, we solve it and then
      // we apply this alogrithm in inverse order
      if (!this.isSolved()) {
        String currentSol = cube.solveCube();
        applyAlgorithm(currentSol.toCharArray(), cube, 0.4);
      }
      applyBackwardsAlgorithm(solutionAlg.toCharArray(), this, 0.4);
      return solutionAlg;
    } else return null;
  }
  
  // Generates a string of the faces of the rubiks cube
  String cubeToString() {
    // HasMap of all the cube Faces. Key = Normal vector of the face.
    // Value = Arraylist of the 9 cubie faces
    HashMap<String, ArrayList<Face>> hmCube = new HashMap<String, ArrayList<Face>>();
    Cubie qb;
    ArrayList<Face> currentFace;
    for (int x=-1; x<=1; x++) {
      for (int y=-1; y<=1; y++) {
        for (int z=-1; z<=1; z++) {
          qb = this.getCubieInPos(x, y, z);
          for (Face f : qb.getFaces()) {
            if (f.getColor() != "") {
              currentFace = hmCube.get(f.getNormalStr());
              if (currentFace == null) {
                currentFace = new ArrayList<Face>();
                hmCube.put(f.getNormalStr(), currentFace);
              }
              currentFace.add(f);
            }
          }
        }
      }
    }
    String rightFace, leftFace, downFace, upFace, frontFace, backFace;
    rightFace = facesToString(hmCube.get("1, 0, 0"));
    leftFace  = facesToString(hmCube.get("-1, 0, 0"));
    downFace  = facesToString(hmCube.get("0, 1, 0"));
    upFace    = facesToString(hmCube.get("0, -1, 0"));
    frontFace = facesToString(hmCube.get("0, 0, 1"));
    backFace  = facesToString(hmCube.get("0, 0, -1"));
    return upFace+leftFace+frontFace+rightFace+backFace+downFace;
  }
  
  // Auxiliar method of the function cubeToString
  String facesToString(ArrayList<Face> faces) {
    String str = "";
    for (Face f : faces) {
      str += f.getColor();
    }
    return str;
  }
  
  // Returns the cubie which is in position (x, y, z)
  Cubie getCubieInPos(int x, int y, int z) {
    for (Cubie qb : cubies) {
      if (qb.getX() == x && qb.getY() == y && qb.getZ() == z) {
        return qb;
      }
    }
    return null;
  }

  /*****  Getters and setters  *****/
  int getDim() {
    return dim;
  }

  Cubie[] getCubies() {
    return cubies;
  }
  
  boolean isSolved() {
     return solved; 
  }
  
  boolean isMoving() {
    return !moves.isEmpty(); 
  }
  
  float getSpeed() {
    return moveSpeed;
  }
  
  void setSpeed(float speed) {
    moveSpeed = speed;
  }
}
