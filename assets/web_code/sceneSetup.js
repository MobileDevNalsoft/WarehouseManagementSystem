import * as THREE from "three";
import { loadModel } from "loader";
import { setupLights } from "lights";
import { animationMixer } from "animations";
import { createCamera } from "camera";
import { addControls } from "controls";
import { addInteractions } from "interactions";
import { localStorageSetup } from "localStorage";
import { addSkyDome } from "skyDome";

export async function initScene(renderer) {
  const container = document.getElementById("container");
  const scene = new THREE.Scene();
  scene.background = new THREE.Color(0xcccccc); // Set your desired background

  renderer.setSize(container.clientWidth, container.clientHeight);
  container.appendChild(renderer.domElement);

  setupLights(scene);

  const gltf = await loadModel();

  // addSkyDome(scene);

  const model = gltf.scene;

  const mixer = animationMixer(gltf);

  const camera = createCamera();

  const controls = addControls(camera, renderer);

  localStorageSetup(scene, camera, controls);

  addInteractions(scene, model, camera, controls);

  scene.add(model);

  scene.add(camera);

  scene.updateMatrixWorld(true);

  window.addEventListener("resize", () => {
    renderer.setSize(container.clientWidth, container.clientHeight);
    camera.aspect = container.clientWidth / container.clientHeight;
    camera.updateProjectionMatrix();
  });

  return { scene, camera, mixer, controls };
}
