// =====================
// Grupo: A Origem
// =====================
MERGE (AOrigem:Movie {nome: 'A Origem'})
MERGE (Acao:Genre {nome: 'Ação'})
MERGE (FiccaoCientifica:Genre {nome: 'Ficção Científica'})
MERGE (ChristopherNolan:Person {nome: 'Christopher Nolan'})
MERGE (LeonardoDiCaprio:Person {nome: 'Leonardo DiCaprio'})
MERGE (EllenPage:Person {nome: 'Elliot Page'})
MERGE (AOrigem)-[:HAS_GENRE]->(Acao)
MERGE (AOrigem)-[:HAS_GENRE]->(FiccaoCientifica)
MERGE (ChristopherNolan)-[:DIRECTED]->(AOrigem)
MERGE (LeonardoDiCaprio)-[:ACTED_IN]->(AOrigem)
MERGE (EllenPage)-[:ACTED_IN]->(AOrigem)

// =====================
// Grupo: Matrix
// =====================
MERGE (Matrix:Movie {nome: 'Matrix'})
MERGE (Acao2:Genre {nome: 'Ação'})
MERGE (FiccaoCientifica2:Genre {nome: 'Ficção Científica'})
MERGE (LanaWachowski:Person {nome: 'Lana Wachowski'})
MERGE (LillyWachowski:Person {nome: 'Lilly Wachowski'})
MERGE (KeanuReeves:Person {nome: 'Keanu Reeves'})
MERGE (CarrieAnneMoss:Person {nome: 'Carrie-Anne Moss'})
MERGE (Matrix)-[:HAS_GENRE]->(Acao2)
MERGE (Matrix)-[:HAS_GENRE]->(FiccaoCientifica2)
MERGE (LanaWachowski)-[:DIRECTED]->(Matrix)
MERGE (LillyWachowski)-[:DIRECTED]->(Matrix)
MERGE (KeanuReeves)-[:ACTED_IN]->(Matrix)
MERGE (CarrieAnneMoss)-[:ACTED_IN]->(Matrix)

// =====================
// Grupo: Interestelar
// =====================
MERGE (Interestelar:Movie {nome: 'Interestelar'})
MERGE (FiccaoCientifica3:Genre {nome: 'Ficção Científica'})
MERGE (Drama:Genre {nome: 'Drama'})
MERGE (ChristopherNolan2:Person {nome: 'Christopher Nolan'})
MERGE (MatthewMcConaughey:Person {nome: 'Matthew McConaughey'})
MERGE (AnneHathaway:Person {nome: 'Anne Hathaway'})
MERGE (Interestelar)-[:HAS_GENRE]->(FiccaoCientifica3)
MERGE (Interestelar)-[:HAS_GENRE]->(Drama)
MERGE (ChristopherNolan2)-[:DIRECTED]->(Interestelar)
MERGE (MatthewMcConaughey)-[:ACTED_IN]->(Interestelar)
MERGE (AnneHathaway)-[:ACTED_IN]->(Interestelar)

// =====================
// Grupo: O Poderoso Chefão
// =====================
MERGE (OPoderosoChefao:Movie {nome: 'O Poderoso Chefão'})
MERGE (Crime:Genre {nome: 'Crime'})
MERGE (Drama2:Genre {nome: 'Drama'})
MERGE (FrancisFordCoppola:Person {nome: 'Francis Ford Coppola'})
MERGE (MarlonBrando:Person {nome: 'Marlon Brando'})
MERGE (AlPacino:Person {nome: 'Al Pacino'})
MERGE (OPoderosoChefao)-[:HAS_GENRE]->(Crime)
MERGE (OPoderosoChefao)-[:HAS_GENRE]->(Drama2)
MERGE (FrancisFordCoppola)-[:DIRECTED]->(OPoderosoChefao)
MERGE (MarlonBrando)-[:ACTED_IN]->(OPoderosoChefao)
MERGE (AlPacino)-[:ACTED_IN]->(OPoderosoChefao)

