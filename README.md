# ⏱️ Time Register

Sistema de **relógio de ponto** desenvolvido em **Ruby on Rails 8 (API-only)**, utilizando **PostgreSQL**, **Sidekiq + Redis** para processamento assíncrono, **RSpec** para testes e totalmente **containerizado com Docker**.

---

## 🚀 Visão Geral

O projeto implementa:

- API RESTful para gestão de usuários e registros de ponto
- Processamento assíncrono de relatórios em CSV
- Script de população de dados simulados
- Testes automatizados (RSpec) com cobertura acima de 95%
- Containerização com Docker (Rails, PostgreSQL e Redis)
- Painel Sidekiq para monitoramento de jobs

---

## ⚙️ Pré-requisitos

- Ruby **3.4.5**
- Rails **8.0.2**
- PostgreSQL **>= 14**
- Redis **>= 7**
- Docker e Docker Compose (opcional, mas recomendado)
- RSpec (para rodar os testes)

---

## 🔧 Instalação e Setup

### Clone o repositório
```bash
git clone https://github.com/seu-usuario/time-register.git
cd time-register
```

### Instale as dependências
```bash
bundle install
```

### Configure o banco de dados
Edite `config/database.yml` caso precise.  
Depois rode:
```bash
rails db:create db:migrate db:seed
```

---

## ▶️ Como Executar

### Desenvolvimento local
```bash
rails server
```
ou
```bash
bin/dev
```

### Executar Sidekiq
```bash
bundle exec sidekiq -C config/sidekiq.yml
```

### Usando Docker

**Build da imagem:**
```bash
docker build -t time-register:latest .
```

**Subir com docker-compose:**
```bash
RAILS_MASTER_KEY=<sua_master_key> docker compose up -d
```

**Rodar migrations:**
```bash
docker compose exec app rails db:create db:migrate
```

---

## 📡 Documentação da API

### Users
- `GET    /api/v1/users` → Lista todos os usuários
- `GET    /api/v1/users/:id` → Retorna um usuário
- `POST   /api/v1/users` → Cria usuário
- `PUT    /api/v1/users/:id` → Atualiza usuário
- `DELETE /api/v1/users/:id` → Remove usuário
- `GET    /api/v1/users/:id/time_registers` → Lista registros de ponto do usuário

### Time Registers
- `GET    /api/v1/time_registers` → Lista todos os registros
- `GET    /api/v1/time_registers/:id` → Retorna registro
- `POST   /api/v1/time_registers` → Cria registro
- `PUT    /api/v1/time_registers/:id` → Atualiza registro
- `DELETE /api/v1/time_registers/:id` → Remove registro

### Relatórios
- `POST   /api/v1/users/:id/reports`
    - Parâmetros: `start_date`, `end_date`
    - Resposta: `{ "process_id": "uuid", "status": "queued" }`

- `GET    /api/v1/reports/:process_id/status`
    - Retorna: `{ "process_id": "uuid", "status": "processing|completed|failed", "progress": 75 }`

- `GET    /api/v1/reports/:process_id/download`
    - Retorna: CSV para download

---

## ✅ Validações

- Usuário não pode ter mais de um registro de ponto aberto (sem `clock_out`)
- `clock_out` deve ser posterior ao `clock_in`
- E-mail deve ser válido e único

---

## 🧪 Testes

Rodar todos os testes:
```bash
bundle exec rspec
```

Cobertura atual: **98%**

Tipos de testes implementados:

- **Model specs:** validações e associações
- **Request specs:** todos os endpoints da API
- **Job specs:** geração assíncrona de relatórios
- **Integração:** fluxo completo de marcação de ponto e geração de relatório

---

## 🗃️ Population de Dados

Para gerar dados realistas de demonstração:
```bash
rails db:seed
```

Esse script cria:

- ~100 usuários
- ~20 registros de ponto por usuário
- Horários comerciais (8h–18h), com variações realistas

---

## 🐳 Containerização

### Estrutura
- `Dockerfile` (multi-stage build para produção)
- `docker-compose.yml` (Rails, Postgres, Redis, Sidekiq)
- `.dockerignore`

### Comandos principais
```bash
# Subir serviços
docker compose up -d

# Rodar migrations
docker compose exec app rails db:migrate

# Rodar testes (fora do container, recomendado)
bundle exec rspec
```

---

## 🏗️ Arquitetura do Projeto

```
app/
  controllers/   -> API controllers
  models/        -> User, TimeEntry, ReportProcess
  jobs/          -> GenerateCsvReportJob
  services/      -> Regras extras (ex: geração de relatórios)
  views/         -> (não utilizado, API only)
spec/
  factories/     -> Factories com FactoryBot
  requests/      -> Testes de endpoints
  models/        -> Testes de validações
  jobs/          -> Testes de background jobs
config/
  database.yml   -> Configuração do PostgreSQL
  sidekiq.yml    -> Configuração do Sidekiq
Dockerfile       -> Build de produção
docker-compose.yml -> Orquestração
```

---

## 📦 Deploy

### Configure variáveis de ambiente

- `RAILS_MASTER_KEY`
- `DATABASE_URL`
- `REDIS_URL`

### Build e push da imagem para o registry
```bash
docker build -t registry.seuprojeto.com/time-register:latest .
docker push registry.seuprojeto.com/time-register:latest
```

### Deploy no servidor
```bash
docker pull registry.seuprojeto.com/time-register:latest
docker compose up -d
```

---

## 📊 Status

✅ Todos os requisitos do desafio implementados:

- API REST completa
- Processamento assíncrono com Sidekiq
- Relatórios CSV
- Script de população
- Testes com alta cobertura
- Containerização com Docker
