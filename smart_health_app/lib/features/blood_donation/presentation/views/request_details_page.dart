import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_health_app/features/blood_donation/presentation/donor_request_details_cubit/donor_request_details_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/models/request_details_models.dart';
import 'package:smart_health_app/features/blood_donation/presentation/request_details_cubit/request_details_cubit.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/donor_request_details_view.dart';
import 'package:smart_health_app/features/blood_donation/presentation/views/requester_request_details_view.dart';

class RequestDetailsPage extends StatelessWidget {
  final RequestDetailsArgs args;
  const RequestDetailsPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    if (args.isOwner) {
      return BlocProvider(
        create: (_) => RequestDetailsCubit()..load(args.requestId),
        child: RequesterRequestDetailsView(requestId: args.requestId),
      );
    }
    return BlocProvider(
      create: (_) => DonorRequestDetailsCubit()..load(args.requestId),
      child: DonorRequestDetailsView(requestId: args.requestId),
    );
  }
}
