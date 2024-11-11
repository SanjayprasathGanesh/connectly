import 'package:auto_route/auto_route.dart';
import 'package:connectly/auto_routes/app_routes.gr.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFFfb6f92),
      onPressed: (){
        context.router.push(const AddNewPost());
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
      child: const Icon(Icons.add, color: Colors.black),
    );
  }
}
