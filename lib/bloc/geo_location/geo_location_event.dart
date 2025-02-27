part of 'geo_location_bloc.dart';

@immutable
sealed class GeoLocationEvent {}

class GetRouteForCoordinates extends GeoLocationEvent{
  List startPoint;
  List endPoint;
  GetRouteForCoordinates({required this.startPoint,required this.endPoint});
}


class LoadRoute extends GeoLocationEvent {
  final LatLng start;
  final LatLng end;
  final List<LatLng> waypoints;

  LoadRoute({required this.start, required this.end, required this.waypoints});

  @override
  List<Object> get props => [start, end, waypoints];
}


class SetMarkers extends GeoLocationEvent {
  

  SetMarkers();


}



class AnimateDriver extends GeoLocationEvent {
 
    StreamSink<List<Marker>>
        mapMarkerSink; //Stream build of map to update the UI
    TickerProvider
        provider; 

  AnimateDriver({required this.mapMarkerSink,required this.provider});

  @override
  List<Object> get props => [mapMarkerSink, provider];
}