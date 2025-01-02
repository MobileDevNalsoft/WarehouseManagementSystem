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
  // model.position.set(0, -11.2, 0);
  scene.add(model);

  const SPEED = 5;

  // scene.getObjectByName("Plane").visible = false;

  addSkyDome(scene);

  // weed
  // let weedGeom = createWeedGeometry();
  // let weedMat = createWeedMaterial();
  // let weed = new THREE.Mesh(weedGeom, weedMat);
  // scene.add(weed);

  // let backGeom = createBackGeometry();
  // let backMat = createBackMaterial();
  // let backMesh = new THREE.Mesh(backGeom, backMat);
  // scene.add(backMesh);

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
      
      box.add(model);
      scene.add(box);
      box.position.set(0.569215386407393, 6.19, -77.49013059402137); 
      console.warn('box model loaded');
    },
    
    (xhr) => {
      console.warn(`Loading progress: ${(xhr.loaded / xhr.total) * 100}%`);
    },
    (error) => {
      console.warn("An error occurred while loading the model:", error);
    }
  )
  
  // const circleMaterial = new THREE.MeshBasicMaterial({
  //   color: 0xffff00, // Yellow
  //   side: THREE.DoubleSide,
  //   transparent: true,
  //   opacity: 0.8, // Start opacity
  // });

  function createBackMaterial() {
    let m = new THREE.MeshBasicMaterial({
      color: 0xC0D0E6,
      side: THREE.BackSide,
      onBeforeCompile: (shader) => {
        shader.fragmentShader = `
          ${shader.fragmentShader}
        `.replace(
          `vec4 diffuseColor = vec4( diffuse, opacity );`,
          `
          vec3 col = mix(diffuse, diffuse + vec3(0.75), smoothstep(0.5, 0.7, vUv.y));
          vec4 diffuseColor = vec4( col, opacity );
          `
        );
        //console.log(shader.fragmentShader);
      }
    });
    m.defines = { USE_UV: "" };
    return m;
  }

  function createBackGeometry() {
    let g = new THREE.SphereGeometry(800,  // Radius of the hemisphere
      32,   // Width segments
      32,   // Height segments
      0,    // phiStart: Start angle in the X axis
      Math.PI * 2,  // phiLength: Full horizontal circle
      0,    // thetaStart: Start angle in the Y axis
      Math.PI / 1.75  // thetaLength: Only upper half to create a dome
      );
    g.translate(6, 0, 0);
    return g;
  }

  function createWeedMaterial() {
    let m = new THREE.MeshLambertMaterial({
      wireframe: false,
      onBeforeCompile: (shader) => {
        shader.uniforms.time = m.userData.uniforms.time;
    
        shader.vertexShader = `
          uniform float time;
          varying vec4 vPos;
          ${simpleNoise}
          ${shader.vertexShader}
        `.replace(
          `#include <begin_vertex>`,
          `#include <begin_vertex>
            vec2 waveUv = uv * vec2(5., 8.);
            float wave = smoothNoise(waveUv - vec2(time, 0.));
            transformed.y += wave * 2.;
            vPos = modelMatrix * vec4(transformed, 1.0);
          `
        );
    
        shader.fragmentShader = `
          uniform float time;
          varying vec4 vPos;
          ${simpleNoise}
          ${shader.fragmentShader}
        `.replace(
          `vec4 diffuseColor = vec4( diffuse, opacity );`,
          `
          vec3 col = vec3(0);
    
          vec2 weedUv = (vUv - vec2(time / 20., 0.)) * vec2(20., 1000.);
          float weed = smoothNoise(weedUv);
          col = mix(vec3(194.0 / 255.0, 178.0 / 255.0, 128.0 / 255.0), vec3(0.8, 0.8, 0.8), weed) * 0.75;
    
          float circleDist = length(vUv - 0.5);
          
          vec4 diffuseColor = vec4( col, opacity );
          `
        ).replace(
          `#include <dithering_fragment>`,
          `#include <dithering_fragment>
    
          // Change grey to sky blue color
          gl_FragColor.rgb = mix(vec3(0.7529, 0.8157, 0.9019), gl_FragColor.rgb, smoothstep(0.5, 0., circleDist));
          `
        );
      }
    });
    m.defines = { USE_UV: "" };
    m.userData = {
      uniforms: {
        time: {
          value: 0
        }
      }
    };
    return m;
  }
  
  function createWeedGeometry() {
    let g = new THREE.PlaneGeometry(1600, 1600, 200, 200);
    g.rotateX(Math.PI * -0.5);
    g.translate(6, -10, 0);
    return g;
  }

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
  // Create a GSAP timeline for smoother transitions
  const timeline = gsap.timeline();

  controls.enabled = false;
  controls.enableDamping = false;

  let warehouse = scene.getObjectByName('warehouse_wall');

  // Animate position and rotation simultaneously
  timeline
    .to(camera.position, {
      duration: 3,
      x: warehouse.position.x,
      y: warehouse.position.y+250,
      z: warehouse.position.z+100,
      ease: "power3.inOut",
    })
    .to(
      controls.target,
      {
        duration: 3,
        x: warehouse.position.x,
        y: warehouse.position.y,
        z: warehouse.position.z,
        ease: "power3.inOut",
        onUpdate: function () {
          camera.lookAt(controls.target); // Smoothly look at the target
        },
      },
      "<"
    );

  // Callbacks after animation completes
  timeline.call(() => {
    controls.enabled = true; 
    controls.enableDamping = true;
  });

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

     // Create a GSAP timeline for smoother transitions
  const timeline = gsap.timeline();

  controls.enabled = false;
  controls.enableDamping = false;

  let warehouse = scene.getObjectByName('warehouse_wall');

  // Animate position and rotation simultaneously
  timeline
    .to(camera.position, {
      duration: 3,
      x: warehouse.position.x,
      y: warehouse.position.y+250,
      z: warehouse.position.z+100,
      ease: "power3.inOut",
    })
    .to(
      controls.target,
      {
        duration: 3,
        x: warehouse.position.x,
        y: warehouse.position.y,
        z: warehouse.position.z,
        ease: "power3.inOut",
        onUpdate: function () {
          camera.lookAt(controls.target); // Smoothly look at the target
        },
      },
      "<"
    );

  // Callbacks after animation completes
  timeline.call(() => {
    controls.enabled = true; 
    controls.enableDamping = true;
  });
        
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
