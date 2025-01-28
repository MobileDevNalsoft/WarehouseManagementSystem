import * as THREE from "three";

const actions = [];

export function animationMixer(gltf) {
  const mixer = new THREE.AnimationMixer(gltf.scene);
  gltf.animations.forEach((clip) => {
    const action = mixer.clipAction(clip);
    action.play();
    actions.push(action);
  });
  if(gltf.scene.getObjectByName("truck_Y10")){
    resetTrucksAnimation(gltf.scene);
  }
  return mixer;
}

export function stopAnimationsAndReset() {
  actions.forEach((action) => {
    action.stop(); // Stop the animation completely
    action.reset(); // Reset it to the starting position
  });
}

export function playAnimations() {
  actions.forEach((action) => {
    action.play();
  });
}

export function resetTrucksAnimation(scene) {
  for (let i = 1; i <= 20; i++) {
    if ((i == 10 || i == 15 || i == 20) && scene.getObjectByName("truck_Y10")) {
      scene.getObjectByName("truck_Y10").visible = false;
      scene.getObjectByName("truck_Y15").visible = false;
      scene.getObjectByName("truck_Y20").visible = false;
    } else if(scene.getObjectByName("truck_Y" + i)) {
      scene.getObjectByName("truck_Y" + i).visible = true;
    }
  }

  if(scene.getObjectByName("truck_A1")){
    scene.getObjectByName("truck_A1").visible = true;
    scene.getObjectByName("truck_A2").visible = true;
    scene.getObjectByName("truck_A3").visible = true;
  }
  window.localStorage.removeItem("resetTrucks");
}
