import * as THREE from "three";
import { loadModel } from "loader";
import { setupLights } from "lights";
import { animationMixer } from "animations";
import { addControls } from "controls";
import { addInteractions } from "interactions";

import { initNodes, getShortestPath } from "navPath";
import { highlightArea } from "highlight";

export async function initScene(renderer) {
  const container = document.getElementById("container");
  const scene = new THREE.Scene();
  scene.background = new THREE.Color(0x000000);

  // Set up renderer
  renderer.setSize(container.clientWidth, container.clientHeight);
  container.appendChild(renderer.domElement);

  // Add lights
  setupLights(scene);

  // Load main model
  const gltf = await loadModel(renderer, scene);
  const model = gltf.scene;
  scene.add(model);
  const data = JSON.parse(window.localStorage.getItem("facilityData"));

  // Animation setup
  const mixer = animationMixer(gltf);

  // Camera setup
  const camera = window.createCamera();
  scene.add(camera);

  // Add controls (for panning, zooming limits )
  const controls = addControls(camera, renderer);

  // Add interactions
  window.areaFocused = false;
  addInteractions(scene, model, camera, controls);

  scene.add(model);
  scene.add(camera);
  scene.updateMatrixWorld(true);


  const areasButton = document.getElementById("areas");

  
  // on clicking the digitalTwin button in left panel 
  digitalTwin.addEventListener("click", (e) => {
    startDigitalTwin();
  });

  // on clicking the shortest path button in left panel 
  document.getElementById("path").addEventListener("click", (e) =>  {
    startStopForkLiftPath();
  });

  // initially all the blocks are hidden.
  if (scene.getObjectByName("storageArea_block")) {
    scene.getObjectByName("storageArea_block").visible = false;
    scene.getObjectByName("yardArea_block").visible = false;
    scene.getObjectByName("stagingArea_block").visible = false;
    scene.getObjectByName("activityArea_block").visible = false;
    scene.getObjectByName("inspectionArea_block").visible = false;
    scene.getObjectByName("receivingArea_block").visible = false;
  }
// colors for the area blocks.
  const areas = [
    {
      name: "storageArea_block",
      color: { r: 50, g: 205, b: 50 },
      opacity: 0.4,
    },
    { name: "yardArea_block", color: { r: 255, g: 99, b: 99 }, opacity: 0.4 },
    {
      name: "stagingArea_block",
      color: { r: 255, g: 214, b: 10 },
      opacity: 0.4,
    },
    {
      name: "activityArea_block",
      color: { r: 0, g: 128, b: 128 },
      opacity: 0.4,
    },
    {
      name: "inspectionArea_block",
      color: { r: 138, g: 46, b: 226 },
      opacity: 0.4,
    },
    {
      name: "receivingArea_block",
      color: { r: 166, g: 20, b: 93 },
      opacity: 0.4,
    },
  ];

  // Button click function to highlight or hide all the area blocks.
  areasButton.addEventListener("click", () => {
    const isFocused = areasButton.classList.contains("focused");
    if (!isFocused) {
      window.switchCamera( "compoundArea");
    }
    areas.forEach((area) => {
      const obj = scene.getObjectByName(area.name);

      if (obj) {
        if (!isFocused) {
          highlightArea(scene, area.name, area.color, area.opacity); // Highlight the area
        } else {
          obj.visible = false; // Hide the area
        }
      }
    });

    areasButton.classList.toggle("focused");
  });

  // Resize listener
  window.addEventListener("resize", () => {
    renderer.setSize(container.clientWidth, container.clientHeight);
    camera.aspect = container.clientWidth / container.clientHeight;
    camera.updateProjectionMatrix();
  });
 
  window.globalThis.threeDProps = {
    scene: scene || null,        
    THREE: THREE || null,        
    clock: THREE?.Clock || null, 
    mixer: mixer || null,        
    camera: camera || null,      
    controls: controls || null   
};

  

}
