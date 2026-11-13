import 'package:flutter/material.dart';

/// Shown when the search / filters match nothing (the catalog itself is
/// not empty). It is scrollable, so Pull-to-Refresh still works here.
class NoResults extends StatelessWidget {
  final VoidCallback onClear;

  const NoResults({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 24),
        const Icon(Icons.search_off, size: 56, color: Colors.black38),
        const SizedBox(height: 12),
        const Text(
          'Nothing found',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        const Text(
          'Try another search or filter.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Center(
          child: OutlinedButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.filter_alt_off),
            label: const Text('Clear filters'),
          ),
        ),
      ],
    );
  }
}
