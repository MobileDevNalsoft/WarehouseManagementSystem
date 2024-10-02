import * as THREE from "three";
import { GLTFLoader } from 'https://cdn.jsdelivr.net/npm/three@0.149.0/examples/jsm/loaders/GLTFLoader.js';
import { OrbitControls } from "https://cdn.jsdelivr.net/npm/three@0.149.0/examples/jsm/controls/OrbitControls.js";

var container, camera, scene, controls, model = new THREE.Object3D(), cameraList = [], prevBinColor, prevBin;

var main_cam;

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

init();

function init() {


    container = document.createElement('div');
    // creating a container section(division) on our html page(not yet visible).
    document.body.appendChild(container);
    // assigning div to document's visible structure i.e. body.

    scene = new THREE.Scene();


    const groundGeometry = new THREE.PlaneGeometry(1000, 1000);
    const groundMaterial = new THREE.MeshStandardMaterial({ color: 0x686868 });
    const ground = new THREE.Mesh(groundGeometry, groundMaterial);
    ground.rotation.x = -Math.PI / 2; // Rotate to horizontal
    scene.add(ground);


    const Loader = new GLTFLoader();
    Loader.load('../3d_models/warehouse_0347.glb', function (gltf) {

        model = gltf.scene;

        cameraList = gltf.cameras;

        main_cam = cameraList[0];

        console.log(dumpObject(model).join('\n'));

        createNewCamera(main_cam);


        scene.add(model);

        scene.getObjectByName('r1rb11004').material.color.set(0xff0000);

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
    renderer.render(scene, camera);
    window.requestAnimationFrame(animate);
}

function dumpObject(obj, lines = [], isLast = true, prefix = '') {
    const localPrefix = isLast ? '└─' : '├─';
    lines.push(`${prefix}${prefix ? localPrefix : ''}${obj.name || '*no-name*'} [${obj.type}]`);
    const newPrefix = prefix + (isLast ? '  ' : '│ ');
    const lastNdx = obj.children.length - 1;
    obj.children.forEach((child, ndx) => {
        const isLast = ndx === lastNdx;
        dumpObject(child, lines, isLast, newPrefix);
    });
    return lines;
}


function createNewCamera(importedCamera) {
    const fov = importedCamera.fov; // Field of view
    const aspect = window.innerWidth / window.innerHeight; // Aspect ratio
    const near = importedCamera.near; // Near clipping plane
    const far = importedCamera.far; // Far clipping plane

    // Create a new Perspective Camera
    camera = new THREE.PerspectiveCamera(fov, aspect, near, far);

    // Set the position of the new camera based on the imported camera's position
    camera.position.set(0, 250, 150);
    camera.quaternion.copy(importedCamera.quaternion);
    camera.rotation.copy(importedCamera.rotation); // Copy rotation if needed

    scene.add(camera);

    // Set up OrbitControls with the new camera
    controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true; // Enable smooth movement
    controls.dampingFactor = 0.25;
    controls.zoomSpeed = 2;
    controls.panSpeed = 2;
    controls.screenSpacePanning = false;

    // limiting vertical rotation around x axis
    controls.minPolarAngle = 0;
    controls.maxPolarAngle = Math.PI / 3;

    // limiting horizontal rotation around y axis
    controls.minAzimuthAngle = -Math.PI;
    controls.maxAzimuthAngle = Math.PI;

    // limiting zoom out
    controls.maxDistance = 500;

    var minPan = new THREE.Vector3(- 2, - 2, - 2);
    var maxPan = new THREE.Vector3(2, 2, 2);

    // Function to clamp target position
    function clampTarget() {
        controls.target.x = Math.max(minPan.x, Math.min(maxPan.x, controls.target.x));
        controls.target.y = Math.max(minPan.y, Math.min(maxPan.y, controls.target.y));
        controls.target.z = Math.max(minPan.z, Math.min(maxPan.z, controls.target.z));
    }

    // Listen for changes in controls
    controls.addEventListener('change', clampTarget);

    // Initial call to set target within bounds if necessary
    clampTarget();

    // Make the camera look at a specific point (optional)
    const center = new THREE.Vector3(0, 0, 0); // Adjust this based on your scene
    controls.target.copy(center);

    // Update controls to reflect the target position
    controls.update();
}

function switchCamera(name) {

    let selectedCamera;
    let center;

    if (name == 'main') {
        center = new THREE.Vector3(0, 0, 0);
        selectedCamera = cameraList.find((cam) => cam.name.toString().includes(name));
    } else {
        const object = scene.getObjectByName(name.split('_')[0])
        console.log(object.name.toString());
        const aabb = new THREE.Box3().setFromObject(object);
        center = aabb.getCenter(new THREE.Vector3());
        selectedCamera = cameraList.find((cam) => cam.name.toString().includes(object.name.toString()));
    }

    if (selectedCamera) {
        // Create a GSAP timeline for smoother transitions
        const timeline = gsap.timeline();

        controls.enabled = false;
        controls.enableDamping = false;

        // Animate position and rotation simultaneously
        timeline.to(camera.position, {
            duration: 3,
            x: selectedCamera.position.x,
            y: selectedCamera.position.y,
            z: selectedCamera.position.z,
            ease: "power3.inOut"
        }).to(camera.quaternion, {
            duration: 3,
            x: selectedCamera.quaternion.x,
            y: selectedCamera.quaternion.y,
            z: selectedCamera.quaternion.z,
            w: selectedCamera.quaternion.w,
            ease: "power3.inOut",
            onComplete: function(){
                controls.enabled = true; // Enable controls after switching cameras
                controls.enableDamping = true;
                controls.target.copy(center);
                camera.lookAt(controls.target);
            }
        }, 0); // Start rotation animation at the same time as position animation
    }
}


function onMouseMove(e) {
    // regularly updating the position of mouse pointer when it is moved on rendered window.
    mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
    mouse.y = - (e.clientY / window.innerHeight) * 2 + 1;
    if (e.button === 0) {
        raycaster.setFromCamera(mouse, camera);
        // This method sets up the raycaster to cast a ray from the camera into the 3D scene based on the current mouse position. It allows you to determine which objects in the scene are intersected by that ray.
        const intersects = raycaster.intersectObjects(scene.children, true);
        // we get the objects from the model as list that are intersected by the casted ray.

        if (intersects.length > 0) {
            const targetObject = intersects[0].object;
            if (targetObject.name.toString().includes('navigation')) {
                console.log(targetObject.name.toString());
            }
        }
    }
}

function onMouseDown(e) {
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
            const targetObject = intersects[0].object;
            console.log(targetObject.position.x.toString() + ' ' + targetObject.position.y.toString() + ' ' + targetObject.position.z.toString());
            if (targetObject.name.toString().includes('cam')) {
                console.log(targetObject.name.toString());
                switchCamera(targetObject.name.toString());
            }
            else if (targetObject.name.toString().includes('b')) {
                changeColor(targetObject);
            } else {
                switchCamera('main');
            }
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
window.addEventListener('mousedown', onMouseDown);
window.addEventListener('mouseup', onMouseUp); // triggered when mouse pointer is clicked.
window.addEventListener('resize', onWindowResize); // triggered when window is resized.

function changeColor(object) {

    if (prevBin != null) {
        prevBin.material.color.copy(prevBinColor);
    }

    prevBinColor = object.material.color.clone();
    if (prevBin != object) {
        object.userData.active = true;
        object.material.color.set(0xffffff);
    } else {
        if (object.userData.active == false) {
            object.userData.active = true;
            prevBinColor = object.material.color.clone();
            prevBin = object;
            object.material.color.set(0xffffff);
        } else {
            object.userData.active = false;
        }
    }
    prevBin = object;
}


function frameArea(sizeToFitOnScreen, boxSize, boxCenter, camera) {

    const halfSizeToFitOnScreen = sizeToFitOnScreen * 0.5;
    const halfFovY = THREE.MathUtils.degToRad(camera.fov * .5);
    const distance = halfSizeToFitOnScreen / Math.tan(halfFovY);
    // compute a unit vector that points in the direction the camera is now
    // in the xz plane from the center of the box
    const direction = (new THREE.Vector3())
        .subVectors(camera.position, boxCenter)
        .multiply(new THREE.Vector3(1, 0, 1))
        .normalize();

    // move the camera to a position distance units way from the center
    // in whatever direction the camera was from the center already
    camera.position.copy(direction.multiplyScalar(distance).add(boxCenter));

    // pick some near and far values for the frustum that
    // will contain the box.
    camera.near = boxSize / 100;
    camera.far = boxSize * 100;

    camera.updateProjectionMatrix();

    // point the camera to look at the center of the box
    camera.lookAt(boxCenter.x, boxCenter.y, boxCenter.z);

}

