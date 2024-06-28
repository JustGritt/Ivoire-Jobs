part of 'service_bloc.dart';

abstract class ServiceCreateState {
  const ServiceCreateState();

  List<Object> get props => [];
}

class CreateServiceInitial extends ServiceCreateState {}

class CreateServiceLoading extends ServiceCreateState {
  CreateServiceLoading();
}

class CreateServiceSuccess extends ServiceCreateState {
  final ServiceCreatedModel serviceCreateModel;

  const CreateServiceSuccess(this.serviceCreateModel);

  @override
  List<Object> get props => [serviceCreateModel];
}

class CreateServiceFailure extends ServiceCreateState {
  final String errorMessage;

  const CreateServiceFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
