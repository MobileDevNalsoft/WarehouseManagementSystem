import * as THREE from "three";
import { Line2 } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/lines/Line2.js";
import { LineMaterial } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/lines/LineMaterial.js";
import { LineGeometry } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/lines/LineGeometry.js";
import { globalState } from "globalState";

let lines = [];
let animations = [];
let sprites = [];

window.animateLPNLifeCycle = function(scene) {
  // Define a list of points
  const points = [
    new THREE.Vector3(10, 6.19, -60), // Start Point
    new THREE.Vector3(10, 6.19, -60), // Mid Point (will animate)
    new THREE.Vector3(10, 6.19, -60), // End Point (will animate)
    new THREE.Vector3(10, 6.19, -60), // Final Point (will animate)
    // new THREE.Vector3(10, 6.19, -60),
  ];

  // Define target positions for animation
  const targetPositions = [
    new THREE.Vector3(10, 6.19, - 120), // Mid Point target
    new THREE.Vector3(-92.4, 6.19, -123.48706235353588), // End Point target
    // new THREE.Vector3(-24.21696383882049, 6.19, -60.86146377835111), // Final Point target
    new THREE.Vector3(-125.14815693589341, 6.19, -60),
  ];

  // LineMaterial for all lines
  const lineMaterial = new LineMaterial({
    color: 0x7cfc00,
    linewidth: 2,
    resolution: new THREE.Vector2(window.innerWidth, window.innerHeight),
  });

  // Function to create a location symbol (Sprite)
  function createLocationSymbol(position) {
    const point = new THREE.Vector3(position.x, 12, position.z);
    const textureLoader = new THREE.TextureLoader();
    const markerTexture = textureLoader.load('./lpn_location.png'); //Your location marker with transparency
    const spriteMaterial = new THREE.SpriteMaterial({ map: markerTexture, transparent: true, alphaTest: 0.5 }); 
    const sprite = new THREE.Sprite(spriteMaterial);
    sprites.push(sprite);
    sprite.scale.set(5, 6, 2); // Adjust scale as needed
    sprite.position.copy(point);
    scene.add(sprite);

    // Bounce Animation (GSAP)
    gsap.to(sprite.position, {
      y: 15, // Peak height of the bounce (adjust as needed)
      duration: 1.5,  // Adjust the duration
      ease: "power2.out", // Adjust the easing function
      repeat: -1,      // Repeat infinitely
      yoyo: true,       // Make it bounce back and forth
  });
  }

  // Create and store location symbols for each point
  // [points[0], ...targetPositions].map(point => createLocationSymbol(point));
  createLocationSymbol(points[0]);

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
    let animation = gsap.to(endPoint, {
      x: target.x,
      y: target.y,
      z: target.z,
      duration: 3,
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
        createLocationSymbol(target);
        if (points[index + 2]) {
          points[index + 2].copy(endPoint);
        }
        // Move to the next segment
        animateSegment(index + 1);
      },
    });

    animations.push(animation);
  }

  // Start the animation sequence
  animateSegment(0);
}

window.removeLPNLifeCycle = function(scene) {
  animations.forEach(animation => animation.kill()); // Stop all animations
  animations = []; // Clear animations array
  lines.forEach((line) => {
    scene.remove(line); // Remove from scene
    line.geometry.dispose(); // Free up memory
    line.material.dispose();
  });
  lines = []; // Clear the array
  sprites.forEach((sprite) => {
    scene.remove(sprite);
    sprite.geometry.dispose();
    sprite.material.dispose();
  })
  sprites = [];
}

window.showLPNLifecycle = function (show) {
  if(show == true){
    document.getElementById("wms-bot").style.display = "none";
    switchCamera(globalThis.scene, "lpnLifeCycle", globalState.camera, globalState.controls);
    animateLPNLifeCycle(globalThis.scene);
  }else{
    document.getElementById("wms-bot").style.display = "block";
    removeLPNLifeCycle(globalThis.scene);
  }
}