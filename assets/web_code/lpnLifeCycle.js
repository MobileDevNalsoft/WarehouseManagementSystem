import * as THREE from "three";
import { Line2 } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/lines/Line2.js";
import { LineMaterial } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/lines/LineMaterial.js";
import { LineGeometry } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/lines/LineGeometry.js";

let lines = [];

export function animateLPNLifeCycle() {
  // Define a list of points
  const points = [
    new THREE.Vector3(-50, 10, 0), // Start Point
    new THREE.Vector3(-50, 10, 0), // Mid Point (will animate)
    new THREE.Vector3(-50, 10, 0), // End Point (will animate)
    new THREE.Vector3(-50, 10, 0), // Final Point (will animate)
    new THREE.Vector3(-50, 10, 0),
  ];

  // Define target positions for animation
  const targetPositions = [
    new THREE.Vector3(-30, 10, 0), // Mid Point target
    new THREE.Vector3(-10, 10, -25), // End Point target
    new THREE.Vector3(10, 10, 50), // Final Point target
    new THREE.Vector3(50, 10, -100),
  ];

  // LineMaterial for all lines
  const lineMaterial = new LineMaterial({
    color: 0xff0000,
    linewidth: 5,
    resolution: new THREE.Vector2(window.innerWidth, window.innerHeight),
  });

  // Function to create a line segment
  function createLineSegment(start, end) {
    const lineGeometry = new LineGeometry();
    lineGeometry.setPositions([start.x, start.y, start.z, end.x, end.y, end.z]);
    const line = new Line2(lineGeometry, lineMaterial);
    lines.push(line); // Store line for later removal
    return line;
  }

  // Recursive function to animate segments
  function animateSegment(index) {
    if (index >= targetPositions.length) return; // Stop recursion when all segments are animated

    let startPoint = points[index];
    let endPoint = points[index + 1]; // Next point
    let target = targetPositions[index];

    // Create and add the line segment
    let line = createLineSegment(startPoint, endPoint);
    scene.add(line);

    // Animate the end point to its target position
    gsap.to(endPoint, {
      x: target.x,
      y: target.y,
      z: target.z,
      duration: 5,
      ease: "power1.out",
      onUpdate: () => {
        line.geometry.setPositions([
          startPoint.x,
          startPoint.y,
          startPoint.z,
          endPoint.x,
          endPoint.y,
          endPoint.z,
        ]);
        line.geometry.attributes.position.needsUpdate = true;
      },
      onComplete: () => {
        if (points[index + 2]) {
          points[index + 2].copy(endPoint);
        }
        // Move to the next segment
        animateSegment(index + 1);
      },
    });
  }

  // Start the animation sequence
  animateSegment(0);
}

export function removeLPNLifeCycle(scene) {
  lines.forEach((line) => {
    scene.remove(line); // Remove from scene
    line.geometry.dispose(); // Free up memory
    line.material.dispose();
  });
  lines = []; // Clear the array
}
