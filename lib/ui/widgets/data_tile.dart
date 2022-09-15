import 'package:flutter/material.dart';

class DataTileWidget extends StatelessWidget {
  IconData icon;
  String text;
  DataTileWidget({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 2),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.grey[600],
                  ),
                  Text(text,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]))
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[600],
            height: 0.5,
            endIndent: 10,
            indent: 10,
          )
        ],
      ),
    );
  }
}
