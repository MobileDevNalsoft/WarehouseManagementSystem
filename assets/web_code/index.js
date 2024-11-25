import * as THREE from "three";
import { createRenderer } from "renderer";
import { initScene } from "scene";

document.addEventListener("DOMContentLoaded", async function () {
  const renderer = createRenderer();

  const {scene, camera, mixer, controls} = await initScene(renderer);

  const clock = new THREE.Clock();

  // Step 4: Render loop
  function animate() {
    requestAnimationFrame(() => {
      animate(renderer, scene, camera);
      window.localStorage.setItem("isLoaded", true);
    });
    const delta = clock.getDelta(); // seconds.
    mixer.update(delta); // Update the animation mixer
    controls.update();
    renderer.render(scene, camera);
  }

  initAfterModelLoaded();
  animate();

});

function initAfterModelLoaded(){

  const toggleButton = document.getElementById('togglePanel');
  toggleButton.style.display = "block";
}