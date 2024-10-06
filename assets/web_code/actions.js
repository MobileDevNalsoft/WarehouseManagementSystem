const init = () => {
    const switchToMainCam = () => {
        window.localStorage.setItem("switchToMainCam", "main")
    }

    const isRacksDataLoaded = (value) => {
        window.localStorage.setItem("isRackDataLoaded", value)
    }
    
    window._switchToMainCam = switchToMainCam;
    window._isRackDataLoaded = isRacksDataLoaded;
}

window.onload = () => {
    init();
}