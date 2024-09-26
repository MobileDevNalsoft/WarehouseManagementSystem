import * as THREE from "three";
import { GLTFLoader } from 'https://cdn.jsdelivr.net/npm/three@0.149.0/examples/jsm/loaders/GLTFLoader.js';
import { OrbitControls } from "https://unpkg.com/three@0.112/examples/jsm/controls/OrbitControls.js";

var container, camera, scene, controls, model;

// we use WebGL renderer for rendering 3d model efficiently
const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true })
renderer.setPixelRatio(Math.min(Math.max(1, window.devicePixelRatio), 2))
//  This line sets the pixel ratio for the renderer based on the device's pixel density.
renderer.outputEncoding = THREE.sRGBEncoding
// This line specifies how colors are encoded when rendered to the screen.

// we use raycasting to add hovering or onclick functionality to 3d model.
const raycaster = new THREE.Raycaster();

// need mouse coordinates for raycasting.
const mouse = new THREE.Vector2();

const lastPos = new THREE.Vector2();

function onMouseMove(e) {
    // regularly updating the position of mouse pointer when it is moved on rendered window.
    mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
    mouse.y = - (e.clientY / window.innerHeight) * 2 + 1;

    // raycaster.setFromCamera(mouse, camera);
    // const intersects = raycaster.intersectObjects(scene.children, true);

    // if(intersects.length > 0 & intersects[0].object.name.toString().includes('r1')){
    //     intersects[0].object.material.color.set(0xff0000);
    //     console.log(intersects[0].object.name.toString());
    // }
}

// Function to calculate distance between two points
function calculateDistance(x1, y1, x2, y2) {
    return Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2));
}

// Function to smoothly move the camera to the clicked object
function moveToObject(object) {
    const targetPosition = new THREE.Vector3(object.position.x, object.position.y, object.position.z); // Adjust as needed

    // Animate the transition (you can replace this with GSAP or another tweening library for smoother animation)
    let startPosition = camera.position.clone();
    let distance = targetPosition.distanceTo(startPosition);
    let duration = distance / 5; // Adjust speed here

    let startTime = null;

    function animateCamera(timestamp) {
        if (!startTime) startTime = timestamp;
        let elapsed = (timestamp - startTime) / duration;

        if (elapsed < 1) {
            camera.position.lerpVectors(startPosition, targetPosition, elapsed); // Lerp for smooth transition
            camera.lookAt(object.position); // Always look at the object
            requestAnimationFrame(animateCamera);
        } else {
            camera.position.copy(targetPosition); // Ensure final position is set
            camera.lookAt(object.position); // Look at the object
        }
    }

    requestAnimationFrame(animateCamera);
}

function onMouseDown(e){
    lastPos.x = (e.clientX / window.innerWidth) * 2 - 1;
    lastPos.y = - (e.clientY / window.innerHeight) * 2 + 1;
}

function onMouseUp(e) {
    if (lastPos.distanceTo(mouse) === 0 & e.button === 0) {
        raycaster.setFromCamera(mouse, camera);
        // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
        const intersects = raycaster.intersectObjects(scene.children, true);
        // we get the objects from the model as list that are intersected by the casted ray.

        if (intersects.length > 0) {
            console.log(intersects[0].object.position.x.toString() + ' ' + intersects[0].object.position.y.toString() + ' ' + intersects[0].object.position.z.toString());
            if (intersects[0].object.name.toString().includes('r1')) {
                intersects[0].object.material.color.set(0xff0000);
                // moveToObject(intersects[0].object);
                console.log(intersects[0].object.name.toString());
            }
            // moveCamera(30.3100461959838867,20,-50);
            // rotateCamera(0, 0, 0);
            moveCam(intersects[0].object);
            
        }
    }

}

// function moveCamera(x, y, z){
//     gsap.to(camera.position, {
//         x,
//         y,
//         z,
//         duration: 3
//     });
// }

// function rotateCamera(x, y, z){
//     gsap.to(camera.rotation, {
//         x,
//         y,
//         z,
//         duration: 3.2
//     })
// }

