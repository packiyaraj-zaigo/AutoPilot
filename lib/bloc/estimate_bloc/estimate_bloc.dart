import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_pilot/Models/appointment_create_model.dart';
import 'package:auto_pilot/Models/canned_service_create.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/client_model.dart';
import 'package:auto_pilot/Models/create_estimate_model.dart';
import 'package:auto_pilot/Models/estimate_appointment_model.dart';
import 'package:auto_pilot/Models/estimate_model.dart';
import 'package:auto_pilot/Models/estimate_note_model.dart';
import 'package:auto_pilot/Models/order_image_model.dart';
import 'package:auto_pilot/Models/payment_history_model.dart';
import 'package:auto_pilot/Models/single_vehicle_info_model.dart';
import 'package:auto_pilot/Models/vendor_response_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/customer_bloc/customer_bloc.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_pilot/Models/customer_model.dart' as cm;

part 'estimate_event.dart';
part 'estimate_state.dart';

class EstimateBloc extends Bloc<EstimateEvent, EstimateState> {
  final ApiRepository _apiRepository;
  int currentPage = 1;
  int totalPages = 0;
  bool isFetching = false;
  bool isVendorsPagenationLoading = false;

  int paymentCurrentPage = 1;
  int paymentTotalPage = 0;
  bool paymentIsFetching = false;
  EstimateBloc({
    required ApiRepository apiRepository,
  })  : _apiRepository = apiRepository,
        super(EstimateInitial()) {
    on<GetEstimateEvent>(getEstimateBloc);
    on<CreateEstimateEvent>(createEstimateBloc);
    on<EditEstimateEvent>(editEstimateBloc);
    on<AddEstimateNoteEvent>(addEstimateNoteBloc);
    on<CreateAppointmentEstimateEvent>(createAppointmentEstimateBloc);
    on<GetSingleEstimateEvent>(getSingleEstimateBloc);
    on<GetEstimateNoteEvent>(getEstimateNoteBloc);
    on<GetEstimateAppointmentEvent>(getEstimateAppointmentBloc);
    on<EstimateUploadImageEvent>(uploadImageBloc);
    on<CreateOrderImageEvent>(createOrderImageBloc);
    on<GetAllOrderImageEvent>(getOrderImageBloc);
    on<DeleteOrderImageEvent>(deleteOrderImageBloc);
    on<CreateOrderServiceEvent>(createOrderServiceBloc);
    on<CreateOrderServiceItemEvent>(createOrderServiceItemBloc);
    on<EditEstimateNoteEvent>(editEstimateNoteBloc);
    on<DeleteEstimateNoteEvent>(deleteEstimateNoteBloc);
    on<EditAppointmentEstimateEvent>(editAppointmentEstimateBloc);
    on<DeleteOrderServiceEvent>(deleteOrderServiceBloc);
    on<SendEstimateToCustomerEvent>(sendEstimateToCustomerBloc);
    on<DeleteAppointmentEstimateEvent>(deleteAppointmentBloc);
    on<CollectPaymentEstimateEvent>(collectPaymentBloc);
    on<DeleteEstimateEvent>(deleteEstimateBloc);
    on<GetPaymentHistoryEvent>(getPaymentHistoryBloc);
    on<CreateEstimateFromAppointmentEvent>(createEstimateFromAppointment);
    on<AuthServiceByTechnicianEvent>(authServiceByTechnicianBloc);
    on<ChangeEstimateStatusEvent>(changeEstimateStateBloc);
    on<GetEventDetailsByIdEvent>(getEventDetailsByIdBloc);
    on<GetClientByIdInEstimateEvent>(getClientByIdEstimate);
    on<CreateCannedOrderServiceEstimateEvent>(createCannedOrderEstimateService);
    on<GetSingleCustomerDetailsEvent>(getSingleCustomerDetailsBloc);
    on<GetSingleVehicleDetailsEvent>(getSingleVehicleDetailsBloc);
    on<GetAllVendorsEstimateEvent>(getAllVendors);
  }

