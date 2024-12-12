import * as THREE from "three";

export function highlightArea(scene, objectName, rgbColor, opacity = 1.0) {
  const object = scene.getObjectByName(objectName);
  
  if (object) {
    // Access the geometry
    object.visible=true;
    const geometry = object.geometry;
  
    if (geometry && geometry.attributes.position) {
      // Ensure the bounding box is calculated to normalize vertex positions
      geometry.computeBoundingBox();
  
      // Get the min and max Y values from the bounding box
      const minY = geometry.boundingBox.min.y;
      const maxY = geometry.boundingBox.max.y;
  
      // Create color data for the gradient
      const position = geometry.attributes.position;
      const colors = [];
  
      // Loop through all vertices
      for (let i = 0; i < position.count; i++) {
        const y = position.getY(i); // Get the Y-coordinate of the vertex
        const normalizedY = 1- (y - minY) / (maxY - minY); // Normalize Y to range [0, 1]
  
        // Define gradient color: rgbColor with varying alpha
        colors.push(rgbColor.r / 255, rgbColor.g / 255, rgbColor.b / 255, normalizedY); // RGBA: color with varying alpha
      }
  
      // Add the color attribute to the geometry
      geometry.setAttribute('color', new THREE.BufferAttribute(new Float32Array(colors), 4)); // 4 components: R, G, B, A
  
      // Create a material that supports vertex colors and transparency
      const material = new THREE.MeshBasicMaterial({
        vertexColors: true, // Use vertex colors
        transparent: true, // Allow transparency
        side: THREE.DoubleSide, // Render both sides of the plane
        opacity: opacity // Set the opacity (0.0 is fully transparent, 1.0 is fully opaque)
      });
  
      // Apply the material to the object mesh
      object.material = material;
    } else {
      console.error("The geometry of the object does not have position attributes.");
    }
  } else {
    console.error("No mesh found with the name '" + objectName + "'");
  }

  // if (object) {
  //   const geometry = object.geometry;

  //   if (geometry && geometry.attributes.position) {
  //     geometry.computeBoundingBox();

  //     const minX = geometry.boundingBox.min.x;
  //     const maxX = geometry.boundingBox.max.x;

  //     const position = geometry.attributes.position;
  //     const colors = [];

  //     for (let i = 0; i < position.count; i++) {
  //       const x = position.getX(i); // Get the X-coordinate of the vertex
  //       const normalizedX = (x - minX) / (maxX - minX); // Normalize X to range [0, 1]

  //       // Define gradient color: rgbColor with varying alpha
  //       colors.push(
  //         rgbColor.r / 255, // Red
  //         rgbColor.g / 255, // Green
  //         rgbColor.b / 255, // Blue
  //         normalizedX       // Alpha (gradient effect)
  //       );
  //     }

  //     geometry.setAttribute('color', new THREE.BufferAttribute(new Float32Array(colors), 4)); // RGBA

  //     const material = new THREE.MeshBasicMaterial({
  //       vertexColors: true,
  //       transparent: true,
  //       side: THREE.DoubleSide,
  //       opacity: opacity
  //     });

  //     object.material = material;
  //   } else {
  //     console.error("The geometry of the object does not have position attributes.");
  //   }
  // } else {
  //   console.error("No mesh found with the name '" + objectName + "'");
  // }
}
