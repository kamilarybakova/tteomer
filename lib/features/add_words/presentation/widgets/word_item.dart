import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WordItem extends StatelessWidget {
  final String word;
  final VoidCallback onDelete;

  const WordItem({super.key, required this.word, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(word),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: onDelete,
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
