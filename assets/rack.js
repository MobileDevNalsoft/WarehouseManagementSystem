var modelViewer = document.getElementById("rackmodel");
var hotspotCounter = 0;
let longPressTimer;

// ontouchstart is a method of modelViewer object that is triggered when touch is started by user on model viewer rendered area.
modelViewer.ontouchstart = (event) => {
  // to create a long press functionality( touch will be triggered after the time out )
  longPressTimer = setTimeout(() => {
    // to confirm whether the touch is started or not
    console.log("Touch started : ", event.targetTouches.item(0).clientX);

    // surfaceFromPoint will take the touch point on screen then it uses rayCasting to check whether the touch action
    // is made on the model object in the rendered area or not.
    // if [Yes] it returns a surface point object with some values else returns null.
    const surfacePoint = modelViewer.surfaceFromPoint(
      event.targetTouches.item(0).clientX,
      event.targetTouches.item(0).clientY
    );

    /*
        Position

            Definition: In 3D graphics, position refers to the location of a point or object in a 3D space. It is 
            typically represented as a vector with three components (x, y, z) that specify the coordinates relative 
            to a coordinate system origin.
            Role in Rendering: The position of each vertex in a 3D model determines its location on the screen when 
            the model is rendered. By manipulating the position of vertices, you can transform the model's shape, 
            size, and orientation.
        */

    /*
        https://www.makeuseof.com/normals-in-3d-modeling-explained/

        Normal

            A normal is a unit vector that is perpendicular to a surface at a given point. It points outward from the surface.
            normals are typically predefined for 3D models. When a 3D model is created or exported, the software used to create
            it will usually calculate and store the normals for each vertex or face of the model.

            These normals are essential for determining the orientation of surfaces and calculating lighting and 
            shading effects during rendering. Without normals, it would be impossible to accurately render a 3D model
            with realistic lighting and shading.
        */
    {
      if (surfacePoint != null) {
        let positionAndNormal = modelViewer.positionAndNormalFromPoint(
          event.targetTouches.item(0).clientX,
          event.targetTouches.item(0).clientY
        );

        let hotspot = document.createElement("div");

        let pulsatingCircle = document.createElement("div");
        pulsatingCircle.classList.add("pulsating-circle");  
  
        hotspot.appendChild(pulsatingCircle);

        hotspot.classList.add(["hotspot-button"]);
        hotspotCounter++;

        let s = "hotspot-" + hotspotCounter;
        hotspot.setAttribute(
          "data-position",
          positionAndNormal.position.toString()
        );
        hotspot.id = s;
        hotspot.setAttribute(
          "data-normal",
          positionAndNormal.normal.toString()
        );
        hotspot.setAttribute("data-visibility-attribute", "visible");
        hotspot.firstChild.style.animation="pulse 1.5s ease-in-out infinite";
        console.log("normal "+ positionAndNormal.normal);
        console.log("position"+ positionAndNormal.position);
        

        hotspot.onclick = function () {
          changeHotSpotColors(hotspot.getAttribute("id"), true);
          hotspot.firstChild.style.animation="pulse 1.5s ease-in-out infinite";
          console.log("clicked "+hotspot.getAttribute("id"))
          window.flutterChannel.postMessage(
            JSON.stringify({ type: "hotspot-click", name: hotspot.getAttribute("id"),cnt:hotspotCounter })
          );
        };

        // hotspot.textContent = s;

        hotspot.setAttribute("slot", s);
        hotspot.setAttribute("id", s);
        modelViewer.appendChild(hotspot);

        changeHotSpotColors(hotspot.getAttribute("id"), false);
        window.flutterChannel.postMessage(
          JSON.stringify({
            type: "hotspot-create",
            position: positionAndNormal.position.toString(),
            normal: positionAndNormal.normal.toString(),
            name: s,
            cnt: hotspotCounter 
          })
        );
      }
    }
  }, 600);
};
// ontouchstart is a method of modelViewer object that is triggered when touch is ended by user on model viewer rendered area.
modelViewer.ontouchend = (event) => {
  clearTimeout(longPressTimer);
};


modelViewer.addEventListener('touchstart', function (e) {
  if(e.touches.length > 1) {
    clearTimeout(longPressTimer);
  }
});
// to avoid creating hotspot when we move the 3D model
modelViewer.ontouchmove = (event) => {
  clearTimeout(longPressTimer);
};

function changeHotSpotColors(selectedHotspotName, changeCamera) {
  console.log("hotspot name ", selectedHotspotName);

  const allHotspots = document.getElementsByClassName("hotspot-button");

  console.log("hotspots ", allHotspots);

  for (var hotspot of allHotspots) {
    if (hotspot.getAttribute("id") == selectedHotspotName) {
      hotspot.style.backgroundColor = "orange";
      hotspot.firstChild.style.animation="pulse 1.5s ease-in-out infinite";
      if (changeCamera == true) {
        const normal = hotspot.getAttribute("data-normal");

        const normalComponents = normal.split(" ");

        const x = parseFloat(normalComponents[0]);
        const y = parseFloat(normalComponents[1]);
        const z = parseFloat(normalComponents[2]);

        // for camera orbit rotation when tapped on hotspot or flutter button
        const theta = Math.atan2(x, z);
        const phi = Math.acos(y);

        modelViewer.cameraOrbit = `${theta}rad ${phi}rad auto`;
        modelViewer.camerTarget = `${x} ${y} ${z}`

        console.log(modelViewer.cameraOrbit);
      }
    } else {
      hotspot.style.backgroundColor = "white";
      hotspot.firstChild.style.animation="none";
    }
  }
}

function renameHotspot(previousName,newName){
  
  document.getElementById(previousName).setAttribute("id",newName);
  console.log(previousName+ ' ' +newName);
  console.log("prev node"+""+document.getElementById(previousName));
  console.log("new node"+""+document.getElementById(newName));
}

function removeButton(selectedHotspotName) {
  const buttonElement = document.getElementById(selectedHotspotName);

  if (buttonElement) {
    modelViewer.removeChild(buttonElement);
  }
}
