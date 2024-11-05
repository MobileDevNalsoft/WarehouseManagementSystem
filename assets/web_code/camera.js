import * as THREE from "three";

export function createCamera(gltf){
    const container = document.getElementById("container");
    const cameraList = gltf.cameras;

    const worldCam = findCameraByName(cameraList, "world_cam");

    const fov = worldCam.fov; // Field of view
    const aspect = container.clientWidth / container.clientHeight; // Aspect ratio
    const near = worldCam.near; // Near clipping plane
    const far = 3000; // Far clipping plane

    // Create a new Perspective Camera
    const camera = new THREE.PerspectiveCamera(fov, aspect, near, far);

    // Set the position of the new camera based on the imported camera's position
    camera.position.copy(worldCam.position);
    camera.quaternion.copy(worldCam.quaternion);
    camera.rotation.copy(worldCam.rotation); // Copy rotation if needed

    return camera;
}

export function switchCamera(scene, name, cameraList, camera, controls) {
  let selectedCamera;
  let center;
  const dropdown = document.querySelector(".dropdown-container");
  dropdown.style.display = "none";

  if (name == "warehouse") {
    const object = scene.getObjectByName("warehouse_wall");
    object.updateWorldMatrix(true, true);
    center = new THREE.Vector3(
      object.position.x,
      object.position.y,
      object.position.z
    );
    console.log('{"object":"null"}');
    selectedCamera = findCameraByName(cameraList, name);
  } else {
    const object = scene.getObjectByName(name);
    object.updateWorldMatrix(true, true);
    center = new THREE.Vector3(
      object.position.x,
      object.position.y,
      object.position.z
    );
    selectedCamera = findCameraByName(cameraList, name);
    if(name === "storageArea_cam"){
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
    timeline
      .to(camera.position, {
        duration: 3,
        x: selectedCamera.position.x,
        y: selectedCamera.position.y,
        z: selectedCamera.position.z,
        ease: "power3.inOut",
        onUpdate: function () {
          controls.target.copy(center); // Adjust target if necessary
        },
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
            // if (!selectedCamera.name.toString().includes("Area")) {
            controls.enabled = true;
            controls.enableDamping = true;
            // }
          },
        },
        0
      ); // Start rotation animation at the same time as position animation
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