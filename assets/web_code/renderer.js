import * as THREE from "three";

export function createRenderer(){
    // Rendering Setup
    // we use WebGL renderer for rendering 3d model efficiently
    const renderer = new THREE.WebGLRenderer({
        antialias: true,
        alpha: true,
        logarithmicDepthBuffer: true,
        preserveDrawingBuffer: true,
    });
    renderer.setPixelRatio(Math.min(Math.max(1, window.devicePixelRatio), 2));

    // Environment Setup
    // PMREM Generator for improved environment lighting
    const pmremGenerator = new THREE.PMREMGenerator(renderer);
    pmremGenerator.compileEquirectangularShader();

    return renderer;
}