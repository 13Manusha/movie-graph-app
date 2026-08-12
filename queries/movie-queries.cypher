// 1. Find a movie by title
MATCH (m:Movie {title: $title})
RETURN m.title AS title, m.year AS year;


// 2. Find actors in a movie
MATCH (a:Actor)-[:ACTED_IN]->(m:Movie {title: $title})
RETURN a.name AS actor, m.title AS movie;


// 3. Find the director of a movie
MATCH (d:Director)-[:DIRECTED]->(m:Movie {title: $title})
RETURN d.name AS director, m.title AS movie;


// 4. Find the genres of a movie
MATCH (m:Movie {title: $title})-[:IN_GENRE]->(g:Genre)
RETURN m.title AS movie, g.name AS genre;


// 5. Multi-hop recommendation query
// Movie → Actor → Another Movie
MATCH (m:Movie {title: $title})
MATCH (a:Actor)-[:ACTED_IN]->(m)
MATCH (a)-[:ACTED_IN]->(other:Movie)
WHERE other.title <> $title
RETURN DISTINCT other.title AS title, other.year AS year;

/// 6. Find movies connected through a shared actor
MATCH (m1:Movie)<-[:ACTED_IN]-(a:Actor)-[:ACTED_IN]->(m2:Movie)
WHERE m1.title <> m2.title
RETURN DISTINCT
    m1.title AS movie1,
    a.name AS sharedActor,
    m2.title AS movie2;