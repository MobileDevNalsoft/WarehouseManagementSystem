import * as THREE from "three";
import { switchCamera, moveToBin } from "camera";
import { resetTrucksAnimation } from "animations";

export function addInteractions(scene, model, camera, controls) {
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

  // Store the list in localStorage
  window.localStorage.setItem("modelObjectNames", JSON.stringify(objectNames));

  function onMouseMove(e) {
    const tooltip = document.getElementById("tooltip");
    if (e.target.classList.contains("ignoreRaycast")) {
      tooltip.style.display = "none";
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
          targetObject.name.toString().includes("Area")
        ) {
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
          if (name.includes("rack")) {
            console.log('{"rack":"' + name.substring(name.length-2, name.length).toUpperCase() + '"}');
            
            window.localStorage.setItem("getData", name);
          } else  {
            console.log('{"area":"' + name + '"}');
            window.localStorage.setItem("rack_cam", "warehouse");
            window.localStorage.setItem( "getData", name );
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
          name.includes("b") &&
          name.includes("r") &&
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
    }else {
      console.log('{"object":"null"}');
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
    let actualName = object.name.toString();
    let resultBin = ""
    let bay="";

    resultBin = actualName.substring(1,4);
    let column = parseInt( actualName.charAt(actualName.length - 1));
    bay = Math.ceil(parseInt( actualName.charAt(actualName.length - 1))/2);
    resultBin += bay;
    resultBin += "0"+actualName.charAt(4);
    resultBin += "0"+ Math.floor(column/bay);

    if (prevBin != object) {
      object.userData.active = true;
      // Set transparent blue color
      object.material.color.set(0xadd8e6); // Blue color
      object.material.opacity = 0.5; // Adjust opacity for transparency
      console.log('{"bin":"' + resultBin + '"}');
      moveToBin(object, camera, controls);
    } else {
      if (object.userData.active == false) {
        object.userData.active = true;
        prevBinColor = object.material.color.clone();
        prevBin = object;
        // Set transparent blue color
        object.material.color.set(0xadd8e6); // Blue color
        object.material.opacity = 0.5; // Adjust opacity for transparency
        console.log('{"bin":"' + resultBin + '"}');
        moveToBin(object, camera, controls);
      } else {
        object.userData.active = false;
        console.log('{"rack":"' + prevNav.split("_")[0].substring(prevNav.split("_")[0].length-2, prevNav.split("_")[0].length).toUpperCase() + '"}');
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

  document
    .getElementById("image-button-container")
    .addEventListener("click", function (e) {
      const manButton = document.getElementById("image-button-container");
      manButton.style.display = "none";
      const arrows = document.querySelectorAll(".arrow");
      arrows.forEach((arrow) => {
        arrow.style.display = "block";
      });
      const clickedObject = scene.getObjectByName("storageArea");

      // Calculate the bounding box of the clicked object
      const boundingBox = new THREE.Box3().setFromObject(clickedObject);

      // Get the minimum and maximum points of the bounding box
      const max = boundingBox.max;

      // Create a GSAP timeline for smoother transitions
      const timeline = gsap.timeline();

      controls.enabled = false;
      controls.enableDamping = false;

      // Animate position and rotation simultaneously
      timeline
        .to(camera.position, {
          duration: 3,
          x: max.x - 20,
          y: camera.position.y - 55,
          z: max.z + 20,
          ease: "power3.inOut",
        })
        .to(
          controls.target,
          {
            duration: 3,
            x: max.x - 20,
            y: camera.position.y - 55,
            z: max.z - 30,
            ease: "power3.inOut",
            onUpdate: function () {
              camera.lookAt(controls.target); // Smoothly look at the target
            },
          },
          "<"
        );

      // Callbacks after animation completes
      timeline.call(() => {
        // controls.enabled = true; // Re-enable controls after animation
        // controls.enableDamping = true; // Re-enable damping after animation
      });
    });

  document.getElementById("arrow-up").addEventListener("click", () => {
    // Create a GSAP timeline for smoother transitions
    const timeline = gsap.timeline();

    controls.enabled = false;
    controls.enableDamping = false;

    // Animate position and rotation simultaneously
    timeline
      .to(camera.position, {
        duration: 1,
        x: camera.position.x,
        y: camera.position.y,
        z: camera.position.z - 5,
        ease: "power3.inOut",
      })
      .to(
        controls.target,
        {
          duration: 1,
          x: controls.target.x,
          y: controls.target.y,
          z: controls.target.z - 5,
          ease: "power3.inOut",
          onUpdate: function () {
            camera.lookAt(controls.target); // Smoothly look at the target
          },
        },
        "<"
      );

    // Callbacks after animation completes
    timeline.call(() => {
      // controls.enabled = true; // Re-enable controls after animation
      // controls.enableDamping = true; // Re-enable damping after animation
    });
  });

  document.getElementById("arrow-down").addEventListener("click", () => {
    // Create a GSAP timeline for smoother transitions
    const timeline = gsap.timeline();

    controls.enabled = false;
    controls.enableDamping = false;

    // Animate position and rotation simultaneously
    timeline
      .to(camera.position, {
        duration: 1,
        x: camera.position.x,
        y: camera.position.y,
        z: camera.position.z + 5,
        ease: "power3.inOut",
      })
      .to(
        controls.target,
        {
          duration: 1,
          x: controls.target.x,
          y: controls.target.y,
          z: controls.target.z + 5,
          ease: "power3.inOut",
          onUpdate: function () {
            camera.lookAt(controls.target); // Smoothly look at the target
          },
        },
        "<"
      );

    // Callbacks after animation completes
    timeline.call(() => {
      // controls.enabled = true; // Re-enable controls after animation
      // controls.enableDamping = true; // Re-enable damping after animation
    });
  });

  document.getElementById("arrow-left").addEventListener("click", () => {
    // Create a GSAP timeline for smoother transitions
    const timeline = gsap.timeline();

    controls.enabled = false;
    controls.enableDamping = false;

    // Animate position and rotation simultaneously
    timeline
      .to(camera.position, {
        duration: 1,
        x: camera.position.x - 5,
        y: camera.position.y,
        z: camera.position.z,
        ease: "power3.inOut",
      })
      .to(
        controls.target,
        {
          duration: 1,
          x: controls.target.x - 5,
          y: controls.target.y,
          z: controls.target.z,
          ease: "power3.inOut",
          onUpdate: function () {
            camera.lookAt(controls.target); // Smoothly look at the target
          },
        },
        "<"
      );

    // Callbacks after animation completes
    timeline.call(() => {
      // controls.enabled = true; // Re-enable controls after animation
      // controls.enableDamping = true; // Re-enable damping after animation
    });
  });

  document.getElementById("arrow-right").addEventListener("click", () => {
    // Create a GSAP timeline for smoother transitions
    const timeline = gsap.timeline();

    controls.enabled = false;
    controls.enableDamping = false;

    // Animate position and rotation simultaneously
    timeline
      .to(camera.position, {
        duration: 1,
        x: camera.position.x + 5,
        y: camera.position.y,
        z: camera.position.z,
        ease: "power3.inOut",
      })
      .to(
        controls.target,
        {
          duration: 1,
          x: controls.target.x + 5,
          y: controls.target.y,
          z: controls.target.z,
          ease: "power3.inOut",
          onUpdate: function () {
            camera.lookAt(controls.target); // Smoothly look at the target
          },
        },
        "<"
      );

    // Callbacks after animation completes
    timeline.call(() => {
      // controls.enabled = true; // Re-enable controls after animation
      // controls.enableDamping = true; // Re-enable damping after animation
    });
  });

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
      switchCamera(scene, "compoundArea", camera, controls);

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

document.addEventListener("wheel", (event) => {
  // console.log(event.deltaY);
  // console.log(event.movementX);
  // console.log(event.movementY);
  const arrows = document.querySelectorAll(".arrow");
  arrows.forEach((arrow) => {
    arrow.style.display = "none";
  });
  const manButton = document.getElementById("image-button-container");
  manButton.style.display = "none";
  console.log('{"object":"null"}');
});
