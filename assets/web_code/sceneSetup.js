import * as THREE from "three";
import { loadModel } from "loader";
import { setupLights } from "lights";
import { animationMixer } from "animations";
import { createCamera } from "camera";
import { addControls } from "controls";
import { addInteractions } from "interactions";
import { localStorageSetup } from "localStorage";
import { addSkyDome } from "skyDome";
import { initNodes, getShortestPath } from "navPath";
import * as GLTFLoader from "gltfLoader";
import { highlightArea } from "highlight";
import { switchCamera} from "camera";
import {DRACOLoader} from "draco";




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

  const SPEED = 5;

  // Add sky dome
  addSkyDome(scene);

  // Animation setup
  const mixer = animationMixer(gltf);

  // Camera setup
  const camera = createCamera();
  scene.add(camera);

  // Add controls
  const controls = addControls(camera, renderer);

  // Local storage setup
  localStorageSetup(scene, camera, controls);

  // Add interactions
  addInteractions(scene, model, camera, controls);

  scene.add(model);

  scene.add(camera);

  scene.updateMatrixWorld(true);

  // const clock = new THREE.Clock();

  // Agent setup
  const agentHeight = 3.0;
  const agentRadius = 5.25;
  // const agent = new THREE.Mesh(
  //   new THREE.BoxGeometry(agentHeight, agentHeight, agentHeight),
  //   new THREE.MeshPhongMaterial({ color: "green" })
  // );
  // agent.position.y = agentHeight / 2;
  const agentGroup = new THREE.Group();
  // agentGroup.add(agent);
  // agentGroup.position.set(-95.1758, 6.0069, -102.0932);
  // scene.add(agentGroup);
  const loader = new GLTFLoader.GLTFLoader();
  // const dracoLoader = new DRACOLoader();
  // dracoLoader.setDecoderPath('https://cdn.jsdelivr.net/npm/three@0.114.0/examples/js/libs/draco/');
  // loader.setDRACOLoader( dracoLoader );
  loader.load(
    '../glbs/forkLift_final_pro.glb', // Replace with the path to your GLB file
    (gltf) => {
      const model = gltf.scene;
      
      model.scale.set(2.5, 2.5, 2.5); // Adjust scale as needed
  
      // Add the model to the group
      model.rotation.y = -(Math.PI/2) ; 
      agentGroup.add(model);

      // scene.add(agentGroup);
      console.log('Model loaded successfully');
    },
    (xhr) => {
      // Optional loading progress
      console.log(`Loading model: ${(xhr.loaded / xhr.total) * 100}% complete`);
    },
    (error) => {
      // Handle loading errors
      console.error('An error occurred while loading the model:', error);
    }
  );

  let combinedPath=[];
  let checkpointCircles=[];
  let highlightedBins = [];
  let pathLine;
  let clock;
  let bins = [
    "1LB20201",
    "5RB10602",
    "1LB10201",
    "1RB30602",
    "3RB20602",
    "2RB10601",
    "2RB30602",
    "3RB10102",
    "2LB20501",
    "2RB10601",
    "2LB20201"
  ]


  
let {nodeMap,nodes,aisleBayPoints}= initNodes(THREE);

console.warn("nodes",nodes);

const pathButton = document.getElementById('path');

const areasButton = document.getElementById('areas');
document.getElementById("path").addEventListener("click", (e) => {
  
  if(areasButton.classList.contains('focused')){
    areasButton.classList.remove('focused');
    areas.forEach(area => {
        const obj = scene.getObjectByName(area.name);
        if (obj) {
                obj.visible = false; 
        }
    });
  }
 
  // Toggle the visibility of the input field and text
  if (!pathButton.classList.contains('focused')) {
      if(combinedPath.length!=0){
        stopAnimation();
      }
      console.warn(bins.toString());
      // localStorage.setItem("highlightBins",bins.toString());
      ( { combinedPath, checkpointCircles,pathLine, clock } = getShortestPath(bins,nodeMap, nodes, aisleBayPoints, THREE, scene, camera, controls, agentGroup,renderer));
     
      bins.forEach((bin)=>{
        scene.getObjectByName(bin).material.color.set(0x65543e);
      });
  } else {
    stopAnimation();
      }
  pathButton.classList.toggle('focused');   
});

