import * as THREE from "three";
import { GLTFLoader } from 'https://cdn.jsdelivr.net/npm/three@0.149.0/examples/jsm/loaders/GLTFLoader.js';
import { OrbitControls } from "https://unpkg.com/three@0.112/examples/jsm/controls/OrbitControls.js";

var container;
var camera, scene;
var model;

let intersects = []
let hovered = {}

var targetRotationX = 0.5;
var targetRotationOnMouseDownX = 0;

var targetRotationY = 0.2;
var targetRotationOnMouseDownY = 0;

var mouseX = 0;
var mouseXOnMouseDown = 0;

var mouseY = 0;
var mouseYOnMouseDown = 0;

var windowHalfX = window.innerWidth / 2;
var windowHalfY = window.innerHeight / 2;

var slowingFactor = 0.25;

const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true })
renderer.setPixelRatio(Math.min(Math.max(1, window.devicePixelRatio), 2))
renderer.outputEncoding = THREE.sRGBEncoding

const raycaster = new THREE.Raycaster();
const mouse = new THREE.Vector2();

function onMouseMove(e) {
    console.log('mouse moved');
    mouse.set((e.clientX / window.innerWidth) * 2 - 1, -(e.clientY / window.innerHeight) * 2 + 1);

    // If a previously hovered item is not among the hits we must call onPointerOut
    Object.keys(hovered).forEach((key) => {
        const hit = intersects.find((hit) => hit.object.uuid === key)
        console.log(hit.toString());
        if (hit === undefined) {
            const hoveredItem = hovered[key]
            // if (hoveredItem.object.onPointerOver) hoveredItem.object.onPointerOut(hoveredItem)
            delete hovered[key]
        }
    })
}

function onMousedown(e) {
    raycaster.setFromCamera();
}

window.addEventListener('mousemove', onMouseMove);

document.addEventListener('mousedown', onMousedown);

init();

function init() {

    container = document.createElement('div');
    document.body.appendChild(container);

    scene = new THREE.Scene();

    camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.10, 1000);

    camera.position.x = 0;
    camera.position.y = 0;
    camera.position.z = 0;

    // controls
    var controls = new OrbitControls(camera, renderer.domElement);
    scene.add(camera);

    // var materials = [];

    // for (var i = 0; i < 6; i++) {

    //     materials.push(new THREE.MeshBasicMaterial({
    //         color: Math.random() * 0xffffff
    //     }));

    // }
    const Loader = new GLTFLoader();
    Loader.load('../3d_models/warehouse_0347.glb', function (gltf) {


        // const Material = new THREE.MeshStandardMaterial({
        //     color: 'green', metalness: 0.1,
        //     roughness: 0.5
        // });


        model = gltf.scene;

        // Traverse the scene graph to find the specific mesh
        model.traverse((child) => {
            // Set up click event listener
            // child.addEventListener('click', () => {
            //     console.log('Clicked on:', child.name.toString());
            //     // Add your desired functionality here
            // });

            console.log(child.name.toString());

            if (child.isMesh && child.name === 'r1lb11') {
                // Access the material of the mesh
                child.material.color.set(0xff0000); // Set the color to red
            } else if (child.isMesh && child.name == 'r1rb33') {
                child.material.color.set(0x3cb371);
            } else if (child.isMesh && child.name == 'r1rb23') {
                child.material.color.set(0x3cb371);
            } else if (child.isMesh && child.name == 'r1lb33') {
                child.material.color.set(0xffa500);
            }
        });

        // console.log(model.children[0].name.toString());

        scene.add(model);


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

    // const geometry = new THREE.BoxGeometry(100, 100, 100);
    // const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
    // const cube = new THREE.Mesh(geometry, material);
    // scene.add(cube);

    container.appendChild(renderer.domElement);

}

function animate() {

    requestAnimationFrame(animate);

    render();


}

function render() {

    targetRotationY = targetRotationY * (1 - slowingFactor);
    targetRotationX = targetRotationX * (1 - slowingFactor);

    raycaster.setFromCamera(mouse, camera);
    intersects = raycaster.intersectObjects(scene.children, true);

    if (intersects.length != 0) {
        console.log('intersects', intersects[0].object.name.toString());
    }
    for (let i = 0; i < intersects.length; i++) {
        console.log(intersects[i].object.name.toString());
    }
    renderer.render(scene, camera);

}