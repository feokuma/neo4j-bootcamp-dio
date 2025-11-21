# Neo4j Docker Setup

Este projeto configura uma instância do Neo4j usando Docker Compose.

## 🚀 Como usar

### 1. Iniciar o Neo4j
```bash
docker-compose up -d
```

### 2. Parar o Neo4j
```bash
docker-compose down
```

### 3. Parar e remover volumes (⚠️ remove todos os dados)
```bash
docker-compose down -v
```

## 🔗 Acesso

- **Neo4j Browser**: http://localhost:7474
- **Bolt Protocol**: bolt://localhost:7687

### Credenciais padrão:
- **Usuário**: `neo4j`
- **Senha**: `password`

## 📊 Configurações

### Memória
- Heap inicial: 512MB
- Heap máximo: 2GB
- Page cache: 1GB

### Plugins incluídos
- **APOC**: Biblioteca de procedimentos avançados
- **Graph Data Science**: Algoritmos de ciência de dados em grafos

## 📁 Volumes

Os dados são persistidos nos seguintes volumes Docker:
- `neo4j_data`: Dados do banco
- `neo4j_logs`: Logs do sistema
- `neo4j_import`: Diretório para importação de arquivos
- `neo4j_plugins`: Plugins instalados

## 🔧 Personalização

Para alterar configurações, edite as variáveis de ambiente no arquivo `docker-compose.yml`:

### Alterar senha
```yaml
- NEO4J_AUTH=neo4j/sua_nova_senha
```

### Alterar configurações de memória
```yaml
- NEO4J_dbms_memory_heap_max__size=4G
- NEO4J_dbms_memory_pagecache_size=2G
```

## 📝 Comandos úteis

### Verificar status do container
```bash
docker-compose ps
```

### Ver logs
```bash
docker-compose logs -f neo4j
```

### Executar Cypher Shell
```bash
docker-compose exec neo4j cypher-shell -u neo4j -p password
```

### Fazer backup
```bash
docker-compose exec neo4j neo4j-admin database dump neo4j --to=/data/backup.dump
```

### Restaurar backup
```bash
docker-compose exec neo4j neo4j-admin database load neo4j --from=/data/backup.dump --overwrite-destination
```

## 🐛 Troubleshooting

### Container não inicia
1. Verifique se as portas 7474 e 7687 não estão sendo usadas
2. Verifique os logs: `docker-compose logs neo4j`

### Problemas de memória
1. Ajuste os valores de heap e pagecache conforme sua disponibilidade de RAM
2. Para desenvolvimento local, você pode reduzir os valores

### Conectividade
1. Aguarde alguns segundos após o `docker-compose up` para o Neo4j inicializar completamente
2. Use o healthcheck para verificar o status: `docker-compose ps`

## 📦 Como popular o banco de dados

### 1. Executar o script Cypher para popular o banco

Com o Neo4j rodando, execute o seguinte comando para rodar o script `Streaming.cypher` e popular o banco:

```bash
docker-compose exec neo4j cypher-shell -u neo4j -p password -f /var/lib/neo4j/import/Streaming.cypher
```

> **Dica:**
> Se o arquivo não estiver no diretório de import do container, copie-o antes:
> ```bash
> docker cp Streaming.cypher neo4j-container:/var/lib/neo4j/import/Streaming.cypher
> ```

---

## 🔍 Como consultar os dados

### Exemplo de consulta para ver quem assistiu o quê e a nota:

```cypher
MATCH (p:Person)-[:MADE_WATCH]->(w:Watched)-[:OF_TITLE]->(t)
RETURN p.nome AS Pessoa, t.nome AS Titulo, w.Rating AS Nota
```

### Exemplo de consulta para visualizar o grafo dos relacionamentos:

```cypher
MATCH (p:Person)-[r1:MADE_WATCH]->(w:Watched)-[r2:OF_TITLE]->(t)
RETURN p, r1, w, r2, t
```

Execute essas queries no Neo4j Browser (http://localhost:7474) ou via cypher-shell.

---

## 🗺️ Como exibir o schema do banco

No Neo4j Browser, execute:

```cypher
CALL db.schema.visualization()
```

Isso mostrará um diagrama com todos os tipos de nós e relacionamentos existentes no banco.

Para listar os labels e tipos de relacionamentos em texto:

```cypher
CALL db.labels();
CALL db.relationshipTypes();
```