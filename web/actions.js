const init = () => {
    const switchToMainCam = () => {
        window.localStorage.setItem("switchToMainCam", "warehouse")
    }

    const isRacksDataLoaded = (value) => {
        window.localStorage.setItem("isRackDataLoaded", value)
    }
    const setNumberOfTrucks = (value) => {
        window.localStorage.setItem("setNumberOfTrucks", value)
    }
    const resetTrucks = () => {
        window.localStorage.setItem("resetTrucks", "true")
    }
    
    window._switchToMainCam = switchToMainCam;
    window._isRackDataLoaded = isRacksDataLoaded;
    window._setNumberOfTrucks = setNumberOfTrucks;
    window._resetTrucks = resetTrucks;
}

window.onload = () => {
    init();
}