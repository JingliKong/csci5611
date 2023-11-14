let maxNumAgents = 3;
let numAgents = 3;

let k_goal = 3;  // Tune this parameter to agent stop naturally on their goals
let k_avoid = 20;
let agentRad = 15;
let goalSpeed = 100;

let agentPos = [];
let agentVel = [];
let agentAcc = [];
let goalPos = [];


let flowerColors = []

let backgroundImage;

function preload() {
  backgroundImage = loadImage('imgs\\grass.jpg'); 
}

function setup() {
  createCanvas(850, 650);

  // Initialize agent positions and goals
  for (let i = 0; i < numAgents; i++) {
    agentPos[i] = createVector(); 
    agentVel[i] = createVector(); 
    agentAcc[i] = createVector();
    goalPos[i] = createVector(); 
  }


  agentPos[0] = createVector(220, 610);
  agentPos[1] = createVector(320, 650);
  agentPos[2] = createVector(320, 420);
  goalPos[0] = createVector(200, 420);
  goalPos[1] = createVector(120, 120);
  goalPos[2] = createVector(220, 220);

  // Set initial velocities to carry agents towards their goals
  for (let i = 0; i < numAgents; i++) {
    agentVel[i] = p5.Vector.sub(goalPos[i], agentPos[i]);
    if (agentVel[i].mag() > 0) {
      agentVel[i].setMag(goalSpeed);
    }
  }
  // 6 petal flower 
  generateFlowerColors(6);
}

let paused = true;

function draw() {
    background(	144, 238, 144); 
    // image(backgroundImage, 0, 0, width, height);
    // Update agent if not paused
    if (!paused) {
        moveAgent(1.0 / frameRate());
    }

    // Draw orange goal rectangle
    fill(255, 150, 50);
    for (let i = 0; i < numAgents; i++) {
        rect(goalPos[i].x - 10, goalPos[i].y - 10, 20, 20);
    }
        // Draw flowers (goals)
        for (let i = 0; i < numAgents; i++) {
          drawFlower(goalPos[i].x, goalPos[i].y, 20);
      }
  
    // Draw bees (agents)
    for (let i = 0; i < numAgents; i++) {
      let angle = atan2(agentVel[i].y, agentVel[i].x) + PI/2; // Calculate the angle of velocity
      drawBee(agentPos[i].x, agentPos[i].y, agentRad * 2, angle);
  }
}


function computeTTC(pos1, vel1, radius1, pos2, vel2, radius2) {
  let relativeVel = p5.Vector.sub(vel2, vel1);
  let combinedRadius = radius1 + radius2;
  let ttc = rayCircleIntersectTime(pos1, combinedRadius, pos2, relativeVel);
  return ttc;
}

function keyPressed() {
  if (key === ' ') {
      paused = !paused;
  }
}


function rayCircleIntersectTime(center, r, l_start, l_dir) {
  let toCircle = p5.Vector.sub(center, l_start);
  let a = l_dir.magSq();
  let b = -2 * p5.Vector.dot(l_dir, toCircle);
  let c = toCircle.magSq() - (r * r);
  let d = b * b - 4 * a * c;

  if (d >= 0) {
      let t = (-b - sqrt(d)) / (2 * a);
      if (t >= 0) return t;
      return -1;
  }
  return -1;
}

function moveAgent(dt) {
  // Compute accelerations for every agent
  for (let i = 0; i < numAgents; i++) {
      agentAcc[i] = computeAgentForces(i);
  }
  // Update position and velocity using recall (Eulerian) numerical integration
  for (let i = 0; i < numAgents; i++) {
      agentVel[i].add(p5.Vector.mult(agentAcc[i], dt));
      agentPos[i].add(p5.Vector.mult(agentVel[i], dt));
  }
}

function computeAgentForces(id) {
  let acc = createVector(0, 0);

  // Calculate goal force
  let goal_vel = p5.Vector.sub(goalPos[id], agentPos[id]);
  if (goal_vel.mag() > 0) {
      goal_vel.setMag(goalSpeed);
  }
  let goal_force = p5.Vector.sub(goal_vel, agentVel[id]).mult(k_goal);
  acc.add(goal_force);

  // Compute avoidance forces
  for (let j = 0; j < numAgents; j++) {
      if (j !== id) { 
          let ttc = computeTTC(agentPos[id], agentVel[id], agentRad, agentPos[j], agentVel[j], agentRad);

          if (ttc >= 0) {
              // Predict future positions
              let A_future = p5.Vector.add(agentPos[id], p5.Vector.mult(agentVel[id], ttc));
              let B_future = p5.Vector.add(agentPos[j], p5.Vector.mult(agentVel[j], ttc));

              // Compute relative direction
              let relative_future_direction = p5.Vector.sub(A_future, B_future).normalize();

              // Compute avoidance force
              let avoidance_force = relative_future_direction.mult(k_avoid / ttc);
              acc.add(avoidance_force);
          }
      }
  }

  return acc;
}


function drawBee(x, y, size, angle) {
  push(); 
  translate(x, y); // Move to the bee's location
  rotate(angle); // Rotate by the angle of the velocity

  // Body of the bee
  fill(255, 215, 0); // Yellow color
  ellipse(0, 0, size, size * 0.8);

  // black body 
  fill(0); // Black color
  ellipse(0, 0, size * 0.6, size * 0.5);
  
  // Wings
  fill(255, 255, 255, 150); // Semi-transparent white
  ellipse(-size / 2, -size / 2, size * 0.8, size * 0.5);
  ellipse(size / 2, -size / 2, size * 0.8, size * 0.5);

  // Antennae
  line(0, -size / 2, -10, -size);
  line(0, -size / 2, 10, -size);

  pop(); // Restore the original drawing settings
}


function drawFlower(x, y, size) {
  let petalCount = 6;
  for (let i = 0; i < petalCount; i++) {
    let angle = TWO_PI / petalCount * i;
    fill(flowerColors[i]);
    ellipse(x + cos(angle) * size, y + sin(angle) * size, size, size);
}

fill(255, 255, 0); // Yellow center
ellipse(x, y, size * 0.5, size * 0.5);
  // for (let i = 0; i < TWO_PI; i += TWO_PI / 6) { // 6 petals
  //   fill(flowerColors[i]);
  //   ellipse(x + cos(i) * size, y + sin(i) * size, size, size);
  // }

  // fill(255, 255, 0); // Yellow center
  // ellipse(x, y, size * 0.5, size * 0.5);
}

function generateFlowerColors(numPetals) {
    flowerColors = []; // Reset the array
    for (let i = 0; i < numPetals; i++) {
        // Generate a random color and add it to the array
        flowerColors.push(color(random(255), random(255), random(255)));
    }
}



