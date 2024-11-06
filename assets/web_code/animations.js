import * as THREE from "three";

export function animationMixer(gltf) {
  const mixer = new THREE.AnimationMixer(gltf.scene);
  gltf.animations.forEach((clip) => {
    mixer.clipAction(clip).play();
  });

  return mixer;
}

export function resetTrucksAnimation(scene) {
  for (let i = 1; i <= 20; i++) {
    if (i == 10 || i == 15 || i == 20) {
      scene.getObjectByName("truck_Y10").visible = false;
      scene.getObjectByName("truck_Y15").visible = false;
      scene.getObjectByName("truck_Y20").visible = false;
    } else {
      scene.getObjectByName("truck_Y" + i).visible = true;
    }
  }

  scene.getObjectByName("truck_A1").visible = true;
  scene.getObjectByName("truck_A2").visible = true;
  scene.getObjectByName("truck_A3").visible = true;
  window.localStorage.removeItem("resetTrucks");
}
