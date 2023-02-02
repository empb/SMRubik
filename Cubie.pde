class Cubie {
  PMatrix3D matrix;    // Describes the position transformation of the center of the cubie
  float len;

  ArrayList<Face> faces;
  
  PVector initial_pos;    // For checking if cubie is in the right place

  /* Constructor of the Cubie
   (x, y, z) is the position in the space
   len is the length of the side of the cubie
   */
  Cubie(float x, float y, float z, float len) {
    PMatrix3D m = new PMatrix3D();
    m.translate(x, y, z);
    matrix = m;
    this.len = len;
    initial_pos = new PVector(x, y, z);

    // Faces colors
    faces = new ArrayList<Face>();
    if (x==1)  faces.add(new Face(new PVector(1, 0, 0), "g"));     // RIGHT
    else faces.add(new Face(new PVector(1, 0, 0), ""));
    if (x==-1) faces.add(new Face(new PVector(-1, 0, 0), "b"));    // LEFT
    else faces.add(new Face(new PVector(-1, 0, 0), ""));
    if (z==1)  faces.add(new Face(new PVector(0, 0, 1), "r"));     // FRONT
    else faces.add(new Face(new PVector(0, 0, 1), ""));
    if (z==-1) faces.add(new Face(new PVector(0, 0, -1), "o"));  // BACK
    else faces.add(new Face(new PVector(0, 0, -1), ""));
    if (y==1)  faces.add(new Face(new PVector(0, 1, 0), "w")); // DOWN
    else faces.add(new Face(new PVector(0, 1, 0), ""));
    if (y==-1) faces.add(new Face(new PVector(0, -1, 0), "y"));  // UP
    else faces.add(new Face(new PVector(0, -1, 0), ""));
  }

  // Applies a rotation in the "cord" axis
  // "dir" indicates the direction of the turn
  void applyMove(Coord coord, int dir) {
    PMatrix2D layerMatrix = new PMatrix2D();    // Initalization of 2D matrix of the layer
    layerMatrix.rotate(dir*HALF_PI);              // Rotate pi/2 (or -pi/2)

    // Update of the cubie with the new positios
    float aux;
    if (coord == Coord.x) {
      layerMatrix.translate(this.getY(), this.getZ()); // Apply transformation
      // Update the cubie position
      aux = this.getX();
      matrix.reset();
      matrix.translate(aux, round(layerMatrix.m02), round(layerMatrix.m12));
    } else if (coord == Coord.y) {
      layerMatrix.translate(this.getX(), this.getZ());  // Apply transformation
      // Update the cubie position
      aux = this.getY();
      matrix.reset();
      matrix.translate(round(layerMatrix.m02), aux, round(layerMatrix.m12));
    } else {
      layerMatrix.translate(this.getX(), this.getY());  // Apply transformation
      // Update the cubie position
      aux = this.getZ();
      matrix.reset();
      matrix.translate(round(layerMatrix.m02), round(layerMatrix.m12), aux);
    }

    // Turn the faces
    for (Face f : faces) {
      f.turnFace(coord, dir);
    }
  }
  
  // Check is cubie is positoned and orientated
  boolean isInPlace() {
    // Centers are always in place
    if (this.isCenter()) return true;
    // This checks position of the cubie
    if (this.getX() == initial_pos.x && this.getY() == initial_pos.y 
      && this.getZ() == initial_pos.z) {
      // This checks orientation of the cubie
      PVector normalRedFace = faces.get(0).getNormal();
      // The normal vector of this face must be (1, 0, 0)
      return ((normalRedFace.x==1) && (normalRedFace.y==0) 
               && (normalRedFace.z==0));
    }
    return false;
  }
  
  // Check is cubie is a center
  boolean isCenter() {
    int cont = 0;
    if (this.getX() == 0) cont++;
    if (this.getY() == 0) cont++;
    if (this.getZ() == 0) cont++;
    return cont >= 2;
  }

  /***** Show function  *****/
  void show() {
    noFill();
    stroke(0);
    strokeWeight(0.1);
    pushMatrix();
    applyMatrix(matrix);
    box(len);
    for (Face f : faces) {
      f.show();
    }
    popMatrix();
  }
  

  /*****  Getters  *****/
  
  float getZ() {
    return matrix.m23;
  }

  float getY() {
    return matrix.m13;
  }

  float getX() {
    return matrix.m03;
  }
  
  ArrayList<Face> getFaces() {
    return faces;
  }

  /**
   * Each coordinate in {x, y, z} matches with {0, 1, 2} values
   * Other value returns the value of z coordinate
   */
  float getValueOfCoord(Coord coord) {
    if (coord == Coord.x) return this.getX();
    else if (coord == Coord.y) return this.getY();
    else return this.getZ();
  }
}