// =====================
// Grupo: Clube da Luta
// =====================
MERGE (ClubeDaLuta:Movie {nome: 'Clube da Luta'})
MERGE (Drama3:Genre {nome: 'Drama'})
MERGE (Suspense:Genre {nome: 'Suspense'})
MERGE (DavidFincher:Person {nome: 'David Fincher'})
MERGE (EdwardNorton:Person {nome: 'Edward Norton'})
MERGE (BradPitt:Person {nome: 'Brad Pitt'})
MERGE (ClubeDaLuta)-[:HAS_GENRE]->(Drama3)
MERGE (ClubeDaLuta)-[:HAS_GENRE]->(Suspense)
MERGE (DavidFincher)-[:DIRECTED]->(ClubeDaLuta)
MERGE (EdwardNorton)-[:ACTED_IN]->(ClubeDaLuta)
MERGE (BradPitt)-[:ACTED_IN]->(ClubeDaLuta)

// =====================
// Grupo: Breaking Bad
// =====================
MERGE (BreakingBad:Serie {nome: 'Breaking Bad'})
MERGE (Crime2:Genre {nome: 'Crime'})
MERGE (Drama4:Genre {nome: 'Drama'})
MERGE (VinceGilligan:Person {nome: 'Vince Gilligan'})
MERGE (BryanCranston:Person {nome: 'Bryan Cranston'})
MERGE (AaronPaul:Person {nome: 'Aaron Paul'})
MERGE (BreakingBad)-[:HAS_GENRE]->(Crime2)
MERGE (BreakingBad)-[:HAS_GENRE]->(Drama4)
MERGE (VinceGilligan)-[:DIRECTED]->(BreakingBad)
MERGE (BryanCranston)-[:ACTED_IN]->(BreakingBad)
MERGE (AaronPaul)-[:ACTED_IN]->(BreakingBad)

// =====================
// Grupo: Stranger Things
// =====================
MERGE (StrangerThings:Serie {nome: 'Stranger Things'})
MERGE (FiccaoCientifica4:Genre {nome: 'Ficção Científica'})
MERGE (Fantasia:Genre {nome: 'Fantasia'})
MERGE (TheDufferBrothers:Person {nome: 'The Duffer Brothers'})
MERGE (MillieBobbyBrown:Person {nome: 'Millie Bobby Brown'})
MERGE (DavidHarbour:Person {nome: 'David Harbour'})
MERGE (StrangerThings)-[:HAS_GENRE]->(FiccaoCientifica4)
MERGE (StrangerThings)-[:HAS_GENRE]->(Fantasia)
MERGE (TheDufferBrothers)-[:DIRECTED]->(StrangerThings)
MERGE (MillieBobbyBrown)-[:ACTED_IN]->(StrangerThings)
MERGE (DavidHarbour)-[:ACTED_IN]->(StrangerThings)

// =====================
// Grupo: Game of Thrones
// =====================
MERGE (GameOfThrones:Serie {nome: 'Game of Thrones'})
MERGE (Fantasia2:Genre {nome: 'Fantasia'})
MERGE (Drama5:Genre {nome: 'Drama'})
MERGE (DavidBenioff:Person {nome: 'David Benioff'})
MERGE (DBWeiss:Person {nome: 'D. B. Weiss'})
MERGE (EmiliaClarke:Person {nome: 'Emilia Clarke'})
MERGE (KitHarington:Person {nome: 'Kit Harington'})
MERGE (GameOfThrones)-[:HAS_GENRE]->(Fantasia2)
MERGE (GameOfThrones)-[:HAS_GENRE]->(Drama5)
MERGE (DavidBenioff)-[:DIRECTED]->(GameOfThrones)
MERGE (DBWeiss)-[:DIRECTED]->(GameOfThrones)
MERGE (EmiliaClarke)-[:ACTED_IN]->(GameOfThrones)
MERGE (KitHarington)-[:ACTED_IN]->(GameOfThrones)

