import * as THREE from "three";

export function createCamera(gltf) {
  const container = document.getElementById("container");
  const cameraList = gltf.cameras;

  const worldCam = findCameraByName(cameraList, "warehouse_cam");

  const fov = worldCam.fov; // Field of view
  const aspect = container.clientWidth / container.clientHeight; // Aspect ratio
  const near = 0.1; // Near clipping plane
  const far = 3000; // Far clipping plane

  // Create a new Perspective Camera
  const camera = new THREE.PerspectiveCamera(fov, aspect, near, far);

  // Set the position of the new camera based on the imported camera's position
  camera.position.copy(worldCam.position);
  camera.quaternion.copy(worldCam.quaternion);
  // camera.rotation.copy(worldCam.rotation); // Copy rotation if needed

  return camera;
}

export function switchCamera(scene, name, cameraList, camera, controls) {
  const {position, target} = getPositionAndTarget(scene, "world");
  let selectedCamera;
  let center = new THREE.Vector3();
  const dropdown = document.querySelector(".dropdown-container");
  dropdown.style.display = "none";

  if (name.toString().split("_").slice(0, 2).join("_") == "warehouse") {
    const object = scene.getObjectByName("warehouse_wall");
    object.updateWorldMatrix(true, true);
    const box = new THREE.Box3().setFromObject(object);
    box.getCenter(center);
    console.log('{"object":"null"}');
    selectedCamera = findCameraByName(
      cameraList,
      name.toString().split("_").slice(0, 2).join("_")
    );
  } else {
    const object = scene.getObjectByName(name);
    object.updateWorldMatrix(true, true);
    const box = new THREE.Box3().setFromObject(object);
    box.getCenter(center);
    selectedCamera = findCameraByName(
      cameraList,
      name.toString().split("_").slice(0, 2).join("_")
    );
    if (name.toString().split("_").slice(0, 2).join("_") === "storageArea") {
      dropdown.style.display = "block";
      console.log('{"object":"null"}');
    }
  }

  if (selectedCamera) {
    // Create a GSAP timeline for smoother transitions
    const timeline = gsap.timeline();

    controls.enabled = false;
    controls.enableDamping = false;

    // Animate position and rotation simultaneously
    timeline.to(camera.position, {
      duration: 3,
      x: position.x,
      y: position.y,
      z: position.z,
      ease: "power3.inOut",
      onUpdate: function () {
        controls.target.copy(target); // Adjust target if necessary
        camera.lookAt(target);
      },
      onComplete: function () {
        // if (!selectedCamera.name.toString().includes("Area")) {
        controls.enabled = true;
        controls.enableDamping = true;
        controls.target.copy(target); // Adjust target if necessary
        controls.update();
        // }
      },
    }); // Start rotation animation at the same time as position animation
  }
}

export function moveToBin(object, camera, controls) {
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

function getPositionAndTarget(scene, view) {
  let position = new THREE.Vector3();
  let target = new THREE.Vector3(0,0,0);
  let object = new THREE.Object3D();

  switch (view) {
    case "world":
      position.set(0, 500, 0);

      object = scene.getObjectByName("flooring");
      object.updateWorldMatrix(true, true);
      const box = new THREE.Box3().setFromObject(object);
      // box.getCenter(target);
      break;
  }

  return {position, target};
}
