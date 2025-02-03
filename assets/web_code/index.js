import * as THREE from "three";
import { createRenderer } from "renderer";
import { initScene } from "scene";

const data = JSON.parse(window.localStorage.getItem('facilityData'));
document.addEventListener("DOMContentLoaded", async function () {
  window.localStorage.setItem("isLoaded", false);
  const renderer = createRenderer();


  if(data.facilityID == 2){
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

  // camera.position.set(agvPosition.x,agvPosition.y,agvPosition.z);
  // camera.lookAt(agvPosition);

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
  const pathButton = document.getElementById('path');
  pathButton.style.display = "flex";
  if(data.model === 'warehouse'){
    document.getElementById("areas").style.display = "flex";
    document.getElementById("digitalTwin").style.display = "flex";
  }
  localStorage.setItem("orange","0x5e99ff");
  localStorage.setItem("red","0xff0000");
  localStorage.setItem("green","0x10ff04");
  window.localStorage.removeItem('lpnLifeCycle');
}