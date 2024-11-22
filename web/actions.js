const init = () => {
    const switchToMainCam = (camName) => {
        window.localStorage.setItem("switchToMainCam", camName);
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
    const highlightBins = (bins) => {
        window.localStorage.setItem("highlightBins", bins);
    }
    const resetBoxColors = () => {
        window.localStorage.setItem("resetBoxColors",true);
    }
    
    const navigateToBin = (bin)=>{
        window.localStorage.setItem("navigateToBin", bin);
    }
    window._switchToMainCam = switchToMainCam;
    window._isRackDataLoaded = isRacksDataLoaded;
    window._setNumberOfTrucks = setNumberOfTrucks;
    window._resetTrucks = resetTrucks;
    window._highlightBins = highlightBins;
    window._navigateToBin = navigateToBin;
    window._resetBoxColors = resetBoxColors;
}

window.onload = () => {
    init();
}