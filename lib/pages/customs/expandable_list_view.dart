import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wmssimulator/bloc/warehouse/warehouse_interaction_bloc.dart';

class ExpandableListView extends StatefulWidget {
  ExpandableListView({super.key});

  @override
  _ExpandableListViewState createState() => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  List<double> heights = [];
  List<double> bottomHeights = [];
  List<double> turns = [];
  List<List<double>> innerHeights = [];
  List<List<double>> innerBottomHeights = [];
  List<List<double>> innerTurns = [];
  int? openDropdownIndex; // Track which dropdown is currently open
  int? outerOpenDropdownIndex;
  late WarehouseInteractionBloc _warehouseInteractionBloc;

  List<Map<String, List<Map<String, List<Map<String, dynamic>>>>>> data = [
    {
      "HLXU2008419": [
        {
          "10044": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "305", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "306", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 150},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "304", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 25},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "304", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 300},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-003", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 600},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-007", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 18000}
          ]
        },
        {
          "10041": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "M10-00001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 15},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0012", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM-9293", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 15},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "M10-00001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 50},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MFM-PO-005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM-9290", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM-9293", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 50},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0012", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0014", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMPUT-0007", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMPUT-0008", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 140},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 200},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-003", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 60},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-006", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 40},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM-9292", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 300},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0006", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0008", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0009", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0010", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0014", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0015", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 200},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM003", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-007", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0011", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0012", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0012", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1220},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "JW4", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 150},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MFM-PO-002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0012", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM-9293", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMPUT-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM-9291", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0014", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 22},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 75},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0012", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 3},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0014", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 3},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMPUT-0001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 15},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "JW4", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 40},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MFM-PO-002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 5},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM-9290", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM-9291", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 50},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0015", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 5},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0E04", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMPUT-0001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 25},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMPUT-0005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 50},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMPUT-0006", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMPUT-0007", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 50},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-003", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 50},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-006", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-008", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MFM-PO-004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 50},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM-9292", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 300},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM-9292", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0015", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 8},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0016", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 8},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAM0015", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 87}
          ]
        },
        {
          "10033": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "VP1", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "JW3", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-007", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-108", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 200},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-151", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-152", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-153", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-154", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 24},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-108", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 180},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "VP1", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "VP2", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "JW3", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 40},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-152", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 25},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-007", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-108_Test", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 120},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-007", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 40},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-151", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-010", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 60},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 6},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-008", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 3720},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-009", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 3720},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-010", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 3660},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-011", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 180},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-012", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 240},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-108_Test", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4800},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-151", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 240},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-152", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 60},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-153", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 60},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MMI-PO-154", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 60}
          ]
        },
        {
          "ORACLE": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-011", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 15},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-003", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-009", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PODEMO2", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "QC1", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 6},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-010", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-006", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 3},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-0001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 5},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-0002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 8}
          ]
        },
        {
          "10035": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0011", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0011", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0011", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 3},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMQC-009", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100}
          ]
        },
        {
          "10025": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 300},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-006", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 14000}
          ]
        },
        {
          "10037": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "POTEST001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "POTRQMDN", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 9}
          ]
        },
        {
          "10042": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "M10_PO-01", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 40},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0008", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAQC-004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 24},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "328", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAQC-004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "M10_PO-01", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 560},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAQC-004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 6}
          ]
        },
        {
          "10043": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "322", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "323", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 3},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "330", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "333", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MFM-PO-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MFM-PO-006", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MFM-PO-003", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 60},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "321", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "331", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 40},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MFM-PO-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 22},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MFM-PO-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 23},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MFM-PO-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 3},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "324", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "319", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 25},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "324", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "331", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "320", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "332", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 12},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "323", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 7},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "330", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 70}
          ]
        },
        {
          "10003": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 450},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4500}
          ]
        },
        {
          "10038": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-007", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10000}
          ]
        },
        {
          "10039": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "317", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "318", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "316", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "316", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 8}
          ]
        },
        {
          "10000": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-003", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2700}
          ]
        },
        {
          "VENDOR": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO1", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 8000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "QC2", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 7980},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-0010", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 5},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-004", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 8000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-008", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 8}
          ]
        },
        {
          "10006": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "31", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-009", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 3000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "32", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "31", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 6}
          ]
        },
        {
          "10027": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "326", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 5},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "325", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10}
          ]
        },
        {
          "10030": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0010", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0010", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 40000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0010", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 9000}
          ]
        },
        {
          "10032": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "DEMO-PO-012", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 6}
          ]
        },
        {
          "10005": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "312", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "314", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "315", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "334", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "POTR1", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "310", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "314", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 15},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "POTR4", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "313", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "310", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "315", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 5},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "POTR3", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-008", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 2000}
          ]
        },
        {
          "10026": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "329", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4}
          ]
        },
        {
          "10036": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "JW2", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 15},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "JW2", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 15}
          ]
        },
        {
          "10040": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "309", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "308", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 108},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "309", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "307", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 250},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMPUT-0002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "SAMPUT-0003", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20}
          ]
        },
        {
          "101009": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 30},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 100},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 15000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 150},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 5400},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 69},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 175},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4800},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4900},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 40},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 4800},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 50},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-002", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 50},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0013", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 5000},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-006", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 1500},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "PO-24-001", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 7500},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "MIM-PO-0005", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 560}
          ]
        },
        {
          "10029": [
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "POWR1", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 10},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "POWR2", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 20},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "POWR2", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 25},
            {"actual_dock_nbr": "DOCK-IN-02", "asn": "1017", "po_nbr": "POWR3", "checkin_ts": "2024-11-15T23:30:25.060649-05:00", "qty": 25}
          ]
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    heights = List.filled(data.length, 60);
    bottomHeights = List.filled(data.length, 60);
    turns = List.filled(data.length, 1);
    innerHeights = List.filled(data.length, []);
    innerBottomHeights = List.filled(data.length, []);
    innerTurns = List.filled(data.length, []);
    _warehouseInteractionBloc = context.read<WarehouseInteractionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      width: 500,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, oindex) {
              if (innerHeights[oindex].isEmpty) {
                innerHeights[oindex] = List.filled(data[oindex].values.first.length, 60);
                innerBottomHeights[oindex] = List.filled(data[oindex].values.first.length, 60);
                innerTurns[oindex] = List.filled(data[oindex].values.first.length, 1);
              }
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: heights[oindex],
                width: 400,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: bottomHeights[oindex],
                      width: 400,
                      color: Colors.transparent,
                      child: Container(
                        height: 60,
                        width: 400,
                        margin: EdgeInsets.only(top: 65, bottom: 5),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(163, 183, 209, 1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: ListView.builder(
                              itemCount: data[oindex].values.first.length,
                              itemBuilder: (context, index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: innerHeights[oindex][index],
                                  width: 380,
                                  child: Stack(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        height: innerBottomHeights[oindex][index],
                                        width: 380,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 65, bottom: 5),
                                          padding: EdgeInsets.all(10),
                                          height: 60,
                                          width: 380,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(126, 150, 182, 1),
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25),
                                            child: ListView.builder(
                                              itemCount: data[oindex].values.first[index].values.first.length,
                                              itemBuilder: (context, inindex) => Container(
                                                padding: EdgeInsets.all(10),
                                                height: 60,
                                                  width: 360,
                                                  margin: EdgeInsets.only(bottom: 5),
                                                  decoration: BoxDecoration(color: Color.fromRGBO(194, 213, 238, 1), borderRadius: BorderRadius.circular(25),),
                                                child:Text(data[oindex].values.first[index].values.first[inindex].toString())
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Close other opened dropdowns
                                            if (openDropdownIndex == index) {
                                              // If the same dropdown is tapped, close it
                                              innerHeights[oindex][index] = innerHeights[oindex][index] == 60 ? 300 : 60;
                                              innerBottomHeights[oindex][index] = innerBottomHeights[oindex][index] == 60 ? 300 : 60;
                                              innerTurns[oindex][index] = innerTurns[oindex][index] == 0.5 ? 1 : 0.5; // Rotate icon
                                              openDropdownIndex = null; // Reset opened index
                                              heights[oindex] = 280;
                                              bottomHeights[oindex] = 280;
                                            } else {
                                              // Close previously opened dropdown and open the new one
                                              if (openDropdownIndex != null) {
                                                innerHeights[oindex][openDropdownIndex!] = 60; // Reset previous dropdown
                                                innerBottomHeights[oindex][openDropdownIndex!] = 60; // Reset previous bottom height
                                                innerTurns[oindex][openDropdownIndex!] = 1;
                                              }
                                              openDropdownIndex = index; // Set current index as opened
                                              heights[oindex] = 520;
                                              bottomHeights[oindex] = 520;
                                              innerHeights[oindex][index] = 300; // Expand current dropdown
                                              innerBottomHeights[oindex][index] = 300; // Expand current bottom height
                                              innerTurns[oindex][index] = 0.5;
                                            }
                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          width: 380,
                                          margin: EdgeInsets.only(bottom: 5),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(68, 98, 136, 1),
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('${data[oindex].values.first[index].keys.first} (${data[oindex].values.first[index].values.first.length})'),
                                              AnimatedRotation(
                                                turns: innerTurns[oindex][index],
                                                duration: const Duration(milliseconds: 200),
                                                child: Icon(
                                                  Icons.keyboard_arrow_down_rounded,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (heights[oindex] == 60) {
                            // If outer dropdown is expanding, close all inner dropdowns first
                            for (int i = 0; i < innerHeights[oindex].length; i++) {
                              innerHeights[oindex][i] = 60; // Reset all inner heights to closed state
                              innerBottomHeights[oindex][i] = 60; // Reset all bottom heights to closed state
                            }
                            openDropdownIndex = null; // Reset opened index for inner dropdowns
                          }
                          // Close other opened dropdowns
                          if (outerOpenDropdownIndex == oindex) {
                            // If the same dropdown is tapped, close it
                            heights[oindex] = heights[oindex] == 60 ? 280 : 60;
                            bottomHeights[oindex] = bottomHeights[oindex] == 60 ? 280 : 60;
                            turns[oindex] = turns[oindex] == 0.5 ? 1 : 0.5; // Rotate icon
                            outerOpenDropdownIndex = null; // Reset opened index
                          } else {
                            // Close previously opened dropdown and open the new one
                            if (outerOpenDropdownIndex != null) {
                              heights[outerOpenDropdownIndex!] = 60; // Reset previous dropdown
                              bottomHeights[outerOpenDropdownIndex!] = 60; // Reset previous bottom height
                              turns[outerOpenDropdownIndex!] = 1;
                            }
                            outerOpenDropdownIndex = oindex; // Set current index as opened
                            heights[oindex] = 280; // Expand current dropdown
                            bottomHeights[oindex] = 280; // Expand current bottom height
                            turns[oindex] = 0.5;
                          }
                        });
                      },
                      child: Container(
                        height: 60,
                        width: 400,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(68, 98, 136, 1), // Purple background
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data[oindex].keys.first,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                            AnimatedRotation(
                              turns: turns[oindex],
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
