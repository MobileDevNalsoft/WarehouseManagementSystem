const globalState = {
    areaFocused: false,
    scene: null,
    camera: null,
    controls: null,
    setAreaFocused(value) {
        this.areaFocused = value;
    },
    setSceneCameraControls(scene, camera, controls){
        this.scene = scene;
        this.camera = camera;
        this.controls = controls;
    }
};

export {globalState};