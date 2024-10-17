// Import Three.js core from the import map
import * as THREE from "three";

// Import loaders and controls from the same version on jsDelivr
import { GLTFLoader } from "https://cdn.jsdelivr.net/npm/three@0.169.0/examples/jsm/loaders/GLTFLoader.js";
import { OrbitControls } from "https://cdn.jsdelivr.net/npm/three@0.169.0/examples/jsm/controls/OrbitControls.js";
import { FontLoader } from "https://cdn.jsdelivr.net/npm/three@0.169.0/examples/jsm/loaders/FontLoader.js";
import { TextGeometry } from "https://cdn.jsdelivr.net/npm/three@0.169.0/examples/jsm/geometries/TextGeometry.js";

//Global Variables
var env,
  controls,
  rack = new THREE.Object3D(),
  warehouseDepth,
  warehouseWidth;

document.addEventListener("DOMContentLoaded", function () {
  env = new Environment(
    new THREE.Scene(),
    new THREE.PerspectiveCamera(
      75,
      window.innerWidth / window.innerHeight,
      0.1,
      3000
    ),
    new THREE.WebGLRenderer({
      antialias: true,
      alpha: true,
      logarithmicDepthBuffer: true,
      preserveDrawingBuffer: true,
    })
  );

  // Environment Setup
  // PMREM Generator for improved environment lighting
  const pmremGenerator = new THREE.PMREMGenerator(env.renderer);
  pmremGenerator.compileEquirectangularShader();

  env.sceneSetup();
  env.cameraSetup();
  env.addRendererToDocument();

  buildGround();
  buildCompund();
  buildWarehouse();
  addRacks();

  lightSetup();

  addOrbitControls();

  // Start Animation Loop
  animate();

  // Animation Loop
  function animate() {
    requestAnimationFrame(animate);
    env.renderer.render(env.scene, env.camera);
  }

  function buildPlane(
    width,
    depth,
    textureImg,
    repeatHorizontal,
    repeatVertical
  ) {
    // Create Plane Geometry
    const geometry = new THREE.PlaneGeometry(width, depth);

    var texture;

    if (textureImg) {
      // Load Texture
      const textureLoader = new THREE.TextureLoader();
      texture = textureLoader.load(textureImg, function () {
        // Set texture repeat
        texture.wrapS = THREE.RepeatWrapping; // Repeat horizontally
        texture.wrapT = THREE.RepeatWrapping; // Repeat vertically
        texture.repeat.set(repeatHorizontal, repeatVertical); // Number of times to repeat in each direction
      }); // Replace with your texture path
    }

    // Create Material with Texture
    const material = new THREE.MeshStandardMaterial({
      map: textureImg != null ? texture : null,
      metalness: 0.1,
      roughness: 0.5,
    });

    // Create Mesh
    const plane = new THREE.Mesh(geometry, material);
    //   plane.rotation.x = -Math.PI / 2; // Rotate the plane to be horizontal

    // Rotate Plane to be perpendicular to Y-axis
    plane.rotation.x = -Math.PI / 2;

    return plane;
  }

  //ground model
  function buildGround() {
    // Add Plane to Scene
    env.scene.add(buildPlane(900, 700, "../images/ground.png", 10, 10));
  }

  function buildCompund() {
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
      metalness: 0.1,
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

    const flooring = buildPlane(
      roomWidth,
      roomDepth,
      "../images/compound_flooring.jpg",
      50,
      100
    );

    flooring.position.set(0, 0.005, 0);

    flooring.rotation.x = -Math.PI / 2;

    env.scene.add(flooring);
  }

  function buildWarehouse() {
    buildWarehouseWall();
    buildWarehouseAreas();
  }

  function buildWarehouseWall() {
    // Define wall dimensions
    const wallHeight = 24; // Height of the walls
    const wallThickness = 2; // Thickness of the walls
    warehouseWidth = 200; // Width of the room
    warehouseDepth = 120; // Depth of the room

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
      metalness: 0.1,
      roughness: 0.5,
    });

    const warehouseWalls = new THREE.Group();

    // Front Wall
    const frontWallLeft = new THREE.Mesh(
      new THREE.BoxGeometry(warehouseWidth / 3 + 2, wallHeight, wallThickness),
      wallMaterial
    );
    frontWallLeft.position.set(
      -warehouseWidth / 3,
      wallHeight / 2,
      warehouseDepth / 2
    ); // Position at front
    const frontWallRight = new THREE.Mesh(
      new THREE.BoxGeometry(warehouseWidth / 3 + 2, wallHeight, wallThickness),
      wallMaterial
    );
    frontWallRight.position.set(
      warehouseWidth / 3,
      wallHeight / 2,
      warehouseDepth / 2
    ); // Position at front
    const frontWallMiddle = new THREE.Mesh(
      new THREE.BoxGeometry(warehouseWidth / 3 + 2, wallHeight, wallThickness),
      wallMaterial
    );
    frontWallMiddle.position.set(0, wallHeight / 2, warehouseDepth / 2 - 10); // Position at front
    const frontWallLeftTurn = new THREE.Mesh(
      new THREE.BoxGeometry(wallThickness, wallHeight, 8),
      wallMaterial
    );
    frontWallLeftTurn.position.set(
      -warehouseWidth / 6,
      wallHeight / 2,
      warehouseDepth / 2 - 5
    ); // Position at front
    const frontWallRightTurn = new THREE.Mesh(
      new THREE.BoxGeometry(wallThickness, wallHeight, 8),
      wallMaterial
    );
    frontWallRightTurn.position.set(
      warehouseWidth / 6,
      wallHeight / 2,
      warehouseDepth / 2 - 5
    ); // Position at front
    warehouseWalls.add(frontWallLeft);
    warehouseWalls.add(frontWallRight);
    warehouseWalls.add(frontWallMiddle);
    warehouseWalls.add(frontWallLeftTurn);
    warehouseWalls.add(frontWallRightTurn);

    // Back Wall
    const backWall = new THREE.Mesh(
      new THREE.BoxGeometry(warehouseWidth + 2, wallHeight, wallThickness),
      wallMaterial
    );
    backWall.position.set(0, wallHeight / 2, -warehouseDepth / 2); // Position at back
    warehouseWalls.add(backWall);

    // Left Wall
    const leftWall = new THREE.Mesh(
      new THREE.BoxGeometry(wallThickness, wallHeight, warehouseDepth),
      wallMaterial
    );
    leftWall.position.set(-warehouseWidth / 2, wallHeight / 2, 0); // Position on left
    warehouseWalls.add(leftWall);

    // Right Wall
    const rightWall = new THREE.Mesh(
      new THREE.BoxGeometry(wallThickness, wallHeight, warehouseDepth),
      wallMaterial
    );
    rightWall.position.set(warehouseWidth / 2, wallHeight / 2, 0); // Position on right
    warehouseWalls.add(rightWall);

    warehouseWalls.position.set(-warehouseDepth / 3, 0, -warehouseWidth / 4);

    // Add Walls to Scene
    env.scene.add(warehouseWalls);
  }

  function buildWarehouseAreas() {
    const storageArea = buildPlane(140, 50);
    console.log("area");
    storageArea.material.color.set(0x8fb0a9);
    storageArea.position.set(-70, 0.01, -84);
    env.scene.add(storageArea);

    write3DText("Storage Area", (textMesh) => {
      console.log("text name", textMesh.name.toString()); // Should log the name without error
      env.scene.add(textMesh); // Add to the scene if desired
    });
  }

  function addRacks() {
    const Loader = new GLTFLoader();

    // Configure the loader to load textures
    Loader.loadTexture = true;
    Loader.load(
      "../glbs/rack.glb",
      function (gltf) {
        rack = gltf.scene;

        // Compute bounding box
        const box = new THREE.Box3().setFromObject(rack);
        const dimensions = new THREE.Vector3();
        box.getSize(dimensions);

        const numberOfRacks = 5; // Number of racks to clone
        const spacing = dimensions.x * 3; // Distance between each rack in the x-axis

        for (let i = 0; i < numberOfRacks; i++) {
          // Clone the original rack
          const rackClone = rack.clone();

          rackClone.traverse((obj) => {
            if (obj.isMesh) {
              if (obj.name.includes("rack")) {
                obj.name = "rack" + i;
              }
            }
          });

          // console.log(dumpObject(rackClone).join('\n'));

          // Set position for each clone
          rackClone.position.set(
            (-warehouseWidth * 11) / 20 + i * spacing,
            0,
            (-warehouseDepth * 2) / 3
          );

          // Add cloned rack to the scene
          env.scene.add(rackClone);
        }

        env.scene.updateMatrixWorld(true);
      },
      undefined,
      function (error) {
        console.error(error.toString());
      }
    );
  }

  function lightSetup() {
    // Add ambient light
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
    env.scene.add(ambientLight);

    // // Add directional light
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
    directionalLight.position.set(0, 100, 100); // Position the light
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

  function dumpObject(obj, lines = [], isLast = true, prefix = "") {
    const localPrefix = isLast ? "└─" : "├─";
    lines.push(
      `${prefix}${prefix ? localPrefix : ""}${obj.name || "*no-name*"} [${
        obj.type
      }]`
    );
    const newPrefix = prefix + (isLast ? "  " : "│ ");
    const lastNdx = obj.children.length - 1;
    obj.children.forEach((child, ndx) => {
      const isLast = ndx === lastNdx;
      dumpObject(child, lines, isLast, newPrefix);
    });
    return lines;
  }
});

function write3DText(text, callback) {
  const fontLoader = new FontLoader();
  fontLoader.load('https://threejs.org/examples/fonts/helvetiker_regular.typeface.json', (font) => {
    // Create the 3D text using the loaded font
    const textGeometry = new TextGeometry(text, {
      font: font,
      size: 1,
      depth: 0.2,
      curveSegments: 5,
      bevelEnabled: true,
      bevelThickness: 0.03,
      bevelSize: 0.02,
      bevelSegments: 3,
    });

    const textMaterial = new THREE.MeshStandardMaterial({ color: 0xffffff });
    const textMesh = new THREE.Mesh(textGeometry, textMaterial);
    textMesh.name = "3D text";
    textMesh.position.set(0,10,10);
    callback(textMesh);
  });
}

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
  }

  addRendererToDocument() {
    this.renderer.setPixelRatio(
      Math.min(Math.max(1, window.devicePixelRatio), 2)
    );
    this.renderer.setSize(window.innerWidth, window.innerHeight);
    document.body.appendChild(this.renderer.domElement);
  }
}
