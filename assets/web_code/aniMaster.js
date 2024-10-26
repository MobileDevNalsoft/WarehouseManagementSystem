import * as THREE from "three";

export function animationMixer(model) {
    const mixer = new THREE.AnimationMixer(gltf.scene);
    gltf.animations.forEach((clip) => {
        mixer.clipAction(clip).play();
    });

    // Render loop
    const clock = new THREE.Clock();

    return {mixer, clock};
}