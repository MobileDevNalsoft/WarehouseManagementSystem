import * as THREE from 'three';

// 
export function createRenderer(){
    const renderer = new THREE.WebGLRenderer({
        antialias: true, // Enables smoother edges (reduces jaggedness in rendering).
        alpha: true, //Allows the background to be transparent.
        logarithmicDepthBuffer: true,
        preserveDrawingBuffer: true,
      });
      renderer.setPixelRatio(Math.min(Math.max(1, window.devicePixelRatio), 2));
    
      // PMREM Generator for improved environment lighting
      const pmremGenerator = new THREE.PMREMGenerator(renderer);
      pmremGenerator.compileEquirectangularShader();

      return renderer;
}