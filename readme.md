# Desafio de Análise de Conversas com OpenAI

Desenvolva uma aplicação para analisar conversas de atendimento e extrair as informações:
- **satisfaction**: nota de satisfação do cliente (0 a 10);
- **summary**: resumo da conversa;
- **improvement**: como a conversa poderia ter sido melhor.

A aplicação deve utilizar a API `https://api.openai.com/v1/chat/completions` com o modelo `gpt-4o-mini` para processar as mensagens e gravar o resultado no banco de dados. Caso outras informações sejam consideradas úteis, novas colunas podem ser adicionadas à tabela `analysis`.

## Pré-requisitos

- **Docker**  
- **Docker Compose**  
- Chave da API do OpenAI (fornecida pelo entrevistador)

## Configuração

1. Clone este repositório.
2. Edite as configurações necessárias para incluir a chave da API do OpenAI.
3. Caso queira adicionar novas colunas à tabela `analysis`, faça a alteração no modelo de dados correspondente.
4. Adicione sua aplicação no docker compose.

## Execução

1. No diretório raiz do projeto, execute:
   ```bash
   docker-compose up --build
   ```
2. A aplicação iniciará e fará a análise das conversas.

3. As informações extraídas serão gravadas no banco de dados.

## Avaliação
- A elaboração do prompt e a solução para extração de dados são os pontos principais a serem avaliados.
- A aplicação deve ser iniciada e fazer a análise das conversas ao executar o comando `docker-compose up --build`.

## Observações

- Mensagens de exemplo serão inseridas automaticamente no banco de dados.
- As conversas possuem o campo `remote` para indicar se a mensagem foi enviada pelo cliente (`true`) ou pela assistente (`false`).
- Uma boa conversa é aquela em que a assistente responde adequadamente às perguntas do usuário e finaliza a reserva.  
