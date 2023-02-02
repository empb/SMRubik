// Function which matches available keys with moves
// minus clockwise, MAYUS -> COUNTERCLOCKWISE
void applyKey(char pKey, Cube cube) {
  switch (pKey) {
    // Simples moves
    case 'u': cube.applyMove(Coord.y, -1, -1); break;
    case 'U': cube.applyMove(Coord.y, -1, 1); break;
    case 'd': cube.applyMove(Coord.y, 1, 1); break;
    case 'D': cube.applyMove(Coord.y, 1, -1); break;
    case 'l': cube.applyMove(Coord.x, -1, 1); break;
    case 'L': cube.applyMove(Coord.x, -1, -1); break;
    case 'r': cube.applyMove(Coord.x, 1, -1); break;
    case 'R': cube.applyMove(Coord.x, 1, 1); break;
    case 'f': cube.applyMove(Coord.z, 1, -1); break;
    case 'F': cube.applyMove(Coord.z, 1, 1); break;
    case 'b': cube.applyMove(Coord.z, -1, 1); break;
    case 'B': cube.applyMove(Coord.z, -1, -1); break;
  }
}

// Applies rubik algorithm
void applyAlgorithm(char[] algorithm, Cube cube) {
  for (char move : algorithm) {
    applyKey(move, cube);
  }
}

// Scrambles rubiks cube
void scrambleCube(Cube cube) {
  cube.setSpeed(0.3);    // Fast moves to scramble
  int maxmoves = 40;
  char[] posMoves = {'U', 'u', 'L', 'l', 'F', 'f', 'R', 'r', 'B', 'b', 'D', 'd'};
  char[] randomMoves = new char[maxmoves];
  int index; char lastMove = ' ';
  for (int i = 0; i < maxmoves; i++) {
    do {
      index = int(random(posMoves.length));
    } while (posMoves[index] == oppMove(lastMove));
    randomMoves[i] = posMoves[index];
    lastMove = posMoves[index];
  }
  for (char move : randomMoves) {
    applyKey(move, cube);
  }
  cube.setSpeed(0.05);    // Normal speed
}

// Returns the same move but in the opposite clockwise 
// or counterclockwise direction
char oppMove(char move) {
  if (Character.isUpperCase(move)) return Character.toLowerCase(move);
  else return Character.toUpperCase(move);
}
