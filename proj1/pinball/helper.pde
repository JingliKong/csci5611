// float flipperLength = 100; // the length of the flipper
// float flipperWidth = 20; // the width of the flipper
// float leftFlipperX = 100; // x position of the left flipper
// float rightFlipperX = 300; // x position of the right flipper
// float flipperY = 350; // y position of the flippers
// float maxAngle = PI/2; // maximum angle of rotation
// float angleSpeed = 0.50; // speed of rotation

// float leftFlipperAngle = 0; // initial angle of the left flipper
// float rightFlipperAngle = 0; // initial angle of the right flipper

// void setup() {
//   size(400, 500);
// }

// void draw() {
//   background(200);
  
//   // draw left flipper
//   drawFlipper(leftFlipperX, flipperY, leftFlipperAngle);
  
//   // draw right flipper
//   drawFlipper(rightFlipperX, flipperY, -rightFlipperAngle);
  
//   // update flipper angles based on arrow keys
//   if (keyPressed) {
//     if (key == CODED) {
//       if (keyCode == LEFT && leftFlipperAngle < maxAngle) {
//         leftFlipperAngle += angleSpeed;
//       }
//       if (keyCode == RIGHT && rightFlipperAngle < maxAngle) {
//         rightFlipperAngle += angleSpeed;
//       }
//     }
//   } else {
//     // reset flipper angles when keys are not pressed
//     leftFlipperAngle = 0;
//     rightFlipperAngle = 0;
//   }
// }

// void drawFlipper(float x, float y, float angle) {
//   //noStroke();
//   pushMatrix();
//   translate(x, y);
//   rotate(angle);
//   rect(-flipperWidth/2, -flipperLength/2, flipperWidth, flipperLength);
//   arc(0, -flipperLength/2, flipperWidth, flipperWidth, PI, TWO_PI);
//   arc(0, flipperLength/2, flipperWidth, flipperWidth, 0, PI);
//   popMatrix();
// }
