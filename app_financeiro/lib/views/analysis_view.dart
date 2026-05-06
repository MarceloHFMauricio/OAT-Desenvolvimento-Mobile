import 'package:flutter/material.dart';
import 'dashboard_view.dart'; 

class AnalysisView extends StatelessWidget {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    final total = financeViewModel.totalIncome;
    final expenses = financeViewModel.totalExpense;
    final usagePercentage = total > 0 ? (expenses / total) : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Análise de Despesas')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Comprometimento da Renda', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: usagePercentage,
                minHeight: 24,
                backgroundColor: Colors.grey[200],
                color: usagePercentage > 0.7 ? Colors.redAccent : Colors.teal,
              ),
            ),
            const SizedBox(height: 12),
            Text('${(usagePercentage * 100).toStringAsFixed(1)}% da sua receita foi gasta.',
              style: const TextStyle(fontSize: 16)),
            
            const SizedBox(height: 40),
            
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.download, color: Colors.green),
                    title: const Text('Total de Receitas'), 
                    trailing: Text('R\$ ${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.upload, color: Colors.red),
                    title: const Text('Total de Despesas'), 
                    trailing: Text('R\$ ${expenses.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}