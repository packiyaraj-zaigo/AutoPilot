part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}


class GetRevenueChartDataEvent extends DashboardEvent{}

class GetUserProfileEvent extends DashboardEvent{}