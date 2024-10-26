import * as THREE from "three";
import { setupLights } from "./lights";
import { createCamera } from "./camera";
import { loadModel } from "./modelLoader";
import { animationMixer } from "./aniMaster";

export function initScene(container, renderer) {
    const scene = new THREE.Scene();
    scene.background = new THREE.Color(0xcccccc); // Set your desired background

    renderer.setSize(container.clientWidth, container.clientHeight);
    container.appendChild(renderer.domElement());

    setupLights(scene);

    const model = loadModel();

    const camera = createCamera(model, container);

    scene.add(model);

    scene.updateMatrixWorld(true);

    window.addEventListener("resize", () => {
        renderer.setSize(container.clientWidth, container.clientHeight);
        camera.aspect = container.clientWidth / container.clientHeight;
        camera.updateProjectionMatrix();
    });

    const { mixer, clock } = animationMixer(model);

    animate(renderer, scene, camera, mixer, clock);


    return scene;
}

function animate(renderer, scene, camera) {
    requestAnimationFrame(() => animate(renderer, scene, camera));
    const delta = clock.getDelta(); // seconds.
    mixer.update(delta); // Update the animation mixer
    renderer.render(scene, camera);
}