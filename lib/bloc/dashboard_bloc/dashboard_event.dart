part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class GetRevenueChartDataEvent extends DashboardEvent {
  final BuildContext context;
  GetRevenueChartDataEvent({required this.context});
}

class GetUserProfileEvent extends DashboardEvent {}

class GetProvinceEvent extends DashboardEvent {}

class AddCompanyEvent extends DashboardEvent {
  final Map<String, dynamic> dataMap;
  final dynamic imagePath;
  final BuildContext context;
  AddCompanyEvent(
      {required this.dataMap, required this.context, required this.imagePath});
}

class CompanyLogoUploadEvent extends DashboardEvent {
  final File imagePath;

  CompanyLogoUploadEvent({required this.imagePath});
}
