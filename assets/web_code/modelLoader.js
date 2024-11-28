import * as GLTFLoader from "gltfLoader";

export function loadModel() {
    const loader = new GLTFLoader.GLTFLoader();

    return new Promise((resolve, reject) => {
        loader.load(
            "../glbs/warehouse_2811_0615.glb",
            function (gltf) {
                resolve(gltf); // Resolve with the loaded glTF model
            },
            (xhr) => {
                if(xhr.lengthComputable){
                    let percentComplete = (xhr.loaded/xhr.total)*100;

                    console.log('{"percentComplete":"' + Math.round(percentComplete) + '"}')
                }
            },
            undefined,
            function (error) {
                console.error('{"Error":"' + error.toString() + '"}');  
                reject(error); // Reject if there's an error
            }
        );
    })
}