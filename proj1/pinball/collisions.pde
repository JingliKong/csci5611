void handleFlipperBallCollisions() {
    // first find the closest point from the ball to the flipper
    Vec2 dir;
}
boolean lineVsCircle(Vec2 lineStart, Vec2 lineEnd, Vec2 circleCenter, float circleRadius) {
    float max_t = 99999999;
    
    // direction of ray 
    Vec2 l_dir = lineEnd.minus(lineStart);
    // normalized dir 
    Vec2 l_dir_norm = l_dir.normalized();
    // length of line 
    float l_len = l_dir.length();
    // compute displacement orom ray start to circle center
    Vec2 toCircle = circleCenter.minus(lineStart);  
    //Step 3: Solve quadratic equation for intersection point (in terms of l_dir and toCircle)
    float a = 1; // we normalized l_dir 
    float b = -2 * dot(l_dir_norm, toCircle);
    float c = toCircle.lengthSqr() - circleRadius * circleRadius;
    float d = b * b - 4 * a * c; 
    if (d >= 0) {
        // If d is positive we know the line is colliding, but we need to check if the collision line within the line segment
        // ... this means t will be between 0 and the length of the line segment
        float t1 = (-b - sqrt(d)) / (2 * a);
        float t2 = (-b + sqrt(d)) / (2 * a);
        if ((t1 > 0 && t1 < l_len && t1 < max_t) || (t2 > 0 && t2 < l_len && t2 < max_t)) {
            return true;
        }
    }
    return false;
}