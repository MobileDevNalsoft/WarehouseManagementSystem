const init = () => {

    const sendOverviewData = (data) => {
        window.localStorage.setItem('areasOverviewData', data);
    }

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

    const changeFacility = (data) => {
        window.localStorage.setItem("facilityData", data)
    }

    const getShoretestPathForTask=(data)=>{
        window.localStorage.setItem("getShoretestPathForTask", data)
    }

    const redBins=(data)=>{
        window.localStorage.setItem("redBins", data)
    }
    const orangeBins=(data)=>{
        window.localStorage.setItem("orangeBins", data)
    }

    const binsStatus=(data)=>{
        window.localStorage.setItem("binsStatus", data)
    }

    window._switchToMainCam = switchToMainCam;
    window._isRackDataLoaded = isRacksDataLoaded;
    window._setNumberOfTrucks = setNumberOfTrucks;
    window._resetTrucks = resetTrucks;
    window._highlightBins = highlightBins;
    window._navigateToBin = navigateToBin;
    window._resetBoxColors = resetBoxColors;
    window._sendOverviewData = sendOverviewData;
    window._changeFacility = changeFacility;
    window._getShoretestPathForTask = getShoretestPathForTask;
    window._redBins = redBins;
    window._orangeBins = orangeBins;
    window._binsStatus = binsStatus;
}

window.onload = () => {
    init();
}