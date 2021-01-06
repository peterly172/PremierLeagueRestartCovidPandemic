-- Number of matches since the PL restart
SELECT COUNT(id) AS total_matches
FROM scores

-- Number of matches taken place each stadium
SELECT v.name, COUNT(*) AS matches
FROM scores
JOIN venues AS v
ON scores.venue_id = v.id
GROUP BY v.name
ORDER BY matches DESC

--  Number of matches per gameweek
SELECT gameweek.name, COUNT(*) AS matches
FROM scores
JOIN gameweek 
ON scores.gameweek_id = gameweek.id
GROUP BY gameweek.name
ORDER BY matches DESC, gameweek.name

--What times do Southampton play and how many times?
SELECT time, COUNT(*)
FROM match
WHERE hometeam_id = 16
OR awayteam_id = 16
GROUP BY time
ORDER BY COUNT(*)

-- Number of goals scored at the PL restart
SELECT SUM(hometeam_goal + awayteam_goal)
FROM scores

--  Number of goals scored in each round

SELECT gameweek.name, SUM(hometeam_goal + awayteam_goal) AS total_goals
FROM scores
JOIN gameweek
ON scores.gameweek_id = gameweek.id
GROUP BY gameweek.name 
ORDER BY total_goals DESC, gameweek.name

--Number of goals scored in each stadium
SELECT venues.name, SUM(hometeam_goal + awayteam_goal) AS total_goals
FROM scores
JOIN venues
ON scores.venue_id = venues.id
GROUP BY venues.name 
ORDER BY total_goals DESC

--Number of goals scored in each stadium capacity less than 40,000 capacity
SELECT venues.name, SUM(hometeam_goal + awayteam_goal) AS total_goals
FROM scores
JOIN venues
ON scores.venue_id = venues.id
WHERE capacity < 40000
GROUP BY venues.name 
ORDER BY total_goals DESC

--Number of goals scored in each stadium capacity of more than 40,000
SELECT venues.name, SUM(hometeam_goal + awayteam_goal) AS total_goals
FROM scores
JOIN venues
ON scores.venue_id = venues.id
WHERE capacity BETWEEN > 40000
GROUP BY venues.name 
ORDER BY total_goals DESC

-- Maximum number of goals scored in a single match at the PL Restart
SELECT MAX(hometeam_goal + awayteam_goal) FROM scores

--Maximum number of goals scored in a match per round
SELECT gameweek.name, MAX(hometeam_goal + awayteam_goal) AS max_goals
FROM scores
JOIN gameweek 
ON scores.venue_id = gameweek.id
GROUP BY gameweek.name
ORDER BY max_goals DESC, gameweek.name

--Maximum number of goals scored in a match per stadium
SELECT venues.name, MAX(hometeam_goal + awayteam_goal) AS max_goals
FROM scores
JOIN venues 
ON scores.venue_id = venues.id
GROUP BY venues.name
ORDER BY max_goals DESC

-- List of matches in full
SELECT m.id, date, time, s.name AS Round, v.name AS Venue, t1.name AS TeamA, t2.name AS TeamB
FROM match AS m
JOIN gameweek AS s
ON m.gameweek_id = s.id
JOIN venues AS v
ON m.venue_id = v.id
JOIN teams AS t1
ON m.hometeam_id = t1.id
JOIN teams AS t2
ON m.awayteam_id = t2.id
ORDER BY m.id

-- List of scores in full
SELECT m.id, s.name AS Round, v.name AS Venue, t1.name AS TeamA, t2.name AS TeamB, hometeam_goal, awayteam_goal
FROM scores AS m
JOIN gameweek AS s
ON m.gameweek_id = s.id
JOIN venues AS v
ON m.venue_id = v.id
JOIN teams AS t1
ON m.hometeam_id = t1.id
JOIN teams AS t2
ON m.awayteam_id = t2.id
ORDER BY m.id

--Displaying all matches and venues
SELECT gameweek_id, venue_id, hometeam_id, awayteam_id
FROM match
UNION 
SELECT gameweek_id, venue_id, hometeam_id, awayteam_id
FROM scores
ORDER BY gameweek_id, venue_id
 
SELECT gameweek_id, venue_id, hometeam_id, awayteam_id
FROM match
UNION ALL
SELECT gameweek_id, venue_id, hometeam_id, awayteam_id
FROM scores
ORDER BY gameweek_id, venue_id
