import numpy as np
import matplotlib.pyplot as plt

# Define the matrix A
A = np.array([[0, 4, 3], [0, 20, 16], [0, -25, -20]])

# Extract row vectors from the matrix A
vectors = A.T  # Transpose to get row vectors

# Create a quiver plot in 3D
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

ax.quiver(0, 0, 0, vectors[0, 0], vectors[0, 1], vectors[0, 2], color='r', label='Row 1')
ax.quiver(0, 0, 0, vectors[1, 0], vectors[1, 1], vectors[1, 2], color='g', label='Row 2')
ax.quiver(0, 0, 0, vectors[2, 0], vectors[2, 1], vectors[2, 2], color='b', label='Row 3')

# Set axis labels and a title
ax.set_xlabel('X-axis')
ax.set_ylabel('Y-axis')
ax.set_zlabel('Z-axis')
ax.set_title('Vector Diagram for Rows of Matrix A')

# Add a legend
ax.legend()

plt.show()
