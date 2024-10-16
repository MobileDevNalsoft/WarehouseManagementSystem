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

  // Environment Setup
  // PMREM Generator for improved environment lighting
  const pmremGenerator = new THREE.PMREMGenerator(env.renderer);
  pmremGenerator.compileEquirectangularShader();

  env.sceneSetup();
  env.cameraSetup();
  env.addRendererToDocument();

  buildGround();
  buildCompundWall();
  buildWarehouseWall();

  lightSetup();

  addOrbitControls();

  // Start Animation Loop
  animate();

  // Animation Loop
  function animate() {
    requestAnimationFrame(animate);
    env.renderer.render(env.scene, env.camera);
  }

  //ground model
  function buildGround() {
    // Create Plane Geometry
    const width = 700; // Width of the plane
    const height = 700; // Height of the plane
    const geometry = new THREE.PlaneGeometry(width, height);

    // Load Texture
    const textureLoader = new THREE.TextureLoader();
    const texture = textureLoader.load("../images/ground.png", function () {
      // Set texture repeat
      texture.wrapS = THREE.RepeatWrapping; // Repeat horizontally
      texture.wrapT = THREE.RepeatWrapping; // Repeat vertically
      texture.repeat.set(10, 10); // Number of times to repeat in each direction
    }); // Replace with your texture path

    // Create Material with Texture
    const material = new THREE.MeshStandardMaterial({
      map: texture,
      metalness: 0.5,
      roughness: 0.5,
    });

    // Create Mesh
    const plane = new THREE.Mesh(geometry, material);
    //   plane.rotation.x = -Math.PI / 2; // Rotate the plane to be horizontal

    // Rotate Plane to be perpendicular to Y-axis
    plane.rotation.x = -Math.PI / 2;

    // Add Plane to Scene
    env.scene.add(plane);
  }

  function buildCompundWall() {
    // Define wall dimensions
    const wallHeight = 36; // Height of the walls
    const wallThickness = 2; // Thickness of the walls
    const roomWidth = 400; // Width of the room
    const roomDepth = 300; // Depth of the room

    // Load Texture
    const textureLoader = new THREE.TextureLoader();
    const texture = textureLoader.load("../images/wall.jpg", function () {
      // Set texture repeat
      texture.wrapS = THREE.RepeatWrapping; // Repeat horizontally
      texture.repeat.set(5); // Number of times to repeat in each direction
    }); // Replace with your texture path

    // Create Walls
    const wallMaterial = new THREE.MeshStandardMaterial({
      map: texture,
      metalness: 0.5,
      roughness: 0.5,
    });

    const compundWalls = new THREE.Group();

    // Front Wall
    const frontWall = new THREE.Mesh(
      new THREE.BoxGeometry(roomWidth + 2, wallHeight, wallThickness),
      wallMaterial
    );
    frontWall.position.set(0, wallHeight / 2, -roomDepth / 2); // Position at front
    compundWalls.add(frontWall);

    // Back Wall
    const backWall = new THREE.Mesh(
      new THREE.BoxGeometry(roomWidth + 2, wallHeight, wallThickness),
      wallMaterial
    );
    backWall.position.set(0, wallHeight / 2, roomDepth / 2); // Position at back
    compundWalls.add(backWall);

    // Left Wall
    const leftWall = new THREE.Mesh(
      new THREE.BoxGeometry(wallThickness, wallHeight, roomDepth),
      wallMaterial
    );
    leftWall.position.set(-roomWidth / 2, wallHeight / 2, 0); // Position on left
    compundWalls.add(leftWall);

    // Right Wall
    const rightWall = new THREE.Mesh(
      new THREE.BoxGeometry(wallThickness, wallHeight, roomDepth),
      wallMaterial
    );
    rightWall.position.set(roomWidth / 2, wallHeight / 2, 0); // Position on right
    compundWalls.add(rightWall);

    // Add Walls to Scene
    env.scene.add(compundWalls);
  }

  function buildWarehouseWall() {
    // Define wall dimensions
    const wallHeight = 24; // Height of the walls
    const wallThickness = 2; // Thickness of the walls
    const roomWidth = 200; // Width of the room
    const roomDepth = 120; // Depth of the room

    // Load Texture
    const textureLoader = new THREE.TextureLoader();
    const texture = textureLoader.load(
      "../images/warehouse_wall.jpg",
      function () {
        // Set texture repeat
        texture.wrapS = THREE.RepeatWrapping; // Repeat horizontally
        texture.wrapT = THREE.RepeatWrapping; // Repeat vertically
        texture.repeat.set(10, 5); // Number of times to repeat in each direction
      }
    ); // Replace with your texture path

    // Create Walls
    const wallMaterial = new THREE.MeshStandardMaterial({
      map: texture,
      metalness: 0.5,
      roughness: 0.5,
    });

    const warehouseWalls = new THREE.Group();

    // Front Wall
    const frontWall = new THREE.Mesh(
      new THREE.BoxGeometry(roomWidth + 2, wallHeight, wallThickness),
      wallMaterial
    );
    frontWall.position.set(0, wallHeight / 2, -roomDepth / 2); // Position at front

    // Back Wall
    const backWall = new THREE.Mesh(
      new THREE.BoxGeometry(roomWidth + 2, wallHeight, wallThickness),
      wallMaterial
    );
    backWall.position.set(0, wallHeight / 2, roomDepth / 2); // Position at back

    // Left Wall
    const leftWall = new THREE.Mesh(
      new THREE.BoxGeometry(wallThickness, wallHeight, roomDepth),
      wallMaterial
    );
    leftWall.position.set(-roomWidth / 2, wallHeight / 2, 0); // Position on left

    // Right Wall
    const rightWall = new THREE.Mesh(
      new THREE.BoxGeometry(wallThickness, wallHeight, roomDepth),
      wallMaterial
    );
    rightWall.position.set(roomWidth / 2, wallHeight / 2, 0); // Position on right

    // Add Walls to Scene
    env.scene.add(frontWall);
    env.scene.add(backWall);
    env.scene.add(leftWall);
    env.scene.add(rightWall);
  }

  function lightSetup() {
    // Add ambient light
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
    ambientLight.castShadow = false; // Soft white light
    env.scene.add(ambientLight);

    // // Add directional light
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
    directionalLight.position.set(5, 5, 5); // Position the light
    env.scene.add(directionalLight);
  }

  //orbit controls
  function addOrbitControls() {
    // Initialize OrbitControls
    controls = new OrbitControls(env.camera, env.renderer.domElement);

    // Optional: Enable damping (inertia)
    controls.enableDamping = true;
    controls.dampingFactor = 0.25;
    controls.screenSpacePanning = false;

    // Optional: Set limits for zooming and rotating
    controls.minDistance = 10; // Minimum zoom distance
    controls.maxDistance = 1500; // Maximum zoom distance

    // limiting vertical rotation around x axis
    controls.minPolarAngle = 0;
    controls.maxPolarAngle = Math.PI / 2.2;

    // limiting horizontal rotation around y axis
    controls.minAzimuthAngle = -Math.PI;
    controls.maxAzimuthAngle = Math.PI;

    var minPan = new THREE.Vector3(-300, -300, -300);
    var maxPan = new THREE.Vector3(300, 300, 300);

    // Function to clamp target position
    function clampTarget() {
      controls.target.x = Math.max(
        minPan.x,
        Math.min(maxPan.x, controls.target.x)
      );
      controls.target.y = Math.max(
        minPan.y,
        Math.min(maxPan.y, controls.target.y)
      );
      controls.target.z = Math.max(
        minPan.z,
        Math.min(maxPan.z, controls.target.z)
      );
    }

    // Listen for changes in controls
    controls.addEventListener("change", clampTarget);

    // Initial call to set target within bounds if necessary
    clampTarget();
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
    this.camera.position.z = 500;
    this.camera.position.y = 500;
    this.camera.far = 3000;
  }

  addRendererToDocument() {
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(this.renderer.domElement);
  }
}
