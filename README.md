# 🤖 ServeRest Web Robot - Automação de Testes

[![Robot Framework](https://img.shields.io/badge/Robot%20Framework-6.1.1-blue.svg)](https://robotframework.org/)
[![Python](https://img.shields.io/badge/Python-3.8%2B-green.svg)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Projeto de automação de testes para a API ServeRest utilizando Robot Framework. Este projeto implementa testes abrangentes para funcionalidades de usuários, produtos, carrinho e autenticação.

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Funcionalidades Testadas](#funcionalidades-testadas)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Execução dos Testes](#execução-dos-testes)
- [Relatórios](#relatórios)
- [Estrutura de Tags](#estrutura-de-tags)
- [Contribuição](#contribuição)

## 🎯 Sobre o Projeto

Este projeto automatiza os testes da API ServeRest, uma API REST gratuita que simula uma loja virtual. Os testes cobrem cenários de fluxos críticos da aplicação, positivos e negativos, para garantir a qualidade e confiabilidade da aplicação.

### 🌐 API Testada
- **URL Base**: `http://13.218.59.237:3000`
- **Documentação**: [ServeRest API](https://serverest.dev/)
- Quadro Jira + QALity: [Quadro Jira + QALity – Challenge 02](https://sbnramos.atlassian.net/jira/software/projects/SBN/boards/38?atlOrigin=eyJpIjoiMTgwNWE5ODgxMWU0NDVlYThmNDM2M2ZhNzE3YjQ3MTEiLCJwIjoiaiJ9)

## ⚡ Funcionalidades Testadas

### 👤 Usuários
- ✅ Cadastro de usuários válidos (admin e comum)
- ❌ Validação de campos obrigatórios
- ❌ Validação de formato de email
- ❌ Validação de domínios bloqueados (gmail.com, hotmail.com)
- ❌ Validação de limites de senha (5-10 caracteres)
- ❌ Prevenção de emails duplicados

### 🔐 Autenticação
- ✅ Login com credenciais válidas
- ❌ Login com credenciais inválidas
- ⏱️ Expiração de token após 10 minutos

### 📦 Produtos
- ✅ Cadastro de produtos (apenas administradores)
- ❌ Tentativa de cadastro por usuários comuns
- ❌ Tentativa de cadastro com token inválido
- ❌ Validação de nomes duplicados
- 📋 Listagem de produtos
- ❌ Exclusão de produto que está em carrinho

### 🛒 Carrinho
- ✅ Adição de produtos ao carrinho
- ✅ Conclusão de compra
- ✅ Cancelamento de compra

### 🔒 Permissões Administrativas
- ❌ Validação de restrições para usuários não administradores
- ✅ Confirmação de permissões para administradores

## 📁 Estrutura do Projeto

```
serverest-web-robot/
├── 📄 README.md                          # Documentação do projeto
├── 📄 requirements.txt                   # Dependências Python
│
├── 📁 tests/                             # Suites de teste
│   ├── 📄 usuarios.robot                 # Testes de usuários
│   ├── 📄 login.robot                    # Testes de autenticação
│   ├── 📄 produtos.robot                 # Testes de produtos
│   ├── 📄 carrinho.robot                 # Testes de carrinho
│
├── 📁 resources/                         # Recursos reutilizáveis
│   ├── 📄 variables.resource             # Variáveis do projeto
│   └── 📁 keywords/                      # Keywords específicas
│       ├── 📄 usuario.resource           # Keywords de usuário
│       ├── 📄 login.resource             # Keywords de login
│       ├── 📄 produto.resource           # Keywords de produto
│       ├── 📄 carrinho.resource          # Keywords de carrinho
│
├── 📁 results/                           # Resultados de execução
│   ├── 📄 log.html                       # Log detalhado
│   ├── 📄 report.html                    # Relatório de execução
│   └── 📄 output.xml                     # Saída em XML
│
└── 📁 docs/                              # Documentação QALity + Robot
    ├── 📊 Test_Execution_Report_02.10.2025.xlsx  # Relatório de execução QALity
    ├── 📄 Planejamento de Testes – ServeRest-031025-050201.pdf  # Planejamento de testes
    ├── 📄 Rastreabilidade de Issues e Melhorias _ Challenge 2-031025-050242.pdf  # Rastreabilidade
    ├── 🖼️ test_execution_log.png         # Log de execução Robot Framework
    ├── 🖼️ testcycle.png                  # Print Test Cycle QALity
    ├── 📈 tests_chart.png                # Gráfico do Test Cycle QALity
    ├── 🖼️ overview_qality_testcycle.png  # Overview de execução QALity
    └── 🖼️ project_structure.png          # Estrutura do projeto

```

## 🔧 Pré-requisitos

- **Python 3.8+**
- **pip** (gerenciador de pacotes Python)
- **Git** (para clonagem do repositório)

## 🚀 Instalação

### 1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/serverest-web-robot.git
cd serverest-web-robot
```

### 2. Crie um ambiente virtual (recomendado)
```bash
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
```

### 3. Instale as dependências
```bash
pip install -r requirements.txt
```

## ▶️ Execução dos Testes

### Executar todos os testes
```bash
robot -d results tests/
```

### Executar suite específica
```bash
# Testes de usuários
robot -d results tests/usuarios.robot

# Testes de produtos
robot -d results tests/produtos.robot

# Testes de carrinho
robot -d results tests/carrinho.robot
```

### Executar por tags
```bash
# Apenas testes críticos
robot -d results -i critico tests/

# Apenas testes positivos
robot -d results -i positivo tests/

# Excluir testes específicos
robot -d results -e negativo tests/
```

### Executar com variáveis customizadas
```bash
# Alterar URL base
robot -d results -v BASE_URL:http://localhost:3000 tests/

```

## 📊 Relatórios

Após a execução, os relatórios são gerados na pasta `results/`:

- **`report.html`**: Relatório visual com estatísticas e resultados
- **`log.html`**: Log detalhado da execução com screenshots
- **`output.xml`**: Saída em XML para integração com CI/CD

### Visualizar relatórios
```bash
# Abrir relatório no navegador (Windows)
start results/report.html

# Linux/Mac
open results/report.html
```

## 🏷️ Estrutura de Tags

### Por Tipo
- `positivo`: Cenários de sucesso
- `negativo`: Cenários de falha/validação

### Por Prioridade
- `critico`: Funcionalidades essenciais
- `alto`: Funcionalidades importantes
- `medio`: Funcionalidades complementares

### Por Funcionalidade
- `usuario`: Testes relacionados a usuários
- `login`: Testes de autenticação
- `produto`: Testes de produtos
- `carrinho`: Testes de carrinho

## 📈 Métricas de Cobertura

### Cenários de Teste Implementados
- **Usuários**: 13 cenários
- **Login**: 3 cenários
- **Produtos**: 6 cenários
- **Carrinho**: 3 cenários

**Total**: 25 cenários de teste


## 🛠️ Desenvolvimento

### Adicionar novos testes
1. Crie keywords reutilizáveis em `resources/keywords/`
2. Adicione dados de teste em `test_data.robot`
3. Implemente os cenários em `tests/`
4. Use tags apropriadas para categorização

### Boas práticas implementadas
- ✅ Keywords reutilizáveis e modulares
- ✅ Separação de dados e lógica
- ✅ Documentação abrangente
- ✅ Tratamento de erros robusto
- ✅ Geração de dados únicos
- ✅ Validações consistentes

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Contato

- **Projeto**: ServeRest Web Robot
- **Documentação**: Veja a pasta `docs/` para documentação adicional

---

⭐ **Se este projeto foi útil para você, considere dar uma estrela!**
