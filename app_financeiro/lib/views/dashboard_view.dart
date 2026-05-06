import 'package:flutter/material.dart';
import '../viewmodels/finance_viewmodel.dart';

final financeViewModel = FinanceViewModel(); 

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo Financeiro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () => Navigator.pushNamed(context, '/analysis'),
          )
        ],
      ),
      body: ListenableBuilder(
        listenable: financeViewModel,
        builder: (context, child) {
          return Column(
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text('Saldo Atual', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text('R\$ ${financeViewModel.balance.toStringAsFixed(2)}', 
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Transações Recentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: financeViewModel.transactions.length,
                  itemBuilder: (context, index) {
                    final t = financeViewModel.transactions[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: t.isIncome ? Colors.green[100] : Colors.red[100],
                        child: Icon(t.isIncome ? Icons.arrow_upward : Icons.arrow_downward, 
                                    color: t.isIncome ? Colors.green : Colors.red),
                      ),
                      title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text('${t.date.day}/${t.date.month}/${t.date.year}'),
                      trailing: Text('R\$ ${t.amount.toStringAsFixed(2)}',
                         style: TextStyle(color: t.isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                    );
                  },
                ),
              ),
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          financeViewModel.addTransaction("Nova Compra", 50.0, false);
        },
        icon: const Icon(Icons.add),
        label: const Text('Lançar'),
      ),
    );
  }
}