import { resetTrucksAnimation } from "animations";
import { switchCamera } from "camera";
import { highlightBinsFromSearch } from "interactions"
import { moveToBin } from "camera";

export function localStorageSetup(scene, camera, controls) {
  // Local Storage Setup



  let actualBinColor;
  let highlightedBins=[];

  window.localStorage.setItem("switchToMainCam", "null");

  window.addEventListener("storage", (event) => {
    switch (event.key) {
      case "switchToMainCam":
        switchCamera(scene, event.newValue, camera, controls);
        break;
      case "isRackDataLoaded":
        isRackDataLoaded = event.newValue;
        break;
      case "setNumberOfTrucks":

        for (let i = 1; i <= parseInt(event.newValue); i++) {
          scene.getObjectByName("truck_Y" + i).visible = true;
        }
        for (let i = parseInt(event.newValue)+1; i <= 20; i++) {
          scene.getObjectByName("truck_Y" + i).visible = false;
        }
        window.localStorage.removeItem("setNumberOfTrucks");
        break;
      case "resetTrucks":
        resetTrucksAnimation(scene);
        break;
      
       case  "highlightBins":
          
       try{
       actualBinColor = scene.getObjectByName( localStorage
          .getItem("highlightBins")
          .toString()
          .split(",")[0].replaceAll("{", "").replaceAll("}", "").trim()).material.color;
        
          


          highlightedBins= localStorage
          .getItem("highlightBins")
          .toString().replaceAll("{", "").replaceAll("}", "").replace(" ", "")
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
       }
       catch(e){

       }
          // localStorage.removeItem("highlightBins");
       break;


      case "resetBoxColors": 
      
      localStorage.setItem("resetBoxColors",false);       
      highlightedBins.forEach((e)=>{
        scene.getObjectByName(e.trim()).material.color.set(0xcbbbab);           
            });
            highlightedBins=[];
          break;

      case "navigateToBin":
        try{
          moveToBin(scene.getObjectByName(event.newValue),camera,controls);
          scene.getObjectByName(bin).material.color.set(0x65543e);
        }
        catch(e){
          
        }
        localStorage.removeItem("navigateToBin");
      default:
        break;
    }
  });
}
