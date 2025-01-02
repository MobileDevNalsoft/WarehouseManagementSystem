import * as THREE from "three";
import { createRenderer } from "renderer";
import { initScene } from "scene";

document.addEventListener("DOMContentLoaded", async function () {
  window.localStorage.setItem("isLoaded", false);
  const renderer = createRenderer();

  if(JSON.parse(window.localStorage.getItem('facilityData')).facilityID == 2){
    document.getElementById('leftPanel').display = "none";
  }

  const {scene, camera, mixer, controls, agvModel} = await initScene(renderer);

  const clock = new THREE.Clock();

  let tooltip = document.getElementById('agvtooltip');

// Create a Vector3 to store AGV's world position
let agvPosition = new THREE.Vector3();

// Assuming you have your AGV model and it's named `agvModel`
// and the AGV's position is updated with animation

function updateTooltip() {
  // Get AGV's position in world space (you may need to use an animation callback for updates)
  let truck = scene.getObjectByName('agvModel');
  truck.getWorldPosition(agvPosition);

  // Convert the 3D world position to 2D screen coordinates
  let vector = new THREE.Vector3();
  vector.setFromMatrixPosition(truck.matrixWorld);
  vector.project(camera); // camera is the Three.js camera object

  // Convert the 2D screen space coordinates into CSS coordinates
  let widthHalf = window.innerWidth / 2;
  let heightHalf = window.innerHeight / 2;

  let x = (vector.x * widthHalf) + widthHalf;
  let y = -(vector.y * heightHalf) + heightHalf;

  // Position the tooltip and show it
  tooltip.style.left = `${x}px`;
  tooltip.style.top = `${y}px`;
  tooltip.style.display = 'block';
}

  // Step 4: Render loop
  function animate() {
    requestAnimationFrame(() => {
      animate(renderer, scene, camera);
      if(scene.getObjectByName('agvModel')){
        updateTooltip();
      }
    });
    const delta = clock.getDelta(); // seconds.
    mixer.update(delta); // Update the animation mixer
    controls.update();
    renderer.render(scene, camera);
    window.localStorage.setItem("isLoaded", true);
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
  areas.style.display = "flex";
  pathButton.style.display = "flex";
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