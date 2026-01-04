
import 'package:axiom/models/perspective_change.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:axiom/providers/perspective_change_provider.dart';
// import 'package:axiom/models/perspective_change_card.dart';

class PerspectiveChangeManagementScreen extends StatefulWidget {
  const PerspectiveChangeManagementScreen({super.key});

  @override
  State<PerspectiveChangeManagementScreen> createState() =>
      _PerspectiveChangeManagementScreenState();
}

class _PerspectiveChangeManagementScreenState
    extends State<PerspectiveChangeManagementScreen> {
  final TextEditingController _dontController = TextEditingController();
  final TextEditingController _sayController = TextEditingController();
  final TextEditingController _aimController = TextEditingController();

  @override
  void dispose() {
    _dontController.dispose();
    _sayController.dispose();
    _aimController.dispose();
    super.dispose();
  }

  void _showAddDialog() {
    _dontController.clear();
    _sayController.clear();
    _aimController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Add Perspective Change Card',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _dontController,
                decoration: const InputDecoration(
                  labelText: 'DON\'T SAY',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sayController,
                decoration: const InputDecoration(
                  labelText: 'SAY THIS',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _aimController,
                decoration: const InputDecoration(
                  labelText: 'AIM (Reason)',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_dontController.text.isNotEmpty &&
                  _sayController.text.isNotEmpty &&
                  _aimController.text.isNotEmpty) {
                final provider =
                    Provider.of<PerspectiveChangeProvider>(context, listen: false);
                provider.addCustomCard(
                  dont: _dontController.text,
                  say: _sayController.text,
                  aim: _aimController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(PerspectiveChangeModel card) {
    _dontController.text = card.dont;
    _sayController.text = card.say;
    _aimController.text = card.aim;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Edit Perspective Change Card',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _dontController,
                decoration: const InputDecoration(
                  labelText: 'DON\'T SAY',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _sayController,
                decoration: const InputDecoration(
                  labelText: 'SAY THIS',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _aimController,
                decoration: const InputDecoration(
                  labelText: 'AIM',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_dontController.text.isNotEmpty &&
                  _sayController.text.isNotEmpty &&
                  _aimController.text.isNotEmpty) {
                final provider =
                    Provider.of<PerspectiveChangeProvider>(context, listen: false);
                provider.updateCustomCard(
                  id: card.id,
                  dont: _dontController.text,
                  say: _sayController.text,
                  aim: _aimController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(PerspectiveChangeModel card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Delete Card?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete this card?\n\n"${card.dont}"',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              final provider =
                  Provider.of<PerspectiveChangeProvider>(context, listen: false);
              provider.deleteCustomCard(card.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PerspectiveChangeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text(
          'Manage Perspective Change',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: provider.cards.isEmpty
          ? const Center(
              child: Text(
                'No perspective change cards yet',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.cards.length,
              itemBuilder: (context, index) {
                final card = provider.cards[index];
                return Card(
                  color: const Color(0xFF1A1A1A),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'DON\'T: ${card.dont}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (card.isCustom)
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.grey),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditDialog(card);
                                  } else if (value == 'delete') {
                                    _showDeleteDialog(card);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 18),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 18),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'SAY: ${card.say}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AIM: ${card.aim}',
                          style: const TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (card.isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Default',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            if (card.isCustom)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Custom',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}