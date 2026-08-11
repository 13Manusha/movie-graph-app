package com.moviegraph.movie_graph_app.controller;

import org.neo4j.driver.Driver;
import org.neo4j.driver.Session;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class MovieController {

    private final Driver driver;

    public MovieController(Driver driver) {
        this.driver = driver;
    }

    @GetMapping("/search")
    public Map<String, Object> searchMovie(
            @RequestParam String title) {

        try (Session session = driver.session()) {

            return session.run(
                    "MATCH (m:Movie {title: $title}) " +
                    "OPTIONAL MATCH (a:Actor)-[:ACTED_IN]->(m) " +
                    "OPTIONAL MATCH (d:Director)-[:DIRECTED]->(m) " +
                    "OPTIONAL MATCH (m)-[:IN_GENRE]->(g:Genre) " +
                    "RETURN m.title AS title, " +
                    "m.year AS year, " +
                    "collect(DISTINCT a.name) AS actors, " +
                    "collect(DISTINCT d.name) AS directors, " +
                    "collect(DISTINCT g.name) AS genres",
                    Map.of("title", title)
            ).list(record -> Map.of(
                    "title", record.get("title").isNull()
                            ? "" : record.get("title").asString(),
                    "year", record.get("year").isNull()
                            ? "" : record.get("year").asInt(),
                    "actors", record.get("actors").asList(),
                    "directors", record.get("directors").asList(),
                    "genres", record.get("genres").asList()
            )).stream().findFirst().orElse(
                    Map.of("message", "Movie not found")
            );

        } catch (Exception e) {
            return Map.of(
                    "message",
                    "Database connection error. Please try again later."
            );
        }
    }

    @GetMapping("/recommendations")
    public Object recommendations(@RequestParam String title) {

        try (Session session = driver.session()) {

            return session.run(
                    "MATCH (m:Movie {title: $title}) " +
                    "MATCH (a:Actor)-[:ACTED_IN]->(m) " +
                    "MATCH (a)-[:ACTED_IN]->(other:Movie) " +
                    "WHERE other.title <> $title " +
                    "RETURN DISTINCT other.title AS title, other.year AS year",
                    Map.of("title", title)
            ).list(record -> Map.of(
                    "title", record.get("title").asString(),
                    "year", record.get("year").asInt()
            ));

        } catch (Exception e) {
            return Map.of(
                    "message",
                    "Database connection error. Please try again later."
            );
        }
    }
    }
