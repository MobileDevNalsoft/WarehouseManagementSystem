export function addSkyDome() {
    // Load the skydome texture
    const loader = new THREE.TextureLoader();
    loader.load("../images/sky_box.jpg", function (texture) {
      // Create a large sphere geometry for the skydome
      const geometry = new THREE.SphereGeometry(650, 32, 32);

      texture.wrapS = THREE.RepeatWrapping; // Ensure the texture wraps horizontally
      texture.wrapT = THREE.ClampToEdgeWrapping; // Optionally clamp vertically to prevent top/bottom seams
      texture.minFilter = THREE.LinearFilter; // Smooth out texture if it's low-res

      // Create a material using the loaded texture
      const material = new THREE.MeshBasicMaterial({
        map: texture,
        side: THREE.BackSide, // Render the inside of the sphere
      });

      // Create the skydome mesh
      const skydome = new THREE.Mesh(geometry, material);

      skydome.rotation.y = Math.PI / 2;

      skydome.position.y = 100;

      // Add the skydome to the scene
      scene.add(skydome);
    });
  }