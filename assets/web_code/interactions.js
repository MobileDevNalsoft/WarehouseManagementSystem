import * as THREE from "three";
// import { switchCamera, moveToBin } from "camera";
import { playAnimations } from "animations";
import { highlightArea, resetAreas } from "highlight";
import { removeLPNLifeCycle } from "lpnLifeCycle";


const data = JSON.parse(window.localStorage.getItem("facilityData"));

export function highlightBinsFromSearch(bins) { // highlighting the bins fetched from search
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

  let areasOverviewData = JSON.parse(
    window.localStorage.getItem("areasOverviewData")
  );

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
          (targetObject.name.toString().includes("Area") &&
            areaFocused == false) ||
          targetObject.name.toString().includes("box")
        ) {
          let name = toCamelCase(targetObject.name);
          console.warn(name);
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
            case "Storage Area":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                        Available bins: 100<br>
                                        Occupied bins: 260
                                    </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Box A1":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                          LPN: IBPAIDL00001676	<br>
                                          Status: Received<br>
                                          Item: HP LAPTOP<br>
                                          Description: HP LAPTOP Series 7 1TB<br>
                                          Qty: 150 <br>
                                          UOM: units
                                      </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Box A2":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                           LPN: IBPAIDL00001677<br>
                                           LPN: Received<br>
                                           Item: ITEM1<br>
                                           Description: ITEM1	<br>
                                           Qty: 500 <br>
                                           UOM: units<br>
                                        </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Box A3":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                             LPN: IBPAIDL00001678<br>
                                             LPN: Received<br>
                                             Item: ROTHSCHILD<br>
                                             Description: Chateau Mouton Rothschild 1945<br>
                                             Qty: 450<br>
                                             UOM: units
                                          </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Box A4":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                            LPN Number:IBPAIDL00001674	<br>
                                            LPN Status:Received<br>
                                            Item: ROTHSCHILD<br>
                                            Item Description: 	Chateau Mouton Rothschild 1945<br>
                                            Qty:45<br>
                                            UOM:units
                                          </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Box A5":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                             LPN Number:IBPAIDL00001673	<br>
                                             LPN Status:Received<br>
                                             Item: ITEM1<br>
                                             Item Description: ITEM1	<br>
                                             Qty:500 <br>
                                             UOM:units
                                          </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Box A6":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                               LPN Number: IBPAIDL00001116	<br>
                                               LPN Status: Quality Check<br>
                                               QC Status: Marked for QC<br>
                                               Item: OLD MONK-1-100<br>
                                               Description: SAMs OLD MONK RUM	<br>
                                               Qty: 10 <br>
                                               UOM: units
                                          </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            case "Box A7":
              tooltip.style.display = "block";
              tooltip.innerHTML = `<strong>${name}</strong><div class="tooltip-content">
                                            LPN Number:IBPAIDL00001117	<br>
                                            LPN Status:Quality Check<br>
                                            QC Status: Marked for QC<br>
                                            Item: ITEM1<br>
                                            Item Description: ITEM1	<br>
                                            Qty:5 <br>
                                            UOM:units                                          
                                          </div>`;
              setToolTipPosition(targetObject, tooltip, camera);
              break;
            default:
              tooltip.style.display = "block";
              tooltip.innerHTML = name.split("A")[0];
              tooltip.style.left = `${e.clientX + 10}px`; // Offset for better visibility
              tooltip.style.top = `${e.clientY + 10}px`;
              tooltip.classList.add("hide-speech-bubble");
          }
        } else if (areaFocused == true) {
          const trucksData = JSON.parse(
            window.localStorage.getItem("trucksData")
          );
          const name = targetObject.parent.name;
          if (name.includes("truck_Y")) {
            for (let i = 1; i <= trucksData.length; i++) {
              try {
                const number = name.match(/(\d+)$/)[1];
                tooltip.style.display = "block";
                tooltip.innerHTML = `<strong>${
                  "T" +
                  name.split("_")[0].slice(1) +
                  " " +
                  trucksData[number - 1].truck_nbr
                }</strong><div class="tooltip-content">
                                        Vendor:${
                                          trucksData[number - 1].vendor_code
                                        }<br>
                                        LOC:${
                                          trucksData[number - 1]
                                            .vehicle_location
                                        }<br>
                                      </div>`;
                setToolTipPosition(targetObject, tooltip, camera);
              } catch (error) {
                tooltip.style.display = "none";
              }
            }
          } else if (name.includes("truck_R")) {
            for (let i = 1; i <= trucksData.length; i++) {
              try {
                const number = name.match(/(\d+)$/)[1];
                tooltip.style.display = "block";
                tooltip.innerHTML = `<strong>${
                  "T" +
                  name.split("_")[0].slice(1) +
                  " " +
                  trucksData[number - 1].truck_no
                }</strong><div class="tooltip-content">
                                        Vendor:${
                                          trucksData[number - 1].vendor
                                        }<br>
                                        ASN:${trucksData[number - 1].asn}<br>
                                      </div>`;
                setToolTipPosition(targetObject, tooltip, camera);
              } catch (error) {
                tooltip.style.display = "none";
              }
            }
          } else if (name.includes("truck_D") || name.includes("truck_A2")) {
            for (let i = 1; i <= trucksData.length; i++) {
              try {
                const number = name.match(/(\d+)$/)[1];
                tooltip.style.display = "block";
                tooltip.innerHTML = `<strong>${
                  "T" +
                  name.split("_")[0].slice(1) +
                  " " +
                  trucksData[number - 1].truck_nbr
                }</strong><div class="tooltip-content">
                                        Driver:${
                                          trucksData[number - 1].driver
                                        }<br>
                                        Load:${
                                          trucksData[number - 1].load_nbr
                                        }<br>
                                      </div>`;
                setToolTipPosition(targetObject, tooltip, camera);
              } catch (error) {
                tooltip.style.display = "none";
              }
            }
          } else {
            tooltip.style.display = "none";
          }
        } else {
          tooltip.style.display = "none";
        }
      }
    }
  }

  // Tooltip for the target object when hovered
  function setToolTipPosition(targetObject, tooltip, camera) {
    // Position tooltip at the mouse location
    const objectPosition = new THREE.Vector3();
    targetObject.getWorldPosition(objectPosition);

    // Convert world position to screen coordinates
    const vector = objectPosition.project(camera);
    const x = (vector.x * 0.5 + 0.5) * window.innerWidth;
    const y = (-(vector.y * 0.5) + 0.5) * window.innerHeight;

    // Position tooltip at the center of the object's position
    tooltip.style.left = `${x}px`;
    tooltip.style.top = `${y - 60}px`;
    tooltip.classList.remove("hide-speech-bubble");
  }

  function onMouseDown(e) {
    lastPos.x = (e.clientX / container.clientWidth) * 2 - 1;
    lastPos.y = -(e.clientY / container.clientHeight) * 2 + 1;
    tooltip.style.display = "none";
  }


  // interactions on mouse left click 
  function onMouseUp(e) {
    if ((lastPos.distanceTo(mouse) <= 0.05) & (e.button === 0)) { // for clicking 
      if (e.target.classList.contains("ignoreRaycast")) return;

      raycaster.setFromCamera(mouse, camera);
      // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
      const intersects = raycaster.intersectObjects(scene.children, true);
      if (intersects.length > 0) {
        const targetObject = intersects[0].object;
        const name = targetObject.name.toString().split("_")[0];
        if (
          targetObject.name.toString().includes("nav") ||
          targetObject.name.toString().includes("Area")
        ) {
          areaFocused = true; 
          removeLPNLifeCycle(scene);
          tooltip.style.display = "none";
          if (name.includes("rack")) {
            console.log(
              '{"rack":"' +
                name.substring(name.length - 2, name.length).toUpperCase() +
                '"}'
            );
            window.localStorage.setItem("rack_cam", "storageArea");
          } else {
            console.log('{"area":"' + name + '"}');
            window.localStorage.setItem("rack_cam", "warehouse");
          }
          window.switchCamera(targetObject.name);
          prevNav = name;
        } else if (
          name.includes("B") &&
          (name.includes("L") || name.includes("R")) &&
          prevNav.includes("rack")
        ) {
          if (targetObject.visible == true) {
            changeColor(targetObject);
          }
        } else {
          if (prevBin) {
            prevBin.material.color.copy(prevBinColor);
          }
          if (data.model === "warehouse") {
            window.switchCamera("compoundArea");
          }
          if (prevNav.includes("yard") && scene.getObjectByName("truck_Y10")) {
            resetTrucksAnimation(scene);
          }
          prevNav = name;
        }
      }
    } else {// for panning 
      document.getElementById("wms-bot").style.display = "block";
      if (areaFocused == true) {
        resetAreas(scene);
        console.log('{"object":"null"}');
      }
      areaFocused=false;
      if (scene.getObjectByName("truck_Y10")) {
        resetTrucksAnimation(scene);
        playAnimations();
        ["truck_R1", "truck_R2", "truck_R3"].forEach((truck) => {
          scene.getObjectByName(truck).visible = true;
        });
        ["truck_D_L1", "truck_A2", "truck_D_L3"].forEach((truck) => {
          scene.getObjectByName(truck).visible = true;
        });
      }
      try {
        if (
          localStorage.getItem("highlightBins") &&
          !document.getElementById("path").classList.contains("focused") &&
          !document.getElementById("digitalTwin").classList.contains("focused")
        ) {
          resetBinColors();
        }
      } catch (e) {
        console.warn("from wheely" + e);
      }
      try {
        if (localStorage.getItem("prevBin")) {
          
          let bin = localStorage.getItem("prevBin").trim();

          if (redBins.includes(bin)) {
            scene
              .getObjectByName(bin)
              .material.color.set(parseInt(localStorage.getItem("red"), 16));
          } else if (orangeBins.includes(bin)) {
            scene.getObjectByName(bin).material.color.set(0xfaf3e2);
          }
          // scene.getObjectByName(bin).material.color.set(0xfaf3e2);
          scene.getObjectByName(bin).material.opacity = 0.5;
          localStorage.removeItem("prevBin");
        }
      } catch (e) {}
    }
  }

  window.addEventListener("mousemove", onMouseMove); // triggered when mouse pointer is moved.
  window.addEventListener("mousedown", onMouseDown);
  window.addEventListener("mouseup", onMouseUp); // triggered when mouse pointer is clicked.

  document.addEventListener("wheel", (event) => {
    tooltip.style.display = "none";
  });



  // changing the color of the bin 
  function changeColor(object) {
    let objectName = object.name.toString();
    if (prevBin != null) {
      if (redBins.includes(prevBin.name)) {
        prevBin.material.color.set(parseInt(localStorage.getItem("red"), 16));
      } else if (orangeBins.includes(prevBin.name)) {
        prevBin.material.color.set(0xfaf3e2);
      }
      // prevBin.material.color.set(0xfaf3e2);
    }

    // prevBinColor = object.material.color.clone();

    localStorage.setItem("prevBin", objectName);

    if (prevBin != object) {
      object.userData.active = true;
      // Set transparent blue color
      object.material.color.set(0x65543e); // Blue color
      object.material.opacity = 0.5; // Adjust opacity for transparency
      console.log('{"bin":"' + objectName + '"}');
      window.moveToBin(object, camera, controls);
    } else {
      if (object.userData.active == false) {
        object.userData.active = true;
        // prevBinColor = object.material.color.clone();
        prevBin = object;
        // Set transparent blue color
        object.material.color.set(0x65543e); // Blue color
        object.material.opacity = 0.5; // Adjust opacity for transparency
        console.log('{"bin":"' + objectName + '"}');

        window.moveToBin(object, camera, controls);
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

        window.switchCamera(prevNav.split("_")[0]);
      }
    }

    prevBin = object;
  }

  
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



