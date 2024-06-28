part of 'service_bloc.dart';

abstract class ServiceEvent {
  const ServiceEvent();

  List<Object> get props => [];
}

class CreateServiceEvent extends ServiceEvent {
  final ServiceCreateModel service;

  const CreateServiceEvent(this.service);

  @override
  List<Object> get props => [service];
}
