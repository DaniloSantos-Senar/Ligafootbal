# Supermundial

Supermundial é uma aplicação web moderna desenvolvida com o framework [Laravel](https://laravel.com). 

Este repositório contém o código fonte do projeto, juntamente com todas as configurações de infraestrutura necessárias para executar o ambiente de desenvolvimento usando Docker.

## Tecnologias Principais

- **PHP**: ^8.1
- **Framework**: Laravel 10
- **Frontend**: Vite
- **Banco de Dados**: MySQL 8.0
- **Cache/Queue**: Redis
- **Servidor Web**: Nginx
- **Infraestrutura**: Docker & Docker Compose

## Pré-requisitos

Para rodar este projeto na sua máquina, você precisará ter instalado:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

Não é necessário ter PHP, Node.js ou MySQL instalados localmente, pois tudo será executado dentro dos contêineres Docker.

## Configuração Inicial do Projeto

Siga os passos abaixo para preparar o ambiente e rodar a aplicação:

1. **Clone o repositório** (se ainda não o fez):
   ```bash
   git clone <url-do-repositorio> supermundial
   cd supermundial
   ```

2. **Crie o arquivo de ambiente**:
   Faça uma cópia do `.env.example` para `.env`:
   ```bash
   cp .env.example .env
   ```

3. **Suba os contêineres Docker**:
   ```bash
   docker compose up -d --build
   ```

4. **Instale as dependências do PHP (Composer)**:
   Acesse o contêiner da aplicação e instale as dependências:
   ```bash
   docker compose exec app composer install
   ```

5. **Gere a chave da aplicação Laravel**:
   ```bash
   docker compose exec app php artisan key:generate
   ```

6. **Rode as migrações (e seeders, se houver)**:
   ```bash
   docker compose exec app php artisan migrate --seed
   ```

## Acessando a Aplicação

Após os passos acima, os serviços estarão disponíveis em:

- **Aplicação Web**: [http://localhost:8000](http://localhost:8000)
- **Vite (Hot Module Replacement)**: Gerenciado automaticamente pelo contêiner `node`.
- **MySQL**: Disponível na porta `3306`.
- **Redis**: Disponível na porta `6379`.

## Comandos Úteis (Docker)

Aqui estão alguns comandos que você pode usar durante o desenvolvimento:

- **Acessar o terminal do contêiner PHP (app)**:
  ```bash
  docker compose exec app bash
  ```
- **Rodar os testes**:
  ```bash
  docker compose exec app php artisan test
  ```
- **Visualizar os logs**:
  ```bash
  docker compose logs -f
  ```
- **Parar os contêineres**:
  ```bash
  docker compose down
  ```

## Documentação Adicional

Para mais detalhes sobre a arquitetura e estruturação dos contêineres, consulte o arquivo [ARCHITECTURE.md](./ARCHITECTURE.md).
