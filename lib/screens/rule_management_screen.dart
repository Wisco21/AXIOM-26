// lib/screens/rule_management_screen.dart
import 'package:axiom/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../providers/rule_provider.dart';
import '../models/os_card.dart';
import '../widgets/rule_card.dart';

class RuleManagementScreen extends StatefulWidget {
  const RuleManagementScreen({super.key});

  @override
  State<RuleManagementScreen> createState() => _RuleManagementScreenState();
}

class _RuleManagementScreenState extends State<RuleManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = List.generate(8, (_) => TextEditingController());
  
  bool _showAddForm = false;
  bool _isEditing = false;
  String? _editingRuleId;
  bool _viewMode = false;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showAddRuleForm() {
    setState(() {
      _showAddForm = true;
      _isEditing = false;
      _viewMode = false;
      _editingRuleId = null;
      
      for (final controller in _controllers) {
        controller.clear();
      }
    });
  }

  void _showEditRuleForm(OSCard rule) {
    setState(() {
      _showAddForm = true;
      _isEditing = true;
      _viewMode = false;
      _editingRuleId = rule.id;
      
      _controllers[0].text = rule.title;
      _controllers[1].text = rule.identityLaw;
      _controllers[2].text = rule.why;
      _controllers[3].text = rule.daily;
      _controllers[4].text = rule.weekly;
      _controllers[5].text = rule.excuse;
      _controllers[6].text = rule.rebuttal;
      _controllers[7].text = rule.mantra;
    });
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<RuleProvider>();

    try {
      if (_isEditing && _editingRuleId != null) {
        await provider.updateCustomRule(
          id: _editingRuleId!,
          title: _controllers[0].text,
          identityLaw: _controllers[1].text,
          why: _controllers[2].text,
          daily: _controllers[3].text,
          weekly: _controllers[4].text,
          excuse: _controllers[5].text,
          rebuttal: _controllers[6].text,
          mantra: _controllers[7].text,
        );
      } else {
        await provider.addCustomRule(
          title: _controllers[0].text,
          identityLaw: _controllers[1].text,
          why: _controllers[2].text,
          daily: _controllers[3].text,
          weekly: _controllers[4].text,
          excuse: _controllers[5].text,
          rebuttal: _controllers[6].text,
          mantra: _controllers[7].text,
        );
      }

      setState(() {
        _showAddForm = false;
        for (final controller in _controllers) {
          controller.clear();
        }
      });

      _showSuccessSnackBar(context, _isEditing ? 'Rule updated successfully' : 'Rule added successfully');
    } catch (e) {
      _showErrorSnackBar(context, 'Error: $e');
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.green, width: 1),
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<RuleProvider>(
        builder: (context, provider, _) {
          if (!provider.isInitialized) {
            return _buildLoadingState();
          }

          return _showAddForm
              ? _buildAddRuleForm(context)
              : _buildRuleList(provider);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00FF88),
                strokeWidth: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Loading rules...',
            style: TextStyle(
              color: Color(0xFF888888),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddRuleForm(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAddForm = false;
                        for (final controller in _controllers) {
                          controller.clear();
                        }
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF1A1A1A),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Icon(
                        Iconsax.arrow_left_2,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _isEditing ? 'Edit Rule' : 'New Rule',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  if (_viewMode)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _viewMode = false;
                        });
                      },
                      icon: const Icon(Iconsax.edit_2, color: Color(0xFF00FF88), size: 20),
                      tooltip: 'Edit',
                    ),
                ],
              ),
            ),
          ),
        ),

        // Form Content
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Field
                      _buildFormField(
                        label: 'TITLE',
                        controller: _controllers[0],
                        icon: Iconsax.text_block,
                        maxLines: 1,
                        isFirst: true,
                      ),

                      const SizedBox(height: 20),

                      // Identity Law Field
                      _buildFormField(
                        label: 'IDENTITY LAW',
                        controller: _controllers[1],
                        icon: Iconsax.shield_tick,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 20),

                      // Why Field
                      _buildFormField(
                        label: 'WHY THIS MATTERS',
                        controller: _controllers[2],
                        icon: Iconsax.info_circle,
                        maxLines: 3,
                      ),

                      const SizedBox(height: 20),

                      // Daily Practice Field
                      _buildFormField(
                        label: 'DAILY PRACTICE',
                        controller: _controllers[3],
                        icon: Iconsax.calendar_tick,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 20),

                      // Weekly Standard Field
                      _buildFormField(
                        label: 'WEEKLY STANDARD',
                        controller: _controllers[4],
                        icon: Iconsax.calendar_2,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 20),

                      // Common Excuse Field
                      _buildFormField(
                        label: 'COMMON EXCUSE',
                        controller: _controllers[5],
                        icon: Iconsax.close_circle,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 20),

                      // Rebuttal Field
                      _buildFormField(
                        label: 'REBUTTAL',
                        controller: _controllers[6],
                        icon: Iconsax.refresh,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 20),

                      // Mantra Field
                      _buildFormField(
                        label: 'MANTRA / AFFIRMATION',
                        controller: _controllers[7],
                        icon: Iconsax.voice_cricle,
                        maxLines: 2,
                        isLast: true,
                      ),

                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _submitForm(context),
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF00FF88), Color(0xFF00CCCC)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF00FF88).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _isEditing ? 'UPDATE RULE' : 'CREATE RULE',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showAddForm = false;
                                for (final controller in _controllers) {
                                  controller.clear();
                                }
                              });
                            },
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFF1A1A1A),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: const Center(
                                child: Icon(
                                  Iconsax.close_circle,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required int maxLines,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF666666), size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFF0A0A0A),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
            maxLines: maxLines,
            cursorColor: const Color(0xFF00FF88),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRuleList(RuleProvider provider) {
    return Column(
      children: [
        // Header
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Iconsax.shield_tick,
                      color: Color(0xFF00FF88),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AXIOM RULES',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Manage your operating system',
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationDebugScreen()),
                    ),
                    icon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF1A1A1A),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Icon(
                        Iconsax.notification,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Rules List
        Expanded(
          child: FutureBuilder<List<OSCard>>(
            future: provider.getAllActiveRules(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingList();
              }

              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState();
              }

              final rules = snapshot.data!;

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: rules.length + 1,
                itemBuilder: (context, index) {
                  if (index == rules.length) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          '• • •',
                          style: TextStyle(
                            color: Color(0xFF444444),
                            fontSize: 24,
                          ),
                        ),
                      ),
                    );
                  }

                  final rule = rules[index];
                  final isDefaultRule = rule.id.length < 3;
                  final isCurrentRule = provider.currentRule?.id == rule.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildRuleListItem(context, rule, isDefaultRule, isCurrentRule),
                  );
                },
              );
            },
          ),
        ),

        // Floating Action Button
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: _showAddRuleForm,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF1A1A1A),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.add,
                      color: Color(0xFF00FF88),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'NEW RULE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF00FF88),
              size: 14,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFF1A1A1A),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00FF88),
                strokeWidth: 2,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A1A1A),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(
              Iconsax.shield_slash,
              color: Color(0xFF444444),
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No rules found',
            style: TextStyle(
              color: Color(0xFF888888),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Add your first rule to build your personal operating system',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _showAddRuleForm,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF00FF88)),
              ),
              child: const Text(
                'Create First Rule',
                style: TextStyle(
                  color: Color(0xFF00FF88),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleListItem(BuildContext context, OSCard rule, bool isDefaultRule, bool isCurrentRule) {
    return GestureDetector(
      onTap: () => _showRulePreview(context, rule),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF1A1A1A),
          border: Border.all(
            color: isCurrentRule ? const Color(0xFF00FF88) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isDefaultRule
                          ? const Color(0xFF00CCCC).withOpacity(0.1)
                          : const Color(0xFF00FF88).withOpacity(0.1),
                      border: Border.all(
                        color: isDefaultRule
                            ? const Color(0xFF00CCCC).withOpacity(0.2)
                            : const Color(0xFF00FF88).withOpacity(0.2),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        isDefaultRule ? Iconsax.book_1 : Iconsax.edit_2,
                        color: isDefaultRule ? const Color(0xFF00CCCC) : const Color(0xFF00FF88),
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rule.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rule.identityLaw,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isCurrentRule)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00FF88).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF00FF88).withOpacity(0.2)),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Color(0xFF00FF88),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (!isDefaultRule) ...[
                    _buildActionButton(
                      icon: Iconsax.edit_2,
                      color: const Color(0xFF00CCCC),
                      onTap: () => _showEditRuleForm(rule),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Iconsax.trash,
                      color: const Color(0xFFFF5555),
                      onTap: () => _showDeleteDialog(context, rule, false),
                    ),
                    const SizedBox(width: 8),
                  ] else ...[
                    _buildActionButton(
                      icon: Iconsax.archive,
                      color: const Color(0xFF888888),
                      onTap: () => _showArchiveDialog(context, rule),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Spacer(),
                  _buildActionButton(
                    icon: Iconsax.eye,
                    color: Colors.white,
                    onTap: () => _showRulePreview(context, rule),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _setAsCurrentRule(context, rule),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: isCurrentRule
                              ? [const Color(0xFF00FF88), const Color(0xFF00CCCC)]
                              : [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        border: Border.all(
                          color: isCurrentRule
                              ? const Color(0xFF00FF88).withOpacity(0.3)
                              : Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        isCurrentRule ? 'CURRENT' : 'USE TODAY',
                        style: TextStyle(
                          color: isCurrentRule ? Colors.black : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Colors.white.withOpacity(0.03),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _showRulePreview(BuildContext context, OSCard rule) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'PREVIEW',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.white.withOpacity(0.03),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: const Center(
                          child: Icon(
                            Iconsax.close_circle,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Rule Card
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: RuleCard(
                      rule: rule,
                      onAudioTap: () {
                        context.read<RuleProvider>().playMantra();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setAsCurrentRule(BuildContext context, OSCard rule) async {
    final provider = context.read<RuleProvider>();
    
    try {
      await provider.setCurrentRule(rule, cardIndex: 0);
      
      _showSuccessSnackBar(context, '"${rule.title}" set as today\'s rule');
    } catch (e) {
      _showErrorSnackBar(context, 'Error: $e');
    }
  }

  void _showArchiveDialog(BuildContext context, OSCard rule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00CCCC).withOpacity(0.1),
                border: Border.all(color: const Color(0xFF00CCCC).withOpacity(0.2)),
              ),
              child: const Center(
                child: Icon(
                  Iconsax.archive,
                  color: Color(0xFF00CCCC),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Archive Rule?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"${rule.title}" will be moved to archives and can be restored later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.03),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      try {
                        await context.read<RuleProvider>().archiveRule(rule.id);
                        _showSuccessSnackBar(context, '"${rule.title}" archived');
                      } catch (e) {
                        _showErrorSnackBar(context, 'Error: $e');
                      }
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00CCCC), Color(0xFF009999)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Archive',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, OSCard rule, bool isDefaultRule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side:BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF5555).withOpacity(0.1),
                border: Border.all(color: const Color(0xFFFF5555).withOpacity(0.2)),
              ),
              child: const Center(
                child: Icon(
                  Iconsax.trash,
                  color: Color(0xFFFF5555),
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Delete Rule?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isDefaultRule
                  ? 'Default rules cannot be deleted. You can archive them instead.'
                  : 'This action cannot be undone. "${rule.title}" will be permanently deleted.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.03),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Center(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (!isDefaultRule) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        try {
                          await context.read<RuleProvider>().deleteCustomRule(rule.id);
                          _showSuccessSnackBar(context, '"${rule.title}" deleted');
                        } catch (e) {
                          _showErrorSnackBar(context, 'Error: $e');
                        }
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF5555), Color(0xFFCC4444)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                        ),
                        ),
                        child: const Center(
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}