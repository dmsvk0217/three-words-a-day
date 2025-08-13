import 'package:flutter/material.dart';

import '../../../core/models/verse.dart';

class VerseTile extends StatelessWidget {
  final Verse verse;
  final VoidCallback? onLongPress;

  const VerseTile({
    super.key,
    required this.verse,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 36,
              child: Text('${verse.verse}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                verse.text,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
