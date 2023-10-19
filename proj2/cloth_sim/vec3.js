class Vec3 {
	constructor(x = 0, y = 0, z = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	add(other) {
		return new Vec3(this.x + other.x, this.y + other.y, this.z + other.z);
	}

	subtract(other) {
		return new Vec3(this.x - other.x, this.y - other.y, this.z - other.z);
	}

	multiply(scalar) {
		return new Vec3(this.x * scalar, this.y * scalar, this.z * scalar);
	}

	divide(scalar) {
		if (scalar === 0) {
			throw new Error("Division by zero is not allowed.");
		}
		return new Vec3(this.x / scalar, this.y / scalar, this.z / scalar);
	}

	addInPlace(other) {
		this.x += other.x;
		this.y += other.y;
		this.z += other.z;
		return this;
	}

	subtractInPlace(other) {
		this.x -= other.x;
		this.y -= other.y;
		this.z -= other.z;
		return this;
	}

	multiplyInPlace(scalar) {
		this.x *= scalar;
		this.y *= scalar;
		this.z *= scalar;
		return this;
	}

	divideInPlace(scalar) {
		if (scalar === 0) {
			throw new Error("Division by zero is not allowed.");
		}
		this.x /= scalar;
		this.y /= scalar;
		this.z /= scalar;
		return this;
	}

	magnitude() {
		return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}

	normalize() {
		const mag = this.magnitude();
		if (mag === 0) {
			throw new Error("Cannot normalize a zero vector.");
		}
		return this.divide(mag);
	}

	toString() {
		return `Vec3(${this.x}, ${this.y}, ${this.z})`;
	} 
    dot(other) {
        return this.x * other.x + this.y * other.y + this.z * other.z;
    }
    cross(other) {
        let crossX = this.y * other.z - this.z * other.y;
        let crossY = this.z * other.x - this.x * other.z;
        let crossZ = this.x * other.y - this.y * other.x;
        return new Vec3(crossX, crossY, crossZ);
    }    
}

// Example usage:
// const v1 = new Vec3(2, 3, 4);
// const v2 = new Vec3(1, 1, 1);
// v1.addInPlace(v2);
// console.log(v1.toString());  // Outputs: Vec3(3, 4, 5)