  Future<void> createEstimateFromAppointment(
    CreateEstimateFromAppointmentEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      emit(CreateEstimateLoadingState());
      final token = await AppUtils.getToken();
      final response = await _apiRepository.createNewEstimateFromAppointment(
          event.vehicleId, event.customerId, token);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final createModel = createEstimateModelFromJson(response.body);
        final appointmentResponse =
            await _apiRepository.editAppointmentEstimate(
          token,
          createModel.data.id.toString(),
          event.customerId,
          event.vehicleId,
          event.startTime,
          event.endTime,
          event.appointmentNote,
          event.appointmentId,
        );
        if (appointmentResponse.statusCode == 200 ||
            appointmentResponse.statusCode == 201) {
          emit(CreateEstimateState(
              createEstimateModel: createEstimateModelFromJson(response.body)));
        } else {
          emit(CreateEstimateErrorState(
              errorMessage:
                  'Estimate created but something went wrong with appointment'));
        }
      } else {
        emit(CreateEstimateErrorState(errorMessage: 'Something went wrong'));
      }
    } catch (e) {
      emit(CreateEstimateErrorState(errorMessage: 'Something went wrong'));
      log(e.toString() + " Create estimate from appointmet bloc error");
    }
  }

  Future<void> getEstimateBloc(
    GetEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      EstimateModel estimateModel;

      if (currentPage == 1) {
        emit(GetEstimateLoadingState());
      }

      Response getEstimateRes = await _apiRepository.getEstimate(
          token, event.orderStatus, currentPage);

      log("res${getEstimateRes.body}");

      if (getEstimateRes.statusCode == 200) {
        estimateModel = estimateModelFromJson(getEstimateRes.body);
        totalPages = estimateModel.data.lastPage ?? 1;
        isFetching = false;
        emit(GetEstimateState(estimateData: estimateModel));

        if (totalPages > currentPage && currentPage != 0) {
          currentPage += 1;
        } else {
          currentPage = 0;
        }
      } else {
        emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e, s) {
      emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> createEstimateBloc(
    CreateEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      CreateEstimateModel createEstimateDetails;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      emit(CreateEstimateLoadingState());

      Response createEstimateRes =
          await _apiRepository.createNewEstimate(event.id, event.which, token);

      log("res${createEstimateRes.body}");

      if (createEstimateRes.statusCode == 201) {
        createEstimateDetails =
            createEstimateModelFromJson(createEstimateRes.body);
        emit(CreateEstimateState(createEstimateModel: createEstimateDetails));
      } else {
        emit(const CreateEstimateErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e, s) {
      emit(
          const CreateEstimateErrorState(errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("hereee");
    }
  }

  Future<void> editEstimateBloc(
    EditEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      CreateEstimateModel createEstimateDetails;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      emit(CreateEstimateLoadingState());

      Response editEstimateRes = await _apiRepository.editEstimate(
          event.id,
          event.which,
          token,
          event.orderId,
          event.customerId,
          event.dropScedule);

      log("res${editEstimateRes.body}");

      if (editEstimateRes.statusCode == 200) {
        createEstimateDetails =
            createEstimateModelFromJson(editEstimateRes.body);
        emit(EditEstimateState(createEstimateModel: createEstimateDetails));
      } else {
        emit(const CreateEstimateErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e, s) {
      emit(
          const CreateEstimateErrorState(errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("hereee");
    }
  }

  Future<void> addEstimateNoteBloc(
    AddEstimateNoteEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      // emit(CreateEstimateLoadingState());

      Response addEstimateNoteRes = await _apiRepository.addEstimateNote(
          event.orderId, event.comment, token);

      log("res${addEstimateNoteRes.body}");
      Map decodedBody = json.decode(addEstimateNoteRes.body);

      if (addEstimateNoteRes.statusCode == 201) {
        emit(AddEstimateNoteState());
      } else {
        if (decodedBody.containsKey("comments")) {
          emit(AddEstimateNoteErrorState(
              errorMessage: decodedBody["comments"][0]));
        } else {
          emit(AddEstimateNoteErrorState(errorMessage: "Something went wrong"));
        }
      }
    } catch (e, s) {
      emit(AddEstimateNoteErrorState(errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("hereee");
    }
  }

  Future<void> editEstimateNoteBloc(
    EditEstimateNoteEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      // emit(CreateEstimateLoadingState());

      Response editEstimateNoteRes = await _apiRepository.editEstimateNote(
          event.orderId, event.comment, token, event.id);

      log("res${editEstimateNoteRes.body}");

      if (editEstimateNoteRes.statusCode == 200) {
        emit(EditEstimateNoteState());
      } else {
        final decodedResponse = json.decode(editEstimateNoteRes.body);
        emit(EditEstimateNoteErrorState(
            errorMessage: decodedResponse['error']['description']));
      }
    } catch (e, s) {
      emit(EditEstimateNoteErrorState(errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("hereee");
    }
  }

  Future<void> deleteEstimateNoteBloc(
    DeleteEstimateNoteEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      // emit(CreateEstimateLoadingState());

      Response deleteEstimateNoteRes =
          await _apiRepository.deleteEstimateNote(token, event.id);

      log("res${deleteEstimateNoteRes.body}");

      if (deleteEstimateNoteRes.statusCode == 200) {
        emit(DeleteEstimateNoteState());
      } else {
        final decodedResponse = json.decode(deleteEstimateNoteRes.body);
        emit(EditEstimateNoteErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e, s) {
      emit(EditEstimateNoteErrorState(errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("hereee");
    }
  }

  createAppointmentEstimateBloc(
    CreateAppointmentEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final Response createAppointmentRes =
          await _apiRepository.createAppointmentEstimate(
              token,
              event.orderId,
              event.customerId,
              event.vehicleId,
              event.startTime,
              event.endTime,
              event.appointmentNote);

      log(createAppointmentRes.body.toString());
      if (createAppointmentRes.statusCode == 200 ||
          createAppointmentRes.statusCode == 201) {
        emit(CreateAppointmentEstimateState());
      } else {
        emit(CreateAppointmentEstimateErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(CreateAppointmentEstimateErrorState(
          errorMessage: "Something went wrong"));
      log("$e create appointment bloc error");
    }
  }

  editAppointmentEstimateBloc(
    EditAppointmentEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      log(event.startTime + "______" + event.endTime);
      final token = await AppUtils.getToken();
      final Response editAppointmentRes =
          await _apiRepository.editAppointmentEstimate(
              token,
              event.orderId,
              event.customerId,
              event.vehicleId,
              event.startTime,
              event.endTime,
              event.appointmentNote,
              event.id);

      log(editAppointmentRes.body.toString());
      if (editAppointmentRes.statusCode == 200 ||
          editAppointmentRes.statusCode == 201) {
        emit(EditAppointmentEstimateState());
      } else {
        emit(CreateAppointmentEstimateErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(CreateAppointmentEstimateErrorState(
          errorMessage: "Something went wrong"));
      log("$e create appointment bloc error");
    }
  }

  Future<void> getSingleEstimateBloc(
    GetSingleEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      emit(GetSingleEstimateLoadingState());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      CreateEstimateModel createEstimateModel;

      Response singleEstimate =
          await _apiRepository.getSingleEstimate(token!, event.orderId);

      log("res${singleEstimate.body}");

      if (singleEstimate.statusCode == 200) {
        createEstimateModel = createEstimateModelFromJson(singleEstimate.body);
        emit(GetSingleEstimateState(createEstimateModel: createEstimateModel));
      } else {
        emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e, s) {
      emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> getEstimateNoteBloc(
    GetEstimateNoteEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      EstimateNoteModel estimateNoteModel;

      Response estimateNoteRes =
          await _apiRepository.getEstimateNote(token!, event.orderId);

      log("res${estimateNoteRes.body}");

      if (estimateNoteRes.statusCode == 200) {
        estimateNoteModel = estimateNoteModelFromJson(estimateNoteRes.body);
        emit(GetEstimateNoteState(estimateNoteModel: estimateNoteModel));
      } else {
        emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e, s) {
      emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> getEstimateAppointmentBloc(
    GetEstimateAppointmentEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      AppointmentDetailsModel estimateAppointmentModel;

      Response estimateAppointmentRes = await _apiRepository
          .getEstimatAppointmentDetails(token!, event.orderId);

      log("res${estimateAppointmentRes.body}");

      if (estimateAppointmentRes.statusCode == 200) {
        estimateAppointmentModel =
            appointmentDetailsModelFromJson(estimateAppointmentRes.body);
        emit(GetEstimateAppointmentState(
            estimateAppointmentModel: estimateAppointmentModel));
      } else {
        emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e, s) {
      emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  uploadImageBloc(
    EstimateUploadImageEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      emit(FirstOrderImageLoadingState());

      final token = await AppUtils.getToken();
      final Response uploadImageRes =
          await _apiRepository.uploadImage(token, event.imagePath);
      final decodedBody = json.decode(uploadImageRes.body);

      log(uploadImageRes.body.toString() + "upload bloccc");
      print(decodedBody.toString() + "stattuss");
      if (uploadImageRes.statusCode == 200 ||
          uploadImageRes.statusCode == 201) {
        emit(EstimateUploadImageState(
            imagePath: decodedBody['data']['image'], index: event.index));

        print(decodedBody['data']['image']);
        print("emitted");
      } else {
        emit(CreateAppointmentEstimateErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(CreateAppointmentEstimateErrorState(
          errorMessage: "Something went wrong"));
      log("$e create appointment bloc error");
    }
  }

  createOrderImageBloc(
    CreateOrderImageEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final Response createInspectionNoteRes =
          await _apiRepository.createInspectionNote(token, event.orderId);
      final decodedInspectionResponse =
          json.decode(createInspectionNoteRes.body);

      log(createInspectionNoteRes.body);
      if (createInspectionNoteRes.statusCode == 200 ||
          createInspectionNoteRes.statusCode == 201) {
        for (int i = 0; i < event.imageUrlList.length; i++) {
          final Response createOrderImageres =
              await _apiRepository.createOrderImage(
                  token,
                  event.orderId,
                  event.imageUrlList[i],
                  decodedInspectionResponse['created_id'].toString());

          if (createOrderImageres.statusCode == 200 ||
              createOrderImageres.statusCode == 201) {
            log(createOrderImageres.body);
            log("image upload completed");
            emit(EstimateCreateOrderImageState());
          } else {
            emit(CreateAppointmentEstimateErrorState(
                errorMessage: "Something went wrong"));
          }

          print("emitted");
        }
      }
    } catch (e, s) {
      emit(CreateAppointmentEstimateErrorState(
          errorMessage: "Something went wrong"));
      log("$e create appointment bloc error");
      print(s);
      print(e.toString());
    }
  }

  Future<void> getOrderImageBloc(
    GetAllOrderImageEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      OrderImageModel orderImageModel;

      Response orderImageRes =
          await _apiRepository.getAllOrderImages(token!, event.orderId);

      log("res${orderImageRes.body}");

      if (orderImageRes.statusCode == 200) {
        orderImageModel = orderImageModelFromJson(orderImageRes.body);
        emit(GetOrderImageState(orderImageModel: orderImageModel));
      } else {
        emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e, s) {
      emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> deleteOrderImageBloc(
    DeleteOrderImageEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);

      Response deleteOrderImageRes =
          await _apiRepository.deleteOrderImage(token!, event.imageId);

      log("res${deleteOrderImageRes.body}");

      if (deleteOrderImageRes.statusCode == 200) {
        emit(DeleteImageState());
      } else {
        emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e, s) {
      emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> createOrderServiceBloc(
    CreateOrderServiceEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      emit(CreateOrderServiceLoadingState());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);

      Response createOrderServiceRes = await _apiRepository.createOrderService(
          token!,
          event.orderId,
          event.serviceName,
          event.serviceNotes,
          event.laborRate,
          event.tax,
          event.servicePrice,
          event.technicianId);

      log("orderserviceres${createOrderServiceRes.body}");

      final decodedBody = json.decode(createOrderServiceRes.body);
      if (createOrderServiceRes.statusCode == 200 ||
          createOrderServiceRes.statusCode == 201) {
        emit(CreateOrderServiceState(
            orderServiceId: decodedBody['created_id'].toString()));
      } else {
        if (decodedBody.containsKey('service_note')) {
          emit(GetEstimateErrorState(errorMsg: decodedBody['service_note'][0]));
        } else {
          emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));
        }
      }
    } catch (e, s) {
      emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> createOrderServiceItemBloc(
    CreateOrderServiceItemEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      emit(CreateOrderServiceItemLoadingState());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = await AppUtils.getToken();
      Response createOrderServiceItem =
          await _apiRepository.createOrderServiceItem(
        token,
        event.item,
        event.cannedServiceId.toString(),
      );

      log("res${createOrderServiceItem.body}");

      if (createOrderServiceItem.statusCode == 200 ||
          createOrderServiceItem.statusCode == 201) {
        emit(CreateOrderServiceItemState());
      } else {
        emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e, s) {
      emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> deleteOrderServiceBloc(
    DeleteOrderServiceEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      // emit(CreateEstimateLoadingState());

      Response deleteOrderServiceRes =
          await _apiRepository.deleteOrderService(token, event.id);

      log("res${deleteOrderServiceRes.body}");

      if (deleteOrderServiceRes.statusCode == 200) {
        emit(DeleteOrderServiceState());
      } else {
        final decodedResponse = json.decode(deleteOrderServiceRes.body);
        emit(
            DeleteOrderServiceErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e, s) {
      emit(DeleteOrderServiceErrorState(errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("hereee");
    }
  }

  Future<void> sendEstimateToCustomerBloc(
    SendEstimateToCustomerEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      emit(SendEstimateToCustomerLoadingState());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);

      Response sendEstimateRes = await _apiRepository.sendToCustomerEstimate(
          token, event.customerId, event.orderId, event.subject);

      log("res${sendEstimateRes.body}");

      if (sendEstimateRes.statusCode == 201) {
        emit(SendEstimateToCustomerState());
      } else {
        emit(
            SendEstimateToCustomerErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e, s) {
      emit(SendEstimateToCustomerErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> deleteAppointmentBloc(
    DeleteAppointmentEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      // emit(CreateEstimateLoadingState());

      Response detailsResponse = await _apiRepository.getAppointmentDetails(
          token!, event.appointmetId);

      Response deleteAppointmentRes = await _apiRepository
          .deleteAppointmentEstimate(token, event.appointmetId);

      log("res${deleteAppointmentRes.body}");

      if (deleteAppointmentRes.statusCode == 200 || event.appointmetId == "0") {
        try {
          if (event.eventId != null) {
            final response =
                await _apiRepository.deleteEvent(token, event.eventId!);
          } else {
            print("executed");

            log(detailsResponse.body + "detaillss");
            if (detailsResponse.statusCode == 200 ||
                detailsResponse.statusCode == 201) {
              final decodedBody = json.decode(detailsResponse.body);
              Response deleteResponse = await _apiRepository.deleteEvent(
                  token, decodedBody['data']['event_id'].toString());

              print(deleteResponse.statusCode.toString() + "coddeee");
              print(deleteResponse.body + "deleteddd");
            }
          }
        } catch (e, s) {
          emit(DeleteAppointmentEstimateErrorState(
              errorMessage: "Something went wrong"));

          print(e.toString());
          print(s);

          print("hereee");
        }
      } else {
        final decodedResponse = json.decode(deleteAppointmentRes.body);
        emit(DeleteAppointmentEstimateErrorState(
            errorMessage: "Something went wrong"));
      }
      emit(DeleteAppointmentEstimateState());
    } catch (e, s) {
      emit(DeleteAppointmentEstimateErrorState(
          errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);
    }
  }

  Future<void> collectPaymentBloc(
    CollectPaymentEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      emit(CollectPaymentEstimateLoadingState());

      Response collectPaymentRes = await _apiRepository.collectPayment(
          token,
          event.customerId,
          event.orderId,
          event.paymentMode,
          event.amount,
          event.date,
          event.note,
          event.transactionId);

      log("res${collectPaymentRes.body}");

      if (collectPaymentRes.statusCode == 201) {
        emit(CollectPaymentEstimateState());
      } else {
        //  final decodedResponse = json.decode(deleteAppointmentRes.body);
        emit(CollectPaymentEstimateErrorState(errorMessage: "Payment failed"));
      }
    } catch (e, s) {
      emit(CollectPaymentEstimateErrorState(errorMessage: "Payment failed"));

      print(e.toString());
      print(s);

      print("hereee");
    }
  }

  Future<void> deleteEstimateBloc(
    DeleteEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      emit(DeleteEstimateLoadingState());

      Response deleteEstimateRes =
          await _apiRepository.deleteEstimate(token, event.id);

      log("res${deleteEstimateRes.body}");

      if (deleteEstimateRes.statusCode == 200) {
        emit(DeleteEstimateState());
      } else {
        emit(DeleteEstimateErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e, s) {
      emit(DeleteEstimateErrorState(errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> getPaymentHistoryBloc(
    GetPaymentHistoryEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      PaymentHistoryModel paymentHistoryModel;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      if (paymentCurrentPage == 1) {
        emit(GetPaymentHistoryLoadingState());
      }

      Response getPaymentResponse = await _apiRepository.getPaymentHistory(
          token, event.orderId, paymentCurrentPage);

      log("res${getPaymentResponse.body}");

      if (getPaymentResponse.statusCode == 200) {
        paymentHistoryModel =
            paymentHistoryModelFromJson(getPaymentResponse.body);

        paymentTotalPage = paymentHistoryModel.data.lastPage ?? 1;
        isFetching = false;
        emit(GetPaymentHistoryState(paymentHistoryModel: paymentHistoryModel));

        if (paymentTotalPage > paymentCurrentPage && paymentCurrentPage != 0) {
          paymentCurrentPage += 1;
        } else {
          paymentCurrentPage = 0;
        }
      } else {
        emit(GetPaymentHistoryErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e, s) {
      emit(GetPaymentHistoryErrorState(errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> authServiceByTechnicianBloc(
    AuthServiceByTechnicianEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      emit(AuthServiceByTechnicianLoadingState());

      Response getPaymentResponse = await _apiRepository.authServiceByTech(
          token,
          event.auth,
          event.serviceName,
          event.technicianId,
          event.serviceId);

      log("res${getPaymentResponse.body}");

      if (getPaymentResponse.statusCode == 200) {
        emit(AuthServiceByTechnicianState());
      } else {
        emit(AuthServiceByTechnicianErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e, s) {
      emit(AuthServiceByTechnicianErrorState(
          errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> changeEstimateStateBloc(
    ChangeEstimateStatusEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      emit(ChangeEstimateStausLoadingState());

      Response changeEstimateStausRes =
          await _apiRepository.changeEstimateStatus(token!, event.orderId);

      log("res${changeEstimateStausRes.body}");

      if (changeEstimateStausRes.statusCode == 200) {
        emit(ChangeEstimateStatusState());
      } else {
        emit(ChangeEstimateStatusErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e, s) {
      emit(
          ChangeEstimateStatusErrorState(errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> getEventDetailsByIdBloc(
    GetEventDetailsByIdEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      emit(AppointmentDetailsLoadingState());

      Response getEventDetailsRes =
          await _apiRepository.getEventDetailsById(token!, event.eventId);

      log("res${getEventDetailsRes.body}");

      if (getEventDetailsRes.statusCode == 200) {
        final decodedBody = json.decode(getEventDetailsRes.body);
        emit(
          GetEventDetailsByIdState(
              orderId: decodedBody['data']['search_id'].toString(),
              beginDate: DateTime.parse(decodedBody['data']['begin_date']),
              endDate: DateTime.parse(decodedBody['data']['complete_date']),
              notes: decodedBody['data']['notes'],
              appointmentId:
                  (decodedBody['data']['appointment_id'] ?? 0).toString()),
        );
        log(getEventDetailsRes.body.toString() + "TESTING I");
      } else {
        emit(GetEventDetailsByIdErrorState(
            errorMessage: "Something went wrong"));
      }
    } catch (e, s) {
      emit(GetEventDetailsByIdErrorState(errorMessage: "Something went wrong"));

      print(e.toString());
      print(s);

      print("thisss");
    }
  }

  Future<void> getClientByIdEstimate(
      GetClientByIdInEstimateEvent event, Emitter<EstimateState> emit) async {
    try {
      final response = await _apiRepository.getClientByClientId();
      if (response.statusCode == 200) {
        final body = await jsonDecode(response.body);
        log(body.toString());
        emit(GetClientByIdInEstimateState(
            clientModel: ClientModel.fromJson(body['client'])));
      } else {
        emit(GetClientByIdInEstimateErrorState(
            errorMessage: 'Something went wrong'));
      }
    } catch (e) {
      log(e.toString() + " Get client bloc error");
      emit(GetClientByIdInEstimateErrorState(
          errorMessage: 'Something went wrong'));
    }
  }

  Future<void> getSingleCustomerDetailsBloc(
      GetSingleCustomerDetailsEvent event, Emitter<EstimateState> emit) async {
    try {
      emit(GetSingleCustomerDetailsLoadingState());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      cm.Datum customerData;
      Response response =
          await _apiRepository.getSingleCustomer(token!, event.customerId);
      if (response.statusCode == 200) {
        print(response.body);
        var decodedBody = json.decode(response.body);
        customerData = cm.Datum.fromJson(decodedBody['customer']);

        emit(GetSingleCustomerDetailsState(customerData: customerData));
      } else {
        emit(GetSingleCustomerDetailsErrorState(
            errorMessage: 'Something went wrong'));
      }
    } catch (e) {
      log(e.toString() + " Get client bloc error");
      emit(GetSingleCustomerDetailsErrorState(
          errorMessage: 'Something went wrong'));
    }
  }

  Future<void> getSingleVehicleDetailsBloc(
      GetSingleVehicleDetailsEvent event, Emitter<EstimateState> emit) async {
    try {
      emit(GetSingleVehicleDetailsLoadingState());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      SingleVehicleInfoModel vehicleData;
      Response response =
          await _apiRepository.getSingleVehicle(token!, event.vehicleId);
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        vehicleData = singleVehicleInfoModelFromJson(response.body);

        emit(GetSingleVehicleDetailsState(vehicleDate: vehicleData));
      } else {
        emit(GetSingleVehicleDetailsErrorState(
            errorMessage: 'Something went wrong'));
      }
    } catch (e) {
      log(e.toString() + " Get client bloc error");
      emit(GetSingleVehicleDetailsErrorState(
          errorMessage: 'Something went wrong'));
    }
  }

  Future<void> getAllVendors(
    GetAllVendorsEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      Response getProvinceRes =
          await _apiRepository.getAllVendors(token!, currentPage);
      log("res${getProvinceRes.body}");
      final body = jsonDecode(getProvinceRes.body);
      if (getProvinceRes.statusCode == 200) {
        List<VendorResponseModel> vendors = [];

        totalPages = body['data']['last_page'] ?? 1;
        isVendorsPagenationLoading = false;
        if (body['data']['data'] != null && body['data']['data'].isNotEmpty) {
          body['data']['data'].forEach((vendor) {
            vendors.add(VendorResponseModel.fromJson(vendor));
          });
        }
        emit(GetAllVendorsSuccessEstimateState(vendors: vendors));

        if (totalPages > currentPage && currentPage != 0) {
          currentPage += 1;
        } else {
          currentPage = 0;
        }
      }
    } catch (e) {
      log(e.toString() + " Vendors pagenation bloc error");
    }
  }

  Future<void> createCannedOrderEstimateService(
    CreateCannedOrderServiceEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      int serviceId = 0;
      bool materialDone = true;
      bool partDone = true;
      bool laborDone = true;
      bool subcontractDone = true;
      bool feeDone = true;
      // emit(CreateCannedOrderServiceLoadingState());
      final token = await AppUtils.getToken();
      final Response serviceCreateResponse =
          await _apiRepository.createCannedOrderService(token, event.service);

      log(serviceCreateResponse.body.toString());

      if (serviceCreateResponse.statusCode == 200 ||
          serviceCreateResponse.statusCode == 201) {
        final body = jsonDecode(serviceCreateResponse.body);
        serviceId = body['created_id'];
        if (event.material != null) {
          event.material!.forEach((material) async {
            final Response materialResponse = await _apiRepository
                .createCannedOrderServiceItem(token, material, serviceId);
            log(materialResponse.body.toString());
            if (materialResponse.statusCode == 200 ||
                materialResponse.statusCode == 201) {
            } else {
              materialDone = false;
            }
          });
        }
        if (event.part != null) {
          for (var part in event.part!) {
            final Response partResponse = await _apiRepository
                .createCannedOrderServiceItem(token, part, serviceId);
            if (partResponse.statusCode == 200 ||
                partResponse.statusCode == 201) {
            } else {
              partDone = false;
            }
          }
        }
        if (event.labor != null) {
          for (var labor in event.labor!) {
            final Response laborResponse = await _apiRepository
                .createCannedOrderServiceItem(token, labor, serviceId);
            if (laborResponse.statusCode == 200 ||
                laborResponse.statusCode == 201) {
            } else {
              laborDone = false;
            }
          }
        }
        if (event.subcontract != null) {
          for (var subcontract in event.subcontract!) {
            final Response subcontractResponse = await _apiRepository
                .createCannedOrderServiceItem(token, subcontract, serviceId);
            if (subcontractResponse.statusCode == 200 ||
                subcontractResponse.statusCode == 201) {
            } else {
              subcontractDone = false;
            }
          }
        }
        if (event.fee != null) {
          for (var fee in event.fee!) {
            final Response feeResponse = await _apiRepository
                .createCannedOrderServiceItem(token, fee, serviceId);
            if (feeResponse.statusCode == 200 ||
                feeResponse.statusCode == 201) {
            } else {
              feeDone = false;
            }
          }
        }
        String message = 'Service Created Successfully';
        String errorMessage =
            'Service Created\nBut Something Went Wrong with\n';

        if (!materialDone) {
          errorMessage += ' Material';
        }
        if (!partDone) {
          if (errorMessage !=
              'Service Created\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Part';
        }
        if (!laborDone) {
          if (errorMessage !=
              'Service Created\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Labor';
        }
        if (!subcontractDone) {
          if (errorMessage !=
              'Service Created\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Sub Contract';
        }
        if (!feeDone) {
          if (errorMessage !=
              'Service Created\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Fee';
        }
        log(message);
        log(errorMessage);
        if (errorMessage !=
            'Service Created\nBut Something Went Wrong with\n') {
          message = errorMessage;
        }

        // emit(CreateCannedOrderServiceSuccessState(message: message));
        emit(CreateCannedServiceEstimateState());
      } else {
        // emit(const CreateCannedOrderServiceErrorState(
        //     message: 'Something went wrong'));
      }
    } catch (e) {
      log("$e Create service bloc error");
      // emit(const CreateCannedOrderServiceErrorState(
      //     message: "Something went wrong"));
    }
  }
}
