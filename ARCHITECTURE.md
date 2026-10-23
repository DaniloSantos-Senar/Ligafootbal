# Arquitetura do Projeto Supermundial

Este documento detalha a arquitetura, as decisões técnicas e a estrutura de infraestrutura do projeto **Supermundial**.

## Visão Geral

O sistema é uma aplicação web construída sobre o framework **Laravel 10** e rodando em **PHP 8.1**. A infraestrutura de desenvolvimento é totalmente baseada em contêineres Docker, gerenciados pelo `docker-compose`.

## Estrutura de Contêineres (Docker)

O ambiente de desenvolvimento (e potencialmente de produção) utiliza os seguintes serviços definidos no `docker-compose.yml`:

1. **app (Laravel / PHP-FPM)**
   - **Imagem/Build**: Usa um `Dockerfile` customizado localizado na raiz do projeto.
   - **Responsabilidade**: Executar o código PHP da aplicação.
   - **Configuração Customizada**: Utiliza um arquivo `local.ini` em `./docker/php/local.ini` para configurações específicas do PHP.
   - **Rede**: Conecta-se ao `mysql` e `redis`.

2. **nginx (Servidor Web)**
   - **Imagem**: `nginx:alpine`
   - **Responsabilidade**: Servir arquivos estáticos (public) e fazer o proxy reverso das requisições PHP para o contêiner `app`.
   - **Porta Mapeada**: `8000` (Localhost) -> `80` (Contêiner).
   - **Configuração Customizada**: Utiliza o arquivo `./docker/nginx/nginx.conf`.

3. **mysql (Banco de Dados Relacional)**
   - **Imagem**: `mysql:8.0`
   - **Responsabilidade**: Armazenar os dados persistentes da aplicação.
   - **Porta Mapeada**: `3306`
   - **Volume**: Utiliza um volume nomeado `mysql_data` para garantir que os dados não se percam quando o contêiner for desligado.
   - **Configuração Customizada**: `./docker/mysql/my.cnf`.

4. **redis (Cache, Sessão e Filas)**
   - **Imagem**: `redis:alpine`
   - **Responsabilidade**: Atuar como banco de dados in-memory para armazenamento rápido de cache, sessões de usuário e gerenciamento de filas (queues) do Laravel.
   - **Porta Mapeada**: `6379`

5. **node (Frontend Tooling / Vite)**
   - **Imagem**: `node:18-alpine`
   - **Responsabilidade**: Instalar dependências JavaScript (`npm install`) e executar o servidor de desenvolvimento do Vite (`npm run dev`) para Hot Module Replacement (HMR).

## Estrutura de Diretórios e Código

O padrão de diretórios segue o padrão oficial do Laravel:

- `/app`: Regras de negócio, Models, Controllers e Middlewares.
- `/config`: Configurações da aplicação.
- `/database`: Migrations e Seeders (MySQL).
- `/docker`: Configurações específicas para os contêineres Docker (Nginx, MySQL, PHP e o script `entrypoint.sh`).
- `/public`: O entrypoint público da aplicação (`index.php`) e os arquivos compilados (se em produção).
- `/resources`: Views, CSS, JavaScript não compilados.
- `/routes`: Definição de rotas da aplicação (web, api, console).
- `/tests`: Testes automatizados (PHPUnit).

## Pipeline de Requisição

1. O cliente acessa `http://localhost:8000`.
2. A requisição bate no contêiner **nginx**.
3. O Nginx verifica se é um arquivo estático existente em `/public`. Se não for, redireciona a requisição via FastCGI para a porta 9000 do contêiner **app** (PHP-FPM).
4. O Laravel processa a requisição no **app**, podendo consultar o **mysql** e o **redis**.
5. O **node** roda em paralelo, observando mudanças nos arquivos estáticos em `/resources` para atualizar o navegador via HMR (Vite).

## Considerações de Deploy

- As credenciais de banco de dados e as variáveis sensíveis são injetadas exclusivamente via `.env`.
- Para ambiente de produção, o serviço `node` deve ser alterado ou omitido para apenas gerar os assets de build estáticos (`npm run build`).
- Os volumes montados (`- ./:/var/www`) são ideais para o desenvolvimento. Em produção, recomenda-se construir a imagem copiando o código-fonte para dentro dela e não utilizar *bind mounts*.
