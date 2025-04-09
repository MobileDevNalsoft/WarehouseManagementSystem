part of 'trips_bloc.dart';

abstract class TripsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// To switch between the tabs
class GetTrips extends TripsEvent {
  GetTrips();

  @override
  List<Object> get props => [];
}

class LoadRoute extends TripsEvent {
  final LatLng start;
  final LatLng end;
  final List<LatLng>? waypoints;
  final BuildContext context;

  LoadRoute({required this.start, required this.end,  this.waypoints,required this.context});

  @override
  List<Object> get props => [start, end];
}


class SetMarkers extends TripsEvent {
  
  final BuildContext context;

  SetMarkers({required this.context});


}



class AnimateDriver extends TripsEvent {
   final BuildContext context;

    StreamController<List<Marker>>
        mapMarkerSC; //Stream build of map to update the UI
    TickerProvider
        provider; 

  AnimateDriver({required this.mapMarkerSC,required this.provider,required this.context});

  @override
  List<Object> get props => [mapMarkerSC, provider];
}


class HideOverlay extends TripsEvent {  
  HideOverlay();
}
 
class ShowOverlay extends TripsEvent {
  final BuildContext context;
  final LatLng activeMarkerPosition;
  final Widget? overlayWidget;
  ShowOverlay({ required this.activeMarkerPosition,required this.context, this.overlayWidget});

  @override
  List<Object> get props => [ activeMarkerPosition,context];
}

class UpdateMapProperties extends TripsEvent {
  
BuildContext context;
  UpdateMapProperties({required this.context});

}