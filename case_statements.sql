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
CASE WHEN scores.hometeam_id = 1 AND hometeam_goal > awayteam_goal THEN 'Arsenal win'
WHEN scores.awayteam_id = 1 AND awayteam_goal > hometeam_goal THEN 'Arsenal win'
END AS outcome
FROM scores
JOIN match m
ON scores.id = m.id
JOIN gameweek s
ON scores.gameweek_id = s.id
JOIN venues v
ON scores.venue_id = v.id

--Sum the total records in each gameweek where home teams won
SELECT s.name AS Gameweek,
SUM(CASE WHEN gameweek_id = 1 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_1,
SUM(CASE WHEN gameweek_id = 2 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_2,
SUM(CASE WHEN gameweek_id = 3 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_3,
SUM(CASE WHEN gameweek_id = 4 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_4,
SUM(CASE WHEN gameweek_id = 5 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_5,
SUM(CASE WHEN gameweek_id = 6 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_6,
SUM(CASE WHEN gameweek_id = 7 AND hometeam_goal > awayteam_goal THEN 1 ELSE 0 END) AS Matchday_7
FROM scores 
JOIN gameweek s
ON scores.gameweek_id = s.id
GROUP BY s.name

--Count the home wins, away wins and Draws in each Stadium
SELECT v.name AS venue,
COUNT(CASE WHEN hometeam_goal > awayteam_goal THEN s.id END) AS home_wins,
COUNT(CASE WHEN hometeam_goal < awayteam_goal THEN s.id END) AS away_wins,
COUNT(CASE WHEN hometeam_goal = awayteam_goal THEN s.id END) AS Draw
FROM scores s
JOIN venues v
ON s.venue_id = v.id
GROUP BY venue
ORDER BY home_wins DESC

