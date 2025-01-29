import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wmssimulator/bloc/workflow/workflow_bloc.dart';

class ContainerStatistics extends StatefulWidget {
  const ContainerStatistics({super.key});

  @override
  State<ContainerStatistics> createState() => _ContainerStatisticsState();
}

class _ContainerStatisticsState extends State<ContainerStatistics> {
  late final WorkflowBloc _workflowBloc;

  @override
  void initState() {
    super.initState();
    _workflowBloc = context.read<WorkflowBloc>();
    _workflowBloc.state.buttonIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<WorkflowBloc, WorkflowState>(builder: (context, state) {
      return SizedBox();
    });
  }
}
