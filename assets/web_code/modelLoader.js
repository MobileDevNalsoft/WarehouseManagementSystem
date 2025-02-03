import * as GLTFLoader from "gltfLoader";
import * as THREE from "three";
import {DRACOLoader} from "draco";

export async function loadModel() {
    const loader = new GLTFLoader.GLTFLoader();

    return new Promise((resolve, reject) => {
        // Create and configure the DRACOLoader
        const dracoLoader = new DRACOLoader();
        dracoLoader.setDecoderPath('https://cdn.jsdelivr.net/npm/three@0.114.0/examples/js/libs/draco/');
        loader.setDRACOLoader( dracoLoader );
        const data = JSON.parse(window.localStorage.getItem('facilityData'));
        loader.load(
            getGLB(data.companyID, data.facilityID, data.model),
            function (gltf) {

                resolve(gltf); // Resolve with the loaded glTF model
                console.log('{"percentComplete":"100"}');
                // return gltf;
            },
            (xhr) => {
                if(xhr.lengthComputable){
                    let percentComplete = (xhr.loaded/xhr.total)*99;

                    console.log('{"percentComplete":"' +
                         Math.round(percentComplete)
                          + '"}')
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

function getGLB(companyID, facilityID, model){
    switch(model){
        case 'warehouse':
            switch(companyID){
                case 1: switch(facilityID){
                    case 1: 
                        return  "../glbs/warehouse_2901_1018.glb";
                    case 2:
                        return "../glbs/warehouse_2.glb";
                }
            }
        case 'storageArea':
            return "../glbs/storage_area.glb"
    }
}