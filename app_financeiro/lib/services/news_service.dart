import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String source;
  final String publishedAt;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.source,
    required this.publishedAt,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
        title: json['title'] ?? '',
        description: json['description'] ?? 'Sem descrição disponível.',
        url: json['url'] ?? '',
        source: json['source']?['name'] ?? 'Desconhecido',
        publishedAt: json['publishedAt'] ?? '',
      );
}

class NewsService {
  static const _apiKey = 'dba1d8092ace430baaee06c9be3ef384';
  static const _baseUrl = 'https://newsapi.org/v2/everything';

  Future<List<NewsArticle>> fetchFinanceNews() async {
    try {
      final uri = Uri.parse(
        '$_baseUrl?q=finanças+investimento+economia&language=pt&sortBy=publishedAt&pageSize=10&apiKey=$_apiKey',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List;
        return articles
            .map((a) => NewsArticle.fromJson(a))
            .where((a) => a.title.isNotEmpty && a.title != '[Removed]')
            .toList();
      }
      return _fallbackNews();
    } catch (e) {
      return _fallbackNews();
    }
  }

  List<NewsArticle> _fallbackNews() => [
        NewsArticle(
          title: 'Como montar uma reserva de emergência',
          description:
              'Especialistas recomendam guardar de 3 a 6 meses de despesas fixas em aplicações de alta liquidez.',
          url: '',
          source: 'Dica Financeira',
          publishedAt: DateTime.now().toIso8601String(),
        ),
        NewsArticle(
          title: 'Tesouro Direto: opção segura para iniciantes',
          description:
              'Investir no Tesouro Direto é uma das formas mais acessíveis de começar a investir com segurança.',
          url: '',
          source: 'Dica Financeira',
          publishedAt: DateTime.now().toIso8601String(),
        ),
        NewsArticle(
          title: 'Regra dos 50/30/20: como dividir seu salário',
          description:
              '50% para necessidades, 30% para desejos e 20% para poupança e investimentos.',
          url: '',
          source: 'Dica Financeira',
          publishedAt: DateTime.now().toIso8601String(),
        ),
        NewsArticle(
          title: 'Juros compostos: o poder do tempo nos investimentos',
          description:
              'Quanto antes você começa a investir, mais tempo os juros compostos trabalham a seu favor.',
          url: '',
          source: 'Dica Financeira',
          publishedAt: DateTime.now().toIso8601String(),
        ),
        NewsArticle(
          title: 'Como sair das dívidas em 2024',
          description:
              'Priorize dívidas com juros mais altos, negocie com credores e evite novos parcelamentos.',
          url: '',
          source: 'Dica Financeira',
          publishedAt: DateTime.now().toIso8601String(),
        ),
      ];
}
