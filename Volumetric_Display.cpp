#include <Adafruit_GFX.h>
#include <Adafruit_Protomatter.h>
#include <math.h>
#include <BasicLinearAlgebra.h>

// using namespace BLA;
float theta = 1;

int count = 0;

int xmax, ymax; // Global variables to store the Matrix dimensions
BLA::Matrix<4, 8> matrixA;

uint8_t rgbPins[] = {7, 8, 9, 10, 11, 12};
uint8_t addrPins[] = {17, 18, 19, 20};
uint8_t clockPin = 14;
uint8_t latchPin = 15;
uint8_t oePin = 16;

Adafruit_Protomatter Matrix(32, 4, 1, rgbPins, 4, addrPins, clockPin, latchPin, oePin, false);

float vertices[8][3] = {
    {-1, -1, -1}, {1, -1, -1}, {1, 1, -1}, {-1, 1, -1},
    {-1, -1, 1}, {1, -1, 1}, {1, 1, 1}, {-1, 1, 1}
};
int edges[12][2] = {
    {0, 1}, {1, 2}, {2, 3}, {3, 0}, {4, 5}, {5, 6}, {6, 7}, {7, 4},
    {0, 4}, {1, 5}, {2, 6}, {3, 7}
};

void setup() {
    xmax = Matrix.width() - 1;
    ymax = Matrix.height() - 1;
    Matrix.begin();
    
    // Initialize matrixA Matrix
    for (int i = 0; i < 8; i++) {
        matrixA(0, i) = vertices[i][0];
        matrixA(1, i) = vertices[i][1];
        matrixA(2, i) = vertices[i][2];
        matrixA(3, i) = 1; // Homogeneous coordinate for transformations
    }
}

void loop() {

  while(count != 100 && count <= 100)
  {
    loop1();
    count++;
    
  }
  while(count != 200 && count >= 100)
  {
    loop2();
    count++;
  }

  if(count == 200) count = 0;
}
void loop1()
{
  Matrix.fillScreen(0);
  Rotate(M_PI/32,M_PI/32, M_PI/32); 
  Scale(0.992,0.992,0.992); 
  Translate(0.005,0.005,0.005);
  // NOTE: LED matrix is sideways to x will by y and vice versa.


  drawCube(); // Draw the transformed cube
  Matrix.show();
  delay(50);
}
void loop2()
{
  Matrix.fillScreen(0);
  Rotate(M_PI/32,M_PI/32, M_PI/32); 
  Scale(1.008,1.008,1.008); 
  Translate(-0.005,-0.005,-0.005);
  // NOTE: LED matrix is sideways to x will by y and vice versa.


  drawCube(); // Draw the transformed cube
  Matrix.show();
  delay(50);
}

void Rotate(float angleX,float angleY,float angleZ) 
{

  BLA::Matrix<4,4> Rx = {1,0,0,0,
                         0,cos(angleX), -sin(angleX),0,
                         0,sin(angleX), cos(angleX),0,
                         0,0,0,1};
  BLA::Matrix<4,4> Ry = {cos(angleY),0,sin(angleY),0,
                         0,1,0,0,
                         -sin(angleY),0, cos(angleY),0,
                         0,0,0,1};
  BLA::Matrix<4,4> Rz = {1,0,0,0,
                         0,cos(angleZ), -sin(angleZ),0,
                         0,sin(angleZ), cos(angleZ),0,
                         0,0,0,1};

  matrixA = Rx * Ry * Rz * matrixA;

}
void Scale(float scaleX, float scaleY, float scaleZ)
{
  BLA::Matrix<4,4> S = {scaleY,0,0,0,
                        0,scaleX,0,0,
                        0,0,scaleZ,0,
                        0,0,0,1};
  matrixA = S * matrixA;
}

void Translate(float moveX, float moveY, float moveZ)
{
  BLA::Matrix<4,4> T = {1,0,0,moveY,
                        0,1,0,moveX,
                        0,0,1,moveZ,
                        0,0,0,1};

  matrixA = T * matrixA;
}


void drawCube() {
    // Project and draw each edge of the cube
    for (int i = 0; i < 12; i++) {
        int start = edges[i][0];
        int end = edges[i][1];
        int sx = map(matrixA(0, start) * 10 + 16, 0, 32, 0, xmax); // Scale and center
        int sy = map(matrixA(1, start) * 10 + 16, 0, 32, 0, ymax); // Scale and center
        int ex = map(matrixA(0, end) * 10 + 16, 0, 32, 0, xmax);   // Scale and center
        int ey = map(matrixA(1, end) * 10 + 16, 0, 32, 0, ymax);   // Scale and center

        Matrix.drawLine(sx, sy, ex, ey, Matrix.color565(255, 255, 255));
    }
}
