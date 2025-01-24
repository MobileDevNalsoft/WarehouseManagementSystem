import * as THREE from "three";
import { globalState } from "globalState";
import { highlightArea, resetAreas } from "highlight";

const data = JSON.parse(window.localStorage.getItem("facilityData"));
export function createCamera() {
  const container = document.getElementById("container");

  const fov = 30; // Field of view
  const aspect = container.clientWidth / container.clientHeight; // Aspect ratio
  const near = 0.1; // Near clipping plane
  const far = 3000; // Far clipping plane

  // Create a new Perspective Camera
  const camera = new THREE.PerspectiveCamera(fov, aspect, near, far);

  // Set the position of the new camera based on the imported camera's position
  switch (data.model) {
    case "warehouse":
      camera.position.set(0, 600, 500);
      break;
    case "storageArea":
      camera.position.set(0, 45, 150);
      break;
  }

  return camera;
}

export function switchCamera(scene, name, camera, controls) {
  if (name == "storageArea") {
    window.localStorage.setItem("rack_cam", "null");
  }
  const { position, target } = getPositionAndTarget(scene, name);
  resetAreas(scene);
  if (document.getElementById("areas").classList.contains("focused")) {
    document.getElementById("areas").classList.toggle("focused");
  }

  switch (name.toString().split("_")[0]) {
    case "storageArea":
      highlightArea(scene, "storageArea_block", { r: 50, g: 205, b: 50 }, 0.4);
      break;
    case "inspectionArea":
      highlightArea(
        scene,
        "inspectionArea_block",
        { r: 138, g: 46, b: 226 },
        0.4
      );
      break;
    case "stagingArea":
      highlightArea(scene, "stagingArea_block", { r: 255, g: 214, b: 10 }, 0.4);
      break;
    case "activityArea":
      highlightArea(scene, "activityArea_block", { r: 0, g: 128, b: 128 }, 0.4);
      break;
    case "receivingArea":
      highlightArea(
        scene,
        "receivingArea_block",
        { r: 166, g: 20, b: 93 },
        0.4
      );
      break;
    case "yardArea":
      highlightArea(scene, "yardArea_block", { r: 255, g: 99, b: 99 }, 0.4);
      break;
  }

  // Create a GSAP timeline for smoother transitions
  const timeline = gsap.timeline();

  controls.enabled = false;
  controls.enableDamping = false;

  // Animate position and rotation simultaneously
  timeline
    .to(camera.position, {
      duration: 3,
      x: position.x,
      y: position.y,
      z: position.z,
      ease: "power3.inOut",
    })
    .to(
      controls.target,
      {
        duration: 3,
        x: target.x,
        y: target.y,
        z: target.z,
        ease: "power3.inOut",
        onUpdate: function () {
          camera.lookAt(controls.target); // Smoothly look at the target
        },
      },
      "<"
    );

  // Callbacks after animation completes
  timeline.call(() => {
    controls.enabled = true; // Re-enable controls after animation
    controls.enableDamping = true; // Re-enable damping after animation
    if (name.includes("compound")) {
      globalState.setAreaFocused(false);
    }
  });
}

export function moveToBin(object, camera, controls) {
  var aabb = new THREE.Box3().setFromObject(object);
  var center = aabb.getCenter(new THREE.Vector3());
  var size = aabb.getSize(new THREE.Vector3());
  const regex = /^[0-9][R]B\d{5}$/;
  if (document.getElementById("path").classList.contains("focused")) {
    document.querySelector("#path").click();
  }
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
        camera.lookAt(center);
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
          camera.lookAt(center);
        },
        onComplete: function () {
          controls.enabled = true; // Enable controls after switching cameras
          controls.enableDamping = true;
          camera.lookAt(center);
        },
      },
      0
    ); // Start rotation animation at the same time as position animation
}

