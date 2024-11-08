import * as GLTFLoader from "gltfLoader";

export function loadModel() {
    const loader = new GLTFLoader.GLTFLoader();

    return new Promise((resolve, reject) => {
        loader.load(
            "../glbs/final.glb",
            function (gltf) {
                resolve(gltf); // Resolve with the loaded glTF model
            },
            undefined,
            function (error) {
                console.error('{"Error":"' + error.toString() + '"}');
                reject(error); // Reject if there's an error
            }
        );
    });
}