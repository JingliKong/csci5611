float flipperLength = 100; // the length of the flipper
float flipperWidth = 20; // the width of the flipper
float leftFlipperX = 100; // x position of the left flipper
float rightFlipperX = 300; // x position of the right flipper
float flipperY = 350; // y position of the flippers
float maxAngle = PI/2; // maximum angle of rotation
float angleSpeed = 0.50; // speed of rotation

float leftFlipperAngle = 0; // initial angle of the left flipper
float rightFlipperAngle = 0; // initial angle of the right flipper

void setup() {
  size(400, 500);
}

void draw() {
  background(200);
  
  //rect(100,100,-50,100);
  circle(50, 55, 10);
  
  arc(50, 55, 50, 50, 0, HALF_PI);
  
  arc(100, 100, 100, 50, 0, PI/2);
  // draw left flipper
  drawFlipper(leftFlipperX, flipperY, leftFlipperAngle);
  
  // draw right flipper
  drawFlipper(rightFlipperX, flipperY, -rightFlipperAngle);
  
  // update flipper angles based on arrow keys
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == LEFT && leftFlipperAngle < maxAngle) {
        leftFlipperAngle += angleSpeed;
      }
      if (keyCode == RIGHT && rightFlipperAngle < maxAngle) {
        rightFlipperAngle += angleSpeed;
      }
    }
  } else {
    // reset flipper angles when keys are not pressed
    leftFlipperAngle = 0;
    rightFlipperAngle = 0;
  }
}

void drawFlipper(float x, float y, float angle) {
  pushMatrix();
  // Translate to the pivot point (the end of the flipper)
  translate(x, y - flipperLength / 2);
  rotate(angle);
  // Draw the rectangle representing the flipper
  rect(-flipperWidth/2, 0, flipperWidth, flipperLength);
  // Draw arcs at the ends of the flipper
  // recall its x, y, width, height, start deg, end deg
  arc(0, 0, flipperWidth, flipperWidth, PI, TWO_PI); // Upper end
  arc(0, flipperLength, flipperWidth, flipperWidth, 0, PI); // Lower end
  popMatrix();
}
