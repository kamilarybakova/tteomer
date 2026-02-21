import 'package:flutter/cupertino.dart';

class DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2E42),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
