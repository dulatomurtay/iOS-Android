import 'package:flutter/material.dart';

/// Placeholder shown when every item of the catalog has been dismissed.
class EmptyCatalog extends StatelessWidget {
  final VoidCallback onReset;

  const EmptyCatalog({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 72,
              color: Colors.black38,
            ),
            const SizedBox(height: 16),
            const Text(
              'Catalog is Empty',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'You removed every item. Restore the initial data to continue.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.restore),
              label: const Text('Reset Catalog'),
            ),
          ],
        ),
      ),
    );
  }
}
