import * as THREE from "three";

export function createCamera() {
  const container = document.getElementById("container");

  const fov = 30; // Field of view
  const aspect = container.clientWidth / container.clientHeight; // Aspect ratio
  const near = 0.1; // Near clipping plane
  const far = 3000; // Far clipping plane

  // Create a new Perspective Camera
  const camera = new THREE.PerspectiveCamera(fov, aspect, near, far);

  // Set the position of the new camera based on the imported camera's position
  camera.position.set(0, 600, 500);

  return camera;
}

export function switchCamera(scene, name, camera, controls) {
  if(name == 'storageArea'){
    // console.log('{"area":"' + name + '"}');
    window.localStorage.setItem("rack_cam", "null");
  }
  const { position, target } = getPositionAndTarget(
    scene,
    name
  );

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
  });
}

export function moveToBin(object, camera, controls) {
  var aabb = new THREE.Box3().setFromObject(object);
  var center = aabb.getCenter(new THREE.Vector3());
  var size = aabb.getSize(new THREE.Vector3());
  const regex = /^[0-9][LR]B\d{5}$/;

  // console.log(object);
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

function findCameraByName(cameraList, name) {
  // Use Array.prototype.find to locate the camera by name
  const foundCamera = cameraList.find((cam) => cam.name.includes(name));

  if (foundCamera) {
    return foundCamera;
  } else {
    console.log('{"Camera Not Found":"' + name + '"}');
    return null;
  }
}

function getPositionAndTarget(scene, name) {
  let position = new THREE.Vector3();
  let target = new THREE.Vector3(0, 0, 0);
  let object = new THREE.Object3D();
  let box;
  let view = name.toString().split("_")[0];
  let number;

  // if(name.includes("rack")){
  //   const result = view.match(/\d+/);  // Matches one or more digits
  //   number = result ? parseInt(result[0], 10) : null;
  //   view = "rack";
  //   console.log(number);
  // }

  switch (view) {
    case "compoundArea":
      position.set(0, 550, 200);
      target.set(0, 0, -60);
      target.z = target.z+50;
      console.log('{"object":"null"}');
      break;
    case "storageArea":
      position.set(-78, 60, 20);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      target.y = target.y + 25;
      target.x = target.x + 5;
      // console.log('{"object":"null"}');
      break;
    case "inspectionArea":
      position.set(18, 50, -50);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "stagingArea":
      position.set(-114, 80, 0);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "activityArea":
      position.set(-45, 80, -20);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "receivingArea":
      position.set(22, 80, 0);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "yardArea":
      position.set(50, 270, -34);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "dockArea-IN":
      position.set(21.4, 120, -2);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      target.z = target.z + 25
      break;
    case "dockArea-OUT":
      position.set(-113.25, 120, -2);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      target.z = target.z + 25
      break;
    // case "rack":
    //   position.set(-120+(32*(number-1)), 50, -116.9);
    //   object = scene.getObjectByName(view+number+"r");
    //   box = new THREE.Box3().setFromObject(object);
    //   box.getCenter(target);
    //   break;
    case "rack5r":
      position.set(0, 50, -116.9);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "rack4r":
      position.set(-30, 50, -116.9);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "rack3r":
      position.set(-55, 50, -116.9);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "rack2r":
      position.set(-80, 50, -116.9);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "rack1r":
      position.set(-100, 50, -116.9);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "rack5l":
      position.set(-60, 50, -116.9);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "rack4l":
      position.set(-85, 50, -116.9);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "rack3l":
      position.set(-110, 50, -116.9);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "rack2l":
      position.set(-130, 50, -116.9);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
    case "rack1l":
      position.set(-160, 50, -116.9);
      object = scene.getObjectByName(view);
      box = new THREE.Box3().setFromObject(object);
      box.getCenter(target);
      break;
  }

  return { position, target };
}