// =====================
// Grupo: La Casa de Papel
// =====================
MERGE (LaCasaDePapel:Serie {nome: 'La Casa de Papel'})
MERGE (Roubo:Genre {nome: 'Roubo'})
MERGE (Suspense2:Genre {nome: 'Suspense'})
MERGE (AlexPina:Person {nome: 'Álex Pina'})
MERGE (UrsulaCorbero:Person {nome: 'Úrsula Corberó'})
MERGE (AlvaroMorte:Person {nome: 'Álvaro Morte'})
MERGE (LaCasaDePapel)-[:HAS_GENRE]->(Roubo)
MERGE (LaCasaDePapel)-[:HAS_GENRE]->(Suspense2)
MERGE (AlexPina)-[:DIRECTED]->(LaCasaDePapel)
MERGE (UrsulaCorbero)-[:ACTED_IN]->(LaCasaDePapel)
MERGE (AlvaroMorte)-[:ACTED_IN]->(LaCasaDePapel)

// =====================
// Grupo: The Office
// =====================
MERGE (TheOffice:Serie {nome: 'The Office'})
MERGE (Comedia:Genre {nome: 'Comédia'})
MERGE (GregDaniels:Person {nome: 'Greg Daniels'})
MERGE (SteveCarell:Person {nome: 'Steve Carell'})
MERGE (RainnWilson:Person {nome: 'Rainn Wilson'})
MERGE (TheOffice)-[:HAS_GENRE]->(Comedia)
MERGE (GregDaniels)-[:DIRECTED]->(TheOffice)
MERGE (SteveCarell)-[:ACTED_IN]->(TheOffice)
MERGE (RainnWilson)-[:ACTED_IN]->(TheOffice)

// =====================
// Grupo: Pessoas que assistiram
// =====================

MERGE (AnaSouza:Person {nome: 'AnaSouza'})
MERGE (CarlosSilva:Person {nome: 'CarlosSilva'})
MERGE (MarianaLima:Person {nome: 'MarianaLima'})
MERGE (JoaoPedro:Person {nome: 'JoaoPedro'})
MERGE (FernandaAlves:Person {nome: 'FernandaAlves'})
MERGE (LucasRocha:Person {nome: 'LucasRocha'})
MERGE (PatriciaGomes:Person {nome: 'PatriciaGomes'})
MERGE (RicardoMartins:Person {nome: 'RicardoMartins'})
MERGE (JulianaCosta:Person {nome: 'JulianaCosta'})
MERGE (GabrielFerreira:Person {nome: 'GabrielFerreira'})

// Relacionamentos de assistidos
MERGE (AnaSouza)-[:MADE_WATCH]->(:Watched {Rating: 9})-[:OF_TITLE]->(AOrigem)
MERGE (AnaSouza)-[:MADE_WATCH]->(:Watched {Rating: 9})-[:OF_TITLE]->(Matrix)
MERGE (CarlosSilva)-[:MADE_WATCH]->(:Watched {Rating: 8})-[:OF_TITLE]->(Matrix)
MERGE (MarianaLima)-[:MADE_WATCH]->(:Watched {Rating: 10})-[:OF_TITLE]->(Interestelar)
MERGE (JoaoPedro)-[:MADE_WATCH]->(:Watched {Rating: 7})-[:OF_TITLE]->(OPoderosoChefao)
MERGE (JoaoPedro)-[:MADE_WATCH]->(:Watched {Rating: 7})-[:OF_TITLE]->(TheOffice)
MERGE (FernandaAlves)-[:MADE_WATCH]->(:Watched {Rating: 8})-[:OF_TITLE]->(ClubeDaLuta)
MERGE (LucasRocha)-[:MADE_WATCH]->(:Watched {Rating: 9})-[:OF_TITLE]->(BreakingBad)
MERGE (PatriciaGomes)-[:MADE_WATCH]->(:Watched {Rating: 8})-[:OF_TITLE]->(StrangerThings)
MERGE (RicardoMartins)-[:MADE_WATCH]->(:Watched {Rating: 7})-[:OF_TITLE]->(GameOfThrones)
MERGE (JulianaCosta)-[:MADE_WATCH]->(:Watched {Rating: 9})-[:OF_TITLE]->(LaCasaDePapel)
MERGE (GabrielFerreira)-[:MADE_WATCH]->(:Watched {Rating: 10})-[:OF_TITLE]->(TheOffice)

// Consulta exemplo: Pessoas e as notas que deram aos títulos que assistiram
WITH *
MATCH (p:Person)-[r1:MADE_WATCH]->(w:Watched)-[r2:OF_TITLE]->(t)
RETURN p, r1, w, r2, t