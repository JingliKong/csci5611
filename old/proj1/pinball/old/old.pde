

// ball information
// Vec2 ball_pos[] = new Vec2[numBalls];
// Vec2 ball_vel[] = new Vec2[numBalls];
// float ball_radius = new float[numBalls];
// float ball_mass = new float[numBalls];



void setup() {
    size(550, 800);
    resetSimulation();
}

void draw() {
    float dt = 1.0f / frameRate;
    background(255);  // Clear the background
    update(dt);
    // println(frameRate);
}

void update(float dt) {
  for (int i = 0; i < numBalls; i++) {
    balls[i].update(dt);
    balls[i].wallCollision();
    for (int j = i + 1; j < numBalls; j++) {
        if (balls[i].collidesWith(balls[j])) {
            println("collision");
            balls[i].collided = true; 
            balls[j].collided = true;
            balls[i].resolveCollision(balls[j]);
        } 
    }
  }
  for (int i = 0; i < numBalls; i++) {
    balls[i].render();
    balls[i].collided = false;
  }
}

void keyPressed() {
    if (key == 'r' || key == 'R') {
        resetSimulation();
    }
}


void resetSimulation() {
    // reseting all the positions and attributes of the balls
    for (int i = 0; i < numBalls; i++) {
        Vec2 pos = new Vec2(random(width), random(height));
        Vec2 vel = new Vec2(random(-500, 500), random(-500, 500));
        // float radius = random(5, 40);
        float radius = 60;
        float mass = radius * radius; // mass is proportional to area
        balls[i] = new Circle(pos, vel, radius, mass);
    }
}