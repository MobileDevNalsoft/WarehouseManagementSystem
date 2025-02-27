import * as THREE from "three";

const actions = [];

// to load all the animations present in the 3d model.
export function animationMixer(gltf) {
  const mixer = new THREE.AnimationMixer(gltf.scene);
  gltf.animations.forEach((clip) => {
    const action = mixer.clipAction(clip);
    action.play();
    actions.push(action);
  });
  // if(gltf.scene.getObjectByName("truck_Y10")){
    // resetTrucksAnimation(gltf.scene);
  // }
  return mixer;
}

window.stopAnimationsAndReset = function() {
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

