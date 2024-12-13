import * as THREE from "three";
import { createRenderer } from "renderer";
import { initScene } from "scene";

document.addEventListener("DOMContentLoaded", async function () {
  window.localStorage.setItem("isLoaded", false);
  const renderer = createRenderer();

  if(JSON.parse(window.localStorage.getItem('facilityData')).facilityID == 2){
    document.getElementById('leftPanel').display = "none";
  }

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

  const areas = document.getElementById('areas');
 

  const pathButton = document.getElementById('path');
  // const inputContainer = document.getElementById('inputContainer');
  // const pathImage = pathButton.querySelector('img');
  // const pathText = pathButton.querySelector('p');
  areas.style.display = "block";
  pathButton.style.display = "block";
  // Add a click event listener to toggle the input field
  // pathButton.addEventListener('click', () => {
  //     if (inputContainer.style.display === 'none' || inputContainer.style.display === '') {
  //         inputContainer.style.display = 'block'; // Show the input field
  //         pathText.style.display = 'none'; // Hide the text
  //         pathImage.style.width = '0.6vw'; // Reduce the image size
  //     } else {
  //         inputContainer.style.display = 'none'; // Hide the input field
  //         pathText.style.display = 'block'; // Show the text
  //         pathImage.style.width = '1vw'; // Reset the image size
  //     }
  // });

}