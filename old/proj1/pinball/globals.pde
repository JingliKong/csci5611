import java.lang.Math; 

int numBalls = 10;
float cor = 0.95f; // Coefficient of Restitution
float obstacleSpeed = 150;


Vec2 pos[] = new Vec2[numBalls];
Vec2 vel[] = new Vec2[numBalls];
Vec2 acc[] = new Vec2[numBalls];
float radius[] = new float[numBalls];
float mass[] = new float[numBalls];

int numLines = 2; 
Vec2 linePos[] = new Vec2[numLines * 2];

// Flipper variables
float flipperLength = 100; // the length of the flipper
float flipperWidth = 20; // the width of the flipper
float leftFlipperX = 350; // x position of the left flipper
float rightFlipperX = 150; // x position of the right flipper
float flipperY = 600; // y position of the flippers
float maxAngle = PI/2; // maximum angle of rotation
float angleSpeed = 0.1; // speed of rotation
float leftFlipperAngle = 0; // initial angle of the left flipper
float rightFlipperAngle = 0; // initial angle of the right flipper



// Circle obstacles 
int numCircleObstacles = 3;
CircleObstacle circleObstacles[] = new CircleObstacle[numCircleObstacles];
