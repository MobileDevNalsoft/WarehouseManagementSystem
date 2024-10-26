import * as THREE from "three";

export function createCamera(model, container){
    const cameraList = model.cameras;

    const worldCam = findCameraByName("world_cam");

    const fov = worldCam.fov; // Field of view
    const aspect = container.clientWidth / container.clientHeight; // Aspect ratio
    const near = worldCam.near; // Near clipping plane
    const far = 3000; // Far clipping plane

    // Create a new Perspective Camera
    camera = new THREE.PerspectiveCamera(fov, aspect, near, far);

    // Set the position of the new camera based on the imported camera's position
    camera.position.copy(worldCam.position);
    camera.quaternion.copy(worldCam.quaternion);
    camera.rotation.copy(worldCam.rotation); // Copy rotation if needed

    return camera;
}

function findCameraByName(cameraList, name) {
    // Use Array.prototype.find to locate the camera by name
    const foundCamera = cameraList.find((cam) => cam.name === name);
  
    if (foundCamera) {
      return foundCamera;
    } else {
      console.log('{"Camera Not Found":"' + name + '"}');
      return null;
    }
  }