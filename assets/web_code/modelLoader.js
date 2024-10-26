import { GLTFLoader } from "https://cdn.jsdelivr.net/npm/three@latest/examples/jsm/loaders/GLTFLoader.js";

export function loadModel() {
    const loader = new GLTFLoader();
    
    loader.load("../glbs/warehouse_2410_1125.glb", function (gltf) {
        return gltf.scene;
    }, undefined, function (error) {
        console.error('{"Error":"' + error.toString() + '"}');
    });
}