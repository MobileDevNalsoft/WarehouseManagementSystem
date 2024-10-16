import * as THREE from "three";
import { GLTFLoader } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/loaders/GLTFLoader.js";
import { OrbitControls } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/controls/OrbitControls.js";

//Global Variables
var env, controls;

document.addEventListener("DOMContentLoaded", function () {
  env = new Environment(
    new THREE.Scene(),
    new THREE.PerspectiveCamera(
      75,
      window.innerWidth / window.innerHeight,
      0.1,
      1000
    ),
    new THREE.WebGLRenderer()
  );

  env.sceneSetup();
  env.cameraSetup();
  env.addRendererToDocument();

  // Create Plane Geometry
  const width = 5; // Width of the plane
  const height = 5; // Height of the plane
  const geometry = new THREE.PlaneGeometry(width, height);

  // Load Texture
  const textureLoader = new THREE.TextureLoader();
  const texture = textureLoader.load("../images/wall.jpg"); // Replace with your texture path

  // Create Material with Texture
  const material = new THREE.MeshStandardMaterial({ map: texture });

  // Create Mesh
  const plane = new THREE.Mesh(geometry, material);
  //   plane.rotation.x = -Math.PI / 2; // Rotate the plane to be horizontal

  // Add Plane to Scene
  env.scene.add(plane);

  // Add Lighting (optional)
  const ambientLight = new THREE.AmbientLight(0xffffff, 0.5); // Soft white light
  env.scene.add(ambientLight);

  const pointLight = new THREE.PointLight(0xffffff, 1);
  pointLight.position.set(10, 10, 10);
  env.scene.add(pointLight);

  addOrbitControls();

  // Animation Loop
  function animate() {
    requestAnimationFrame(animate);
    env.renderer.render(env.scene, env.camera);
  }

  // Start Animation Loop
  animate();

  //orbit controls
  function addOrbitControls(){
    // Initialize OrbitControls
  controls = new OrbitControls(env.camera, env.renderer.domElement);
  
  // Optional: Enable damping (inertia)
  controls.enableDamping = true; 
  controls.dampingFactor = 0.25;

  // Optional: Set limits for zooming and rotating
  controls.minDistance = 2;   // Minimum zoom distance
  controls.maxDistance = 10;   // Maximum zoom distance
  controls.maxPolarAngle = Math.PI/1.05; // Limit vertical rotation
}
});

class Environment {
  constructor(scene, camera, renderer) {
    this.scene = scene;
    this.camera = camera;
    this.renderer = renderer;
  }
  sceneSetup() {
    this.scene.background = new THREE.Color(0xcccccc); // Set your desired background
  }

  cameraSetup() {
    this.camera.position.z = 5;
  }

  addRendererToDocument() {
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(this.renderer.domElement);
  }
}