// ============================================
// Movie Graph Explorer - Seed Data
// ============================================

// Clear existing data
// MATCH (n)
// DETACH DELETE n;

// ============================================
// Movies
// ============================================

CREATE
(inception:Movie {title: 'Inception', year: 2010}),
(titanic:Movie {title: 'Titanic', year: 1997}),
(darkKnight:Movie {title: 'The Dark Knight', year: 2008});

// ============================================
// Actors
// ============================================

CREATE
(leonardo:Actor {name: 'Leonardo DiCaprio'}),
(christian:Actor {name: 'Christian Bale'});

// ============================================
// Directors
// ============================================

CREATE
(nolan:Director {name: 'Christopher Nolan'});

// ============================================
// Genres
// ============================================

CREATE
(sciFi:Genre {name: 'Sci-Fi'}),
(action:Genre {name: 'Action'});

// ============================================
// Actor relationships
// ============================================

CREATE
(leonardo)-[:ACTED_IN]->(inception),
(leonardo)-[:ACTED_IN]->(titanic),
(christian)-[:ACTED_IN]->(darkKnight),
(christian)-[:ACTED_IN]->(inception);

// ============================================
// Director relationships
// ============================================

CREATE
(nolan)-[:DIRECTED]->(inception),
(nolan)-[:DIRECTED]->(darkKnight);

// ============================================
// Genre relationships
// ============================================

CREATE
(inception)-[:IN_GENRE]->(sciFi),
(darkKnight)-[:IN_GENRE]->(action);