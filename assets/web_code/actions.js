const init = () => {
    const switchToMainCam = () => {
        window.localStorage.setItem("switchToMainCam", "main")
    }
    
    window._switchToMainCam = switchToMainCam;
}

window.onload = () => {
    init();
}