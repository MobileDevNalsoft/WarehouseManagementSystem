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
        
          console.log("actualBinColor "+actualBinColor);


          highlightedBins= localStorage
          .getItem("highlightBins")
          .toString().replaceAll("{", "").replaceAll("}", "").replace(" ", "")
          .split(",");
          console.log(highlightedBins);

        localStorage
          .getItem("highlightBins")
          .toString()
          .split(",")
          .forEach((e) => {
            let bin = e.replaceAll("{", "").replaceAll("}", "").trim();
            scene.getObjectByName(bin).material.color.set(0xadd8e6);
            scene.getObjectByName(bin).material.opacity = 0.5;
          });
       }
       catch(e){

       }
          localStorage.removeItem("highlightBins");
       break;


      case "resetBoxColors": 

                

      console.log('inside reset');   
        console.log(highlightedBins);
      highlightedBins.forEach((e)=>{
             console.log("bin  "+e);
             console.log(e.toString().replaceAll(" ",""));

             scene.getObjectByName("1RB30201").material.color.set(0x614B33); 
            });
            highlightedBins=[];
            localStorage.removeItem("resetBoxColors");
          break;

      case "navigateToBin":
        try{
          moveToBin(scene.getObjectByName(event.newValue),camera,controls);
          scene.getObjectByName(bin).material.color.set(0xadd8e6);
        }
        catch(e){
          
        }
        localStorage.removeItem("navigateToBin");
      default:
        break;
    }
  });
}
