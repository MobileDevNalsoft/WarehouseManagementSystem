import * as THREE from "three";
import { GLTFLoader } from 'https://cdn.jsdelivr.net/npm/three@0.149.0/examples/jsm/loaders/GLTFLoader.js';
import { OrbitControls } from "https://unpkg.com/three@0.112/examples/jsm/controls/OrbitControls.js";
import { DragControls } from "https://cdn.jsdelivr.net/npm/three@0.114/examples/jsm/controls/DragControls.js";


window.addEventListener('storage', (event) => {
    if (event.key) {
    boxes[event.newValue].material.color.set(0x3cb371);
    }
});

var container, camera, scene, controls, model;
var cameraPos0   // initial camera position
var cameraUp0    // initial camera up
var cameraZoom   // camera zoom
var iniQ         // initial quaternion
var endQ         // target quaternion
var curQ         // temp quaternion during slerp
var vec3         // generic vector object
var tweenValue   // tweenable value
var camera_is_moving ;
var objects =[];
var orbitControls;
var dragControls;
 
 
 
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
var camPos = new THREE.Vector3(0, 0, 0);       // Holds current camera position
var targetPos = new THREE.Vector3(10, 10, -10);// Target position
var origin = new THREE.Vector3(0, 0, 0)
 
function onMouseMove(e) {
    // regularly updating the position of mouse pointer when it is moved on rendered window.
    mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
    mouse.y = - (e.clientY / window.innerHeight) * 2 + 1;
    // console.log("mouse move");
 
}
// Function to calculate distance between two points
 
// Function to smoothly move the camera to the clicked object
//requestAnimationFrame(animateCamera);
 
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
            // console.log(intersects[0].object.position.x.toString() + ' ' + intersects[0].object.position.y.toString() + ' ' + intersects[0].object.position.z.toString());
           
                intersects[0].object.material.color.set(0xff0000);
                // moveToObject(intersects[0].object);
                console.info(JSON.stringify({"type":"click","object":intersects[0].object.name.toString()}));
                // console.log(intersects[0].object.name.toString());
               
                moveCam(intersects[0].object,intersects[0].object.name.toString());
            
        }
    }
 
}   
// set a new target for the camera
 
// on every update of the tween
 
function dragStartCallback(event) {
    startColor = event.object.material.color.getHex();
    event.object.material.color.setHex(0x000000);
}
 
function dragendCallback(event) {
    event.object.material.color.setHex(startColor);
}
function moveCam(object,name){
    var aabb = new THREE.Box3().setFromObject( object );
  var center = aabb.getCenter( new THREE.Vector3() );
  var size = aabb.getSize( new THREE.Vector3() );
 
  console.log(center.x + ' ' + center.y + ' ' + center.z);
  
  var camPosition = camera.position.clone();  
  var targPosition = object.position.clone();  
  var distance = camPosition.sub(targPosition);  
  var direction = distance.normalize();  
  var offset = distance.clone().sub(direction.multiplyScalar(1));  
  var newPos = object.position.clone().sub(offset);
  newPos.y = camera.position.y;
  
  var pl = gsap.timeline( );
 
 
  if(name.includes("r1r")){
    gsap.to( camera.position, {
        duration: 1,
        x: center.x+size.x+1.5,
        y: center.y+1, // place camera a bit higher than the object
        z: center.z , // maybe adding even more offset depending on your model
        onUpdate: function() {
            // console.log("center"+center.x);
            camera.lookAt( object.position );
            //  /important
        }
    } );
    
    
    gsap.to( orbitControls.target, {
        duration: 1,
        x: center.x,
        y: center.y, //set the center of the controler to the zoomed object
        z: center.z ,
        onUpdate: function(){
            // console.log("ANGLE "+center.x)
            camera.lookAt(object.position);
        },// no distance needed
        onComplete: ()=>{
            
            
            controls.enabled = true; // activate the controler again after animation
        }
    } );
  }else if(name.includes("r1l")){
    gsap.to( camera.position, {
        duration: 1,
        x: (center.x-size.x),
        y: center.y+1, // place camera a bit higher than the object
        z: center.z , // maybe adding even more offset depending on your model
        onUpdate: function() {
            // console.log("center"+center.x);
            camera.lookAt( object.position );
            //  /important
        }
    } );
    
    
    gsap.to( orbitControls.target, {
        duration: 1,
        x: center.x,
        y: center.y, //set the center of the controler to the zoomed object
        z: center.z ,
        onUpdate: function(){
            // console.log("ANGLE "+center.x)
            camera.lookAt(object.position);
        },// no distance needed
        onComplete: ()=>{
            
            
            orbitControls.enabled = true; // activate the controler again after animation
        }
    } );
  }else{
    gsap.to( camera.position, {
        duration: 1,
        x: center.x,
        y: center.y+25, // place camera a bit higher than the object
        z: center.z , // maybe adding even more offset depending on your model
        onUpdate: function() {
            // console.log("center"+center.x);
            camera.lookAt( object.position );
            //  /important
        }
    } );
    
    
    gsap.to( orbitControls.target, {
        duration: 1,
        x: center.x,
        y: center.y, //set the center of the controler to the zoomed object
        z: center.z ,
        onUpdate: function(){
            // console.log("ANGLE "+center.x)
            camera.lookAt(object.position);
        },// no distance needed
        onComplete: ()=>{
            
            
            orbitControls.enabled = true; // activate the controler again after animation
        }
    } );
  }
 
}
function onDragEvent(e) {
    var plane = new THREE.Plane(new THREE.Vector3(0, 1, 0), 0);
var raycaster = new THREE.Raycaster();
var intersects = new THREE.Vector3();
    raycaster.setFromCamera(mouse, camera);
    raycaster.ray.intersectPlane(plane, intersects);
    e.object.position.set(intersects.x, intersects.y, intersects.z);
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
     orbitControls = new OrbitControls( camera, renderer.domElement );
        
     dragControls = new DragControls( objects, camera, renderer.domElement );
    
   
 
    // controls.maxPolarAngle = Math.PI;
    orbitControls.mouseButtons = {
        LEFT: THREE.MOUSE.ROTATE,
        MIDDLE: THREE.MOUSE.DOLLY,
        RIGHT: THREE.MOUSE.PAN
    }
 
    orbitControls.zoomSpeed = 2.0;
    orbitControls.panSpeed = 0.5;
 
    // controls.enableDamping = true;
    
     dragControls.addEventListener( 'dragstart', function () {
          
        // console.log("drag start");
        orbitControls.enabled = false; } );
    dragControls.addEventListener( 'drag', onDragEvent );
    dragControls.addEventListener( 'dragend', function () { orbitControls.enabled = true; } );
   
 
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
 
       // scene.updateMatrixWorld(true);
 
 
        // Add ambient light
        const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
        ambientLight.castShadow  = true// Soft white light
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
    orbitControls.update();
 
    renderer.render(scene, camera);
    window.requestAnimationFrame(animate);
}
 