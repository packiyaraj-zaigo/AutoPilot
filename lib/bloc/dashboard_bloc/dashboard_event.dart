part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}


class GetRevenueChartDataEvent extends DashboardEvent{}

class GetUserProfileEvent extends DashboardEvent{}

class GetProvinceEvent extends DashboardEvent{}

class AddCompanyEvent extends DashboardEvent{
  final Map<String,dynamic>dataMap;
  final BuildContext context;
  AddCompanyEvent({required this.dataMap,required this.context});

}
