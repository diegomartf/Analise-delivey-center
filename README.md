
# Projeto de Análise de Dados do Delivery Center

Este repositório contém o código SQL e as análises realizadas no projeto de análise de dados para o Delivery Center. O objetivo deste projeto é explorar e analisar dados de pedidos, entregas, pagamentos, lojistas e hubs, visando obter insights valiosos para o negócio.

## Descrição do Projeto

O Delivery Center é uma plataforma que integra lojistas e marketplaces, operando com diversos hubs espalhados pelo Brasil. Com um cadastro extenso de itens e milhares de pedidos processados diariamente, a análise desses dados se torna essencial para tomar decisões informadas e estratégicas.

### Objetivos

- Entender a estrutura dos dados do Delivery Center.
- Realizar análises descritivas e inferenciais.
- Identificar padrões e tendências nos dados de pedidos, entregas e pagamentos.
- Avaliar o desempenho dos entregadores e marketplaces.
- Criar visualizações interativas em Power BI para facilitar a interpretação dos resultados.

## Estrutura dos Dados

Os dados utilizados no projeto estão organizados nas seguintes tabelas:

- **channels**: Informações sobre os canais de venda (marketplaces).
- **deliveries**: Informações sobre as entregas realizadas.
- **drivers**: Informações sobre os entregadores parceiros.
- **hubs**: Informações sobre os hubs (centros de distribuição).
- **orders**: Informações sobre as vendas processadas.
- **payments**: Informações sobre os pagamentos realizados.
- **stores**: Informações sobre os lojistas.

## Análises Realizadas

### Exploração Inicial

- Conhecimento da estrutura das tabelas.
- Contagem de registros por tabela.

### Análises Estatísticas Básicas

- Resumo estatístico das vendas.
- Distribuição dos valores dos pedidos.
- Quantidade de pedidos abaixo e acima de 100.
- Quantidade de pedidos cancelados.

### Transformações e Limpeza de Dados

- Criação de uma nova tabela `orders_new`.
- Adição de colunas de data e hora para cálculo do tempo de entrega.
- Remoção de linhas duplicadas.
- Contagem de valores nulos.

### Análises Avançadas

- Identificação dos marketplaces mais rentáveis.
- Cálculo do tempo médio de entrega por hub.
- Desempenho dos entregadores.
- Análise do impacto do tipo de contratação no desempenho dos entregadores.
- Volume de pedidos e valor médio de venda por lojista.
- Análise de pagamentos por método e tendência ao longo do tempo.

## Ferramentas Utilizadas

- **SQL**: Para manipulação e análise dos dados.
- **Power BI**: Para criação de dashboards interativos.


## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.


## Contato

Para dúvidas e sugestões, entre em contato:

- **Nome**: Diego Martins Faria
- **Email**: diegomartinsa15@gmail.com
- **LinkedIn**: https://www.linkedin.com/in/diego-martins-faria/
