var modelViewer = document.getElementById("model");
var hotspotCounter = 0;
let longPressTimer;

console.log("inside js");
document.addEventListener('DOMContentLoaded', () => {
    console.log("Document loaded");
});
// modelViewer.addEventListener("load", () => {
 
//   var button = document.createElement(button);
//   button.setAttribute("data-position","-0.1997m 0.11766m 0.0056m")
//   button.setAttribute("data-normal","-0.4421014m 0.04410423m 0.8958802m")
//   button.setAttribute("data-orbit","3.711166deg 92.3035deg 0.04335197m")
//   button.setAttribute("data-target","-0.1879433m 0.1157161m -0.01563221m")
//   button.setAttribute("slot","hotspot-1")
//   button.setAttribute("class","view-button")
 
//   setTimeout(()=>{
//     modelViewer.cameraOrbit = button.getAttribute("data-orbit");
//     modelViewer.camerTarget = button.getAttribute("data-target");
// },1000)
 
 
//   const changeColor = (event) => {
//     if(modelViewer.modelIsVisible){
//       const material = modelViewer.materialFromPoint(event.clientX, event.clientY);
//       if (material != null) {
//         material.pbrMetallicRoughness.
//           setBaseColorFactor([Math.random(), Math.random(), Math.random()]);
//       }
//     }
     
//   };
// //TEX.031
//   console.log("model  "+ modelViewer.model.variant)
//   const mat =modelViewer.model.getMaterialByName("TEX.005");
//      console.log("mat "+mat);
//      mat.pbrMetallicRoughness.
//      setBaseColorFactor([100,100,100]);
//   // const materials = {};
//   // modelViewer.model.traverse((object) => {
//   //     if (object.isMesh) {
//   //         materials[object.material.name] = object.material;
//   //     }
//   //     console.log("materials  "+materials  );
//   // });
 
// //   modelViewer.addEventListener('load', () => {
   
// //     // Now you can access your specific material
// //     // const specificMaterial = materials['YourMaterialName'];
// //     // console.log(specificMaterial);
// // });
 
//   document.addEventListener("click", changeColor);
// });

const changeColor = (event) => {
    if(modelViewer.modelIsVisible){
        
      const material = modelViewer.materialFromPoint(event.clientX, event.clientY);
    //      mat = modelViewer.model.getMaterialByName("inbound_box_2");
    //     if(mat!=null){
    //     console.log("material "+mat);
    //     mat.pbrMetallicRoughness.
    //  setBaseColorFactor("#00ff00");
    
    //  const position = getModelPosition(event.clientX, event.clientY);
    //         console.log("Clicked Position: ", position);
    //     } else {
    //         console.log("Material not found");
    //     }
    

     
      if (material != null) {
        console.log("inside event");
        material.pbrMetallicRoughness.
          setBaseColorFactor([Math.random(), Math.random(), Math.random()]);
          flutterChannel(
            JSON.stringify({ type: "hotspot-click"})
          );
      }
    }
     
  };


document.addEventListener("click", changeColor);

function getModelPosition(clientX, clientY) {
    const rect = modelViewer.getBoundingClientRect();
    const x = ((clientX - rect.left) / rect.width) * 2 - 1;
    const y = -((clientY - rect.top) / rect.height) * 2 + 1;

    const vector = new THREE.Vector3(x, y, 0.5); // z=0.5 for mid-depth
    vector.unproject(modelViewer.camera); // Convert to 3D coordinates

    const raycaster = new THREE.Raycaster(modelViewer.camera.position, vector.sub(modelViewer.camera.position).normalize());
    const intersects = raycaster.intersectObjects(modelViewer.model.scene.children, true);

    if (intersects.length > 0) {
        return intersects[0].point; // Return the intersection point
    }
    return null; // No intersection found
}
