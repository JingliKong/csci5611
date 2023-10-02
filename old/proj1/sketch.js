var numBalls = 10;
var cor = 0.95;
var acc;

// ball data 
var pos = [];
var vel = [];
var radius = [];
var mass = [];

function resetBalls() {
	for (let i = 0; i < numBalls; i++) {
		// pos.push(new Vec2(random(0, width), random(0, height)));
		vel.push(new Vec2(Math.random() * 200 - 100, Math.random() * 200 - 100));
		// vel.push(new Vec2(0, 0));
	}
}


function setup() {
	createCanvas(500, 500);
	acc = new Vec2(0, 300)
	smooth();
	resetBalls();

}

function draw() {

	updatePhysics(1 / frameRate);
	background(220);
	stroke(0,0,0);
	// draw the balls 
	for (let i = 0; i < numBalls; i++) {
		fill(255, 0, 0);
		circle(pos[i].x, pos[i].y, radius[i] * 2);
	}
	
}

function updatePhysics(dt) {
	for (let i = 0; i < numBalls; i++) {
		vel[i].add(acc.times(dt));
		pos[i].add(vel[i].times(dt));

		// Ball-Wall Collision (account for radius)
		if (pos[i].x < 0) {
			pos[i].x = 0;
			vel[i].x *= -cor;
		} else if (pos[i].x > width) {
			pos[i].x = width;
			vel[i].x *= -cor;
		}
		if (pos[i].y < 0) {
			pos[i].y = 0;
			vel[i].y *= -cor;
		} else if (pos[i].y > height) {
			pos[i].y = height;
			vel[i].y *= -cor;
		}
		// Ball to ball collision
		for (let j = i + 1; j < numBalls; j++) {
			let delta = pos[i].minus(pos[j]);
			let dist = delta.length();
			
			// checks for collision
			if (dist > radius[i] + radius[j]) {
				let overlap = radius[i] + radius[j] - dist;
				pos[i].subtract(delta.normalized().times(overlap / dist));
				pos[j].add(delta.normalized().times(overlap / dist));

				// Collision 
				let dir = delta.normalized();
				let v1 = dot(vel[i], dir);
				let v2 = dot (vel[j], dir);
				let m1 = mass[i];
				let m2 = mass[j];
				
				let new_v1 = (m1 * v1 + m2 * v2 - m2 * (v1 - v2) * cor) / (m1 + m2);
				let new_v2 = (m1 * v1 + m2 * v2 - m1 * (v2 - v1) * cor) / (m1 + m2);
				vel[i] = vel[i].plus(dir.times(new_v1 - v1));
				vel[j] = vel[j].plus(dir.times(new_v2 - v2));
			}
		}
	}
}