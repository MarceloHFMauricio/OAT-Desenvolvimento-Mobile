import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/app_providers.dart';
import '../models/transaction_model.dart';
import 'transaction_form_sheet.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  void _openForm(BuildContext context, {TransactionModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TransactionFormSheet(existing: existing),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, TransactionModel t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir transação'),
        content: Text('Deseja excluir "${t.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(financeViewModelProvider).deleteTransaction(t.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeVM = ref.watch(financeViewModelProvider);
    final authVM = ref.watch(authViewModelProvider);
    final news = ref.watch(newsProvider);
    final fmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Meu Dinheiro',
                style: TextStyle(fontWeight: FontWeight.bold)),
            if (authVM.currentUser != null)
              Text(
                'Olá, ${authVM.currentUser!.name.split(' ').first}',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Análise',
            onPressed: () => Navigator.pushNamed(context, '/analysis'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              ref.read(authViewModelProvider).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
        elevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      body: financeVM.isLoading
          ? _SkeletonDashboard()
          : RefreshIndicator(
              onRefresh: () async {
                await financeVM.loadTransactions(authVM.currentUser?.id ?? 0);
                ref.invalidate(newsProvider);
              },
              child: CustomScrollView(
                slivers: [
                  // --- Cartão saldo ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Column(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 600),
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: child,
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.primary.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Saldo atual',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Text(
                                    fmt.format(financeVM.balance),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _SummaryCard(
                                label: 'Receitas',
                                value: fmt.format(financeVM.totalIncome),
                                icon: Icons.arrow_upward,
                                color: Colors.green,
                              ),
                              const SizedBox(width: 12),
                              _SummaryCard(
                                label: 'Despesas',
                                value: fmt.format(financeVM.totalExpense),
                                icon: Icons.arrow_downward,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Feed de Notícias ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Icon(Icons.newspaper,
                              size: 18, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text('Notícias Financeiras',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 160,
                      child: news.when(
                        loading: () => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: 3,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, __) => _NewsSkeletonCard(),
                        ),
                        error: (e, _) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off,
                                  color: Colors.grey[400], size: 32),
                              const SizedBox(height: 8),
                              Text('Sem conexão com notícias',
                                  style: TextStyle(color: Colors.grey[500])),
                            ],
                          ),
                        ),
                        data: (articles) => ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: articles.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, i) =>
                              _NewsCard(article: articles[i]),
                        ),
                      ),
                    ),
                  ),

                  // --- Cabeçalho transações ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Transações',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Text(
                            '${financeVM.transactions.length} registro(s)',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Lista de transações ---
                  financeVM.transactions.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.receipt_long,
                                    size: 72, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                Text('Nenhuma transação ainda',
                                    style:
                                        TextStyle(color: Colors.grey[500])),
                                const SizedBox(height: 8),
                                FilledButton.tonalIcon(
                                  onPressed: () => _openForm(context),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Adicionar'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, index) {
                              final t = financeVM.transactions[index];
                              return _AnimatedTile(
                                index: index,
                                child: _TransactionTile(
                                  transaction: t,
                                  onEdit: () =>
                                      _openForm(context, existing: t),
                                  onDelete: () =>
                                      _confirmDelete(context, ref, t),
                                ),
                              );
                            },
                            childCount: financeVM.transactions.length,
                          ),
                        ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Lançar'),
      ),
    );
  }
}

// --- Skeleton Dashboard ---
class _SkeletonDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _SkeletonBox(height: 120, radius: 20),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _SkeletonBox(height: 80, radius: 16)),
            const SizedBox(width: 12),
            Expanded(child: _SkeletonBox(height: 80, radius: 16)),
          ]),
          const SizedBox(height: 20),
          _SkeletonBox(height: 16, radius: 8, width: 180),
          const SizedBox(height: 12),
          Row(children: [
            _SkeletonBox(height: 140, radius: 16, width: 220),
            const SizedBox(width: 12),
            _SkeletonBox(height: 140, radius: 16, width: 220),
          ]),
          const SizedBox(height: 20),
          for (int i = 0; i < 4; i++) ...[
            _SkeletonBox(height: 72, radius: 14),
            const SizedBox(height: 8),
          ]
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatefulWidget {
  final double height;
  final double radius;
  final double? width;
  const _SkeletonBox(
      {required this.height, required this.radius, this.width});

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width ?? double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

// --- News Skeleton ---
class _NewsSkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 12, color: Colors.grey[300],
              width: double.infinity),
          const SizedBox(height: 8),
          Container(height: 12, color: Colors.grey[300], width: 160),
          const SizedBox(height: 12),
          Container(height: 10, color: Colors.grey[200],
              width: double.infinity),
          const SizedBox(height: 6),
          Container(height: 10, color: Colors.grey[200], width: 180),
        ],
      ),
    );
  }
}

// --- News Card ---
class _NewsCard extends StatelessWidget {
  final dynamic article;
  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 240,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: colorScheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.article_outlined,
                  size: 14, color: colorScheme.primary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  article.source,
                  style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            article.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              article.description,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Animated Tile ---
class _AnimatedTile extends StatefulWidget {
  final Widget child;
  final int index;
  const _AnimatedTile({required this.child, required this.index});

  @override
  State<_AnimatedTile> createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<_AnimatedTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300 + widget.index * 50),
    )..forward();
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// --- Summary Card ---
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          color: Colors.grey[600], fontSize: 12)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 13),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Transaction Tile ---
class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TransactionTile({
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final color = t.isIncome ? Colors.green : Colors.red;
    final fmt = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.grey.withOpacity(0.15)),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              t.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              color: color,
              size: 20,
            ),
          ),
          title: Text(t.title,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            '${t.category} • ${DateFormat('dd/MM/yyyy').format(t.date)}',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fmt.format(t.amount),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 18),
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ])),
                  const PopupMenuItem(
                      value: 'delete',
                      child: Row(children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Excluir',
                            style: TextStyle(color: Colors.red)),
                      ])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
