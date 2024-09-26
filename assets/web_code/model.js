import * as THREE from "three";
import { GLTFLoader } from 'https://cdn.jsdelivr.net/npm/three@0.149.0/examples/jsm/loaders/GLTFLoader.js';
import { OrbitControls } from "https://unpkg.com/three@0.112/examples/jsm/controls/OrbitControls.js";

var container, camera, scene, controls, model, port;

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

function onMousedown(e) {

    raycaster.setFromCamera(mouse, camera);
    // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
    const intersects = raycaster.intersectObjects(scene.children, true);
    // we get the objects from the model as list that are intersected by the casted ray.

    if (intersects.length > 0) {
        if (intersects[0].object.name.toString().includes('r1')) {
            intersects[0].object.material.color.set(0xff0000);
            console.log(intersects[0].object.name.toString());
        }
    }
}

// for responsiveness
function onWindowResize() {
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(window.innerWidth, window.innerHeight);
}

window.addEventListener('mousemove', onMouseMove); // triggered when mouse pointer is moved.

window.addEventListener('mousedown', onMousedown); // triggered when mouse pointer is clicked.

window.addEventListener('resize', onWindowResize); // triggered when window is resized.

init();

function init() {


    container = document.createElement('div');
    // creating a container section(division) on our html page(not yet visible).
    document.body.appendChild(container);
    // assigning div to document's visible structure i.e. body.

    scene = new THREE.Scene();

    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.10, 1000);

    camera.position.x = 0;
    camera.position.y = 80;
    camera.position.z = 0;

    // controls
    controls = new OrbitControls(camera, renderer.domElement);

    // controls.maxPolarAngle = Math.PI;
    controls.mouseButtons = {
	LEFT: THREE.MOUSE.ROTATE,
	MIDDLE: THREE.MOUSE.DOLLY,
	RIGHT: THREE.MOUSE.PAN
}   

    // controls.enableDamping = true;

    scene.add(camera);

    renderer.setClearColor(0x000000, 1); // Set clear color to black
    scene.background = new THREE.Color(0x000000); // Set scene background to black

    const Loader = new GLTFLoader();
    Loader.load('../3d_models/warehouse_0347.glb', function (gltf) {

        model = gltf.scene;

        // Traverse the scene graph to find the specific mesh
        model.traverse((child) => {
            // Set up click event listener
            // child.addEventListener('click', () => {
            //     console.log('Clicked on:', child.name.toString());
            //     // Add your desired functionality here
            // });

            console.log(child.position.x.toString());

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

//from flutter

// listen for messages
window.addEventListener('message', function (event) {
    if (event.data == 'capturePort') {
        // capture port2 coming from the Dart side
        if (event.ports[0] != null) {
            // the port is ready for communication,
            // so you can use port.postMessage(message); wherever you want
            port = event.ports[0];
            // To listen to messages coming from the Dart side, set the onmessage event listener
            port.onmessage = function (event) {
                // event.data contains the message data coming from the Dart side 
                console.log('got data', event.data);
            };
        }
    }
}, false);

function test() {
    console.log('testing');
}