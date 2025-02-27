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
