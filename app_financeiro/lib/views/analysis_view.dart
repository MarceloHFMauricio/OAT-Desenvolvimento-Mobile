import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/app_providers.dart';

class AnalysisView extends ConsumerWidget {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeVM = ref.watch(financeViewModelProvider);
    final fmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final colorScheme = Theme.of(context).colorScheme;

    final total = financeVM.totalIncome;
    final expenses = financeVM.totalExpense;
    final balance = financeVM.balance;
    final usagePercentage =
        total > 0 ? (expenses / total).clamp(0.0, 1.0) : 0.0;

    final byCategory = financeVM.expenseByCategory;
    final sortedCategories = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final categoryColors = [
      Colors.red,
      Colors.orange,
      Colors.amber,
      Colors.purple,
      Colors.blue,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
      Colors.brown,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise Financeira',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Comprometimento da Renda',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: usagePercentage,
                        minHeight: 20,
                        backgroundColor: Colors.grey[200],
                        color: usagePercentage > 0.8
                            ? Colors.red
                            : usagePercentage > 0.6
                                ? Colors.orange
                                : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${(usagePercentage * 100).toStringAsFixed(1)}% da receita comprometida',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatCard(
                  label: 'Receitas',
                  value: fmt.format(total),
                  icon: Icons.download_outlined,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Despesas',
                  value: fmt.format(expenses),
                  icon: Icons.upload_outlined,
                  color: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: balance >= 0
                  ? Colors.green.withOpacity(0.08)
                  : Colors.red.withOpacity(0.08),
              child: ListTile(
                leading: Icon(
                  balance >= 0
                      ? Icons.savings_outlined
                      : Icons.warning_amber_outlined,
                  color: balance >= 0 ? Colors.green : Colors.red,
                ),
                title: Text(
                  balance >= 0 ? 'Saldo positivo!' : 'Atenção: saldo negativo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: balance >= 0 ? Colors.green : Colors.red,
                  ),
                ),
                subtitle: Text(fmt.format(balance),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: balance >= 0 ? Colors.green : Colors.red)),
              ),
            ),
            const SizedBox(height: 20),
            if (sortedCategories.isNotEmpty) ...[
              const Text('Despesas por Categoria',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...sortedCategories.asMap().entries.map((entry) {
                final idx = entry.key;
                final e = entry.value;
                final pct = expenses > 0 ? e.value / expenses : 0.0;
                final color = categoryColors[idx % categoryColors.length];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    color: color, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Text(e.key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Text(
                            '${fmt.format(e.value)} (${(pct * 100).toStringAsFixed(1)}%)',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 8,
                          backgroundColor: color.withOpacity(0.15),
                          color: color,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ] else ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.pie_chart_outline,
                          size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text('Sem despesas para analisar',
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 8),
              Text(label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: color),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
