class Face {
  PVector normal;    // Normal vector of the face
  String scol;       // Color of the face in string format
                     // "y" for yellow, "b" for blue, "r" for red
                     // "g" for green, "o" for orange, "w" for white

  // Face constructor
  Face(PVector normal, String scol) {
    this.normal = normal;
    this.scol = scol;
  }

  // Applies a rotation in the "cord" axis
  // "dir" indicates the direction of the turn
  void turnFace(Coord coord, int dir) {
    // Use of matrix transformations for rotations
    PMatrix2D matrix = new PMatrix2D();
    matrix.rotate(HALF_PI*dir);
    if (coord == Coord.x) {
      matrix.translate(normal.y, normal.z);       // Apply transformation
      // Update the normal vector
      normal.x = round(normal.x);
      normal.y = round(matrix.m02);
      normal.z = round(matrix.m12);
    } else if (coord == Coord.y) {
      matrix.translate(normal.x, normal.z);       // Apply transformation
      // Update the normal vector
      normal.x = round(matrix.m02);
      normal.y = round(normal.y);
      normal.z = round(matrix.m12);
    } else {
      matrix.translate(normal.x, normal.y);       // Apply transformation
      // Update the normal vector
      normal.x = round(matrix.m02);
      normal.y = round(matrix.m12);
      normal.z = round(normal.z);
    }
  }
  
  int stringToColor(String sscol) {
    switch(sscol) {
      case "y": return color(255, 243, 0); 
      case "b": return color(62, 50, 252);
      case "r": return color(241, 55, 1);
      case "g": return color(18, 211, 33);
      case "o": return color(255, 151, 0);
      case "w": return color(255, 255, 255);
    }
      return color(0);
  }
  
  /*****  Getters  *****/
  PVector getNormal() {
    return normal;
  }
  
  // Gets the normal vector as a String
  String getNormalStr() {
    return str(int(normal.x))+", "+str(int(normal.y))+", "+str(int(normal.z));
  }
  
  String getColor() {
    return scol;
  }

  /***** Show function  *****/
  void show() {
    pushMatrix();
    fill(stringToColor(this.scol));
    noStroke();
    rectMode(CENTER);
    translate(0.5*normal.x, 0.5*normal.y, 0.5*normal.z);
    if (abs(normal.x) > 0) {
      rotateY(HALF_PI);
    } else if (abs(normal.y) > 0) {
      rotateX(HALF_PI);
    }
    square(0, 0, 1);
    popMatrix();
  }
}
