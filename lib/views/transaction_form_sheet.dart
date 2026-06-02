import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../providers/app_providers.dart';

class TransactionFormSheet extends ConsumerStatefulWidget {
  final TransactionModel? existing;

  const TransactionFormSheet({super.key, this.existing});

  @override
  ConsumerState<TransactionFormSheet> createState() =>
      _TransactionFormSheetState();
}

class _TransactionFormSheetState extends ConsumerState<TransactionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  bool _isIncome = false;
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Outros';

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleCtrl.text = widget.existing!.title;
      _amountCtrl.text = widget.existing!.amount.toStringAsFixed(2);
      _isIncome = widget.existing!.isIncome;
      _selectedDate = widget.existing!.date;
      _selectedCategory = widget.existing!.category;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  List<String> get _categories => _isIncome
      ? TransactionModel.incomeCategories
      : TransactionModel.expenseCategories;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount =
        double.tryParse(_amountCtrl.text.trim().replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Valor inválido')),
      );
      return;
    }

    final financeVM = ref.read(financeViewModelProvider);

    if (_isEditing) {
      await financeVM.updateTransaction(TransactionModel(
        id: widget.existing!.id,
        userId: widget.existing!.userId,
        title: _titleCtrl.text.trim(),
        amount: amount,
        isIncome: _isIncome,
        date: _selectedDate,
        category: _selectedCategory,
      ));
    } else {
      await financeVM.addTransaction(
        title: _titleCtrl.text.trim(),
        amount: amount,
        isIncome: _isIncome,
        date: _selectedDate,
        category: _selectedCategory,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isEditing ? 'Editar Transação' : 'Nova Transação',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: Row(
                  children: [
                    _TypeButton(
                      label: 'Despesa',
                      icon: Icons.arrow_downward,
                      selected: !_isIncome,
                      color: Colors.red,
                      onTap: () => setState(() {
                        _isIncome = false;
                        _selectedCategory = 'Outros';
                      }),
                    ),
                    _TypeButton(
                      label: 'Receita',
                      icon: Icons.arrow_upward,
                      selected: _isIncome,
                      color: Colors.green,
                      onTap: () => setState(() {
                        _isIncome = true;
                        _selectedCategory = 'Outros';
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  prefixIcon: Icon(Icons.label_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Informe a descrição';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Valor (R\$)',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o valor';
                  final parsed =
                      double.tryParse(v.trim().replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0)
                    return 'Valor numérico inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categories.contains(_selectedCategory)
                    ? _selectedCategory
                    : _categories.first,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  prefixIcon: Icon(Icons.category_outlined),
                  border: OutlineInputBorder(),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: Icon(_isEditing ? Icons.save : Icons.add),
                  label: Text(_isEditing ? 'Salvar alterações' : 'Adicionar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: selected ? Border.all(color: color, width: 1.5) : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: selected ? color : Colors.grey, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? color : Colors.grey,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
