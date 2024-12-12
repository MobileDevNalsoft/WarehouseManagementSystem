import * as THREE from "three";
import { switchCamera, moveToBin } from "camera";
import { resetTrucksAnimation } from "animations";
import {globalState} from "globalState";

export function highlightBinsFromSearch(bins) {
  let listOfBins = bins.toString().split(",");

  for (let i = 0; i < listOfBins; i++) {
    changeColor({ name: listOfBins[i] });
  }
}

export function addInteractions(scene, model, camera, controls) {
  const container = document.getElementById("container");

  const raycaster = new THREE.Raycaster();

  const mouse = new THREE.Vector2();
  const lastPos = new THREE.Vector2();

  let areasOverviewData = JSON.parse(window.localStorage.getItem('areasOverviewData'));

  let prevNav = "warehouse";
  let prevBin;
  let prevBinColor;
  let objectNames = [];

  // Traverse the model and collect object names
  model.traverse((child) => {
    if (
      child.isMesh &&
      child.name &&
      ((child.name.includes("r") && child.name.includes("b")) ||
        child.name.includes("rack"))
    ) {
      objectNames.push(child.name);
    }
  });

  // Store the list in localStorage
  window.localStorage.setItem("modelObjectNames", JSON.stringify(objectNames));

  const tooltip = document.getElementById("tooltip");
  function onMouseMove(e) {
    if (e.target.classList.contains("ignoreRaycast")) {
      return;
    }
    const rect = container.getBoundingClientRect();
    mouse.x = ((e.clientX - rect.left) / rect.width) * 2 - 1;
    mouse.y = -((e.clientY - rect.top) / rect.height) * 2 + 1;

    if (model != null && camera != null) {
      raycaster.setFromCamera(mouse, camera);
      // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
      const intersects = raycaster.intersectObjects(scene.children, true);
      // we get the objects from the model as list that are intersected by the casted ray.

      if (intersects.length > 0) {
        const targetObject = intersects[0].object;
        if (
          targetObject.name.toString().includes("nav") ||
          targetObject.name.toString().includes("Area") && globalState.areaFocused == false
        ) {
          let name = toCamelCase(targetObject.name);
          switch (name) {
            case "Yard Area":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                        AWT: 1hr<br>
                                        Available Slots: ${areasOverviewData.yardArea.available}<br>
                                        Occupied Slots: ${areasOverviewData.yardArea.occupied}
                                    </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Receiving Area":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                        Vendors: ${areasOverviewData.receivingArea.vendors}<br>
                                        Shipments: ${areasOverviewData.receivingArea.shipments}<br>
                                        Items: ${areasOverviewData.receivingArea.items}
                                    </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Inspection Area":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                        Vendors: ${areasOverviewData.inspectionArea.vendors}<br>
                                        Shipments: ${areasOverviewData.inspectionArea.shipments}<br>
                                        Items: ${areasOverviewData.inspectionArea.items}
                                    </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Activity Area":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                        Assembly: ${areasOverviewData.activityArea.assembly}<br>
                                        Items: ${areasOverviewData.activityArea.items}
                                    </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Staging Area":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                        Customers: ${areasOverviewData.stagingArea.customers}<br>
                                        Items: ${areasOverviewData.stagingArea.items}
                                    </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            default:
              tooltip.style.display = "block";
              tooltip.innerHTML = name;
              tooltip.style.left = `${e.clientX + 10}px`; // Offset for better visibility
              tooltip.style.top = `${e.clientY + 10}px`;
              tooltip.classList.add("hide-speech-bubble");
          }
        } else {
          tooltip.style.display = "none";
        }
      }
    }
  }

  function setToolTipPosition(targetObject, tooltip, camera){
    // Position tooltip at the mouse location
    const objectPosition = new THREE.Vector3();
    targetObject.getWorldPosition(objectPosition);

    // Convert world position to screen coordinates
    const vector = objectPosition.project(camera);
    const x = (vector.x * 0.5 + 0.5) * window.innerWidth;
    const y = (-(vector.y * 0.5) + 0.5) * window.innerHeight;

    // Position tooltip at the center of the object's position
    tooltip.style.left = `${x}px`;
    tooltip.style.top = `${y}px`;
    tooltip.classList.remove("hide-speech-bubble");
  }

  function onMouseDown(e) {
    lastPos.x = (e.clientX / container.clientWidth) * 2 - 1;
    lastPos.y = -(e.clientY / container.clientHeight) * 2 + 1;
    tooltip.style.display = "none"
  }

  function onMouseUp(e) {
    if ((lastPos.distanceTo(mouse) === 0) & (e.button === 0)) {
      if (e.target.classList.contains("ignoreRaycast")) return;

      raycaster.setFromCamera(mouse, camera);
      // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
      const intersects = raycaster.intersectObjects(scene.children, true);
      // we get the objects from the model as list that are intersected by the casted ray.

      if (intersects.length > 0) {
        const targetObject = intersects[0].object;
        const name = targetObject.name.toString().split("_")[0];
        if (
          targetObject.name.toString().includes("nav") ||
          targetObject.name.toString().includes("Area")
        ) {
          globalState.setAreaFocused(true);
          tooltip.style.display = "none"
          if (name.includes("rack")) {
            console.log(
              '{"rack":"' +
                name.substring(name.length - 2, name.length).toUpperCase() +
                '"}'
            );
          } else {
            console.log('{"area":"' + name + '"}');
            window.localStorage.setItem("rack_cam", "warehouse");
            if (name == "yardArea") {
              for (let i = 1; i <= 20; i++) {
                scene.getObjectByName("truck_Y" + i).visible = false;
              }
              scene.getObjectByName("truck_A1").visible = false;
              scene.getObjectByName("truck_A2").visible = false;
              scene.getObjectByName("truck_A3").visible = false;
            }
          }
          switchCamera(scene, targetObject.name, camera, controls);

          prevNav = name;
          window.localStorage.setItem("switchToMainCam", "null");
          if (name.includes("rack")) {
            window.localStorage.setItem("rack_cam", "storageArea");
          } else {
            window.localStorage.setItem("rack_cam", "warehouse");
          }
        } else if (
          name.includes("B") &&
          (name.includes("L") || name.includes("R")) &&
          prevNav.includes("rack")
        ) {
          changeColor(targetObject);
          window.localStorage.setItem("switchToMainCam", "null");
        } else {
          if (prevBin) {
            prevBin.material.color.copy(prevBinColor);
          }
          switchCamera(scene, "compoundArea", camera, controls);
          if (prevNav.includes("yard")) {
            resetTrucksAnimation(scene);
          }
          prevNav = name;
        }
      }
    } else {
      console.log('{"object":"null"}');
      globalState.setAreaFocused(false);
      resetTrucksAnimation(scene);
    }
  }

  window.addEventListener("mousemove", onMouseMove); // triggered when mouse pointer is moved.
  window.addEventListener("mousedown", onMouseDown);
  window.addEventListener("mouseup", onMouseUp); // triggered when mouse pointer is clicked.

  document.addEventListener("wheel", (event) => {
    // console.log(event.deltaY);
    // console.log(event.movementX);
    // console.log(event.movementY);

    //console.log('{"object":"null"}');
    localStorage.removeItem("resetBoxColors");
    try {
      if (localStorage.getItem("highlightBins")) {
        localStorage
          .getItem("highlightBins")
          .toString()
          .split(",")
          .forEach((e) => {
            let bin = e.replaceAll("{", "").replaceAll("}", "").trim();
            scene.getObjectByName(bin).material.color.set(0xfaf3e2);
            scene.getObjectByName(bin).material.opacity = 0.5;
          });

        localStorage.removeItem("highlightBins");
      }
    } catch (e) {}
    try {
      if (localStorage.getItem("prevBin")) {
        let bin = localStorage.getItem("prevBin").trim();
        scene.getObjectByName(bin).material.color.set(0xfaf3e2);
        scene.getObjectByName(bin).material.opacity = 0.5;
        localStorage.removeItem("prevBin");
      }
    } catch (e) {}
  });

  // setInterval(() => {

  //   if (localStorage.getItem("highlightBins") !== null) {

  //     actualBinColor = scene.getObjectByName( localStorage
  //       .getItem("highlightBins")
  //       .toString()
  //       .split(",")[0].replaceAll("{", "").replaceAll("}", "").trim()).material.color;

  //       console.log("actualBinColor "+actualBinColor);

  //       highlightedBins= localStorage
  //       .getItem("highlightBins")
  //       .toString().replaceAll("{", "").replaceAll("}", "").replace(" ", "")
  //       .split(",");
  //       console.log(highlightedBins);

  //     localStorage
  //       .getItem("highlightBins")
  //       .toString()
  //       .split(",")
  //       .forEach((e) => {
  //         let bin = e.replaceAll("{", "").replaceAll("}", "").trim();
  //         scene.getObjectByName(bin).material.color.set(0x65543e);
  //         scene.getObjectByName(bin).material.opacity = 0.5;
  //       });

  //     localStorage.removeItemItem("highlightBins");
  //   }

  //   if(localStorage.getItem("resetBoxColors")!==null && localStorage.getItem("resetBoxColors")==true &&  highlightedBins.length!=0){

  //     highlightedBins.forEach((e)=>{
  //      console.log(e);
  //      console.log(e.toString().replaceAll(" ",""));
  //     scene.getObjectByName(e.toString().replaceAll(" ","")).material.color.copy(actualBinColor) ;
  //     });
  //     highlightedBins=[];
  //     localStorage.getItem("resetBoxColors")=false;
  //   }
  //   // else{
  //   //   localStorage.getItem("resetBoxColors")=false;
  //   // }

  // }, 1000);

  function changeColor(object) {
    if (prevBin != null) {
      prevBin.material.color.set(0xfaf3e2);
    }

    // prevBinColor = object.material.color.clone();
    let objectName = object.name.toString();
    localStorage.setItem("prevBin", objectName);

    if (prevBin != object) {
      object.userData.active = true;
      // Set transparent blue color
      object.material.color.set(0x65543e); // Blue color
      object.material.opacity = 0.5; // Adjust opacity for transparency
      console.log('{"bin":"' + objectName + '"}');
      moveToBin(object, camera, controls);
    } else {
      if (object.userData.active == false) {
        object.userData.active = true;
        // prevBinColor = object.material.color.clone();
        prevBin = object;
        // Set transparent blue color
        object.material.color.set(0x65543e); // Blue color
        object.material.opacity = 0.5; // Adjust opacity for transparency
        console.log('{"bin":"' + objectName + '"}');

        moveToBin(object, camera, controls);
      } else {
        object.userData.active = false;
        console.log(
          '{"rack":"' +
            prevNav
              .split("_")[0]
              .substring(
                prevNav.split("_")[0].length - 2,
                prevNav.split("_")[0].length
              )
              .toUpperCase() +
            '"}'
        );

        switchCamera(scene, prevNav.split("_")[0], camera, controls);
      }
    }

    prevBin = object;
  }

  // Get all elements with the class name "areaButton"
  let buttons = document.getElementsByClassName("areaButton");

  // Loop through the buttons collection and log each element
  for (let i = 0; i < buttons.length; i++) {
    buttons[i].onclick = function () {
      switchCamera(scene, buttons[i].id, camera, controls);
      window.localStorage.setItem("switchToMainCam", "null");
      if (!buttons[i].id.includes("storage")) {
        console.log('{"area":"' + buttons[i].id.split("_")[0] + '"}');
      }
      if (buttons[i].id.includes("yard")) {
        window.localStorage.setItem("getData", "yardArea");
        for (let i = 1; i <= 20; i++) {
          scene.getObjectByName("truck_Y" + i).visible = false;
        }
        scene.getObjectByName("truck_A1").visible = false;
        scene.getObjectByName("truck_A2").visible = false;
        scene.getObjectByName("truck_A3").visible = false;
      }
    };
  }

  // JavaScript to handle the panel toggle
  const toggleButton = document.getElementById("togglePanel");
  const toggleTooltip = document.getElementById("toggleTooltip");
  const leftPanel = document.getElementById("leftPanel");
  const togglePanel = document.getElementById("togglePanel");

  // Show tooltip on hover
  // toggleButton.addEventListener("mouseover", function () {
  //   if(!leftPanel.classList.contains("open")){
  //     toggleTooltip.style.opacity = 1; // Show tooltip on hover
  //     toggleTooltip.textContent = "Open Controls";
  //     toggleTooltip.style.left = "22.5vw";
  //   }
  // });

  // toggleButton.addEventListener("mouseout", function () {
  //   if (!leftPanel.classList.contains("open")) {
  //       toggleTooltip.style.opacity = 0; // Hide tooltip if panel is closed
  //   }
  // });
  toggleTooltip.style.opacity = 0;
  // Toggle the panel when the button is clicked
  toggleButton.addEventListener("click", function () {
    // Toggle the 'open' class for both the panel and chevron
    leftPanel.classList.toggle("open");
    togglePanel.classList.toggle("open");

    // Slide the panel out when clicked
    if (leftPanel.classList.contains("open")) {
      leftPanel.style.left = "0"; // Panel moves out
      togglePanel.style.left = "10vw"; // Button moves to the edge of the panel
      // toggleTooltip.style.left = "12.5vw"
      // toggleTooltip.textContent = "Close Controls"; // Update tooltip text to 'Close Controls'

      // Hide tooltip during the animation
      // toggleTooltip.style.opacity = 0;

      // Wait for the animation to finish
      togglePanel.addEventListener(
        "transitionend",
        function (event) {
          if (
            event.propertyName === "left" &&
            leftPanel.classList.contains("open")
          ) {
            // toggleTooltip.style.opacity = 1; // Show the tooltip after animation completes
          }
        },
        { once: true }
      ); // Ensure this runs only once after the transition
    } else {
      leftPanel.style.left = "-220px"; // Hide panel
      togglePanel.style.left = "0"; // Reset button position
      // toggleTooltip.style.left = "-100px"
      // toggleTooltip.textContent = "Open Controls"; // Reset tooltip text to 'Open Controls'

      // // Hide tooltip during the animation
      // toggleTooltip.style.opacity = 0;
      switchCamera(scene, "compoundArea", camera, controls);

      // Wait for the animation to finish
      togglePanel.addEventListener(
        "transitionend",
        function (event) {
          if (
            event.propertyName === "left" &&
            !leftPanel.classList.contains("open")
          ) {
            // toggleTooltip.style.opacity = 1; // Show the tooltip after animation completes
          }
        },
        { once: true }
      ); // Ensure this runs only once after the transition
    }
  });

  function toCamelCase(str) {
    var words = str.split("_")[0].split("A");
    return (
      words[0].charAt(0).toUpperCase() +
      words[0].slice(1).toLowerCase() +
      " A" +
      words[1]
    );
  }
}
