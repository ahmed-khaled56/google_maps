import 'package:flutter/material.dart';
import 'package:google_maps/features/maps/data/models/search_model/search_model.dart';
import 'package:google_maps/features/maps/data/repos/sharedpref_service.dart';

class CustomHistoryList extends StatelessWidget {
  const CustomHistoryList({
    super.key,
    required this.historyList,
    this.onTap,
    this.onClear,
  });
  final VoidCallback? onClear;
  final List<SearchModel> historyList;
  final void Function(SearchModel)? onTap;

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 10),
          child: IconButton(
            onPressed: () async {
              onClear?.call();
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final place = historyList[index];
              return ListTile(
                onTap: () {
                  if (onTap != null) {
                    onTap!(place);
                  }
                },
                leading: const Icon(Icons.location_on),
                title: Text(historyList[index].displayName!),
              );
            },
          ),
        ),
      ],
    );
  }
}
