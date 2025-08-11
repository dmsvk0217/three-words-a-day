import 'package:flutter/material.dart';

class DropChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  const DropChip(
      {super.key, required this.label, this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final color = enabled ? Colors.white : Colors.white54;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF6A4B3F),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(color: color, fontSize: 14)),
            if (enabled)
              const Icon(Icons.expand_more, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }
}
