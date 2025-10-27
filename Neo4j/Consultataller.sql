//1 Usuarios que siguen a otros

MATCH (u:User)-[:FOLLOWS]->(f:User)
RETURN u.name AS Seguidor, f.name AS Seguido;


//2 Usuarios que invierten en empresas del sector “Inversiones”

MATCH (u:User)-[:INVESTS_IN]->(c:Company {sector:"Inversiones"})
RETURN u.name, c.name;

//3 Cantidad de inversiones por usuario
MATCH (u:User)-[:INVESTS_IN]->(c:Company)
RETURN u.name, count(c) AS NumInversiones;


//4 Usuarios que invierten en las mismas empresas

MATCH (u1:User)-[:INVESTS_IN]->(c:Company)<-[:INVESTS_IN]-(u2:User)
WHERE u1 <> u2
RETURN u1.name, u2.name, collect(DISTINCT c.name) AS Empresas;

//5 Usuarios con más seguidores
MATCH (u:User)<-[:FOLLOWS]-(f:User)
RETURN u.name, count(f) AS Seguidores
ORDER BY Seguidores DESC;


//6 Empresas con más inversores
MATCH (u:User)-[:INVESTS_IN]->(c:Company)
RETURN c.name, count(u) AS Inversores
ORDER BY Inversores DESC;


//7 Grado de conexión (centralidad) de cada usuario
MATCH (u:User)
RETURN u.name, size((u)--()) AS Conexiones;

//8 Caminos de influencia (quién sigue a quién indirectamente)
MATCH p = (u:User)-[:FOLLOWS*2..3]->(f:User)
RETURN u.name AS Influencer, f.name AS Alcanzado, length(p) AS Nivel;

//9 Usuarios que siguen a alguien que invierte en la misma empresa

MATCH (u:User)-[:FOLLOWS]->(f:User)-[:INVESTS_IN]->(c:Company)<-[:INVESTS_IN]-(u)
RETURN DISTINCT u.name, c.name;

//10 Promedio de edad de usuarios por país
MATCH (u:User)
RETURN u.country, avg(u.age) AS PromedioEdad;


//11 Recomendaciones de inversión (usuarios con inversiones similares)

MATCH (u1:User)-[:INVESTS_IN]->(c:Company)<-[:INVESTS_IN]-(u2:User)
WHERE u1 <> u2
RETURN u1.name, collect(DISTINCT u2.name) AS Recomendaciones;

//12 Empresas compartidas por al menos dos usuarios

MATCH (u:User)-[:INVESTS_IN]->(c:Company)
WITH c, count(DISTINCT u) AS num
WHERE num >= 2
RETURN c.name, num;

//13 Rango de edad de los inversores por sector

MATCH (u:User)-[:INVESTS_IN]->(c:Company)
RETURN c.sector, min(u.age) AS EdadMin, max(u.age) AS EdadMax;

//14  Usuarios con más relaciones totales (seguidores + inversiones)

MATCH (u:User)
RETURN u.name, size((u)--()) AS TotalRelaciones
ORDER BY TotalRelaciones DESC;

//15 Subgrafo de influencia e inversión (vista combinada)
MATCH p=(u:User)-[:FOLLOWS|INVESTS_IN*1..2]-(x)
RETURN p;
