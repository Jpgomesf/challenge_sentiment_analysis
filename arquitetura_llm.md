A seguir, apresento uma documentação completa para o projeto, detalhando a arquitetura dos agentes LLM, o fluxo de execução e as instruções necessárias para configurar e iniciar a aplicação usando Docker.

---

# Análise de Conversa com Agentes LLM

---

## Sumário

- [Arquitetura dos Agentes LLM](#arquitetura-dos-agentes-llm)
  - [Coordinator Agent](#coordinator-agent)
  - [Analyst Agent](#analyst-agent)
  - [Reporter Agent](#reporter-agent)
  - [Finalizer Agent](#finalizer-agent)
  - [Diagrama de Fluxo](#diagrama-de-fluxo)
- [Fluxo de Execução do Processamento](#fluxo-de-execução-do-processamento)
- [Configuração e Execução com Docker](#configuração-e-execução-com-docker)
- [Outras Informações do Projeto](#outras-informações-do-projeto)

---

## Arquitetura dos Agentes LLM

A arquitetura dos agentes LLM foi pensada para ser modular, permitindo que cada agente realize uma tarefa específica no processamento de uma conversa. A seguir, explicamos cada um dos agentes e seu papel no fluxo:

### Coordinator Agent

- **Objetivo:**  
  Receber o histórico completo da conversa e segmentar as mensagens em blocos lógicos.  
- **Como Funciona:**  
  - Concatena as mensagens (formando uma string com cada mensagem identificada pelo autor).  
  - Utiliza um prompt que instrui o agente a identificar os limites entre as mensagens e agrupar os trechos por contexto.  
  - Retorna um JSON contendo os segmentos identificados (chave `"segments"`).

### Analyst Agent

- **Objetivo:**  
  Analisar detalhadamente cada bloco de mensagens, avaliando diversos aspectos como sentimento, comportamento, red flags, elogios, pontos positivos e consistência de linguagem.  
- **Como Funciona:**  
  - Recebe um bloco de mensagens (resultado do Coordinator) e o histórico acumulado de análises anteriores.  
  - Utiliza um prompt que instrui o agente a analisar o bloco, retornando objetos com campos como `text` (texto da análise) e `confidence` (nível de confiança, entre 0 e 1).  
  - Opcionalmente, inclui um array `evaluation_history` para acumular análises anteriores.

### Reporter Agent

- **Objetivo:**  
  Consolidar as análises dos blocos e gerar um relatório final da conversa.  
- **Como Funciona:**  
  - Recebe todas as análises dos blocos (lista de JSONs).  
  - Utiliza um prompt que instrui o agente a gerar um relatório contendo:
    - **combined_result:** resumo consolidado da conversa,
    - **pros_summary:** resumo dos pontos positivos,
    - **cons_summary:** resumo dos pontos negativos,
    - **improvements_summary (opcional):** sugestões para melhorar o processo de atendimento,
    - **risk_points (opcional):** fatores de risco para a empresa ou cliente,
    - **confidence:** um objeto indicando o nível de confiança das afirmações.
  - Retorna o relatório final em formato JSON.

### Finalizer Agent

- **Objetivo:**  
  Com base no relatório final e no prompt original (a pergunta do usuário), gerar uma resposta final concisa.  
- **Como Funciona:**  
  - Recebe o relatório gerado pelo Reporter e o prompt original.  
  - Utiliza um prompt que instrui o agente a produzir uma resposta final contendo as chaves:
    - **satisfaction:** escala de satisfação (por exemplo, de 1 a 10),
    - **summary:** resumo da análise,
    - **improvements:** sugestões de melhorias.
  - Retorna o resultado final em formato JSON.

### Diagrama de Fluxo

Abaixo, um diagrama simplificado que ilustra o fluxo entre os agentes:

```
                   +--------------------------+
                   |    Coordinator Agent     |
                   | (Segmenta a conversa em  |
                   |       blocos lógicos)    |
                   +-------------+------------+
                                 |
                                 V
                   +--------------------------+
                   |     Analyst Agent        |
                   | (Analisa cada bloco e    |
                   |  acumula o histórico)    |
                   +-------------+------------+
                                 |
                                 V
                   +--------------------------+
                   |     Reporter Agent       |
                   | (Consolida análises em   |
                   |    relatório final)      |
                   +-------------+------------+
                                 |
                                 V
                   +--------------------------+
                   |    Finalizer Agent       |
                   | (Gera a resposta final   |
                   |  com base no relatório)  |
                   +--------------------------+
```

---

## Fluxo de Execução do Processamento

O processamento completo da conversa é orquestrado de forma assíncrona e dividido em quatro etapas principais:

1. **Segmentação da Conversa:**  
   O **Coordinator Agent** é executado em paralelo para cada bloco de mensagens (se a conversa for dividida devido ao volume de tokens).

2. **Análise dos Blocos:**  
   O **Analyst Agent** processa cada bloco de mensagens sequencialmente, acumulando um histórico de análises para referência futura.

3. **Geração do Relatório Final:**  
   O **Reporter Agent** consolida as análises individuais, gerando um relatório final abrangente.

4. **Resposta Final:**  
   O **Finalizer Agent** recebe o relatório e o prompt original, gerando a resposta final com os campos `satisfaction`, `summary` e `improvements`.

Cada etapa é registrada no banco de dados (via SQLAlchemy) por meio de um mecanismo de _stages_, que permite rastrear o status e os resultados (ou erros) de cada agente.

---

## Configuração e Execução com Docker

Para facilitar a configuração e execução do projeto, siga os passos abaixo:

1. **Configurar o Arquivo de Ambiente:**

   - Localize o arquivo `env_example` na raiz do projeto.
   - Edite o arquivo, inserindo sua chave da API do OpenAI, por exemplo:

     ```ini
     OPENAI_API_KEY=sua_chave_api_openai_aqui
     DATABASE_URL=postgresql://usuario:senha@localhost:5432/nome_do_banco
     ```
     
   - Renomeie o arquivo `env_example` para `.env`.

2. **Construir e Executar a Aplicação com Docker Compose:**

   - Certifique-se de ter o Docker e o Docker Compose instalados em sua máquina.
   - No terminal, na raiz do projeto, execute:

     ```bash
     docker-compose up --build
     ```

   - O comando irá:
     - Construir a imagem do contêiner a partir do `Dockerfile`.
     - Iniciar todos os serviços definidos no `docker-compose.yml` (por exemplo, a aplicação e o banco de dados, se aplicável).
     - A aplicação utilizará as variáveis definidas no arquivo `.env` e iniciará o processamento automaticamente.

---

## Outras Informações do Projeto

- **Tecnologias Utilizadas:**
  - **Python 3.8+**
  - **SQLAlchemy:** ORM para interação com o banco de dados.
  - **Pydantic:** Validação e serialização dos dados.
  - **LangChain e OpenAI:** Para construir e executar pipelines (chains) que operam os agentes LLM.
  - **Docker e Docker Compose:** Para facilitar a configuração, isolamento e execução da aplicação.

- **Estrutura Modular:**
  - **core/** – Configurações globais e conexão com o banco.
  - **models/** – Definição dos modelos do banco de dados.
  - **schemas/** – Esquemas Pydantic para validação de dados.
  - **services/** – Lógica dos agentes LLM e orquestração do processamento.
  - **main.py** – Ponto de entrada da aplicação.

- **Registro de Estágios (Stages):**  
  Cada etapa (stage) do processamento é registrada, permitindo identificar com clareza o andamento e a ocorrência de eventuais erros durante a execução dos agentes.

---

## Conclusão

Esta documentação apresenta uma visão completa da arquitetura dos agentes LLM, o fluxo de execução do processamento de conversas e as instruções para configuração e execução do projeto via Docker. Basta inserir sua chave da OpenAI no arquivo `.env_example`, renomeá-lo para `.env` e rodar:

```bash
docker-compose up --build
```
