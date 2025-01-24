import { resetTrucksAnimation } from "animations";
import { switchCamera } from "camera";
import { highlightBinsFromSearch } from "interactions";
import { moveToBin, getPositionAndTarget } from "camera";
import { globalState } from "globalState";
import { highlightArea, resetAreas } from "highlight";



export function localStorageSetup(scene, camera, controls) {
  // Local Storage Setup

  let actualBinColor;
  let highlightedBins = [];
  window.localStorage.setItem("switchToMainCam", "null");

  window.addEventListener("storage", (event) => {
    switch (event.key) {
      case "switchToMainCam":

        if (event.newValue != "") {
          document.getElementById("wms-bot").style.display = "none";
          const { position, target } = getPositionAndTarget(
            scene,
            event.newValue
          );
          resetAreas(scene);
          if (document.getElementById('areas').classList.contains('focused')) {
            document.getElementById('areas').classList.toggle('focused');
          }
          switch (event.newValue.toString().split("_")[0]) {
            case "storageArea":
              highlightArea(scene, "storageArea_block", { r: 50, g: 205, b: 50 }, 0.4);
              break;
            case "inspectionArea":
              highlightArea(scene, "inspectionArea_block", { r: 138, g: 46, b: 226 }, 0.4);
              break;
            case "stagingArea":
              highlightArea(scene, "stagingArea_block", { r: 255, g: 214, b: 10 }, 0.4);
              break;
            case "activityArea":
              highlightArea(scene, "activityArea_block", { r: 0, g: 128, b: 128 }, 0.4);
              break;
            case "receivingArea":
              highlightArea(scene, "receivingArea_block", { r: 166, g: 20, b: 93 }, 0.4);
              break;
            case "yardArea":
              highlightArea(scene, "yardArea_block", { r: 255, g: 99, b: 99 }, 0.4);
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
            globalState.setAreaFocused(false);
          });
        }
        break;
      case "isRackDataLoaded":
        isRackDataLoaded = event.newValue;
        break;
      case "setNumberOfTrucks":
        try {
          for (let i = 1; i <= parseInt(event.newValue); i++) {
            scene.getObjectByName("truck_Y" + i).visible = true;
          }
          for (let i = parseInt(event.newValue) + 1; i <= 20; i++) {
            scene.getObjectByName("truck_Y" + i).visible = false;
          }
        } catch (e) { }
        // window.localStorage.removeItem("setNumberOfTrucks");
        break;
      case "resetTrucks":
        resetTrucksAnimation(scene);
        break;

      case "highlightBins":
        try {
          if (document.getElementById('path').classList.contains('focused')) {
            document.querySelector('#path').click();
          }
          let redBins = JSON.parse(localStorage.getItem("binsStatus")).red;
          let orangeBins = JSON.parse(localStorage.getItem("binsStatus")).orange;
          try {
            highlightedBins.forEach((e) => {
              if (redBins.includes(e.trim())) {
                scene.getObjectByName(e.trim()).material.color.set(parseInt(localStorage.getItem("red"), 16));
              }
              else if (orangeBins.includes(e.trim())) {
                scene.getObjectByName(e.trim()).material.color.set(parseInt(localStorage.getItem("orange"), 16));
              }
              else {
                scene.getObjectByName(e.trim()).material.color.set(parseInt(localStorage.getItem("green"), 16));
              }
              // scene.getObjectByName(e.trim()).material.color.set(0xfaf3e2);
            });
            highlightedBins = [];
            if (localStorage.getItem("prevBin")) {
              if (redBins.includes(localStorage.getItem("prevBin"))) {
                scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(parseInt(localStorage.getItem("red"), 16));
              }
              else if (orangeBins.includes(localStorage.getItem("prevBin"))) {
                scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(parseInt(localStorage.getItem("orange"), 16));
              } else {
                scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(parseInt(localStorage.getItem("green"), 16));
              }
              // scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(0xfaf3e2);
              localStorage.removeItem("prevBin");
            }
          } catch (e) { }

          highlightedBins = localStorage
            .getItem("highlightBins")
            .toString()
            .replaceAll("{", "")
            .replaceAll("}", "")
            .replace(" ", "")
            .split(",");

          localStorage
            .getItem("highlightBins")
            .toString()
            .split(",")
            .forEach((e) => {
              let bin = e.replaceAll("{", "").replaceAll("}", "").trim();
              scene.getObjectByName(bin).material.color.set(0x65543e);
              scene.getObjectByName(bin).material.opacity = 0.5;
            });
        } catch (e) { }
        // localStorage.removeItem("highlightBins");
        break;

      case "resetBoxColors":
        localStorage.setItem("resetBoxColors", false);
        let redBins = JSON.parse(localStorage.getItem("binsStatus")).red;
        let orangeBins = JSON.parse(localStorage.getItem("binsStatus")).orange;

        try {


          highlightedBins.forEach((e) => {

            if (redBins.includes(e.trim())) {
              scene.getObjectByName(e.trim()).material.color.set(parseInt(localStorage.getItem("red"), 16));
            }
            else if (orangeBins.includes(e.trim())) {
              scene.getObjectByName(e.trim()).material.color.set(parseInt(localStorage.getItem("orange"), 16));
            }
            else {
              scene.getObjectByName(e.trim()).material.color.set(parseInt(localStorage.getItem("green"), 16));
            }
            // scene.getObjectByName(e.trim()).material.color.set(0xfaf3e2);
          });
          highlightedBins = [];
          if (localStorage.getItem("prevBin")) {

            if (redBins.includes(localStorage.getItem("prevBin"))) {
              scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(parseInt(localStorage.getItem("red"), 16));
            }
            else if (orangeBins.includes(localStorage.getItem("prevBin"))) {
              scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(parseInt(localStorage.getItem("orange"), 16));
            }
            else {
              scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(parseInt(localStorage.getItem("green"), 16));
            }
            // scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(0xfaf3e2);
            localStorage.removeItem("prevBin");
          }
        } catch (e) { }
        break;
      case "getShoretestPathForTask":
        if (event.newValue != "" && event.newValue != null) {
          document.querySelector('#showPath').click();
        }
        else {
          document.querySelector('#stopAnimation').click();
          document.querySelector('#path').classList.toggle('focused');
        }
        break;


      case "navigateToBin":
        try {
          moveToBin(scene.getObjectByName(event.newValue), camera, controls);
          scene.getObjectByName(bin).material.color.set(0x65543e);
        } catch (e) { }
        localStorage.removeItem("navigateToBin");

      case "binsStatus":
        try {
          let redBins = JSON.parse(event.newValue).red;
        let orangeBins = JSON.parse(event.newValue).orange
          for (let aisle = 1; aisle <= 5; aisle++) {
            for (let bay = 1; bay <= 3; bay++) {
              for (let level = 1; level <= 6; level++) {
                for (let position = 1; position <= 2; position++) {
                  let leftBinId = aisle + "LB" + bay + "0" + level + "0" + position;
                  let rightBinId = aisle + "RB" + bay + "0" + level + "0" + position;
                 
                  if (redBins.includes(leftBinId)) {
                    scene.getObjectByName(leftBinId).material.color.set(parseInt(localStorage.getItem("red"), 16));
                  }
                  else if (orangeBins.includes(leftBinId)) { 
                    scene.getObjectByName(leftBinId).material.color.set(parseInt(localStorage.getItem("orange"), 16));
                  }
                  else {
                    scene.getObjectByName(leftBinId).material.color.set(parseInt(localStorage.getItem("green"), 16));
                  }

                  
                  if (redBins.includes(rightBinId)) {
                    scene.getObjectByName(rightBinId).material.color.set(parseInt(localStorage.getItem("red"), 16));
                  }
                  else if (orangeBins.includes(rightBinId)) { 
                    scene.getObjectByName(rightBinId).material.color.set(parseInt(localStorage.getItem("orange"), 16));
                  }
                  else {
                    scene.getObjectByName(rightBinId).material.color.set(parseInt(localStorage.getItem("green"), 16));
                }
              }
            }
          }
        }
       

    }
        catch (e) {
      console.warn("binsStatus" + e);
    }
      
      default:
    break;
  }
  });
}
