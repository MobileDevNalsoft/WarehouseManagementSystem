const init = () => {

    const sendOverviewData = (data) => {
        window.localStorage.setItem('areasOverviewData', data);
    }

    const sendTrucksData = (data) => {
        window.localStorage.setItem('trucksData', data);
    }

    const isRacksDataLoaded = (value) => {
        window.localStorage.setItem("isRackDataLoaded", value)
    }

    const changeFacility = (data) => {
        window.localStorage.setItem("facilityData", data)
    }




    window._isRackDataLoaded = isRacksDataLoaded;
    window._sendOverviewData = sendOverviewData;
    window._sendTrucksData = sendTrucksData;
    window._changeFacility = changeFacility;

}

window.onload = () => {
    init();
}