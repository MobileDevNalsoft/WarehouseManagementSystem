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
import { switchCamera } from "camera";

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

  // Add skydome
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

  const forkLift = new THREE.Group();
  const agv = new THREE.Group();
  const box = new THREE.Group();
  
  const box2 = new THREE.Group();
  const box3 = new THREE.Group();

  const loader = new GLTFLoader.GLTFLoader();

  //fork lift model
  loader.load(
    "../glbs/forkLift_final_pro.glb", 
    (gltf) => {
      const model = gltf.scene;

      model.scale.set(3.5, 2.5, 2.5); 

      model.rotation.y = -(Math.PI / 2);
      forkLift.add(model);
      console.warn('fork lift model loaded');
    },
    (xhr) => {
      console.warn(`Loading progress: ${(xhr.loaded / xhr.total) * 100}%`);
    },
    (error) => {
      console.warn("An error occurred while loading the model:", error);
    }
  );

  //agv model
  loader.load(
    "../glbs/agv_with_boxes.glb",
    (gltf) => {
      const model = gltf.scene;
      model.scale.set(3.5, 3.5, 3.5); 
      model.rotation.y = -(Math.PI );
      agv.add(model);
      model.name = 'agvModel';
      console.warn('agv model loaded');
    },
    (xhr) => {
      console.warn(`Loading progress: ${(xhr.loaded / xhr.total) * 100}%`);
    },
    (error) => {
      console.warn("An error occurred while loading the model:", error);
    }
  );


  //box model
  loader.load(
    "../glbs/box.glb",
    (gltf) => {
      const model = gltf.scene;
      model.scale.set(10.5, 10.5, 3.5); 
      model.rotation.y = -(Math.PI );
      let box2Model = model.clone();
      let box3Model = model.clone();
      let box4Model= model.clone();
      let box5Model= model.clone();
      let box6Model= model.clone();
      let box7Model= model.clone();
      
      model.name = 'box1Area';
      scene.add(model);
      model.position.set(12.812496810374281, 11.155107021331787, -54.67921206610449); 
      
      model.traverse((child) => {
        if (child.isMesh) {
          child.name='box1Area';
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 0;     // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });
      box2Model.traverse((child) => {
        if (child.isMesh) {
          child.name='box2Area';
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 0;     // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });
      box3Model.traverse((child) => {
        if (child.isMesh) {
          child.name='box3Area';
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 0;     // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
        
      });
      box4Model.traverse((child) => {
        if (child.isMesh) {
          child.name='box4Area';
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 1;     // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });

      box5Model.traverse((child) => {
        if (child.isMesh) {
          child.name='box5Area';
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 1;     // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });

      box6Model.traverse((child) => {
        if (child.isMesh) {
          child.name='box6Area';
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 0;     // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });

      box7Model.traverse((child) => {
        if (child.isMesh) {
          child.name='box7Area';
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 0;     // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });
      box2.add(box2Model);
      scene.add(box2);
      box2.position.set(12.812496810374281, 11.155107021331787, -49.061114295086436);  

      box3.add(box3Model);
      scene.add(box3);
      box3.position.set(12.812496810374281, 11.155107021331787, -46.80325333229198);  
      
      scene.add(box4Model);
      box4Model.scale.set(8.5,20.5, 5.5);
      box4Model.position.set(32.45690885576458, 10, -63.375218967468555);  

      scene.add(box5Model);
      box5Model.scale.set(8.5,20.5, 5.5);
      box5Model.position.set(40.45690885576458, 10, -63.375218967468555);  

      scene.add(box6Model);
      box6Model.scale.set(10.5,11, 15.5);
      box6Model.position.set(10.034054594205543, 11.155107021331787, -130.33101405425458);  

      scene.add(box7Model);
      box7Model.scale.set(10.5,11, 15.5);
      box7Model.position.set(9.028635267710587, 11.155107021331787, -105.6580355896106);  


      console.warn('box models loaded');
    },
    
  //   (xhr) => {
  //     console.warn(`Loading progress: ${(xhr.loaded / xhr.total) * 100}%`);
  //   },
  //   (error) => {
  //     console.warn("An error occurred while loading the model:", error);
  //   }
  // )
  
  // const circleMaterial = new THREE.MeshBasicMaterial({
  //   color: 0xffff00, // Yellow
  //   side: THREE.DoubleSide,
  //   transparent: true,
  //   opacity: 0.8, // Start opacity
  // });

  // [
    // new THREE.Vector3(-125.16835094362332, 6.19, -91),
  //   new THREE.Vector3(-104.0724984440678, 6.19, -91),
  //  new THREE.Vector3(-84.20038905146427, 6.19, -91),
  //  new THREE.Vector3(-48.400711886208356, 6.19, -91),
  // new THREE.Vector3(-104.0, 6.19, -100.0),
  //  new THREE.Vector3(-14.035990842471623, 6.19, -91),
  //  new THREE.Vector3(-14.185505861653581, 6.19 ,-107.84385506088879),
  //  new THREE.Vector3(-14.114602359858907, 6.19, -131.37753635985396),
  //  new THREE.Vector3(-14.197195127688875, 6.19, -77.49013059402137),
  //  new THREE.Vector3(-14.264927005311744, 6.19, -61.64698518320672)
  // ].forEach((point) => { const circleGeometry = new THREE.CircleGeometry(1, 32); // Radius 2, 32 segments
  //    const circle = new THREE.Mesh(circleGeometry, circleMaterial);

  //    // Rotate to lie flat on the ground
  //    circle.rotation.x = -Math.PI / 2;

  //    // Position at the checkpoint
  //    circle.position.set(point.x, point.y + 0.1, point.z); // Slightly above ground
  //    scene.add(circle);});

  let combinedPath = [];
  let checkpointCircles = [];
  let highlightedBins = [];
  let pathLine;
  let clock;
  let bins=[];
  let forkLiftbins = [
    'p4',
    "4RB30602",
    '4LB30102',
    "1RB30602",
    "3RB20602",
    "2RB10601",
    "2RB30602",
    "3RB10102",
    "2LB20501",
    "2RB10601",
    "2LB20201",
    "stagingArea",
  ];

 

  let { nodeMap, nodes, aisleBayPoints, intermediatePoints } = initNodes(THREE);

  let agvTask = ["receivingArea","5RB30602","3RB20602"];
   let digitalTwin= document.getElementById("digitalTwin");
    document.getElementById("digitalTwin").addEventListener("click", (e) => {
      if (digitalTwin.classList.contains("focused")) {
        digitalTwin.classList.remove("focused");
        stopAnimation();
        return;
      }
   digitalTwin.classList.add("focused");
   stopAnimation();
   document.getElementById('path').classList.remove('focused');
   bins = agvTask;
  ({ combinedPath, checkpointCircles, pathLine, clock } = getShortestPath(
    agvTask,
    nodeMap,
    nodes,
    aisleBayPoints,
    intermediatePoints,
    THREE,
    scene,
    camera,
    controls,
    agv,
    renderer,2000,
    agvTask[agvTask.length-1],
    0xffff00,
    0x0099ff
  ));
  bins.forEach((bin) => {
    if(!bin.toLowerCase().includes('area')){
      try{
    scene.getObjectByName(bin).material.color.set(0x65543e);}
    catch(e){
      console.warn('error in setting color to bins');
    }
  }
   
  });
  
  switchCamera(scene, "warehouse_wall", camera, controls);

});

  console.warn("nodes", nodes);

  const pathButton = document.getElementById("path");

  const areasButton = document.getElementById("areas");

  document.getElementById("path").addEventListener("click", (e) => {
    console.warn("got inside path click");
    if (areasButton.classList.contains("focused")) {
      areasButton.classList.remove("focused");
      areas.forEach((area) => {
        const obj = scene.getObjectByName(area.name);
        if (obj) {
          obj.visible = false;
        }
      });
    }

   
   
    // Toggle the visibility of the input field and text
    if (!pathButton.classList.contains("focused")) {
      if (combinedPath.length != 0) {
        stopAnimation();
      }
      console.log('{"openPathDialog":"true","object":"null"}');
      console.warn(bins.toString());
    } else {
      stopAnimation();
    }
    pathButton.classList.toggle("focused");
  });

  function stopAnimation() {
    combinedPath = [];
    checkpointCircles.forEach((circle) => scene.remove(circle));
    try{ 
    pathLine.forEach((line) => scene.remove(line));}
    catch(e){
      console.warn('error in removing path line');
    }
    // scene.remove(pathLine);
    scene.remove(forkLift);
    scene.remove(agv);
    document.getElementById("agvtooltip").style.display = "none";
    try{
    bins.forEach((e) => {if(!e.toLowerCase().includes('area') && !e.toLowerCase().startsWith('p')){scene.getObjectByName(e).material.color.set(0xfaf3e2)}});}
    catch(e){
      console.warn('error in setting color back to original');
    }
    if (clock) {
      clock.stop();
    }
  }

document.getElementById('showPath').addEventListener('click',(e)=>{
  digitalTwin.classList.remove("focused");
  bins=forkLiftbins;
  localStorage.setItem("highlightBins", bins.toString());
        ({ combinedPath, checkpointCircles, pathLine, clock } = getShortestPath(
          bins,
          nodeMap,
          nodes,
          aisleBayPoints,
          intermediatePoints,
          THREE,
          scene,
          camera,
          controls,
          forkLift,
          renderer,
          2000,
    bins[bins.length-1],
    0xffff00,
    0xcc0066
        ));

        bins.forEach((bin) => {
          if(!bin.toLowerCase().includes('area')){
            try{
          scene.getObjectByName(bin).material.color.set(0x65543e);}
          catch(e){
            console.warn('error in setting color to bins');
          }
        }
         
        });

        switchCamera(scene, "warehouse_wall", camera, controls);
        
});

document.getElementById('stopAnimation').addEventListener('click',(e)=>{
  stopAnimation();
})


  
  if (scene.getObjectByName("storageArea_block")) {
    scene.getObjectByName("storageArea_block").visible = false;
    scene.getObjectByName("yardArea_block").visible = false;
    scene.getObjectByName("stagingArea_block").visible = false;
    scene.getObjectByName("activityArea_block").visible = false;
    scene.getObjectByName("inspectionArea_block").visible = false;
    scene.getObjectByName("receivingArea_block").visible = false;
  }

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

  areasButton.addEventListener("click", () => {
    const isFocused = areasButton.classList.contains("focused");
    if (!isFocused) {
      switchCamera(scene, "compoundArea", camera, controls);
    }
    areas.forEach((area) => {
      console.warn(isFocused);
      const obj = scene.getObjectByName(area.name);
      console.warn(obj);
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
