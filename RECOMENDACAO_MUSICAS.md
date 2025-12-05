# Sistema de Recomendação de Músicas - Neo4j

## 📋 Visão Geral

Este projeto implementa um sistema de recomendação de músicas usando Neo4j como banco de dados de grafos. O modelo relaciona usuários, faixas, álbuns e artistas para criar recomendações baseadas em padrões de escuta.

## 🗂️ Modelo de Dados

### Nós (Nodes)
- **User**: Ouvintes/usuários do sistema
  - `id`: Identificador único
  - `name`: Nome do usuário

- **Track**: Faixas musicais
  - `id`: ID do Spotify
  - `name`: Nome da música
  - `popularity`: Índice de popularidade (0-100)
  - `explicit`: Conteúdo explícito (true/false)

- **Album**: Álbuns
  - `name`: Nome do álbum

- **Artist**: Artistas
  - `name`: Nome do artista

### Relacionamentos (Relationships)
- `(User)-[:LISTENED]->(Track)`: Usuário ouviu uma faixa
  - `playcount`: Número de reproduções
  - `last_listen`: Data/hora da última escuta
  - `userId`: ID do usuário (para constraint)
  - `trackId`: ID da track (para constraint)

- `(Track)-[:BELONGS_TO]->(Album)`: Faixa pertence a um álbum
- `(Track)-[:PERFORMED_BY]->(Artist)`: Faixa executada por artista

## 🚀 Passo a Passo: Criação do Banco de Dados

### 1. Preparar o Ambiente

#### 1.1. Iniciar o Neo4j via Docker
```bash
docker-compose up -d
```

#### 1.2. Verificar se o container está rodando
```bash
docker ps
```

#### 1.3. Acessar o Neo4j Browser
Abra no navegador: http://localhost:7474

**Credenciais:**
- Usuário: `neo4j`
- Senha: `password`

### 2. Preparar os Arquivos CSV

#### 2.1. Copiar os CSVs para o container

```bash
# Copiar dataset de músicas do Spotify
docker cp SpotifyTracks.csv neo4j-container:/var/lib/neo4j/import/

# Copiar lista de ouvintes
docker cp Listeners.csv neo4j-container:/var/lib/neo4j/import/
```

#### 2.2. Estrutura dos CSVs

**SpotifyTracks.csv:**
- Colunas: `id`, `name`, `artists`, `album`, `popularity`, `explicit`, etc.

**Listeners.csv:**
- Colunas: `listener_id`, `listener_name`

### 3. Importar os Dados

#### 3.1. Selecionar o banco de dados correto
No Neo4j Browser, execute:
```cypher
:use neo4j
```

#### 3.2. Importar Tracks, Albums e Artists
```cypher
LOAD CSV WITH HEADERS FROM 'file:///SpotifyTracks.csv' AS row
MERGE (track:Track {id: row.id, name: row.name, popularity: toInteger(row.popularity), explicit: row.explicit})
MERGE (album:Album {name: row.album})
MERGE (artist:Artist {name: row.artists})
MERGE (track)-[:BELONGS_TO]->(album)
MERGE (track)-[:PERFORMED_BY]->(artist);
```

#### 3.3. Importar Usuários (Listeners)
```cypher
LOAD CSV WITH HEADERS FROM 'file:///Listeners.csv' AS row
MERGE (user:User {id: row.listener_id, name: row.listener_name});
```

### 4. Criar Relacionamentos de Escuta Aleatórios

#### 4.1. Criar constraint (opcional, evita duplicatas)
```cypher
CREATE CONSTRAINT listened_unique IF NOT EXISTS
FOR ()-[r:LISTENED]-() REQUIRE (r.userId, r.trackId) IS UNIQUE;
```

#### 4.2. Gerar escutas aleatórias (10 músicas por usuário)
```cypher
CALL apoc.periodic.iterate(
  "MATCH (u:User) RETURN u",
  "
  MATCH (t:Track)
  WITH u, collect(t) AS tracks
  WITH u, apoc.coll.randomItems(tracks, 10, false) AS sample
  UNWIND sample AS t
  MERGE (u)-[r:LISTENED]->(t)
    ON CREATE SET
      r.playcount   = toInteger(rand()*20) + 1,
      r.last_listen = datetime() - duration({days: toInteger(rand()*365)}),
      r.userId = u.id,
      r.trackId = t.id
  ",
  {batchSize: 50, parallel:false}
);
```

**Parâmetros ajustáveis:**
- `10`: Número de músicas aleatórias por usuário
- `rand()*20 + 1`: Playcount entre 1 e 20
- `rand()*365`: Última escuta nos últimos 365 dias

### 5. Verificar a Importação

#### 5.1. Contar nós
```cypher
MATCH (n) RETURN labels(n) AS tipo, count(n) AS total;
```

#### 5.2. Ver exemplos de escutas
```cypher
MATCH (u:User)-[r:LISTENED]->(t:Track)
RETURN u.name, t.name, r.playcount, r.last_listen
LIMIT 25;
```

#### 5.3. Álbuns com mais de 10 faixas
```cypher
MATCH (a:Album)<-[:BELONGS_TO]-(t:Track)
WITH a, count(t) AS numTracks
WHERE numTracks > 10
RETURN a.name AS album, numTracks
ORDER BY numTracks DESC
LIMIT 20;
```

## 🎯 Queries de Recomendação

### 1. Recomendar por artistas favoritos
Recomenda músicas de artistas que o usuário mais ouve, mas que ainda não foram escutadas.

