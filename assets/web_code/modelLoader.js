import * as GLTFLoader from "gltfLoader";
import * as THREE from "three";
import {DRACOLoader} from "draco";

export function loadModel() {
    const loader = new GLTFLoader.GLTFLoader();

    return new Promise((resolve, reject) => {
        // Create and configure the DRACOLoader
        const dracoLoader = new DRACOLoader();
        dracoLoader.setDecoderPath('https://cdn.jsdelivr.net/npm/three@0.114.0/examples/js/libs/draco/');
        loader.setDRACOLoader( dracoLoader );
        console.log(window.localStorage.getItem('facilityData'));
        const data = JSON.parse(window.localStorage.getItem('facilityData'));
        console.log(data);
        loader.load(
            getGLB(data.companyID, data.facilityID),
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

function getGLB(companyID, facilityID){
    switch(companyID){
        case 1: switch(facilityID){
            case 1: 
                return  "../glbs/wartehouse_1312_1235.glb";
            case 2:
                return "../glbs/warehouse_2811_0604.glb";
        }
    }
}