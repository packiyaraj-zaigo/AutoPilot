import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_pilot/Models/appointment_create_model.dart';
import 'package:auto_pilot/Models/create_estimate_model.dart';
import 'package:auto_pilot/Models/estimate_appointment_model.dart';
import 'package:auto_pilot/Models/estimate_model.dart';
import 'package:auto_pilot/Models/estimate_note_model.dart';
import 'package:auto_pilot/Models/order_image_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'estimate_event.dart';
part 'estimate_state.dart';

class EstimateBloc extends Bloc<EstimateEvent, EstimateState> {
  final ApiRepository _apiRepository;
  int currentPage = 1;
  int totalPages = 0;
  bool isFetching = false;
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
          event.id, event.which, token, event.orderId, event.customerId);

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

      if (addEstimateNoteRes.statusCode == 201) {
        emit(AddEstimateNoteState());
      } else {
        emit(AddEstimateNoteErrorState());
      }
    } catch (e, s) {
      emit(AddEstimateNoteErrorState());

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

  Future<void> getSingleEstimateBloc(
    GetSingleEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
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
      final token = await AppUtils.getToken();
      final Response uploadImageRes =
          await _apiRepository.uploadImage(token, event.imagePath);
      final decodedBody = json.decode(uploadImageRes.body);

      log(uploadImageRes.body.toString());
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);

      Response createOrderServiceRes = await _apiRepository.createOrderService(
          token!,
          event.orderId,
          event.serviceName,
          event.serviceNotes,
          event.laborRate,
          event.tax);

      log("orderserviceres${createOrderServiceRes.body}");

      if (createOrderServiceRes.statusCode == 200 ||
          createOrderServiceRes.statusCode == 201) {
        final decodedBody = json.decode(createOrderServiceRes.body);
        emit(CreateOrderServiceState(
            orderServiceId: decodedBody['created_id'].toString()));
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

  Future<void> createOrderServiceItemBloc(
    CreateOrderServiceItemEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      Response createOrderServiceItem =
          await _apiRepository.createOrderServiceItem(
              token,
              event.cannedServiceId,
              event.itemType,
              event.itemName,
              event.unitPrice,
              event.quantityHours,
              event.discount,
              event.discountType,
              event.position,
              event.subTotal);

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
}