export function moveCam(controls, camera, target) {
  controls.enabled = false;
  const offset = {
    x: controls.target.x - camera.position.x - 10,
    y: controls.target.y - camera.position.y,
    z: controls.target.z - camera.position.z - 10,
  };

  const new_pos = { ...target };
  new_pos.y = camera.position.y;

  gsap.to(camera.position, {
    duration: 3,
    x: new_pos.x,
    y: new_pos.y,
    z: new_pos.z,

    onComplete: () => {
      offset.x = controls.target.x - camera.position.x;
      offset.y = controls.target.y - camera.position.y;
      offset.z = controls.target.z - camera.position.z;
      controls.enabled = true;
    },
  });
  gsap.to(controls.target, {
    duration: 3,
    x: offset.x + new_pos.x,
    z: offset.z + new_pos.z,
    onUpdate: () => {
      camera.lookAt(target);
    },
  });
}

export function getPositionAndTarget(scene, name) {
  let position = new THREE.Vector3();
  let target = new THREE.Vector3(0, 0, 0);
  let object = new THREE.Object3D();
  let box;
  let view = name.toString().split("_")[0];

  if (!["compoundArea", "storageArea", "warehouse"].includes(view)) {
    document.getElementById("wms-bot").style.display = "none";
  }

  switch (data.model) {
    case "warehouse":
      switch (view) {
        case "compoundArea":
          position.set(0, 550, 220);
          target.set(0, 0, -60);
          target.z = target.z + 50;
          console.log('{"object":"null"}');
          break;
        case "warehouse":
          object = scene.getObjectByName(name);
          position.set(
            object.position.x,
            object.position.y + 250,
            object.position.z + 100
          );
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          break;
        case "storageArea":
          object = scene.getObjectByName(view);
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          position.set(-78, 60, 20);
          target.y = target.y + 25;
          target.x = target.x + 5;
          break;
        case "inspectionArea":
          position.set(21.2, 50, -50);
          object = scene.getObjectByName(view);
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          break;
        case "stagingArea":
          position.set(-119, 80, 0);
          object = scene.getObjectByName(view);
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          break;
        case "activityArea":
          position.set(-49, 80, -20);
          object = scene.getObjectByName(view);
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          break;
        case "receivingArea":
          position.set(20.8, 80, 0);
          object = scene.getObjectByName(view);
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          break;
        case "yardArea":
          position.set(50, 300, -34);
          object = scene.getObjectByName(view);
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          break;
        case "dockArea-IN":
          position.set(20.9, 120, -2);
          object = scene.getObjectByName(view);
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          target.z = target.z + 25;
          break;
        case "dockArea-OUT":
          position.set(-113.95, 120, -2);
          object = scene.getObjectByName(view);
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          target.z = target.z + 25;
          break;
        case "rack5r":
        case "rack4r":
        case "rack3r":
        case "rack2r":
        case "rack1r":
          object = scene.getObjectByName(view);
          position.set(
            object.position.x + 20,
            object.position.y + 24,
            object.position.z
          );
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          break;
        case "rack5l":
        case "rack4l":
        case "rack3l":
        case "rack2l":
        case "rack1l":
          object = scene.getObjectByName(view);
          position.set(
            object.position.x - 20,
            object.position.y + 24,
            object.position.z
          );
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          break;
      }
      break;
    case "storageArea":
      switch (view) {
        case "storageArea":
        case "compoundArea":
          position.set(0, 45, 150);
          target.z = 50;
          break;
        case "rack5r":
        case "rack4r":
        case "rack3r":
        case "rack2r":
        case "rack1r":
          object = scene.getObjectByName(view);
          position.set(
            object.position.x + 20,
            object.position.y + 24,
            object.position.z
          );
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          break;
        case "rack5l":
        case "rack4l":
        case "rack3l":
        case "rack2l":
        case "rack1l":
          object = scene.getObjectByName(view);
          position.set(
            object.position.x - 20,
            object.position.y + 24,
            object.position.z
          );
          box = new THREE.Box3().setFromObject(object);
          box.getCenter(target);
          break;
      }
      break;
  }

  return { position, target };
}
