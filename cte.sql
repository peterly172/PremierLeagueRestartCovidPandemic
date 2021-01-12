--Number of games per gameweek where total goals are more than / equal to 6
WITH match_list AS (
SELECT
m.id FROM scores m
WHERE (hometeam_goal + awayteam_goal) >= 6)
SELECT g.name AS gameweek, COUNT(match_list.id) AS matches
FROM scores
JOIN gameweek AS g
ON scores.gameweek_id = g.id
LEFT JOIN match_list ON scores.id = match_list.id
GROUP BY g.name
ORDER BY matches DESC

--Matches where 4 or more goals were scored
WITH match_list AS (
SELECT
scores.gameweek_id, m.date, hometeam_goal, awayteam_goal, (hometeam_goal + awayteam_goal) AS total_goals
	FROM scores
	LEFT JOIN match m ON scores.id = m.id)
SELECT gameweek_id, date, hometeam_goal, awayteam_goal FROM match_list
WHERE total_goals >= 4  

--Number of goals scored on AVG per venue in July
WITH match_list AS (
SELECT
venue_id, (hometeam_goal + awayteam_goal) AS goals
	FROM scores
	WHERE id IN (SELECT id FROM match 
				WHERE  EXTRACT(MONTH FROM date) = 07))
SELECT v.name, AVG(match_list.goals)
FROM venues v
LEFT JOIN match_list 
ON v.id = match_list.venue_id
GROUP BY v.name
ORDER BY avg DESC

--Full scoresheet using CTE
WITH home AS (
SELECT s.id, m.date, t.name AS home, s.hometeam_goal
FROM scores s
LEFT JOIN teams t
ON t.id = s.hometeam_id
LEFT JOIN match m
ON s.id = m.id),
away AS (
SELECT s.id, m.date, t.name AS away, s.awayteam_goal
FROM scores s
LEFT JOIN teams t
ON t.id = s.awayteam_id
LEFT JOIN match m
On s.id = m.id)
SELECT home.date, home.home, away.away, home.hometeam_goal, away.awayteam_goal
FROM home
JOIN away
On home.id = away.id
ORDER BY date

--Full Scoresheet for Chelsea for PL Restart
WITH home AS(
	SELECT s.id, t.name,
CASE WHEN s.hometeam_goal > s.awayteam_goal THEN 'Chelsea Win'
WHEN s.hometeam_goal < s.awayteam_goal THEN 'Chelsea Lost'
ELSE 'Draw' END AS ChelseaPL
FROM scores s
LEFT JOIN teams t
ON s.hometeam_id = t.id),
away AS (
SELECT s.id, t.name,
CASE WHEN s.hometeam_goal > s.awayteam_goal THEN 'Chelsea Lost'
WHEN s.hometeam_goal < s.awayteam_goal THEN 'Chelsea Win'
ELSE 'Draw' END AS ChelseaPL
FROM scores s
LEFT JOIN teams t
ON s.awayteam_id = t.id)
SELECT DISTINCT m.date, home.name AS home, away.name AS away, hometeam_goal, awayteam_goal
FROM scores s
JOIN match m ON s.id = m.id
JOIN home ON s.id = home.id
JOIN away ON s.id = away.id
WHERE home.name = 'Chelsea' OR away.name = 'Chelsea'
