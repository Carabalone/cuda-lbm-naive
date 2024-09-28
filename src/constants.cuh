#ifndef CONSTANTS_H
#define CONSTANTS_H

#include <array>
#include <cmath>
#include <stdio.h>

// each lattice will have this structure with discrete velocities:
//  
//   6  2  5   
//    \ | /        
//   3- 0 -1
//    / | \     
//   7  4  8           

// grid info
#define NX 400
#define NY 50

// ------------------------- Simulation Parameters --------------------------
#define STEPS 10000

std::array<std::array<int, 9>, 2> C = {{
    {0, 1, 0, -1, 0, 1, -1, -1, 1},
    {0, 0, 1, 0, -1, 1, 1, -1, -1}
}};

std::array<float, 9> W = {
    4.0f/9.0f,                                      // Central
    1.0f/9.0f, 1.0f/9.0f, 1.0f/9.0f, 1.0f/9.0f,     // Axis aligned
    1.0f/36.0f, 1.0f/36.0f, 1.0f/36.0f, 1.0f/36.0f  // Diagonal
};

float CS = 1 / std::sqrt(3); // speed of sound in lattice units

float TAU = 0.55f; // not accurate but enough for this port

std::array<int, 9> oppositeIndices = {
  0, 3, 4, 1, 2, 7, 8, 5, 6
};

// ------------------------------- Boundary Conditions ----------------------

float u_inflow = 0.1;
float rho_inflow = 1.0;

// Cylinder parameters
int cylinderCenterX = NX / 4;
int cylinderCenterY = NY / 2;
int cylinderRadius  = NY / 9;
int cylinderRadiusSquared = cylinderRadius * cylinderRadius;

std::array<std::array<bool, NY>, NX> generateCylinderMask() {
    std::array<std::array<bool, NY>, NX> cylinderMask;
    for (auto& row : cylinderMask) {
        std::fill(row.begin(), row.end(), false);
    }

    for (int i=0; i < NX; i++) {
        for (int j=0; j < NY; j++) {
            auto dx = (cylinderCenterX - i);
            auto dy = (cylinderCenterY - j);

            if (dx * dx + dy * dy < cylinderRadiusSquared) {
                cylinderMask[i][j] = true;
            }
         }
    }

    return cylinderMask;
}

// --------------------------------------------------------------------------

void printSimulationParameters() {
    std::cout << "Simulation Parameters:" << std::endl;
    std::cout << "Grid size: NX = " << NX << ", NY = " << NY << std::endl;
    std::cout << "Steps: " << STEPS << std::endl;
    std::cout << "Relaxation time (TAU): " << TAU << std::endl;
    std::cout << "Speed of sound (CS): " << CS << std::endl;
    
    std::cout << "Velocity vectors (C):" << std::endl;
    for (int i = 0; i < 9; ++i) {
        std::cout << "C[" << i << "] = (" << C[0][i] << ", " << C[1][i] << ")" << std::endl;
    }
    
    std::cout << "Weights (W):" << std::endl;
    for (int i = 0; i < 9; ++i) {
        std::cout << "W[" << i << "] = " << W[i] << std::endl;
    }

    std::cout << "Opposite indices:" << std::endl;
    for (int i = 0; i < 9; ++i) {
        std::cout << "oppositeIndices[" << i << "] = " << oppositeIndices[i] << std::endl;
    }

    std::cout << "Inflow conditions: u_inflow = " << u_inflow << ", rho_inflow = " << rho_inflow << std::endl;
}

#endif // ! CONSTANTS_H
