void updatePhysics(float dt) {
    for (int i = 0; i < numBalls; i++) {
        vel[i].add(acc[i].times(dt));
        pos[i].add(vel[i].times(dt));
        // Ball-Wall Collision (account for radius)
        if (pos[i].x < radius[i]) {
            pos[i].x = radius[i];
            vel[i].x *= -cor;
        }
        
        if (pos[i].x > width - radius[i]) {
            pos[i].x = width - radius[i];
            vel[i].x *= -cor;
        }
        if (pos[i].y < radius[i]) {
            pos[i].y = radius[i];
            vel[i].y *= -cor;
        }
        if (pos[i].y > height - radius[i]) {
            pos[i].y = height - radius[i];
            vel[i].y *= -cor;
        }
        // Ball-Ball Collision
        for (int j = i + 1; j < numBalls; j++) {
            Vec2 delta = pos[i].minus(pos[j]);
            float dist = delta.length();
            if (dist < radius[i] + radius[j]) { // checks ball to ball collisions 
                float overlap = 0.5f * (dist - radius[i] - radius[j]);
                pos[i].subtract(delta.normalized().times(overlap));
                pos[j].add(delta.normalized().times(overlap));
                // Collision
                Vec2 dir = delta.normalized();
                float v1 = dot(vel[i], dir);
                float v2 = dot(vel[j], dir);
                float m1 = mass[i];
                float m2 = mass[j];
                // Pseudo-code for collision response
                
                float new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
                float new_v2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
                vel[i] = vel[i].plus(dir.times(new_v1 - v1)); // Add the change in velocity along the collision axis
                vel[j] = vel[j].plus(dir.times(new_v2 - v2)); //  ... collisions only affect velocity along this axis!
                
            }
        }
        // ball to line collisions 
        for (int j = 0; j < numLines; j++) {
            if (lineVsCircle(linePos[j], linePos[j+1], pos[i], radius[i])) {
                println(linePos[j]);
                println(linePos[j+1]);
                println("hit");
            }
        }
    }

}



// reset the balls to random positions and velocities
void resetBalls() {
    for (int i = 0; i < numBalls; i++) {
        pos[i] = new Vec2(random(width), 0);
        vel[i] = new Vec2(random( -500, 500), random( -500, 500));
        acc[i] = new Vec2(0, 100);
        radius[i] = random(5, 40);
        mass[i] = radius[i] * radius[i]; //TODO: Change this to be proportional to area
    }
}

void setup() {
    size(500, 700);
    smooth();
    noStroke();
    // create the balls 
    resetBalls();
    
    // adding line locations
    linePos[0] = new Vec2(0, 540); 
    linePos[1] = new Vec2(0, 580);
    linePos[2] = new Vec2(0, 580);
    linePos[3] = new Vec2(150, 600);    


    // creating the flippers on opposite sides of the screen
    float radius = 5; 
    float length = 10;
    float maxRotation = 1.0f; 
    float restAngle = 0.5f;
    float angleVel = 10.0f; 
    float restitution = 0.0; 

    Vec2 pos1 = new Vec2(26, 22);
    Vec2 pos2 = new Vec2(74, 22);

    
    
    // creating the circle obstacles
    circleObstacles[0] = new CircleObstacle(new Vec2(250, 250), 50, 20);
    circleObstacles[1] = new CircleObstacle(new Vec2(250, 450), 50, 20);
    circleObstacles[2] = new CircleObstacle(new Vec2(250, 650), 50, 20);

    // initializing the positions of the paddles 
    
}

void draw() {
    // handles all the collisions between balls and the other obstacles
    updatePhysics(1 / frameRate);
    background(255);
    
    // drawing the slopes in to the paddle area
    stroke(0);
    strokeWeight(5);
    for (int i = 0; i < numLines*2; i +=2) {
        line(linePos[i].x, linePos[i].y, linePos[i+1].x, linePos[i+1].y);
    } 
    push();
    fill(41);
    noStroke();
    //draw the balls
    for (int i = 0; i < numBalls; i++) {
        circle(pos[i].x, pos[i].y, radius[i] * 2);
    }
    pop();
    // draw the flippers 

    // draw left flipper
    drawFlipper(leftFlipperX, flipperY, leftFlipperAngle);    
    // draw right flipper
    drawFlipper(rightFlipperX, flipperY, -rightFlipperAngle);

    // draw the circle obstacles 
    for (int i = 0; i < numCircleObstacles; i++) {
        push();
        fill(255, 0, 0); 
        circle(circleObstacles[i].pos.x, circleObstacles[i].pos.y, circleObstacles[i].radius * 2);
        pop();
    }
    text("Mouse X: " + mouseX + ", Mouse Y: " + mouseY, 10, 20);
    // handling key presses for paddles 
    // if we have its own function the paddle stays in the location it was moved 
    // so its easier just to put it here
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

void keyPressed() {
    if(key == 'r' || key == 'R') {
        resetBalls();
}
}