--Scorelist with the AVG
SELECT sc.id, v.name AS venue, st.name AS gameweek, sc.hometeam_goal, awayteam_goal,
AVG(hometeam_goal + awayteam_goal) OVER() AS overall_avg
FROM scores sc
JOIN venues v ON sc.venue_id = v.id
JOIN gameweek st ON sc.gameweek_id = st.id

--Venue ranking on Average goals
SELECT v.name AS venue,
ROUND(AVG(hometeam_goal + awayteam_goal), 2) AS avg_goals,
RANK() OVER(ORDER BY AVG(hometeam_goal + awayteam_goal)DESC) AS venue_rank
FROM venues v
JOIN scores ON v.id = scores.venue_id
GROUP BY v.name
ORDER BY venue_rank

--Gameweek ranking on Average goals
SELECT s.name AS gameweek,
ROUND(AVG(hometeam_goal + awayteam_goal), 2) AS avg_goals,
RANK() OVER(ORDER BY AVG(hometeam_goal + awayteam_goal)DESC) AS gameweek_rank
FROM gameweek s
JOIN scores ON s.id = scores.gameweek_id
GROUP BY s.name
ORDER BY gameweek_rank

--Partitioning by a column
SELECT m.date, scores.venue_id, scores.hometeam_goal, scores.awayteam_goal,
CASE WHEN scores.hometeam_id = 1 THEN 'home' ELSE 'away' END AS Arsenal,
AVG(hometeam_goal) OVER(PARTITION BY scores.venue_id) AS homeavg,
AVG(awayteam_goal) OVER(PARTITION BY scores.venue_id) AS awayavg
FROM scores
JOIN match m ON scores.id = m.id
JOIN gameweek s ON scores.gameweek_id = s.id
WHERE scores.hometeam_id = 1
OR scores.awayteam_id = 1
ORDER BY(hometeam_goal + awayteam_goal) DESC

--Assessing Running total of goals and AVG from Liverpool when they are home
SELECT m.date, scores.venue_id, scores.hometeam_goal, scores.awayteam_goal,
CASE WHEN scores.hometeam_id = 10 THEN 'home' ELSE 'away' END AS Liverpool,
AVG(hometeam_goal) OVER(PARTITION BY scores.venue_id) AS homeavg,
AVG(awayteam_goal) OVER(PARTITION BY scores.venue_id) AS awayavg
FROM scores
JOIN match m ON scores.id = m.id
JOIN gameweek s ON scores.gameweek_id = s.id
WHERE scores.hometeam_id = 10
OR scores.awayteam_id = 10
ORDER BY(hometeam_goal + awayteam_goal) DESC



