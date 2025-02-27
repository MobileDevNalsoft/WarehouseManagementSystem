
import { playAnimations } from "animations";
import * as THREE from 'three';
import { highlightArea, resetAreas } from "highlight";
import { initNodes, getShortestPath } from "navPath";
import { addSkyDome } from "skyDome";
import * as GLTFLoader from "gltfLoader";
export function intiGlobalFunctions(){


const { scene, camera, controls, renderer } = window.globalThis.threeDProps;
const dockIntrucks = ['truck_R1', 'truck_R2', 'truck_R3'];
const dockOuttrucks = ['truck_D_L1', 'truck_A2', 'truck_D_L3'];
const data = JSON.parse(window.localStorage.getItem("facilityData"));
let agvTask = ["receivingArea", "5RB30602", "3RB20602"]; // static bins for the agv digital twin.
const digitalTwin = document.getElementById("digitalTwin");
const pathButton = document.getElementById("path");  
const areasButton = document.getElementById("areas");

window.highlightedBins =[]
window.redBins = [];
window.orangeBins = [];
window.pathBins = [];
window.pathProps = {};


window.combinedPath = [];
window.checkpointCircles = [];
window.pathLine;
window.pathClock = new THREE.Clock();
window.bins = [];


const forkLift = new THREE.Group();
const agv = new THREE.Group();
const box = new THREE.Group();

const box2 = new THREE.Group();
const box3 = new THREE.Group();



window.intiatePathProperties= function(){
({ nodeMap: pathProps.nodeMap, nodes: pathProps.nodes, aisleBayPoints: pathProps.aisleBayPoints, intermediatePoints: pathProps.intermediatePoints } = initNodes(THREE, scene));


}


window.setNumberofTrucks = function(data){
  
    try {
      const type = data.split("_")[0].trim().toUpperCase();
      const count = parseInt(data.split("_")[1]);
      switch (type) {
          case "Y":
          stopAnimationsAndReset();
          for (let i = 1; i <= count; i++) {
            scene.getObjectByName("truck_Y" + i).visible = true;
          }
          for (let i = count + 1; i <= 20; i++) {
            scene.getObjectByName("truck_Y" + i).visible = false;
          }
          scene.getObjectByName("truck_A1").visible = false;
          scene.getObjectByName("truck_A2").visible = false;
          scene.getObjectByName("truck_A3").visible = false;
          break;
          case "DI":
            stopAnimationsAndReset();
            for(let i = 0; i < dockIntrucks.length; i++){
              if(i < count){
                scene.getObjectByName(dockIntrucks[i]).visible = true;
              }else{
                scene.getObjectByName(dockIntrucks[i]).visible = false;
              }
            }
            break;
          case "DO":
            stopAnimationsAndReset();
            for(let i = 0; i < dockOuttrucks.length; i++){
              if(i < count){
                scene.getObjectByName(dockOuttrucks[i]).visible = true;
              }else{
                scene.getObjectByName(dockOuttrucks[i]).visible = false;
              }
            }
            break;
      }
    } catch (e) {
      console.warn(e);
    }
  }

// enabling the trucks animation 
window.resetTrucksAnimation = function() {
    
    console.warn("scene "+scene);
    for (let i = 1; i <= 20; i++) {
      if ((i == 10 || i == 15 || i == 20) && scene.getObjectByName("truck_Y10")) {
        scene.getObjectByName("truck_Y10").visible = false;
        scene.getObjectByName("truck_Y15").visible = false;
        scene.getObjectByName("truck_Y20").visible = false;
      } else if(scene.getObjectByName("truck_Y" + i)) {
        scene.getObjectByName("truck_Y" + i).visible = true;
      }
    }
  
    if(scene.getObjectByName("truck_A1")){
      scene.getObjectByName("truck_A1").visible = true;
      scene.getObjectByName("truck_A2").visible = true;
      scene.getObjectByName("truck_A3").visible = true;
    }
  }

window.highlightBins = function(data){
    try {
        if (document.getElementById("path").classList.contains("focused") || document.getElementById("digitalTwin").classList.contains("focused")) {
          document.getElementById("path").classList.remove("focused");
          document.getElementById("digitalTwin").classList.remove("focused")
          stopAnimation();
        }
        try {
          highlightedBins.forEach((e) => {
            if (redBins.includes(e.trim())) {
              scene
                .getObjectByName(e.trim())
                .material.color.set(
                  parseInt(localStorage.getItem("red"), 16)
                );
            } else if (orangeBins.includes(e.trim())) {
              scene
                .getObjectByName(e.trim())
                .material.color.set(
                  0xfaf3e2
                );
            } else {
              // scene
              //   .getObjectByName(e.trim())
              //   .material.color.set(
              //     parseInt(localStorage.getItem("green"), 16)
              //   );
            }
            // scene.getObjectByName(e.trim()).material.color.set(0xfaf3e2);
          });
          highlightedBins = [];
          if (localStorage.getItem("prevBin")) {
            if (redBins.includes(localStorage.getItem("prevBin"))) {
              scene
                .getObjectByName(localStorage.getItem("prevBin"))
                .material.color.set(
                  parseInt(localStorage.getItem("red"), 16)
                );
            } else if (orangeBins.includes(localStorage.getItem("prevBin"))) {
              scene
                .getObjectByName(localStorage.getItem("prevBin"))
                .material.color.set(
                  0xfaf3e2
                );
            } else {
              scene
                .getObjectByName(localStorage.getItem("prevBin"))
                .material.color.set(
                  parseInt(localStorage.getItem("green"), 16)
                );
            }
            // scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(0xfaf3e2);
            localStorage.removeItem("prevBin");
          }
        } catch (e) {}

        highlightedBins = data
          .toString()
          .replaceAll("{", "")
          .replaceAll("}", "")
          .replace(" ", "")
          .split(",");

        data
          .toString()
          .split(",")
          .forEach((e) => {
            let bin = e.replaceAll("{", "").replaceAll("}", "").trim();
            scene.getObjectByName(bin).material.color.set(0x65543e);
            scene.getObjectByName(bin).material.opacity = 0.5;
          });
      } catch (e) {
        console.warn("error "+e);
      }
}

window.resetBinColors = function(){
  try {
    highlightedBins.forEach((e) => {
      if (redBins.includes(e.trim())) {
        scene
          .getObjectByName(e.trim())
          .material.color.set(parseInt(localStorage.getItem("red"), 16));
      } else if (orangeBins.includes(e.trim())) {
        scene
          .getObjectByName(e.trim())
          .material.color.set(
            0xfaf3e2
          );
      } else {
        scene
          .getObjectByName(e.trim())
          .material.color.set(
            parseInt(localStorage.getItem("green"), 16)
          );
      }
      // scene.getObjectByName(e.trim()).material.color.set(0xfaf3e2);
    });
    highlightedBins = [];
    if (localStorage.getItem("prevBin")) {
      if (redBins.includes(localStorage.getItem("prevBin"))) {
        scene
          .getObjectByName(localStorage.getItem("prevBin"))
          .material.color.set(parseInt(localStorage.getItem("red"), 16));
      } else if (orangeBins.includes(localStorage.getItem("prevBin"))) {
        scene
          .getObjectByName(localStorage.getItem("prevBin"))
          .material.color.set(
            0xfaf3e2
          );
      } else {
        scene
          .getObjectByName(localStorage.getItem("prevBin"))
          .material.color.set(
            parseInt(localStorage.getItem("green"), 16)
          );
      }
      // scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(0xfaf3e2);
      localStorage.removeItem("prevBin");
    }
  } catch (e) {
    console.warn("error from resetBinColors "+e);
  }
}

window.resetpathBinColors = function(){
  pathBins.forEach((e) => {
    if (redBins.includes(e.trim())) {
      scene
        .getObjectByName(e.trim())
        .material.color.set(parseInt(localStorage.getItem("red"), 16));
    } else if (orangeBins.includes(e.trim())) {
      scene
        .getObjectByName(e.trim())
        .material.color.set(
          0xfaf3e2
        );
    } else {
      scene
        .getObjectByName(e.trim())
        .material.color.set(
          parseInt(localStorage.getItem("green"), 16)
        );
    }
    // scene.getObjectByName(e.trim()).material.color.set(0xfaf3e2);
  });
}

window.binsStatus = function(data){
  try {  
    console.warn("data "+data);
    redBins = JSON.parse(data).red;
   orangeBins = JSON.parse(data).orange;
    for (let aisle = 1; aisle <= 5; aisle++) {
      for (let bay = 1; bay <= 3; bay++) {
        for (let level = 1; level <= 6; level++) {
          for (let position = 1; position <= 2; position++) {
            let leftBinId =
              aisle + "LB" + bay + "0" + level + "0" + position;
            let rightBinId =
              aisle + "RB" + bay + "0" + level + "0" + position;

            if (redBins.includes(leftBinId)) {
              scene
                .getObjectByName(leftBinId)
                .material.color.set(
                  parseInt(localStorage.getItem("red"), 16)
                );
            } else if (orangeBins.includes(leftBinId)) {
              // scene.getObjectByName(leftBinId).material.color.set(parseInt(localStorage.getItem("orange"), 16));
            } else {
              scene.getObjectByName(leftBinId).visible = false;
              // scene.getObjectByName(leftBinId).material.color.set(parseInt(localStorage.getItem("green"), 16));
            }

            if (redBins.includes(rightBinId)) {
              scene
                .getObjectByName(rightBinId)
                .material.color.set(
                  parseInt(localStorage.getItem("red"), 16)
                );
            } else if (orangeBins.includes(rightBinId)) {
              // scene.getObjectByName(rightBinId).material.color.set(parseInt(localStorage.getItem("orange"), 16));
            } else {
              scene.getObjectByName(rightBinId).visible = false;
              // scene.getObjectByName(rightBinId).material.color.set(parseInt(localStorage.getItem("green"), 16));
            }
          }
        }
      }
    }
  } catch (e) {
    console.warn("binsStatus " + e);
  }
}


window.switchToMainCam = function(data){
try{
 areaFocused = true;
  document.getElementById("wms-bot").style.display = "none";
    const { position, target } = window.getPositionAndTarget(
      scene,
      data
    );
    resetAreas(scene);
    playAnimations();
    dockIntrucks.forEach((truck) => {
      if(scene.getObjectByName(truck)){
        scene.getObjectByName(truck).visible = true;
      }
    });
    dockOuttrucks.forEach((truck) => {
      if(scene.getObjectByName(truck)){
        scene.getObjectByName(truck).visible = true;
      }
    });
    if (document.getElementById("areas").classList.contains("focused")) {
      document.getElementById("areas").classList.toggle("focused");
    }
    switch (data.toString().split("_")[0]) {
      case "storageArea":
        highlightArea(
          scene,
          "storageArea_block",
          { r: 50, g: 205, b: 50 },
          0.4
        );
        break;
      case "inspectionArea":
        highlightArea(
          scene,
          "inspectionArea_block",
          { r: 138, g: 46, b: 226 },
          0.4
        );
        break;
      case "stagingArea":
        highlightArea(
          scene,
          "stagingArea_block",
          { r: 255, g: 214, b: 10 },
          0.4
        );
        break;
      case "activityArea":
        highlightArea(
          scene,
          "activityArea_block",
          { r: 0, g: 128, b: 128 },
          0.4
        );
        break;
      case "receivingArea":
        highlightArea(
          scene,
          "receivingArea_block",
          { r: 166, g: 20, b: 93 },
          0.4
        );
        break;
      case "yardArea":
        highlightArea(
          scene,
          "yardArea_block",
          { r: 255, g: 99, b: 99 },
          0.4
        );
        break;
      case "dockArea-IN" || "dockArea-OUT":
        break;
      default:
        document.getElementById("wms-bot").style.display = "block";
        break;
    }
    // Create a GSAP timeline for smoother transitions
    const timeline = gsap.timeline();

    controls.enabled = false;
    controls.enableDamping = false;

    // Animate position and rotation simultaneously
    timeline
      .to(camera.position, {
        duration: 3,
        x: position.x,
        y: position.y,
        z: position.z,
        ease: "power3.inOut",
      })
      .to(
        controls.target,
        {
          duration: 3,
          x: target.x,
          y: target.y,
          z: target.z,
          ease: "power3.inOut",
          onUpdate: function () {
            camera.lookAt(controls.target); // Smoothly look at the target
          },
        },
        "<"
      );

    // Callbacks after animation completes
    timeline.call(() => {
      controls.enabled = true; // Re-enable controls after animation
      controls.enableDamping = true; // Re-enable damping after animation
    });
  }
  catch(e){
    console.warn("error from switchToMainCam"+e);
  }
  }


window.navigateToBin = function(data){
  try {
    moveToBin(scene.getObjectByName(data), camera, controls);
  } catch (e) {
    console.warn("error from navigateToBin "+e);
  }
}

     


window.load3dObjects = function(){
  const loader = new GLTFLoader.GLTFLoader();
  
  //fork lift model
  loader.load(
    "../glbs/forkLift_final_pro.glb",
    (gltf) => {
      const model = gltf.scene;

      model.scale.set(3.5, 2.5, 2.5);

      model.rotation.y = -(Math.PI / 2);
      forkLift.add(model);
      console.warn("fork lift model loaded");
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
      model.rotation.y = -Math.PI;
      agv.add(model);
      model.name = "agvModel";
      console.warn("agv model loaded");
    },
    (xhr) => {
      console.warn(`Loading progress: ${(xhr.loaded / xhr.total) * 100}%`);
    },
    (error) => {
      console.warn("An error occurred while loading the model:", error);
    }
  );

  if (data.model === "warehouse") {
    // Add skydome
    addSkyDome(scene);

    //Displaying the box data on hovering the box in few areas.
    
    //box model
    loader.load("../glbs/box.glb", (gltf) => {
      const model = gltf.scene;
      model.scale.set(10.5, 10.5, 3.5);
      model.rotation.y = -Math.PI;
      let box2Model = model.clone();
      let box3Model = model.clone();
      let box4Model = model.clone();
      let box5Model = model.clone();
      let box6Model = model.clone();
      let box7Model = model.clone();

      model.name = "boxA1_";
      scene.add(model);
      model.position.set(
        12.812496810374281,
        11.155107021331787,
        -54.67921206610449
      );

      model.traverse((child) => {
        if (child.isMesh) {
          child.name = "boxA1_";
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 0; // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });
      box2Model.traverse((child) => {
        if (child.isMesh) {
          child.name = "boxA2_";
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 0; // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });
      box3Model.traverse((child) => {
        if (child.isMesh) {
          child.name = "boxA3_";
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 0; // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });
      box4Model.traverse((child) => {
        if (child.isMesh) {
          child.name = "boxA4_";
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 1; // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });

      box5Model.traverse((child) => {
        if (child.isMesh) {
          child.name = "boxA5_";
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 1; // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });

      box6Model.traverse((child) => {
        if (child.isMesh) {
          child.name = "boxA6_";
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 0; // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });

      box7Model.traverse((child) => {
        if (child.isMesh) {
          child.name = "boxA7_";
          child.material = child.material.clone();
          child.material.transparent = true; // Enable transparency
          child.material.opacity = 0; // Set opacity (0 is fully transparent, 1 is fully opaque)
        }
      });
      box2.add(box2Model);
      scene.add(box2);
      box2.position.set(
        12.812496810374281,
        11.155107021331787,
        -49.061114295086436
      );

      box3.add(box3Model);
      scene.add(box3);
      box3.position.set(
        12.812496810374281,
        11.155107021331787,
        -46.80325333229198
      );

      scene.add(box4Model);
      box4Model.scale.set(8.5, 20.5, 5.5);
      box4Model.position.set(32.45690885576458, 10, -63.375218967468555);

      scene.add(box5Model);
      box5Model.scale.set(8.5, 20.5, 5.5);
      box5Model.position.set(40.45690885576458, 10, -63.375218967468555);

      scene.add(box6Model);
      box6Model.scale.set(10.5, 11, 15.5);
      box6Model.position.set(
        10.034054594205543,
        11.155107021331787,
        -130.33101405425458
      );

      scene.add(box7Model);
      box7Model.scale.set(10.5, 11, 15.5);
      box7Model.position.set(
        9.028635267710587,
        11.155107021331787,
        -105.6580355896106
      );

      console.warn("box models loaded");
    });
  }

 

}



window.startDigitalTwin = function(){
  if (digitalTwin.classList.contains("focused")) {
    digitalTwin.classList.remove("focused");
    stopAnimation();
    return;
  }
  digitalTwin.classList.add("focused");
  stopAnimation();

  if(highlightedBins.length>0){
    resetBinColors();
    console.log('{"object":"null"}');
  }
  document.getElementById("path").classList.remove("focused");

  pathBins = agvTask.filter((value,index,a)=> !value.toLowerCase().includes("area") && !value.toLowerCase().startsWith("p"));
  // fetching the shortestpath 
  ({ combinedPath: window.combinedPath, checkpointCircles:window.checkpointCircles, pathLine:window.pathLine, clock:window.pathClock } = getShortestPath(
    agvTask,
    pathProps.nodeMap,
    pathProps.nodes,
    pathProps.aisleBayPoints,
    pathProps.intermediatePoints,
    THREE,
    scene,
    camera,
    controls,
    agv,
    renderer,
    2000,
    agvTask[agvTask.length - 1],
    0xffff00,
    0x0099ff,
    "digitalTwin"
  ));
  
  pathBins.forEach((bin) => {
    if (!bin.toLowerCase().includes("area") && !bin.toLowerCase().startsWith("p") ) {
      try {
        scene.getObjectByName(bin).material.color.set(0x65543e);
      } catch (e) {
        console.warn("error in setting color to bins");
      }
    }
  });

  window.switchCamera("warehouse_wall");
}

window.startStopForkLiftPath =function(){
  if (areasButton.classList.contains("focused")) {
    areasButton.classList.remove("focused");
    areas.forEach((area) => {
      const obj = scene.getObjectByName(area.name);
      if (obj) {
        obj.visible = false;
      }
    });
  }

  if( digitalTwin.classList.contains("focused")){
    digitalTwin.classList.toggle("focused");
  }

  if(highlightedBins.length>0){
    resetBinColors();
    console.log('{"object":"null"}');
  }

  // Toggle the visibility of the input field and text
  if (!pathButton.classList.contains("focused")) {
    if (combinedPath.length != 0) {
     stopAnimation();
    }
    console.log('{"openPathDialog":"true","object":"null"}');
  } else {
    stopAnimation();
    pathButton.classList.remove("focused");
  }
}

window.getShoretestPathForTask = function(data){
    try{
        console.warn("getShoretestPathForTask "+data );
       
        bins=["p4",...data.split(","),"p1"];
        if(!pathButton.classList.contains("focused")){
          
          pathButton.classList.add("focused");
        }
        pathBins = bins.filter((value,index,a)=> !value.toLowerCase().includes("area") && !value.toLowerCase().startsWith("p"));
        
        ({combinedPath: window.combinedPath, checkpointCircles:window.checkpointCircles, pathLine:window.pathLine, clock:window.pathClock } = getShortestPath(
          bins,
          pathProps.nodeMap,
    pathProps.nodes,
    pathProps.aisleBayPoints,
    pathProps.intermediatePoints,
          THREE,
          scene,
          camera,
          controls,
          forkLift,
          renderer,
          1500,
          bins[bins.length - 1],
          0xffff00,
          0xcc0066,
          "path"
        ));
        
      }catch(e){
        console.warn("error "+e);
      }
     
      bins.forEach((bin) => {
        if (!bin.toLowerCase().includes("area")  && !bin.toLowerCase().startsWith("p")) {
          try {
            scene.getObjectByName(bin).material.color.set(0x65543e);
          } catch (e) {
            console.warn("error in setting color to bins");
          }
        }
      });
  
      window.switchCamera("warehouse_wall");

}


function stopAnimation() {
  combinedPath = [];
  checkpointCircles.forEach((circle) => scene.remove(circle));
  
  try {
    pathLine.forEach((line) => scene.remove(line));
  } catch (e) {
    console.warn("error in removing path line");
  }

 try{
  scene.remove(forkLift);
 }
 catch(e){
  console.warn("error in removing fork lift");
 }

 try{
  scene.remove(agv);
 }
 catch(e){
  console.warn("error in removing agv");
 }

  document.getElementById("agvtooltip").style.display = "none";
  resetpathBinColors();
  if (pathClock) {
    pathClock.stop();
  }
  return 
}

window.lpnLifeCycle = function(data){
  if(data == 'true'){
    document.getElementById("wms-bot").style.display = "none";
    switchCamera("lpnLifeCycle");
    animateLPNLifeCycle(scene);
  }else{
    document.getElementById("wms-bot").style.display = "block";
    removeLPNLifeCycle(scene);
  }
}

}




