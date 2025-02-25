import * as THREE from "three";
import { createRenderer } from "renderer";
import { initScene } from "scene";
import { initCamera } from "camera";
import { intiGlobalFunctions } from "initFunctions";

const data = JSON.parse(window.localStorage.getItem('facilityData'));
document.addEventListener("DOMContentLoaded", async function () {
  await initCamera(); 
  window.localStorage.setItem("isLoaded", false);
  const renderer = createRenderer();  


  if(data.facilityID == 2){
    document.getElementById('leftPanel').display = "none";
  }
  
  //starting point for the 3d model
 await initScene(renderer);
 const clock = new THREE.Clock();
 window.globalThis.threeDProps = {
   ...window.globalThis.threeDProps, // Preserve existing properties
   "clock": clock,
   renderer:renderer
};
 intiGlobalFunctions();
 load3dObjects();
 intiatePathProperties();



const { scene, camera, controls,mixer } = window.globalThis.threeDProps;

  let tooltip = document.getElementById('agvtooltip');

// Create a Vector3 to store AGV's world position
let agvPosition = new THREE.Vector3();


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
// to animate each frame in the model : a recursive call to animate function.
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
    // window.parent.postMessage({"isLoaded": true});
    window.localStorage.setItem("isLoaded", true);
  }

  initAfterModelLoaded();
  animate();

});

// operation done after the model is loaded and ready to render. 
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



  let isEmitted =  window.dispatchEvent(new CustomEvent("chatChannel", { detail: "Hello from JavaScript!" }));
  console.warn("event emmitted "+isEmitted);
   // Listen for events coming from Dart
  //  window.addEventListener("chatChannel", (event) => {
  //   console.log(" JavaScript received from Dart:", event.detail);
  // });

  // Send an event to Dart after 3 seconds
  // setTimeout(() => {
  //  
  // }, 3000);
}

// window.parent.postMessage({"testingEvent":"test"});

// window.parent.postMessage("Hello from JavaScript!");
