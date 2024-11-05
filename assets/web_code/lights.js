import * as THREE from "three";

export function setupLights(scene) {
    // Add ambient light
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
    ambientLight.castShadow = false; // Soft white light
    scene.add(ambientLight);

    // // Add directional light
    const directionalLight = new THREE.DirectionalLight(0xffffff, 1); // Bright white light
    directionalLight.position.set(5, 5, 5); // Position the light
    scene.add(directionalLight);
}