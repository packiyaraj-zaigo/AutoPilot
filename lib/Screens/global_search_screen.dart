// ignore_for_file: deprecated_member_use

import 'package:auto_pilot/Models/search_model.dart';
import 'package:auto_pilot/Screens/customer_information_screen.dart';
import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/Screens/vechile_information_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:auto_pilot/bloc/search/search_bloc.dart';
import 'package:auto_pilot/bloc/vechile/vechile_state.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _debouncer = Debouncer();
  final FocusNode searchFieldFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    searchFieldFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryColors,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTitleColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocProvider(
          create: (context) => SearchBloc()..add(SearchEmptyEvent()),
          child: BlocListener<SearchBloc, SearchState>(
            listener: (context, state) {
              if (state is GlobalSearchErrorState) {
                CommonWidgets().showDialog(context, 'Something went wrong');
              }
            },
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Search by keyword',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff6A7187),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: SizedBox(
                            height: 56,
                            width: MediaQuery.of(context).size.width,
                            child: TextField(
                              focusNode: searchFieldFocus,
                              onChanged: (value) {
                                if (value.trim().isEmpty) {
                                  _debouncer.run(() {
                                    BlocProvider.of<SearchBloc>(context)
                                        .add(SearchEmptyEvent());
                                  });
                                } else {
                                  _debouncer.run(() {
                                    BlocProvider.of<SearchBloc>(context)
                                        .add(GlobalSearchEvent(query: value));
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Search",
                                counterText: "",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xffC1C4CD),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: state is GlobalSearchErrorState
                          ? const Center(
                              child: Text(
                                "No Results Found",
                                style: TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : state is SearchEmptyState
                              ? Container()
                              : state is GlobalSearchLoadingState
                                  ? const Center(
                                      child: CupertinoActivityIndicator())
                                  : state is GlobalSearchSuccessState
                                      ? state.estimates.isEmpty &&
                                              state.users.isEmpty &&
                                              state.vehicles.isEmpty
                                          ? const Center(
                                              child: Text(
                                                "No Results Found",
                                                style: TextStyle(
                                                  color: AppColors.greyText,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          : ScrollConfiguration(
                                              behavior: const ScrollBehavior(),
                                              child: ListView(
                                                children: [
                                                  state.users.isNotEmpty
                                                      ? const Text(
                                                          'Users',
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .greyText,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  state.users.isNotEmpty
                                                      ? const SizedBox(
                                                          height: 16)
                                                      : const SizedBox(),
                                                  state.users.isNotEmpty
                                                      ? Column(
                                                          children:
                                                              List.generate(
                                                            state.users.length,
                                                            (index) => userCard(
                                                                state.users[
                                                                    index]),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  state.users.isNotEmpty
                                                      ? const SizedBox(
                                                          height: 16)
                                                      : const SizedBox(),
                                                  state.vehicles.isNotEmpty
                                                      ? const Text(
                                                          'Vehicles',
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .greyText,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  state.vehicles.isNotEmpty
                                                      ? const SizedBox(
                                                          height: 16)
                                                      : const SizedBox(),
                                                  state.vehicles.isNotEmpty
                                                      ? Column(
                                                          children:
                                                              List.generate(
                                                            state.vehicles
                                                                .length,
                                                            (index) => vehicleCard(
                                                                state.vehicles[
                                                                    index]),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  state.vehicles.isNotEmpty
                                                      ? const SizedBox(
                                                          height: 16)
                                                      : const SizedBox(),
                                                  state.estimates.isNotEmpty
                                                      ? const Text(
                                                          'Order',
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .greyText,
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  state.estimates.isNotEmpty
                                                      ? const SizedBox(
                                                          height: 16)
                                                      : const SizedBox(),
                                                  state.estimates.isNotEmpty
                                                      ? Column(
                                                          children:
                                                              List.generate(
                                                            state.estimates
                                                                .length,
                                                            (index) => estimateCard(
                                                                state.estimates[
                                                                    index]),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  state.estimates.isNotEmpty
                                                      ? const SizedBox(
                                                          height: 16)
                                                      : const SizedBox(),
                                                ],
                                              ),
                                            )
                                      : Container(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Column userCard(SearchModel user) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CustomerInformationScreen(
                  id: user.searchResultId.toString(), navigation: "search"),
            ));
          },
          child: Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(),
                      Text(
                        user.searchResultTitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF061237),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      user.searchResultBody.isNotEmpty
                          ? Text(
                              user.searchResultBody.split(' ').first,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF6A7187),
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : const SizedBox(),
                      user.searchResultBody.isNotEmpty
                          ? Text(
                              user.searchResultBody.split(' ').last,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF6A7187),
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                      onPressed: () {
                        if (user.searchResultBody.isNotEmpty) {
                          final Uri smsLaunchUri = Uri(
                            scheme: 'sms',
                            path: user.searchResultBody.split(' ').last,
                            queryParameters: <String, String>{
                              'body': Uri.encodeComponent(' '),
                            },
                          );
                          launchUrl(smsLaunchUri);
                        }
                      },
                      icon: SvgPicture.asset(
                        'assets/images/sms.svg',
                        color: AppColors.primaryColors,
                      )),
                  IconButton(
                      onPressed: () {
                        if (user.searchResultBody.isNotEmpty) {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'tel',
                            path: user.searchResultBody.split(' ').last,
                          );

                          launchUrl(emailLaunchUri);
                        }
                      },
                      icon: SvgPicture.asset(
                        'assets/images/phone_icon.svg',
                        color: AppColors.primaryColors,
                      ))
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  Column vehicleCard(SearchModel vehicle) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VechileInformation(
                  vehicleId: vehicle.searchResultId.toString()),
            ));
          },
          child: Container(
            height: 77,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(),
                  Text(
                    vehicle.searchResultTitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF061237),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    vehicle.searchResultBody,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF6A7187),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget estimateCard(SearchModel estimate) {
    final key = GlobalKey();
    return BlocProvider(
      create: (ctx) => EstimateBloc(apiRepository: ApiRepository()),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (ctx, state) {
          if (state is GetSingleEstimateState) {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EstimatePartialScreen(
                estimateDetails: state.createEstimateModel,
                navigation: 'search',
              ),
            ));
          } else if (state is GetSingleEstimateLoadingState) {
            showDialog(
              context: context,
              builder: (context) => const CupertinoActivityIndicator(),
            );
          } else if (state is GetEstimateErrorState) {
            CommonWidgets().showDialog(context, state.errorMsg);
          }
        },
        child: Column(
          key: key,
          children: [
            GestureDetector(
              onTap: () {
                BlocProvider.of<EstimateBloc>(key.currentContext!).add(
                    GetSingleEstimateEvent(
                        orderId: estimate.searchResultId.toString()));
              },
              child: Container(
                height: 77,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      offset: const Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(),
                      Text(
                        estimate.searchResultTitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF061237),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        estimate.searchResultBody,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF6A7187),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