function stopAnimation(){
  combinedPath=[];
  checkpointCircles.forEach((circle)=> scene.remove(circle));
  scene.remove(pathLine);
  scene.remove(agentGroup);
  bins.forEach((e)=>scene.getObjectByName(e).material.color.set(0xfaf3e2));
  if(clock){
  clock.stop();}
}


  if(scene.getObjectByName("storageArea_block")){
    scene.getObjectByName("storageArea_block").visible=false;
    scene.getObjectByName("yardArea_block").visible=false;
    scene.getObjectByName("stagingArea_block").visible=false;
    scene.getObjectByName("activityArea_block").visible=false;
    scene.getObjectByName("inspectionArea_block").visible=false;
    scene.getObjectByName("receivingArea_block").visible=false;
  }


const areas = [
    { name: "storageArea_block", color: { r: 50, g: 205, b: 50 }, opacity: 0.4 },
    { name: "yardArea_block", color: { r: 255, g: 99, b: 99 }, opacity: 0.4 },
    { name: "stagingArea_block", color: { r: 255, g: 214, b: 10 }, opacity: 0.4 },
    { name: "activityArea_block", color: { r: 0, g: 128, b: 128 }, opacity: 0.4 },
    { name: "inspectionArea_block", color: { r: 138, g: 46, b: 226 }, opacity: 0.4 },
    { name: "receivingArea_block", color: { r: 166, g: 20, b: 93 }, opacity: 0.4 },
];

areasButton.addEventListener("click", () => {
    const isFocused = areasButton.classList.contains('focused');
    if (!isFocused) {
      switchCamera(scene, "compoundArea", camera, controls);  } 
    areas.forEach(area => {
      console.warn(isFocused);
        const obj = scene.getObjectByName(area.name);
        console.warn(obj)
        if (obj) {
            if (!isFocused) {
               
                highlightArea(scene, area.name, area.color, area.opacity); // Highlight the area

            } else {
                obj.visible = false; // Hide the area
            }
        }
    });

    areasButton.classList.toggle('focused');
});

// areasButton.addEventListener("click", (e) => {
  


//   if(!(areasButton.classList.contains('focused'))){
//     highlightArea(scene,`storageArea_block`, {"r":50,"g":205,"b":50},0.4);
//     highlightArea(scene,`yardArea_block`, {"r":255,"g":159,"b":10},0.4);
//     highlightArea(scene,`stagingArea_block`, {"r":255,"g":214,"b":10},0.4);
//     highlightArea(scene,`activityArea_block`, {"r":0,"g":128,"b":128},0.4);
//     highlightArea(scene,`inspectionArea_block`, {"r":138,"g":46,"b":226},0.4);
//     highlightArea(scene,`receivingArea_block`, {"r":255,"g":105,"b":180},0.4);
// }
// else {
//   scene.getObjectByName("storageArea_block").visible=false;
//   scene.getObjectByName("yardArea_block").visible=false;
//   scene.getObjectByName("stagingArea_block").visible=false;
//   scene.getObjectByName("activityArea_block").visible=false;
//   scene.getObjectByName("inspectionArea_block").visible=false;
//   scene.getObjectByName("receivingArea_block").visible=false;

// }

// areasButton.classList.toggle('focused');
 
// });


  // Resize listener
  window.addEventListener("resize", () => {
    renderer.setSize(container.clientWidth, container.clientHeight);
    camera.aspect = container.clientWidth / container.clientHeight;
    camera.updateProjectionMatrix();
  });

  return { scene, camera, mixer, controls };
}