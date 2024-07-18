import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_create_model.dart';
import 'package:barassage_app/features/main_app/providers/my_services_provider.dart';
import 'package:barassage_app/features/main_app/services/service_services.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

part 'service_event.dart';
part 'service_create_state.dart';

ServiceServices serviceServices = serviceLocator<ServiceServices>();
MyServicesProvider myServicesProvider = serviceLocator<MyServicesProvider>();

class ServiceBloc extends Bloc<ServiceEvent, ServiceCreateState> {
  ServiceBloc() : super(CreateServiceInitial()) {
    on<ServiceEvent>((event, emit) {});

    on<CreateServiceEvent>((event, emit) async {
      emit(CreateServiceLoading());
      try {
        MyServicesProvider myServicesProvider = MyServicesProvider();
        ServiceCreatedModel serviceCreatedModel =
            await serviceServices.create(event.service);
        myServicesProvider.addService(serviceCreatedModel);
        emit(CreateServiceSuccess(serviceCreatedModel));
      } on DioException catch (e) {
        if (e.message != null && e.message!.contains("413")) {
          return emit(const CreateServiceFailure("File too large"));
        }
        if (e.response?.data['message']?.runtimeType == String &&
            e.response?.data['message'] != null) {
          return emit(CreateServiceFailure(e.response?.data['message']));
        } else if (e.response?.data['errors']?.runtimeType == List) {
          return emit(
              CreateServiceFailure(e.response?.data['errors'][0]['msg']));
        } else {
          return emit(const CreateServiceFailure("An error occurred"));
        }
      } on Exception catch (e) {
        emit(CreateServiceFailure(e.toString()));
      }
    });
  }
}
