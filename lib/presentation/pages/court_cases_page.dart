import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/court_case_provider.dart';
import '../../domain/models/court_case.dart';

class CourtCasesPage extends ConsumerWidget {
  const CourtCasesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Court Cases'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCaseDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filters
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search cases...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: Consumer(
                      builder: (context, ref, child) {
                        final searchState = ref.watch(
                          courtCaseNotifierProvider,
                        );
                        return searchState.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  ref
                                      .read(courtCaseNotifierProvider.notifier)
                                      .clearFilters();
                                },
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                  onChanged: (value) => ref
                      .read(courtCaseNotifierProvider.notifier)
                      .searchCourtCases(value),
                ),
                const SizedBox(height: 12),
                // Filter dropdowns
                Row(
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final searchState = ref.watch(
                            courtCaseNotifierProvider,
                          );
                          return DropdownButtonFormField<String>(
                            value: searchState.selectedStatus.isEmpty
                                ? 'All'
                                : searchState.selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                            ),
                            items: searchState.statusOptions
                                .map(
                                  (status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => ref
                                .read(courtCaseNotifierProvider.notifier)
                                .filterByStatus(value ?? 'All'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final searchState = ref.watch(
                            courtCaseNotifierProvider,
                          );
                          return DropdownButtonFormField<String>(
                            value: searchState.selectedCaseType.isEmpty
                                ? 'All'
                                : searchState.selectedCaseType,
                            decoration: const InputDecoration(
                              labelText: 'Case Type',
                              border: OutlineInputBorder(),
                            ),
                            items: searchState.caseTypeOptions
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => ref
                                .read(courtCaseNotifierProvider.notifier)
                                .filterByCaseType(value ?? 'All'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Court cases list
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final searchState = ref.watch(courtCaseNotifierProvider);

                if (searchState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (searchState.courtCases.isEmpty) {
                  return const Center(
                    child: Text(
                      'No court cases found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: searchState.courtCases.length,
                  itemBuilder: (context, index) {
                    final courtCase = searchState.courtCases[index];
                    return _buildCourtCaseCard(context, courtCase);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourtCaseCard(BuildContext context, CourtCase courtCase) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _showCaseDetails(context, courtCase),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      courtCase.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(courtCase.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Case #: ${courtCase.caseNumber}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                'Court: ${courtCase.courtPanel}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              if (courtCase.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  courtCase.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Filed: ${_formatDate(courtCase.filingDate)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    courtCase.caseType.toUpperCase(),
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'closed':
        color = Colors.grey;
        break;
      case 'appealed':
        color = Colors.purple;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCaseDetails(BuildContext context, CourtCase courtCase) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(courtCase.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Case Number', courtCase.caseNumber),
              _buildDetailRow('Status', courtCase.status),
              _buildDetailRow('Type', courtCase.caseType),
              _buildDetailRow('Court', courtCase.courtPanel),
              if (courtCase.judgeName != null)
                _buildDetailRow('Judge', courtCase.judgeName!),
              _buildDetailRow('Filing Date', _formatDate(courtCase.filingDate)),
              if (courtCase.hearingDate != null)
                _buildDetailRow(
                  'Hearing Date',
                  _formatDate(courtCase.hearingDate!),
                ),
              if (courtCase.description != null) ...[
                const SizedBox(height: 12),
                const Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(courtCase.description!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditCaseDialog(context, courtCase);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showCreateCaseDialog(BuildContext context) {
    // This would open a form to create a new case
    // For now, we'll show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Case'),
        content: const Text('Case creation form would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditCaseDialog(BuildContext context, CourtCase courtCase) {
    // This would open a form to edit the case
    // For now, we'll show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Case'),
        content: const Text('Case editing form would go here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