```cypher
// Encontrar artistas mais ouvidos por um usuário
MATCH (u:User {name: 'Emma Wilson'})-[l:LISTENED]->(t:Track)-[:PERFORMED_BY]->(a:Artist)
WITH u, a, sum(l.playcount) AS totalPlays
ORDER BY totalPlays DESC

// Buscar outras músicas desses artistas não ouvidas ainda
MATCH (a)<-[:PERFORMED_BY]-(rec:Track)
WHERE NOT EXISTS {
  MATCH (u)-[:LISTENED]->(rec)
}
RETURN rec.name AS musica, a.name AS artista, rec.popularity
ORDER BY rec.popularity DESC
LIMIT 15;
```

### 2. Recomendar baseado em usuários similares (Filtragem Colaborativa)
Encontra músicas que usuários com gosto similar ouviram. Baseado nas top músicas favoritas do usuário.

```cypher
// Músicas favoritas do usuário (top 2)
MATCH (u:User {name: 'Mia Martin'})-[l:LISTENED]->(t:Track)
WITH u, t, l.playcount AS plays
ORDER BY plays DESC
LIMIT 2

// Outros usuários que ouviram essas músicas
MATCH (t)<-[:LISTENED]-(other:User)-[l2:LISTENED]->(rec:Track)
WHERE other <> u
  AND NOT EXISTS { MATCH (u)-[:LISTENED]->(rec) }
WITH rec, count(DISTINCT other) AS coOccurrence, avg(rec.popularity) AS avgPop
RETURN rec.name AS musica, coOccurrence AS usuarios_similares, rec.popularity
ORDER BY coOccurrence DESC, avgPop DESC
LIMIT 10;
```

### 3. Recomendar músicas com base em usuários similares (Versão Alternativa)
Identifica usuários que ouviram músicas em comum e recomenda o que eles ouviram.

```cypher
// Encontrar usuários que ouviram músicas semelhantes
MATCH (u:User {name: 'Alice Johnson'})-[:LISTENED]->(t:Track)<-[:LISTENED]-(other:User)
WHERE u <> other
WITH other, count(t) AS commonTracks
ORDER BY commonTracks DESC
LIMIT 5

// Buscar músicas que esses usuários ouviram mas você não
MATCH (other)-[:LISTENED]->(rec:Track)
WHERE NOT EXISTS {
  MATCH (u:User {name: 'Alice Johnson'})-[:LISTENED]->(rec)
}
WITH rec, count(DISTINCT other) AS score
RETURN rec.name AS musica, rec.popularity AS popularidade, score
ORDER BY score DESC, popularidade DESC
LIMIT 10;
```

### 4. Músicas populares por álbum
Lista as top 5 músicas mais populares de cada álbum.

```cypher
MATCH (a:Album)<-[:BELONGS_TO]-(t:Track)
WITH a, t
ORDER BY t.popularity DESC
RETURN a.name AS album, collect(t.name)[0..5] AS top5_tracks;
```

## 🔧 Manutenção

### Limpar todos os dados
```cypher
MATCH (n) DETACH DELETE n;
```

### Remover apenas relacionamentos de escuta
```cypher
MATCH ()-[r:LISTENED]->() DELETE r;
```

### Remover constraint
```cypher
DROP CONSTRAINT listened_unique IF EXISTS;
```

## 📊 Estatísticas do Grafo

```cypher
// Total de nós e relacionamentos
CALL apoc.meta.stats()
YIELD nodeCount, relCount, labels, relTypes
RETURN nodeCount, relCount, labels, relTypes;

// Usuários mais ativos
MATCH (u:User)-[l:LISTENED]->()
RETURN u.name AS usuario, count(l) AS total_escutas, sum(l.playcount) AS total_plays
ORDER BY total_plays DESC
LIMIT 10;

// Músicas mais ouvidas
MATCH ()-[l:LISTENED]->(t:Track)
RETURN t.name AS musica, count(l) AS ouvintes, sum(l.playcount) AS total_plays
ORDER BY total_plays DESC
LIMIT 10;
```

## 🎨 Visualização

No Neo4j Browser, use estas queries para visualizar o grafo:

```cypher
// Visualizar um usuário e suas escutas
MATCH path = (u:User {name: 'Alice Johnson'})-[:LISTENED]->(t:Track)-[:PERFORMED_BY]->(a:Artist)
RETURN path LIMIT 25;

// Visualizar um álbum completo
MATCH path = (a:Album {name: 'Hot Fuss'})<-[:BELONGS_TO]-(t:Track)-[:PERFORMED_BY]->(artist:Artist)
RETURN path;
```

## 📝 Notas

- **APOC é necessário**: As queries de recomendação usam `apoc.periodic.iterate` e `apoc.coll.randomItems`. O plugin já está configurado no `docker-compose.yml`.
- **Performance**: Para datasets muito grandes (>100k tracks), considere criar índices:
  ```cypher
  CREATE INDEX track_id IF NOT EXISTS FOR (t:Track) ON (t.id);
  CREATE INDEX user_id IF NOT EXISTS FOR (u:User) ON (u.id);
  ```
- **Banco de dados**: Execute sempre no banco `neo4j`, não no `system`.

## 🔗 Recursos

- [Neo4j Browser](http://localhost:7474)
- [Documentação Neo4j](https://neo4j.com/docs/)
- [APOC Documentation](https://neo4j.com/labs/apoc/)
- [Cypher Reference](https://neo4j.com/docs/cypher-manual/current/)