function moveCam(object){
    var aabb = new THREE.Box3().setFromObject( object ); 
  var center = aabb.getCenter( new THREE.Vector3() );
  var size = aabb.getSize( new THREE.Vector3() );

  console.log(center.x + ' ' + center.y + ' ' + center.z);
  
  var camPosition = camera.position.clone();  
  var targPosition = object.position.clone();  
  var distance = camPosition.sub(targPosition);  
  var direction = distance.normalize();  
  var offset = distance.clone().sub(direction.multiplyScalar(1.75));  
  var newPos = object.position.clone().sub(offset);
  newPos.y = camera.position.y;
  
  var pl = gsap.timeline( );
  
  pl.to( controls.target, {
    duration: 1,
    x: center.x,
    y: center.y,
    z: center.z,
    // ease: "power4.in",
    ease: "circ.in",
    onUpdate: function() {
      controls.update();
    }
  })
    .to( camera.position, {
    //delay: 1.3,
    duration: 2,
    ease: "power4.out",
    // ease: "slow (0.7, 0.1, false)",    
    x: newPos.x,
    y: center.y,
    z: center.z,
    onUpdate: function() {
      controls.update();
    }
  });
}

// for responsiveness
function onWindowResize() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
}

window.addEventListener('mousemove', onMouseMove); // triggered when mouse pointer is moved.

window.addEventListener('mouseup', onMouseUp); // triggered when mouse pointer is clicked.
window.addEventListener('mousedown', onMouseDown);

window.addEventListener('resize', onWindowResize); // triggered when window is resized.

init();

function init() {


    container = document.createElement('div');
    // creating a container section(division) on our html page(not yet visible).
    document.body.appendChild(container);
    // assigning div to document's visible structure i.e. body.

    scene = new THREE.Scene();

    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.10, 1000);

    // Set initial camera position
    camera.position.set(0, 0, 180);
    camera.lookAt(0, 0, 0);

    // controls
    controls = new OrbitControls(camera, renderer.domElement);

    // controls.maxPolarAngle = Math.PI;
    controls.mouseButtons = {
        LEFT: THREE.MOUSE.ROTATE,
        MIDDLE: THREE.MOUSE.DOLLY,
        RIGHT: THREE.MOUSE.PAN
    }

    controls.zoomSpeed = 2.0;
	controls.panSpeed = 0.5;

    // controls.enableDamping = true;

    scene.add(camera);

    renderer.setClearColor(0x000000, 1); // Set clear color to black
    scene.background = new THREE.Color(0x000000); // Set scene background to black

    const Loader = new GLTFLoader();
    Loader.load('../3d_models/rack_3d_1535.glb', function (gltf) {

        model = gltf.scene;

        // Traverse the scene graph to find the specific mesh
        model.traverse((child) => {
            // Set up click event listener
            // child.addEventListener('click', () => {
            //     console.log('Clicked on:', child.name.toString());
            //     // Add your desired functionality here
            // });

            if (child.isMesh && child.name === ']') {
                // Access the material of the mesh
                child.material.color.set(0xff0000); // Set the color to red
            } else if (child.isMesh && child.name == 'r1rb11') {
                child.material.visible = false;
            } else if (child.isMesh && child.name == 'r1rb23') {
                child.material.color.set(0x3cb371);
            } else if (child.isMesh && child.name == 'r1lb33') {
                child.material.color.set(0xffa500);
            }
        });

        // console.log(model.children[0].name.toString());

        scene.add(model);

        scene.updateMatrixWorld(true);


        // Add ambient light
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.5); // Soft white light
        scene.add(ambientLight);

        // Add directional light
        const directionalLight = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
        directionalLight.position.set(0, 1, 1).normalize(); // Position the light
        scene.add(directionalLight);

        animate();



    }, undefined, function (error) {
        console.error(error);
    });

    renderer.setSize(window.innerWidth, window.innerHeight);

    container.appendChild(renderer.domElement);


    window.requestAnimationFrame(animate);
}

function animate() {
    controls.update();

    renderer.render(scene, camera);
    window.requestAnimationFrame(animate);
}
