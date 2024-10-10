import * as THREE from "three";
import { GLTFLoader } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/loaders/GLTFLoader.js";
import { OrbitControls } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/controls/OrbitControls.js";

// Global variables

var container,
  camera,
  scene,
  controls,
  model = new THREE.Object3D();
var cameraList = [],
  prevBinColor,
  prevBin,
  currentObject = new THREE.Object3D();
var prevNav,
  isRackDataLoaded = false,
  world_cam;

document.addEventListener("DOMContentLoaded", function () {
  // Local Storage Setup
  window.localStorage.setItem("switchToMainCam", "null");

  window.addEventListener("storage", (event) => {
    if (event.key === "switchToMainCam") {
      switchCamera(event.newValue);
    } else if (event.key === "isRackDataLoaded") {
      isRackDataLoaded = event.newValue;
    }
  });

  // Rendering Setup
  // we use WebGL renderer for rendering 3d model efficiently
  const renderer = new THREE.WebGLRenderer({
    antialias: true,
    alpha: true,
    logarithmicDepthBuffer: true,
    preserveDrawingBuffer: true,
  });
  renderer.setPixelRatio(Math.min(Math.max(1, window.devicePixelRatio), 2));

  //Raycasting Setup
  // we use raycasting to add hovering or onclick functionality to 3d model.
  const raycaster = new THREE.Raycaster();

  // need mouse coordinates for raycasting.
  const mouse = new THREE.Vector2();
  const lastPos = new THREE.Vector2();

  // Environment Setup
  // PMREM Generator for improved environment lighting
  const pmremGenerator = new THREE.PMREMGenerator(renderer);
  pmremGenerator.compileEquirectangularShader();

  init();

  function init() {
    container = document.createElement("div");
    // creating a container section(division) on our html page(not yet visible).
    document.body.appendChild(container);
    // assigning div to document's visible structure i.e. body.

    scene = new THREE.Scene();

    scene.background = new THREE.Color(0xcccccc); // Set your desired background

    const Loader = new GLTFLoader();

    // Configure the loader to load textures
    Loader.loadTexture = true;
    Loader.load(
      "../3d_models/warehouse_1010_1721.glb",
      function (gltf) {
        model = gltf.scene;

        cameraList = gltf.cameras;

        world_cam = findCameraByName("world_cam");

        // console.log(dumpObject(model).join('\n'));

        createNewCamera(world_cam);

        scene.add(model);

        currentObject = model;

        scene.getObjectByName("r1rb11004").material.color.set(0xff0000);

        scene.updateMatrixWorld(true);

        // Add ambient light
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
        ambientLight.castShadow = false; // Soft white light
        scene.add(ambientLight);

        // // Add directional light
        const directionalLight = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
        directionalLight.position.set(5, 5, 5); // Position the light
        scene.add(directionalLight);

        animate();
      },
      undefined,
      function (error) {
        console.error(error.toString());
      }
    );

    renderer.setSize(window.innerWidth, window.innerHeight);

    container.appendChild(renderer.domElement);

    window.requestAnimationFrame(animate);
  }

  function animate() {
    renderer.render(scene, camera);
    window.requestAnimationFrame(animate);
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

  // Creating first camera with world cam properties to show entire model and adding orbit controls to interact with model.
  function createNewCamera(importedCamera) {
    const fov = importedCamera.fov; // Field of view
    const aspect = window.innerWidth / window.innerHeight; // Aspect ratio
    const near = importedCamera.near; // Near clipping plane
    const far = 3000; // Far clipping plane

    // Create a new Perspective Camera
    camera = new THREE.PerspectiveCamera(fov, aspect, near, far);

    // Set the position of the new camera based on the imported camera's position
    camera.position.copy(importedCamera.position);
    camera.quaternion.copy(importedCamera.quaternion);
    camera.rotation.copy(importedCamera.rotation); // Copy rotation if needed

    scene.add(camera);

    // Set up OrbitControls with the new camera
    controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true; // Enable smooth movement
    controls.dampingFactor = 0.25;
    controls.zoomSpeed = 2;
    controls.panSpeed = 2;
    controls.screenSpacePanning = false;

    // limiting vertical rotation around x axis
    controls.minPolarAngle = 0;
    controls.maxPolarAngle = Math.PI / 2;

    // limiting horizontal rotation around y axis
    controls.minAzimuthAngle = -Math.PI;
    controls.maxAzimuthAngle = Math.PI;

    // limiting zoom out
    controls.maxDistance = 1500;

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

    // Make the camera look at a specific point (optional)
    const center = new THREE.Vector3(0, 0, 0); // Adjust this based on your scene
    controls.target.copy(center);

    // Update controls to reflect the target position
    controls.update();
  }

  function switchCamera(name) {
    let selectedCamera;
    let center;

    if (name == "warehouse") {
      const object = scene.getObjectByName("warehouse_wall");
      currentObject = object;
      const aabb = new THREE.Box3().setFromObject(object);
      center = aabb.getCenter(new THREE.Vector3());
      console.log('{"object":"null"}');
      selectedCamera = cameraList.find((cam) =>
        cam.name.toString().includes(name)
      );
    } else {
      const object = scene.getObjectByName(name.split("_")[0]);
      currentObject = object;
      const aabb = new THREE.Box3().setFromObject(object);
      center = aabb.getCenter(new THREE.Vector3());
      selectedCamera = cameraList.find((cam) =>
        cam.name.toString().includes(object.name.toString())
      );
    }

    if (selectedCamera) {
      // Create a GSAP timeline for smoother transitions
      const timeline = gsap.timeline();

      controls.enabled = false;
      controls.enableDamping = false;

      // Animate position and rotation simultaneously
      timeline
        .to(camera.position, {
          duration: 3,
          x: selectedCamera.position.x,
          y: selectedCamera.position.y,
          z: selectedCamera.position.z,
          onUpdate: function () {
            controls.target.copy(center); // Adjust target if necessary
          },
          ease: "power3.inOut",
        })
        .to(
          camera.quaternion,
          {
            duration: 3,
            x: selectedCamera.quaternion.x,
            y: selectedCamera.quaternion.y,
            z: selectedCamera.quaternion.z,
            w: selectedCamera.quaternion.w,
            ease: "power3.inOut",
            onUpdate: function () {
              controls.target.copy(center); // Adjust target if necessary
            },
            onComplete: function () {
              if (!selectedCamera.name.toString().includes("Area")) {
                controls.enabled = true; // Enable controls after switching cameras
                controls.enableDamping = true;
              }
            },
          },
          0
        ); // Start rotation animation at the same time as position animation
    }
  }

  function moveToBin(object) {
    var aabb = new THREE.Box3().setFromObject(object);
    var center = aabb.getCenter(new THREE.Vector3());
    var size = aabb.getSize(new THREE.Vector3());
    const regex = /r\d+r/;

    // Create a GSAP timeline for smoother transitions
    const timeline = gsap.timeline();

    controls.enabled = false;
    controls.enableDamping = false;

    // Animate position and rotation simultaneously
    timeline
      .to(camera.position, {
        duration: 1,
        x: regex.test(object.name.toString())
          ? center.x + size.x * 2
          : center.x - size.x * 2,
        y: center.y,
        z: center.z,
        ease: "power1.out",
        onUpdate: function () {
          controls.target.copy(center);
        },
      })
      .to(
        controls.target,
        {
          duration: 1,
          x: center.x,
          y: center.y,
          z: center.z,
          ease: "power1.out",
          onUpdate: function () {
            camera.lookAt(controls.target);
          },
          onComplete: function () {
            controls.enabled = true; // Enable controls after switching cameras
            controls.enableDamping = true;
          },
        },
        0
      ); // Start rotation animation at the same time as position animation
  }

  function onMouseMove(e) {
    // regularly updating the position of mouse pointer when it is moved on rendered window.
    mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
    mouse.y = -(e.clientY / window.innerHeight) * 2 + 1;
    if (model) {
      raycaster.setFromCamera(mouse, camera);
      // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
      const intersects = raycaster.intersectObjects(scene.children, true);
      // we get the objects from the model as list that are intersected by the casted ray.

      if (intersects.length > 0) {
        const targetObject = intersects[0].object;
        // Send the object name to Flutter
        if (window.flutter_inappwebview) {
          window.flutter_inappwebview.callHandler(
            "sendObjectName",
            targetObject.name.toString()
          );
        }
        if (targetObject.name.toString().includes("navigation")) {
          tooltip.style.display = "block";
          tooltip.innerHTML = targetObject.name.toString().split("_")[0];

          // Position tooltip at the mouse location
          tooltip.style.left = `${e.clientX + 10}px`; // Offset for better visibility
          tooltip.style.top = `${e.clientY + 10}px`;
        } else {
          tooltip.style.display = "none";
        }
      }
    }
  }

  function onMouseDown(e) {
    lastPos.x = (e.clientX / window.innerWidth) * 2 - 1;
    lastPos.y = -(e.clientY / window.innerHeight) * 2 + 1;
  }

  function onMouseUp(e) {
    if ((lastPos.distanceTo(mouse) === 0) & (e.button === 0)) {
      raycaster.setFromCamera(mouse, camera);
      // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
      const intersects = raycaster.intersectObjects(scene.children, true);
      // we get the objects from the model as list that are intersected by the casted ray.

      if (intersects.length > 0) {
        const targetObject = intersects[0].object;
        if (targetObject.name.toString().includes("cam")) {
          if (targetObject.name.toString().includes("rack")) {
            console.log(
              '{"rack":"' + targetObject.name.toString().split("_")[0] + '"}'
            );
          } else {
            console.log(
              '{"area":"' + targetObject.name.toString().split("_")[0] + '"}'
            );
          }
          switchCamera(targetObject.name.toString());
          window.localStorage.setItem("switchToMainCam", "null");
          prevNav = targetObject.name.toString();
        } else if (
          targetObject.name.toString().includes("b") &&
          prevNav.includes("rack")
        ) {
          changeColor(targetObject);
          window.localStorage.setItem("switchToMainCam", "null");
        } else {
          if (prevBin) {
            prevBin.material.color.copy(prevBinColor);
          }
          switchCamera("warehouse");
          prevNav = targetObject.name.toString();
        }
      }
    }
  }

  // for responsiveness
  function onWindowResize() {
    renderer.setSize(window.innerWidth, window.innerHeight);
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
  }

  window.addEventListener("mousemove", onMouseMove); // triggered when mouse pointer is moved.
  window.addEventListener("mousedown", onMouseDown);
  window.addEventListener("mouseup", onMouseUp); // triggered when mouse pointer is clicked.
  window.addEventListener("resize", onWindowResize); // triggered when window is resized.

  function changeColor(object) {
    if (prevBin != null) {
      prevBin.material.color.copy(prevBinColor);
    }

    prevBinColor = object.material.color.clone();
    if (prevBin != object) {
      object.userData.active = true;
      // Set transparent blue color
    object.material.color.set(0xadd8e6); // Blue color
    object.material.opacity = 0.5; // Adjust opacity for transparency
      console.log('{"bin":"' + object.name.toString() + '"}');
      moveToBin(object);
    } else {
      if (object.userData.active == false) {
        object.userData.active = true;
        prevBinColor = object.material.color.clone();
        prevBin = object;
        // Set transparent blue color
    object.material.color.set(0xadd8e6); // Blue color
    object.material.opacity = 0.5; // Adjust opacity for transparency
        console.log('{"bin":"' + object.name.toString() + '"}');
        moveToBin(object);
      } else {
        object.userData.active = false;
        console.log('{"rack":"' + prevNav.split("_")[0] + '"}');
        switchCamera(prevNav);
      }
    }
    prevBin = object;
  }

  function frameArea(sizeToFitOnScreen, boxSize, boxCenter, camera) {
    const halfSizeToFitOnScreen = sizeToFitOnScreen * 0.5;
    const halfFovY = THREE.MathUtils.degToRad(camera.fov * 0.5);
    const distance = halfSizeToFitOnScreen / Math.tan(halfFovY);
    // compute a unit vector that points in the direction the camera is now
    // in the xz plane from the center of the box
    const direction = new THREE.Vector3()
      .subVectors(camera.position, boxCenter)
      .multiply(new THREE.Vector3(1, 0, 1))
      .normalize();

    // move the camera to a position distance units way from the center
    // in whatever direction the camera was from the center already
    camera.position.copy(direction.multiplyScalar(distance).add(boxCenter));

    // pick some near and far values for the frustum that
    // will contain the box.
    camera.near = boxSize / 100;
    camera.far = boxSize * 100;

    camera.updateProjectionMatrix();

    // point the camera to look at the center of the box
    camera.lookAt(boxCenter.x, boxCenter.y, boxCenter.z);
  }
});

// functions

function findCameraByName(name) {
  // Use Array.prototype.find to locate the camera by name
  const foundCamera = cameraList.find((cam) => cam.name === name);

  if (foundCamera) {
    return foundCamera;
  } else {
    console.log("Camera not found:", name);
    return null;
  }
}
