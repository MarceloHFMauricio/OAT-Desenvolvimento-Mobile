# 💰 Meu Dinheiro — Controle Financeiro Pessoal

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Riverpod](https://img.shields.io/badge/Riverpod-State%20Management-blue)
![Firebase](https://img.shields.io/badge/Firebase-Backend-orange?logo=firebase)
![SQLite](https://img.shields.io/badge/SQLite-Database-blue?logo=sqlite)
![License](https://img.shields.io/badge/Academic%20Project-UNEX-green)

Aplicativo de **controle financeiro pessoal** desenvolvido em **Flutter** como atividade avaliativa da disciplina de **Desenvolvimento Mobile**.

O projeto permite o gerenciamento de receitas e despesas, autenticação de usuários, sincronização em nuvem, análise financeira e consumo de APIs externas.

---

## 📱 Funcionalidades

### 🔐 Autenticação

* Cadastro de usuário com nome, e-mail e senha
* Login com validação de campos
* Firebase Authentication via REST API
* Fallback local utilizando SharedPreferences
* Persistência automática de sessão

### 📊 Dashboard

* Saldo atualizado em tempo real
* Resumo de receitas e despesas
* Lista de transações com animações (Fade + Slide)
* Skeleton Loading durante carregamento
* Feed de notícias financeiras em tempo real
* Pull-to-refresh
* Tratamento de erros e fallback offline

### 💸 Gestão de Transações (CRUD)

* Adicionar receitas e despesas
* Editar transações existentes
* Excluir com confirmação
* Cadastro de:

  * Título
  * Valor
  * Categoria
  * Data
  * Tipo (Entrada/Saída)
* Validação completa de formulários
* Sincronização automática com Firebase Firestore

### 📈 Análise Financeira

* Percentual de comprometimento da renda
* Indicadores visuais de desempenho financeiro
* Distribuição de gastos por categoria
* Saldo positivo/negativo destacado visualmente

---

## 🏗️ Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)**.

```text
lib/
├── models/
│   ├── user_model.dart
│   └── transaction_model.dart
│
├── services/
│   ├── database_service.dart
│   ├── firestore_service.dart
│   └── news_service.dart
│
├── viewmodels/
│   ├── auth_viewmodel.dart
│   └── finance_viewmodel.dart
│
├── providers/
│   └── app_providers.dart
│
├── views/
│   ├── auth_view.dart
│   ├── dashboard_view.dart
│   ├── analysis_view.dart
│   └── transaction_form_sheet.dart
│
└── main.dart
```

---

## 🛠️ Tecnologias Utilizadas

| Tecnologia              | Finalidade                      |
| ----------------------- | ------------------------------- |
| Flutter                 | Desenvolvimento multiplataforma |
| Riverpod                | Gerenciamento de estado         |
| Firebase Authentication | Autenticação                    |
| Firebase Firestore      | Banco de dados em nuvem         |
| SQLite                  | Persistência local              |
| SharedPreferences       | Cache e sessão                  |
| NewsAPI                 | Notícias financeiras            |
| HTTP                    | Consumo de APIs                 |
| Intl                    | Formatação de datas e moedas    |

---

## ☁️ Serviços Externos

| Serviço                 | Função                             |
| ----------------------- | ---------------------------------- |
| Firebase Authentication | Cadastro e login                   |
| Firebase Firestore      | Armazenamento em nuvem             |
| NewsAPI                 | Notícias financeiras em tempo real |

---

## ✅ Critérios Atendidos

### Nível Básico

* ✅ CRUD completo de transações
* ✅ Cálculo automático de saldo
* ✅ Validação de formulários
* ✅ Persistência local
* ✅ Navegação entre telas
* ✅ Gerenciamento de estado
* ✅ Fluxo completo de autenticação
* ✅ Material Design 3
* ✅ Arquitetura MVVM

### Nível Avançado

* ✅ Riverpod + Injeção de Dependência
* ✅ Firebase Authentication
* ✅ Firebase Firestore
* ✅ Estratégia Offline First
* ✅ Sincronização Local + Nuvem
* ✅ Consumo de API Externa (NewsAPI)
* ✅ Skeleton Loading
* ✅ Animações de interface
* ✅ Tratamento de falhas de rede
* ✅ APK gerado via CI/CD
* ✅ Acabamento visual avançado

---

## 🚀 Executando no GitHub Codespaces

### 1. Criar um Codespace

```text
Code → Codespaces → Create codespace on main
```

### 2. Configurar Flutter

```bash
export PATH="$PATH:/workspaces/flutter/bin"
```

### 3. Instalar dependências

```bash
cd app_financeiro
flutter pub get
```

### 4. Executar versão Web

```bash
flutter build web

cd build/web

python3 -m http.server 8080
```

Abra a porta **8080** disponibilizada pelo Codespaces.

---


## 👨‍💻 Desenvolvido por

**Marcelo Henrique Fernandes Mauricio

Projeto acadêmico desenvolvido para a disciplina de **Desenvolvimento Mobile**.

**UNEX — 2026**
