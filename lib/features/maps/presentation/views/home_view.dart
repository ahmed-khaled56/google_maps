import 'package:flutter/material.dart';
import 'package:google_maps/features/maps/presentation/views/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: Text("Flutter Maps")),
      body: HomeViewBody(),
    );
  }
}
