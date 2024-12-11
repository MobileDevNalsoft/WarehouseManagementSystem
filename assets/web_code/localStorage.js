import { resetTrucksAnimation } from "animations";
import { switchCamera } from "camera";
import { highlightBinsFromSearch } from "interactions";
import { moveToBin, getPositionAndTarget } from "camera";
import globalState from "globalState";


export function localStorageSetup(scene, camera, controls) {
  // Local Storage Setup

  let actualBinColor;
  let highlightedBins = [];

  window.localStorage.setItem("switchToMainCam", "null");

  window.addEventListener("storage", (event) => {
    switch (event.key) {
      case "switchToMainCam":
        
        if (event.newValue != "") {
          const { position, target } = getPositionAndTarget(
            scene,
            event.newValue
          );

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
        } catch (e) {}
        window.localStorage.removeItem("setNumberOfTrucks");
        break;
      case "resetTrucks":
        resetTrucksAnimation(scene);
        break;

      case "highlightBins":
        try {
          try {
            highlightedBins.forEach((e) => {
              scene.getObjectByName(e.trim()).material.color.set(0xfaf3e2);
            });
            highlightedBins = [];
            if(localStorage.getItem("prevBin")){
              scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(0xfaf3e2);
              localStorage.removeItem("prevBin");
            }
          } catch (e) {}

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
        } catch (e) {}
        // localStorage.removeItem("highlightBins");
        break;

      case "resetBoxColors":
        localStorage.setItem("resetBoxColors", false);
        try {
          highlightedBins.forEach((e) => {
            scene.getObjectByName(e.trim()).material.color.set(0xfaf3e2);
          });
          highlightedBins = [];
          if(localStorage.getItem("prevBin")){
            scene.getObjectByName(localStorage.getItem("prevBin")).material.color.set(0xfaf3e2);
            localStorage.removeItem("prevBin");
          }
        } catch (e) {}
        break;

      case "navigateToBin":
        try {
          moveToBin(scene.getObjectByName(event.newValue), camera, controls);
          scene.getObjectByName(bin).material.color.set(0x65543e);
        } catch (e) {}
        localStorage.removeItem("navigateToBin");
      default:
        break;
    }
  });
}
