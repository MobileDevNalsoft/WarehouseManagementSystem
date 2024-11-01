import * as THREE from "three";
import { switchCamera } from "camera";
import { resetTrucksAnimation } from "aniMaster";

export function addInteractions(scene, model, camera, cameraList, controls) {
  const container = document.getElementById("container");

  const raycaster = new THREE.Raycaster();

  const mouse = new THREE.Vector2();
  const lastPos = new THREE.Vector2();

  let prevNav = "warehouse";
  let prevBin;
  let prevBinColor;

  function onMouseMove(e) {
    const rect = container.getBoundingClientRect();
    mouse.x = ((e.clientX - rect.left) / rect.width) * 2 - 1;
    mouse.y = -((e.clientY - rect.top) / rect.height) * 2 + 1;

    const tooltip = document.getElementById("tooltip");
    if (model != null && camera != null) {
      raycaster.setFromCamera(mouse, camera);
      // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
      const intersects = raycaster.intersectObjects(scene.children, true);
      // we get the objects from the model as list that are intersected by the casted ray.

      if (intersects.length > 0) {
        const targetObject = intersects[0].object;
        // Send the object name to Flutter
        if (window.flutter_inappwebview) {
          window.flutter_inappwebview.callHandler(
            "sendObjectName",
            targetObject.name.toString()
          );
        }
        if (targetObject.name.toString().includes("navigation")) {
          tooltip.style.display = "block";
          tooltip.innerHTML = targetObject.name.toString().split("_")[0];

          // Position tooltip at the mouse location
          tooltip.style.left = `${e.clientX + 10}px`; // Offset for better visibility
          tooltip.style.top = `${e.clientY + 10}px`;
        } else {
          tooltip.style.display = "none";
        }
      }
    }
  }

  function onMouseDown(e) {
    lastPos.x = (e.clientX / container.clientWidth) * 2 - 1;
    lastPos.y = -(e.clientY / container.clientHeight) * 2 + 1;
  }

  function onMouseUp(e) {
    if ((lastPos.distanceTo(mouse) === 0) & (e.button === 0)) {
      // Check if the mouse event is over a button
      if (e.target.classList.contains("areaButton")) return;

      raycaster.setFromCamera(mouse, camera);
      // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
      const intersects = raycaster.intersectObjects(scene.children, true);
      // we get the objects from the model as list that are intersected by the casted ray.

      if (intersects.length > 0) {
        const targetObject = intersects[0].object;
        if (targetObject.name.toString().includes("cam")) {
          if (targetObject.name.toString().includes("rack")) {
            console.log(
              '{"rack":"' + targetObject.name.toString().split("_")[0] + '"}'
            );
            window.localStorage.setItem(
              "getData",
              targetObject.name.toString().split("_")[0]
            );
          } else if (!targetObject.name.toString().includes("storage")) {
            console.log(
              '{"area":"' + targetObject.name.toString().split("_")[0] + '"}'
            );
            window.localStorage.setItem(
              "getData",
              targetObject.name.toString().split("_")[0]
            );
            if (targetObject.name.toString().split("_")[0] == "yardArea") {
              for (let i = 1; i <= 20; i++) {
                scene.getObjectByName("truck_Y" + i).visible = false;
              }
              scene.getObjectByName("truck_A1").visible = false;
              scene.getObjectByName("truck_A2").visible = false;
              scene.getObjectByName("truck_A3").visible = false;
            }
          }
          switchCamera(
            scene,
            targetObject.name.toString().split("_").slice(0, 2).join("_"),
            cameraList,
            camera,
            controls
          );

          window.localStorage.setItem("switchToMainCam", "null");
          prevNav = targetObject.name.toString();
        } else if (
          targetObject.name.toString().includes("b") &&
          prevNav.includes("rack")
        ) {
          changeColor(targetObject);
          window.localStorage.setItem("switchToMainCam", "null");
        } else {
          if (prevBin) {
            prevBin.material.color.copy(prevBinColor);
          }
          switchCamera(scene, "warehouse", cameraList, camera, controls);
          if (prevNav.includes("yard")) {
            resetTrucksAnimation();
          }
          prevNav = targetObject.name.toString();
        }
      }
    }
  }

  window.addEventListener("mousemove", onMouseMove); // triggered when mouse pointer is moved.
  window.addEventListener("mousedown", onMouseDown);
  window.addEventListener("mouseup", onMouseUp); // triggered when mouse pointer is clicked.

  function changeColor(object) {
    if (prevBin != null) {
      prevBin.material.color.copy(prevBinColor);
    }
  
    prevBinColor = object.material.color.clone();
    if (prevBin != object) {
      object.userData.active = true;
      // Set transparent blue color
      object.material.color.set(0xadd8e6); // Blue color
      object.material.opacity = 0.5; // Adjust opacity for transparency
      console.log('{"bin":"' + object.name.toString() + '"}');
      moveToBin(object);
    } else {
      if (object.userData.active == false) {
        object.userData.active = true;
        prevBinColor = object.material.color.clone();
        prevBin = object;
        // Set transparent blue color
        object.material.color.set(0xadd8e6); // Blue color
        object.material.opacity = 0.5; // Adjust opacity for transparency
        console.log('{"bin":"' + object.name.toString() + '"}');
        moveToBin(object);
      } else {
        object.userData.active = false;
        console.log('{"rack":"' + prevNav.split("_")[0] + '"}');
        switchCamera(prevNav);
      }
    }
    prevBin = object;
  }
  
}