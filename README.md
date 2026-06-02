# 💰 Meu Dinheiro — Controle Financeiro Pessoal

Aplicativo Flutter de controle financeiro desenvolvido como atividade avaliativa da disciplina de **Desenvolvimento Mobile — UNIFTC**.

---

## 📱 Funcionalidades

### 🔐 Autenticação
- Cadastro de usuário com nome, e-mail e senha
- Login com validação completa de campos
- Autenticação via **Firebase Authentication (REST API)**
- Fallback local com **SharedPreferences** quando offline
- Dados persistidos entre sessões

### 📊 Dashboard
- Saldo atual atualizado automaticamente em tempo real
- Resumo visual de receitas e despesas
- Lista de transações com **animações de entrada** (fade + slide)
- **Skeleton screen** animado enquanto os dados carregam
- **Feed de Notícias Financeiras** em tempo real (NewsAPI)
- Tratamento de erro de rede com fallback de dicas financeiras
- Pull-to-refresh para atualizar dados e notícias

### 💸 Transações (CRUD Completo)
- Adicionar receitas e despesas via **BottomSheet**
- Editar transações existentes
- Excluir com confirmação via **Dialog**
- Campos: Título, Valor, Categoria, Data e Tipo (Entrada/Saída)
- Validação completa com `GlobalKey<FormState>` e `TextFormField`
- Sincronização automática com **Firebase Firestore**

### 📈 Análise Financeira
- Percentual de comprometimento da renda com barra visual
- Breakdown de despesas por categoria com barras de progresso
- Indicador visual de saldo positivo/negativo

---

## 🏗️ Arquitetura — MVVM
lib/
├── models/
│   ├── user_model.dart           # Modelo de usuário
│   └── transaction_model.dart    # Modelo de transação (SQLite + Firestore)
├── services/
│   ├── database_service.dart     # Persistência local (SharedPreferences)
│   ├── firestore_service.dart    # Firebase Auth + Firestore via REST API
│   └── news_service.dart         # Consumo da NewsAPI
├── viewmodels/
│   ├── auth_viewmodel.dart       # Lógica de autenticação (Firebase + fallback local)
│   └── finance_viewmodel.dart    # Lógica financeira com CRUD duplo
├── providers/
│   └── app_providers.dart        # Providers Riverpod (DI)
├── views/
│   ├── auth_view.dart            # Tela de login/cadastro
│   ├── dashboard_view.dart       # Tela principal com notícias e animações
│   ├── analysis_view.dart        # Tela de análise financeira
│   └── transaction_form_sheet.dart # Formulário BottomSheet com validação
└── main.dart

---

## 🛠️ Tecnologias e Pacotes

| Pacote | Versão | Uso |
|--------|--------|-----|
| `flutter_riverpod` | ^2.5.1 | Gerenciamento de estado + Injeção de Dependência |
| `shared_preferences` | ^2.3.2 | Persistência local de dados |
| `sqflite` | ^2.3.3 | Banco de dados SQLite (mobile) |
| `http` | ^1.2.2 | Firebase REST API + NewsAPI |
| `intl` | ^0.19.0 | Formatação de moeda e datas |

---

## ☁️ Serviços Externos

| Serviço | Uso |
|---------|-----|
| **Firebase Authentication** | Cadastro e login de usuários |
| **Firebase Firestore** | Armazenamento de transações na nuvem |
| **NewsAPI** | Feed de notícias financeiras em tempo real |

---

## ✅ Requisitos Atendidos

### Nível Básico (6 pontos)
- [x] CRUD completo de transações (adicionar, listar, editar, excluir)
- [x] Cálculo de saldo automático e reativo no Dashboard
- [x] Campos: Título, Valor, Data, Tipo e Categoria
- [x] Validação com `GlobalKey<FormState>` e `TextFormField`
- [x] Persistência local (SharedPreferences/SQLite)
- [x] Gerenciamento de estado com **Riverpod**
- [x] Fluxo de autenticação real (Login + Cadastro)
- [x] CRUD via BottomSheet e Dialog (sem mudar de rota)
- [x] Navegação entre 3 telas funcionando
- [x] Padrão MVVM respeitado
- [x] Material Design 3

### Nível Avançado (16 pontos)
- [x] **Riverpod** com `ChangeNotifierProvider` e `FutureProvider`
- [x] **Injeção de Dependência** via providers
- [x] **Firebase Firestore** como banco externo
- [x] **Firebase Authentication** para autenticação real
- [x] Persistência local robusta com **SharedPreferences** (cache offline)
- [x] **Estratégia dual**: dados salvos local + nuvem simultaneamente
- [x] **API externa real** — NewsAPI com feed de notícias financeiras
- [x] **Skeleton screens** animados durante carregamento
- [x] **Animações de transição** (fade + slide) nas transações
- [x] **Tratamento de erros de rede** com fallback e feedback visual
- [x] **APK gerado** via Codemagic CI/CD
- [x] Acabamento visual superior com Material Design 3

---

## 🚀 Como Rodar no GitHub Codespaces

### 1. Abrir o Codespace
Acesse o repositório → **Code → Codespaces → Create codespace on main**.

O `.devcontainer` configura o ambiente automaticamente.

### 2. Se o Flutter não estiver no PATH
```bash
export PATH="$PATH:/workspaces/flutter/bin"
```

### 3. Instalar dependências
```bash
cd app_financeiro
flutter pub get
```

### 4. Build de produção
```bash
flutter build web
cd build/web
python3 -m http.server 8080
```

Acesse a URL gerada pelo Codespace na porta **8080**.

---

## 👥 Grupo

Desenvolvido para a disciplina de **Desenvolvimento Mobile**
**UNEX — 2026**