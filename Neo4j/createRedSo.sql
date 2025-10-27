// Crear restricciones
CREATE CONSTRAINT FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT FOR (c:Company) REQUIRE c.id IS UNIQUE;

// Cargar usuarios
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/jathinson/jathinson/refs/heads/master/Neo4j/users.csv' AS row
CREATE (:User {id: toInteger(row.id), name: row.name, age: toInteger(row.age), country: row.country});

// Cargar empresas
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/jathinson/jathinson/refs/heads/master/Neo4j/companies.csv' AS row
CREATE (:Company {id: toInteger(row.id), name: row.name, sector: row.sector});

// Cargar relaciones
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/jathinson/jathinson/refs/heads/master/Neo4j/relationships.csv' AS row
MATCH (a:User {id: toInteger(row.from)})
OPTIONAL MATCH (b:User {id: toInteger(row.to)})
OPTIONAL MATCH (c:Company {id: toInteger(row.to)})
FOREACH(_ IN CASE WHEN b IS NOT NULL THEN [1] ELSE [] END |
    CREATE (a)-[:FOLLOWS]->(b))
FOREACH(_ IN CASE WHEN c IS NOT NULL THEN [1] ELSE [] END |
    CREATE (a)-[:INVESTS_IN]->(c));
