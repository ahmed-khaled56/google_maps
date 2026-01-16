import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/cores/helper/show_message.dart';
import 'package:google_maps/features/maps/data/models/search_model/search_model.dart';
import 'package:google_maps/features/maps/data/repos/sharedpref_service.dart';
import 'package:google_maps/features/maps/presentation/views/widgets/custom_history_list.dart';
import 'package:google_maps/features/maps/presentation/views/widgets/home_view_body.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void initState() {
    super.initState();
    _loadData();
  }

  List<SearchModel> historyList = [];

  List<String> PlaceNameList = [];
  Future<void> _loadData() async {
    final list = await SebhaSharedPrefs.load();

    setState(() {
      historyList = list;
    });
  }

  void updateHistory(SearchModel newPlace) async {
    setState(() {
      historyList.removeWhere((e) => e.displayName == newPlace.displayName);
      historyList.insert(0, newPlace);
    });

    await SebhaSharedPrefs.save(historyList);
  }

  void clearHistory() async {
    setState(() {
      historyList.clear();
    });
    await SebhaSharedPrefs.clear();
  }

  final GlobalKey<HomeViewBodyState> homeBodyKey =
      GlobalKey<HomeViewBodyState>();

  bool ispressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Flutter Maps",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => CustomHistoryList(
                  onTap: (place) {
                    setState(() {
                      ispressed = true;
                    });
                    homeBodyKey.currentState?.goToPlaceFromHistory(place);
                    Navigator.pop(context);
                  },
                  historyList: historyList,
                  onClear: clearHistory,
                ),
              );
            },
          ),
        ],
      ),
      body: HomeViewBody(key: homeBodyKey, onHistoryChanged: updateHistory),
    );
  }
}
