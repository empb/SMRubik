import sys
from rubik_solver import utils
import numpy as np
import re

# Cube string from Processing program
scube = sys.argv[1]

## We have to convert the cube string format of the Processing program to 
## the format that the rubik_solver works on.
# Split the string in the 6 faces
facesString = [ scube[i:i+9] for i in range(0, 54, 9) ]
# Convert the strings into matrixes
facesMatrix = []
for f in facesString:
	m = np.array([[f[c+r*3] for c in range(3)] for r in range(3)])
	facesMatrix.append(m)

# Transform the matrixes
newFacesMatrix = []
# UP face has to be transposed
newFacesMatrix.append(facesMatrix[0].transpose())
# Left face is OK
newFacesMatrix.append(facesMatrix[1])
# Front face has to be transposed
newFacesMatrix.append(facesMatrix[2].transpose())
# Right face has to permute columns 1 and 3
facesMatrix[3][:,[0, 2]] = facesMatrix[3][:,[2, 0]]
newFacesMatrix.append(facesMatrix[3])
# Back face has to be transposed and the permute columns 1 and 3
maux = facesMatrix[4].transpose()
maux[:,[0, 2]] = maux[:,[2, 0]]
newFacesMatrix.append(maux)
# Down face has to permute columns 1 and 3 and then transpose
facesMatrix[5][:,[0, 2]] = facesMatrix[5][:,[2, 0]]
newFacesMatrix.append(facesMatrix[5].transpose())

# Convert the matrixes into strings
snewCube = ""
for nm in newFacesMatrix:
	rows = ["".join(r) for r in  nm]
	snewCube += "".join(rows)

## Solve the cube with the library and print result
moves = utils.solve(snewCube, 'Kociemba')
moves = str(moves)
# Remove the brackets, spaces and ,
moves = moves.replace("[", "")
moves = moves.replace("]", "")
moves = moves.replace(" ", "")
moves = moves.replace(",", "")
# Moves with prima 
matches = re.findall(r"\w'", moves)
for match in matches:
    moves = moves.replace(match, match[0].lower())
# Double moves 
matches = re.findall(r"\w2", moves)
for match in matches:
    moves = moves.replace(match, match[0]+match[0])
print(moves)




