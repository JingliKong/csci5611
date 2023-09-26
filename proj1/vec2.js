class Vec2 {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    toString() {
        return "(" + this.x + "," + this.y + ")";
    }

    length() {
        return Math.sqrt(this.x * this.x + this.y * this.y);
    }

    plus(rhs) {
        return new Vec2(this.x + rhs.x, this.y + rhs.y);
    }

    add(rhs) {
        this.x += rhs.x;
        this.y += rhs.y;
    }

    minus(rhs) {
        return new Vec2(this.x - rhs.x, this.y - rhs.y);
    }

    subtract(rhs) {
        this.x -= rhs.x;
        this.y -= rhs.y;
    }

    times(rhs) {
        return new Vec2(this.x * rhs, this.y * rhs);
    }

    mul(rhs) {
        this.x *= rhs;
        this.y *= rhs;
    }

    clampToLength(maxL) {
        const magnitude = Math.sqrt(this.x * this.x + this.y * this.y);
        if (magnitude > maxL) {
            this.x *= maxL / magnitude;
            this.y *= maxL / magnitude;
        }
    }

    setToLength(newL) {
        const magnitude = Math.sqrt(this.x * this.x + this.y * this.y);
        this.x *= newL / magnitude;
        this.y *= newL / magnitude;
    }

    normalize() {
        const magnitude = Math.sqrt(this.x * this.x + this.y * this.y);
        this.x /= magnitude;
        this.y /= magnitude;
    }

    normalized() {
        const magnitude = Math.sqrt(this.x * this.x + this.y * this.y);
        return new Vec2(this.x / magnitude, this.y / magnitude);
    }

    distanceTo(rhs) {
        const dx = rhs.x - this.x;
        const dy = rhs.y - this.y;
        return Math.sqrt(dx * dx + dy * dy);
    }
}

function interpolate(a, b, t) {
    if (a instanceof Vec2 && b instanceof Vec2) {
        return a.plus(b.minus(a).times(t));
    } else if (typeof a === 'number' && typeof b === 'number') {
        return a + (b - a) * t;
    }
}

function dot(a, b) {
    return a.x * b.x + a.y * b.y;
}

function projAB(a, b) {
    return b.times(dot(a, b));
}
