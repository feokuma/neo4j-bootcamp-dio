LOAD CSV WITH HEADERS FROM 'file:///SpotifyTracks.csv' AS row
MERGE (track:Track {id: row.id, name: row.name, popularity: toInteger(row.popularity), explicit: row.explicit})
MERGE (album:Album {name: row.album})
MERGE (artist:Artist {name: row.artists})
MERGE (track)-[:BELONGS_TO]->(album)
MERGE (track)-[:PERFORMED_BY]->(artist);

LOAD CSV WITH HEADERS FROM 'file:///Listeners.csv' AS row
MERGE (user:User {id: row.listener_id, name: row.listener_name})

CREATE CONSTRAINT listened_unique IF NOT EXISTS
FOR ()-[r:LISTENED]-() REQUIRE (r.userId, r.trackId) IS UNIQUE;

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


// Recomendação de músicas para o usuário 'Emma Wilson'
MATCH (u:User {name: 'Emma Wilson'})-[l:LISTENED]->(t:Track)-[:PERFORMED_BY]->(a:Artist)
WITH u, a, sum(l.playcount) AS totalPlays
ORDER BY totalPlays DESC
// Outras músicas desses artistas
MATCH (a)<-[:PERFORMED_BY]-(rec:Track)
WHERE NOT EXISTS {
  MATCH (u)-[:LISTENED]->(rec)
}
RETURN rec.name AS musica, a.name AS artista, rec.popularity
ORDER BY rec.popularity DESC
LIMIT 15;



// Recomendação baseada em usuários similares
// Músicas favoritas do usuário (top 3)
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

MATCH path = (u:User)-[:LISTENED]->(t:Track)-[:PERFORMED_BY]->(a:Artist)
RETURN path LIMIT 80;