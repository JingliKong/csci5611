

class CircleObstacle {
    Vec2 pos; 
    float radius;
    float bounceVel;
    CircleObstacle(Vec2 pos, float radius, float bounceVel) {
        this.radius = radius;
        this.pos = pos.clone();
        this.bounceVel = bounceVel;
        }
}

void drawFlipper(float x, float y, float angle) {
    float endPointX = 0; 
    float endPointY = 0;
    pushMatrix();
    //Translate to the pivot point (the end of the flipper)
    float pivotX = x;
    float pivotY = y - flipperLength / 2;
    translate(pivotX, pivotY);
    rotate(angle);
    //Draw the rectangle representing the flipper
    rect( -flipperWidth / 2, 0, flipperWidth, flipperLength);
    //Draw arcs at the ends of the flipper
    //recall its x, y, width, height, start deg, end deg
    arc(0, 0, flipperWidth, flipperWidth, PI, TWO_PI); // Upper end
    arc(0, flipperLength, flipperWidth, flipperWidth, 0, PI); // Lower end
    endPointX = pivotX + flipperLength * sin(angle);
    endPointY = pivotY + flipperLength * cos(angle);
    // println("endPointX: " + endPointX);
    // println("endPointY: " + endPointY);
    circle(endPointX, -endPointY, 50);
    popMatrix(); 
    // println("endPointY: " + (-endPointY));
    // circle(endPointX, -endPointY, 50);
}


// class Flipper {
//     //fixed properties
//     float radius;
//     Vec2 pos; 
//     float length;
//     float restAngle;
//     float maxRotation;
//     int sign;
//     float angularVelocity;

//     //these get updated during the simulation  
//     float rotation;
//     float currentAngularVelocity;
//     int touchIdentifier;

//     //Constructor
//     Flipper(float radius, Vec2 pos, float length, float restAngle, float maxRotation, float angularVelocity, float restitution) {
//         this.radius = radius;
//         this.pos = pos.clone();
//         this.length = length;
//         this.restAngle = restAngle;
//         this.maxRotation = abs(maxRotation);
//         this.sign = (int) Math.signum(maxRotation);
//         this.angularVelocity = angularVelocity;

//         // initializing changing properties
//         this.rotation = 0.0;
//         this.currentAngularVelocity = 0.0;
//         this.touchIdentifier = -1;
// 	}
//     void simulate(float dt) {
//         float prevRotation = this.rotation;
//         boolean pressed = this.touchIdentifier >= 0;

//         if (pressed) {
//             this.rotation = min(this.rotation + dt * this.angularVelocity, this.maxRotation);
//         } else {
//             this.rotation = max(this.rotation - dt * this.angularVelocity, 0.0);
//         }

//         this.currentAngularVelocity = this.sign * (this.rotation - prevRotation) / dt;
//     }

//     boolean select(Vec2 pos) {
//         Vec2 d = this.pos.minus(pos);
//         return d.length() < this.length;
//     }

//     Vec2 getTip() {
//         float angle = this.restAngle + this.sign * this.rotation;
//         Vec2 dir = new Vec2(cos(angle), sin(angle));
//         Vec2 tip = this.pos.clone();
//         return tip.plus(dir.times(this.length));
//     }
	
// 	void drawFlipper(float x, float y, float angle) {
// 		pushMatrix();
// 		translate(x, y);
// 		rotate(angle);
// 		rect(-flipperWidth/2, -flipperLength/2, flipperWidth, flipperLength);
// 		arc(0, -flipperLength/2, flipperWidth, flipperWidth, PI, TWO_PI);
// 		arc(0, flipperLength/2, flipperWidth, flipperWidth, 0, PI);
// 		popMatrix();
// 	}
// }

// class Paddle {
//     float x, y, w, h;

//     Paddle(float x, float y, float w, float h) {
//         this.x = x;
//         this.y = y;
//         this.w = w;
//         this.h = h;
// }

//     void display() {
//         rect(x, y, w, h);
// }

//     void update() {
//         x = mouseX - w / 2;
// }
// }
