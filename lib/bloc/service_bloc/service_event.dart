part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

class GetAllServicess extends ServiceEvent {
  final String query;
  GetAllServicess({this.query = ''});
}

class CreateServices extends ServiceEvent {
  // final ServicesCreationModel model;
  // CreateServices({required this.model});
}
