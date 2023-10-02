
// checks collisions between circles 
// x1, y1, r1 are the coordinates and radius of the first circle
// x2, y2, r2 are the coordinates and radius of the second circle
boolean collidesWith (float x1, float y1, float r1, float x2, float y2, float r2) {
    float dx = x1 - x2;
    float dy = y1 - y2;
    float distance = sqrt(dx*dx + dy*dy);
    return distance < r1 + r2;
}

// resolves collisions between two balls 
// void resolveCollision() {
//     // calculate the distance between the two balls
//     float dx = ball1.x - ball2.x;
//     float dy = ball1.y - ball2.y;
//     float distance = sqrt(dx*dx + dy*dy);

//     // calculate the normal vector
//     float nx = dx / distance;
//     float ny = dy / distance;

//     // calculate the tangent vector
//     float tx = -ny;
//     float ty = nx;

//     // project the velocities onto the normal and tangent vectors
//     float dpTan1 = ball1.vx * tx + ball1.vy * ty;
//     float dpTan2 = ball2.vx * tx + ball2.vy * ty;

//     float dpNorm1 = ball1.vx * nx + ball1.vy * ny;
//     float dpNorm2 = ball2.vx * nx + ball2.vy * ny;

//     // calculate the mass of each ball
//     float m1 = (ball1.radius - ball2.radius) / (ball1.radius + ball2.radius);
//     float m2 = (ball2.radius - ball1.radius) / (ball1.radius + ball2.radius);

//     // calculate the new velocity vectors
//     ball1.vx = (dpNorm1 * nx + dpTan1 * tx) * m1;
//     ball1.vy = (dpNorm1 * ny + dpTan1 * ty) * m1;
//     ball2.vx = (dpNorm2 * nx + dpTan2 * tx) * m2;
//     ball2.vy = (dpNorm2 * ny + dpTan2 * ty) * m2;
// }

