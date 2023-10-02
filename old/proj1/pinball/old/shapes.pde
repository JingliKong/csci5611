class Circle {
    Vec2 pos;
    Vec2 acc;
    Vec2 vel;
    float x, y, r, mass; 
    boolean collided; 
    boolean infiniteMass;
    float cor = 0.95; // coefficient of restitution
    
    Circle(Vec2 pos, Vec2 vel, float r , float mass) {
        this.pos = pos;
        this.x = pos.x;
        this.y = pos.y;
        this.r = r;
        this.mass = PI * r * r;
        this.infiniteMass = false;
        this.vel = vel;
        // this.vel = new Vec2(0, 0); // start at reset
        this.acc = new Vec2(0, 300);
        
        this.collided = false;
    }
    void update(float dt) {
        this.vel.add(this.acc.times(dt));
        this.pos.add(this.vel.times(dt));
        this.x = this.pos.x;
        this.y = this.pos.y;
        
        
    }
    void render() {
        push(); // Save the current drawing state
        noStroke();
        // Draw the shape centered at the new origin
        if (this.collided == false) {
            fill(42);
        }
        else {
            fill(255, 0, 0);
        }
        ellipse(this.x, this.y, this.r * 2, this.r * 2);
        pop(); // Restore the saved drawing state
    }
    boolean collidesWith(Circle other) {
        // Check if the distance between the two circles is less than the sum of their radii
        float dx = this.x - other.x;
        float dy = this.y - other.y;
        float distance = sqrt(dx * dx + dy * dy);
        
        return distance < this.r + other.r;
    }
    void resolveCollision(Circle other) {
        Vec2 delta = this.pos.minus(other.pos);
        float dist = delta.length();
        float overlap = 0.5f * (dist - this.r - other.r);
       // Separate circles, move them away from each other
        this.pos.subtract(delta.normalized().times(overlap));
        other.pos.add(delta.normalized().times(overlap));

        // Collision 
        Vec2 dir = delta.normalized();
        float v1 = dot(this.vel, dir);
        float v2 = dot(other.vel, dir);
        float m1 = this.mass;
        float m2 = other.mass;

        float new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
        float new_v2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);

        this.vel = this.vel.plus(dir.times(new_v1 - v1));
        other.vel = other.vel.plus(dir.times(new_v2 - v2));
        println("Resolving collision");
    }
    void wallCollision() {
        // Check for collisions with canvas boundaries
        if (this.x - this.r < 0) {
            this.x = this.r * 1.01;
            this.vel.x *= -1; // Reverse the x-velocity
        }
        if (this.x + this.r > width) {
            this.x = width - this.r * 1.01;
            this.vel.x *= -1; // Reverse the x-velocity
        }
        if (this.y - this.r < 0) {
            // Collision with top or bottom wall
            this.y = this.r * 1.01;
            this.vel.y *= -1;// Reverse the y-velocity
        }
        if (this.y + this.r > height) {
            this.y = height - this.r * 1.01;
            this.vel.y *= -1; // Reverse the y-velocity
        }
    }
    boolean isCollided() {
        return this.collided;
    }
    void setCollided(boolean collided) {
        this.collided = collided;
    }   
}

class Line {
    float x1, y1, x2, y2;
    Vec2 start, end;
    Line(float x1, float y1, float x2, float y2) {
        this.x1 = x1; this.y1 = y1;
        this.x2 = x2; this.y2 = y2;
        this.start = new Vec2(x1, y1);
        this.end = new Vec2(x2, y2);
    }
    void render() {
        push();
        stroke(255);
        line(this.x1, this.y1, this.x2, this.y2);
        pop();
    }
}

class Box {
    float x, y, w, h;
    Vec2 pos;
    Box(float x, float y, float w, float h) {
        this.x = x; this.y = y;
        this.w = w; this.h = h;
        this.pos = new Vec2(x, y);
    }
    void render() {
        push();
        stroke(255);
        fill(185, 214, 242);
        rect(this.x, this.y, this.w, this.h);
        pop();
    }
}