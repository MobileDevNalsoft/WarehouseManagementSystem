import * as THREE from "three";
import { createRenderer } from "renderer";
import { initScene } from "scene";

document.addEventListener("DOMContentLoaded", async function () {
  const renderer = createRenderer();

  const {scene, camera, mixer, controls} = await initScene(renderer);

  const clock = new THREE.Clock();

  // Step 4: Render loop
  function animate() {
    requestAnimationFrame(() => animate(renderer, scene, camera));
    const delta = clock.getDelta(); // seconds.
    mixer.update(delta); // Update the animation mixer
    renderer.render(scene, camera);
  }

  window.localStorage.setItem("isLoaded", true);
  animate();

});


// Get all elements with the class name "areaButton"
let buttons = document.getElementsByClassName("areaButton");

// Loop through the buttons collection and log each element
for (let i = 0; i < buttons.length; i++) {
  buttons[i].onclick = function () {
    switchCamera(buttons[i].id);
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
