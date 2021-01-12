--Identify home wins, losses or draw
SELECT id,
CASE WHEN hometeam_goal > awayteam_goal THEN 'Home win!'
WHEN hometeam_goal < awayteam_goal THEN 'Home loss'
ELSE 'Draw' END AS outcome
FROM scores

--Select matches where Aston Villa was away
SELECT s.id, t.name,
CASE WHEN hometeam_goal > awayteam_goal THEN 'Villa lose!'
WHEN hometeam_goal < awayteam_goal THEN 'Villa win!'
ELSE 'Draw' END AS Outcome
FROM scores s
JOIN teams t
ON s.hometeam_id = t.id
WHERE awayteam_id = 2

--Identify when Arsenal won a match since the PL Restart
SELECT m.date, s.name, v.name, 
CASE WHEN scores.hometeam_id = 1 AND hometeam_goal > awayteam_goal THEN 'Arsenal Win'
WHEN scores.awayteam_id = 1 AND awayteam_goal > hometeam_goal THEN 'Arsenal Win'
END AS outcome
FROM scores
JOIN match m
ON scores.id = m.id
JOIN gameweek g
ON scores.gameweek_id = g.id
JOIN venues v
ON scores.venue_id = g.id

--Sum the total records in each gameweek where home team won
SELECT g.name AS Gameweek,
SUM(CASE WHEN gameweek_id = 1 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_1,
SUM(CASE WHEN gameweek_id = 2 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_2,
SUM(CASE WHEN gameweek_id = 3 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_3,
SUM(CASE WHEN gameweek_id = 4 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_4,
SUM(CASE WHEN gameweek_id = 5 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_5,
SUM(CASE WHEN gameweek_id = 6 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_6,
SUM(CASE WHEN gameweek_id = 7 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_7
FROM scores 
JOIN gameweek g
ON scores.gameweek_id = g.id
GROUP BY g.name

--Count the hometeam, awayteam and Draws in each Stadium
SELECT v.name AS venue,
COUNT(CASE WHEN hometeam_goal > awayteam_goal THEN s.id END) AS home_wins,
COUNT(CASE WHEN hometeam_goal < awayteam_goal THEN s.id END) AS away_wins,
COUNT(CASE WHEN hometeam_goal = awayteam_goal THEN s.id END) AS Draw
FROM scores s
JOIN venues v
ON s.venue_id = v.id
GROUP BY venue
ORDER BY home_wins DESC
