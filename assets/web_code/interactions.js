import * as THREE from "three";
import { switchCamera, moveToBin } from "camera";
import { resetTrucksAnimation } from "aniMaster";

export function addInteractions(scene, model, camera, cameraList, controls) {
  const container = document.getElementById("container");

  const raycaster = new THREE.Raycaster();

  const mouse = new THREE.Vector2();
  const lastPos = new THREE.Vector2();

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

  const dropdown = document.getElementById("objectDropdown");

  // Populate dropdown with object names
  objectNames.forEach((name) => {
    const option = document.createElement("option");
    option.value = name;
    option.text = name;
    option.onclick = function () {
      window.localStorage.setItem("switchToMainCam", "null");
      window.localStorage.setItem("rack_cam", "storageArea");
      prevNav = name;
      switchCamera(scene, name, cameraList, camera, controls);
      console.log('{"rack":"' + name + '"}');
      window.localStorage.setItem(
        "getData",
        name
      );
    };
    dropdown.add(option);
  });

  // Function to show dropdown
  function showDropdown() {
    dropdown.style.display = "block";
  }

  // Function to filter dropdown options based on input text
  function filterDropdown() {
    const filter = document.getElementById("searchInput").value.toLowerCase();
    dropdown.style.display = "block"; // Show dropdown when filtering

    // Loop through dropdown options and display only those that match the filter
    Array.from(dropdown.options).forEach((option) => {
      const text = option.text.toLowerCase();
      option.style.display = text.includes(filter) ? "block" : "none";
    });
  }

  document.querySelector("#searchInput").onkeyup = filterDropdown;
  // Hide dropdown when clicking outside
  document.addEventListener("click", function (event) {
    const container = document.querySelector(".dropdown-container");
    if (!container.contains(event.target)) {
      dropdown.style.display = "none";
    }
  });

  // Store the list in localStorage
  window.localStorage.setItem("modelObjectNames", JSON.stringify(objectNames));

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
      if (e.target.classList.contains("searchInput")) {
        showDropdown();
      }
      if (
        e.target.classList.contains("areaButton") ||
        e.target.classList.contains("searchInput")
      )
        return;

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
            targetObject.name,
            cameraList,
            camera,
            controls
          );

          prevNav = targetObject.name.toString();
          window.localStorage.setItem("switchToMainCam", "null");
          if (prevNav.includes("rack")) {
            window.localStorage.setItem("rack_cam", "storageArea");
          } else {
            window.localStorage.setItem("rack_cam", "warehouse");
          }
        } else if (
          targetObject.name.toString().includes("b") &&
          targetObject.name.toString().includes("r") &&
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
      moveToBin(object, camera, controls);
    } else {
      if (object.userData.active == false) {
        object.userData.active = true;
        prevBinColor = object.material.color.clone();
        prevBin = object;
        // Set transparent blue color
        object.material.color.set(0xadd8e6); // Blue color
        object.material.opacity = 0.5; // Adjust opacity for transparency
        console.log('{"bin":"' + object.name.toString() + '"}');
        moveToBin(object, camera, controls);
      } else {
        object.userData.active = false;
        console.log('{"rack":"' + prevNav.split("_")[0] + '"}');
        switchCamera(scene, prevNav.split("_")[0], cameraList, camera, controls);
      }
    }
    prevBin = object;
  }

  // Get all elements with the class name "areaButton"
let buttons = document.getElementsByClassName("areaButton");

// Loop through the buttons collection and log each element
for (let i = 0; i < buttons.length; i++) {
  buttons[i].onclick = function () {
    switchCamera(scene, buttons[i].id+"_cam_navigation", cameraList, camera, controls);
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
const tooltip = document.getElementById("toggleTooltip");
const leftPanel = document.getElementById("leftPanel");
const togglePanel = document.getElementById("togglePanel");

// Show tooltip on hover
// toggleButton.addEventListener("mouseover", function () {
//   if(!leftPanel.classList.contains("open")){
//     tooltip.style.opacity = 1; // Show tooltip on hover
//     tooltip.textContent = "Open Controls";
//     tooltip.style.left = "22.5vw";
//   }
// });

// toggleButton.addEventListener("mouseout", function () {
//   if (!leftPanel.classList.contains("open")) {
//       tooltip.style.opacity = 0; // Hide tooltip if panel is closed
//   }
// });
tooltip.style.opacity = 0;
// Toggle the panel when the button is clicked
toggleButton.addEventListener("click", function () {
  // Toggle the 'open' class for both the panel and chevron
  leftPanel.classList.toggle("open");
  togglePanel.classList.toggle("open");

  // Slide the panel out when clicked
  if (leftPanel.classList.contains("open")) {
    leftPanel.style.left = "0"; // Panel moves out
    togglePanel.style.left = "10vw"; // Button moves to the edge of the panel
    // tooltip.style.left = "12.5vw"
    // tooltip.textContent = "Close Controls"; // Update tooltip text to 'Close Controls'

    // Hide tooltip during the animation
    // tooltip.style.opacity = 0;

    // Wait for the animation to finish
    togglePanel.addEventListener(
      "transitionend",
      function (event) {
        if (
          event.propertyName === "left" &&
          leftPanel.classList.contains("open")
        ) {
          // tooltip.style.opacity = 1; // Show the tooltip after animation completes
        }
      },
      { once: true }
    ); // Ensure this runs only once after the transition
  } else {
    leftPanel.style.left = "-220px"; // Hide panel
    togglePanel.style.left = "0"; // Reset button position
    // tooltip.style.left = "-100px"
    // tooltip.textContent = "Open Controls"; // Reset tooltip text to 'Open Controls'

    // // Hide tooltip during the animation
    // tooltip.style.opacity = 0;

    // Wait for the animation to finish
    togglePanel.addEventListener(
      "transitionend",
      function (event) {
        if (
          event.propertyName === "left" &&
          !leftPanel.classList.contains("open")
        ) {
          // tooltip.style.opacity = 1; // Show the tooltip after animation completes
        }
      },
      { once: true }
    ); // Ensure this runs only once after the transition
  }
});

}
