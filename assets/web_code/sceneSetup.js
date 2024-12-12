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

  const clock = new THREE.Clock();

  // Agent setup
  const agentHeight = 3.0;
  const agentRadius = 5.25;
  const agent = new THREE.Mesh(
    new THREE.BoxGeometry(agentHeight, agentHeight, agentHeight),
    new THREE.MeshPhongMaterial({ color: "green" })
  );
  agent.position.y = agentHeight / 2;
  const agentGroup = new THREE.Group();
  agentGroup.add(agent);
  // agentGroup.position.set(-95.1758, 6.0069, -102.0932);
  scene.add(agentGroup);
  highlightArea(scene,`storageArea_block`, {"r":50,"g":205,"b":50},0.4);
  highlightArea(scene,`yardArea_block`, {"r":255,"g":159,"b":10},0.4);
  highlightArea(scene,`stagingArea_block`, {"r":255,"g":214,"b":10},0.4);
  highlightArea(scene,`activityArea_block`, {"r":0,"g":128,"b":128},0.4);
  highlightArea(scene,`inspectionArea_block`, {"r":138,"g":46,"b":226},0.4);
  highlightArea(scene,`receivingArea_block`, {"r":255,"g":105,"b":180},0.4);
  

  let combinedPath=[];
  let checkpointCircles=[];
  let highlightedBins = [];

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

document.getElementById("navigation_path").addEventListener("click", (e) => {
 ( { combinedPath, checkpointCircles } = getShortestPath(bins,nodeMap, nodes, aisleBayPoints, THREE, scene, camera, controls, agentGroup));
  console.warn(checkpointCircles,combinedPath);
  bins.forEach((bin)=>{
    scene.getObjectByName(bin).material.color.set(0x65543e);
  });
});



  function animateCircles(delta) {
    const time = clock.getElapsedTime();

    checkpointCircles.forEach((circle, index) => {
      // Scale the circle up and down
      const scale = 1 + 0.2 * Math.sin(time * 2); // Adjust frequency with time multiplier
      circle.scale.set(scale, scale, scale);

      // Optionally adjust opacity for a fading effect
      circle.material.opacity = 0.5 + 0.5 * Math.sin(time * 2);
    });
  }

function move(delta) {
  if (!combinedPath || combinedPath.length <= 0) {
    // console.warn("No combinedPath available for agent motion.");
    return;
  }

  const targetPosition = combinedPath[0];
  const direction = targetPosition.clone().sub(agentGroup.position);

  const distanceSq = direction.lengthSq();
  if (distanceSq > 0.05 * 0.05) {
    direction.normalize();
    // Calculate the target angle
  const targetAngle = Math.atan2(direction.x, direction.z);
  // Get current angle and calculate the shortest path
  let currentAngle = agentGroup.rotation.y;
  const angleDifference =
    THREE.MathUtils.euclideanModulo(
      targetAngle - currentAngle + Math.PI,
      Math.PI * 2
    ) - Math.PI;

    if (Math.abs(angleDifference) > 0.01) {
      currentAngle += angleDifference * delta * 5; // Smoothly interpolate rotation
      agentGroup.rotation.y = currentAngle;

    }
    const moveDistance = Math.min(delta * SPEED, Math.sqrt(distanceSq));
    agentGroup.position.add(direction.multiplyScalar(moveDistance));
  } else {
    agentGroup.position.copy(targetPosition);
    combinedPath.shift();
  }
}


// Game loop
const delta = clock.getDelta();
const gameLoop = () => {
 move(clock.getDelta());
 animateCircles(delta);
 controls.update();
 renderer.render(scene, camera);
 requestAnimationFrame(gameLoop);
};
gameLoop();

  // Resize listener
  window.addEventListener("resize", () => {
    renderer.setSize(container.clientWidth, container.clientHeight);
    camera.aspect = container.clientWidth / container.clientHeight;
    camera.updateProjectionMatrix();
  });

  return { scene, camera, mixer, controls };
}