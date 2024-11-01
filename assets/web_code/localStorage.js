import { resetTrucksAnimation } from "aniMaster";
import { switchCamera } from "camera";

export function localStorageSetup(scene, cameraList, camera, controls) {
  // Local Storage Setup
  window.localStorage.setItem("switchToMainCam", "null");

  window.addEventListener("storage", (event) => {
    switch (event.key) {
      case "switchToMainCam":
        switchCamera(scene, event.newValue, cameraList, camera, controls);
        break;
      case "isRackDataLoaded":
        isRackDataLoaded = event.newValue;
        break;
      case "setNumberOfTrucks":
        for (let i = 1; i <= parseInt(event.newValue); i++) {
          scene.getObjectByName("truck_Y" + i).visible = true;
        }
        window.localStorage.removeItem("setNumberOfTrucks");
        break;
      case "resetTrucks":
        resetTrucksAnimation(scene);
        break;
      default:
        break;
    }
  });
}
