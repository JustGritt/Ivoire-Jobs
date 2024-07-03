import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_create_model.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/features/main_app/services/service_services.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

part 'service_event.dart';
part 'service_create_state.dart';

ServiceServices serviceServices = serviceLocator<ServiceServices>();

class ServiceBloc extends Bloc<ServiceEvent, ServiceCreateState> {
  ServiceBloc() : super(CreateServiceInitial()) {
    on<ServiceEvent>((event, emit) {});

    on<CreateServiceEvent>((event, emit) async {
      emit(CreateServiceLoading());
      try {
        ServiceCreatedModel serviceCreatedModel =
            await serviceServices.create(event.service);
        emit(CreateServiceSuccess(serviceCreatedModel));
      } on DioException catch (e) {
        if (e.message != null && e.message!.contains("413")) {
          return emit(const CreateServiceFailure("File too large"));
        }
        if (e.response?.data['message']?.runtimeType == String &&
            e.response?.data['message'] != null) {
          return emit(CreateServiceFailure(e.response?.data['message']));
        } else {
          return emit(const CreateServiceFailure("An error occurred"));
        }
      } on Exception catch (e) {
        emit(CreateServiceFailure(e.toString()));
      }
    });
  }
}
