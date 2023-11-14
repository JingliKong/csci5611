let arms = [];
let legs = [];

let body;
let bodyRadius = 60; // Define the radius of the circular body
let armCount = 2; 
left_arm_length = 50;
right_arm_length = 50;

var xRight = 0;
var yRight = 0;
var xLeft = 0; 
var yLeft = 0;

// leg stuff 
var THIGH_LENGTH = 100;
var CALF_LENGTH = 100;
var HIP_JOINT_MIN = 0;
var HIP_JOINT_MAX = 0
var KNEE_JOINT_MIN = 0;
var KNEE_JOINT_MAX = 0;

var hipOffsetX = 0;
var leftHip;
var rightHip;

let bodySprite;
let bananaSprite; 
let backgroundSprite ;
let armSprite;

function preload() {
  bodySprite = loadImage('imgs\\orange.jpeg');
  bananaSprite = loadImage('imgs\\banana.png');
  backgroundSprite = loadImage('imgs\\jg.png');
  armSprite = loadImage('imgs\\arm.png');
}



function setup() {
  createCanvas(800, 800);
  body = createVector(width / 2, height / 2 + 100);

  // First arm on the right side
  xRight = body.x + cos(0) * bodyRadius; // 0 radians, pointing to the right
  yRight = body.y + sin(0) * bodyRadius; // sin(0) is 0, so y is the vertical center

  // arms with angle constraints
  arms.push(new IKArm(createVector(xRight, yRight), [
    [right_arm_length, -PI / 4, PI / 4], 
    [right_arm_length, -PI / 4, PI / 4], 
    [right_arm_length, -PI / 4, PI / 4], 
  ]));

  // Second arm on the opposite side
  xLeft = body.x + cos(PI) * bodyRadius;
  yLeft = body.y + sin(PI) * bodyRadius;
  arms.push(new IKArm(createVector(xLeft, yLeft), [
    [left_arm_length, -3 * PI / 4, -PI / 3],
    [left_arm_length, -PI / 4, PI / 4],
    [left_arm_length, -PI / 4, PI / 4]
  ]));

  // leg constraints 
  HIP_JOINT_MIN = -PI / 3;
  HIP_JOINT_MAX = PI / 3;
  KNEE_JOINT_MAX = PI / 2;
  // leg information 
  // Position the base points for the legs relative to the body position
  hipOffsetX = bodyRadius - 10; // Horizontal offset for the hips from the body center
  leftHip = createVector(body.x - hipOffsetX, body.y + 30);
  rightHip = createVector(body.x + hipOffsetX, body.y + 30);

  // Create left leg with IK
  legs.push(new IKArm(leftHip, [
    [THIGH_LENGTH, HIP_JOINT_MIN, HIP_JOINT_MAX],
    [CALF_LENGTH, KNEE_JOINT_MIN, KNEE_JOINT_MAX], 
  ]));

  // Create right leg with IK
  legs.push(new IKArm(rightHip, [
    [THIGH_LENGTH, -HIP_JOINT_MAX, -HIP_JOINT_MIN],
    [CALF_LENGTH, KNEE_JOINT_MIN, KNEE_JOINT_MAX], 
  ]));
}

var walkingLeft = false;
var walkingRight = false;

function draw() {
  background(41);
  imageMode(CORNER); 
  image(backgroundSprite, 0, 0, width, height); 

  
  let spriteWidth = bananaSprite.width / 9;  
  let spriteHeight = bananaSprite.height / 9;  
  imageMode(CENTER); 
  image(bananaSprite, mouseX, mouseY, spriteWidth, spriteHeight);
  let swingDirection = 0;
  // Move the body if walking
  if (walkingLeft) {
    body.x -= 2; // Move body left
    // move arms left and right 
    arms[0].basePoint.x -= 2;
    arms[1].basePoint.x -= 2;
    swingDirection = sin(frameCount * 0.05); // if we go in a different opposite direction 
  }
  else if (walkingRight) {
    body.x += 2; // Move body right
    arms[0].basePoint.x += 2;
    arms[1].basePoint.x += 2;  
    swingDirection = cos(frameCount * 0.05); // Oscillates between -1 and 1
  }
  

  // Check boundaries to prevent the body from moving off-screen
  body.x = constrain(body.x, bodyRadius, width - bodyRadius);

  // drwaing body 
  fill(100);
  noStroke();
  ellipse(body.x, body.y, bodyRadius * 2, bodyRadius * 2);
  imageMode(CENTER); // Ensure the image is centered on the body point
  image(bodySprite, body.x, body.y, bodyRadius * 2, bodyRadius * 2); // Draw the sprite

  let target = createVector(mouseX, mouseY);
  arms.forEach(arm => {
    arm.updateAndDraw(target);
  });

  // Update the hip positions relative to the moving body
  leftHip.x = body.x - hipOffsetX;
  rightHip.x = body.x + hipOffsetX;


  // Simulate a walking target for each leg by alternating the target's x position
  let leftTarget;
  let rightTarget;

  let swingOffset = 50;

  leftTarget = height - 60 - swingDirection * swingOffset;
  rightTarget = height - 60 + swingDirection * swingOffset;

  leftTarget = createVector(leftHip.x, leftTarget);
  rightTarget = createVector(rightHip.x, rightTarget);

  // Update and draw each leg
  legs.forEach((leg, i) => {
    let target = (i % 2 == 0) ? leftTarget : rightTarget; // just alternate legs that are moving  
    leg.updateAndDraw(target);
  });
}

function keyPressed() {
  if (key == 'a' || key == 'A') {
    walkingLeft = true;
  }
  if (key == 'd' || key == 'D') {
    walkingRight = true;
  }
}

function keyReleased() {
  if (key == 'a' || key == 'A') {
    walkingLeft = false;
  }
  if (key == 'd' || key == 'D') {
    walkingRight = false;
  }
}