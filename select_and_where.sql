-- Scores from the first matchday
SELECT * FROM scores
WHERE gameweek_id = 1

-- Scores from first 4 gameweeks
SELECT * FROM scores
WHERE gameweek_id BETWEEN 1 AND 4

-- Scores that took place at Etihad Stadium
SELECT * FROM scores
WHERE venue_id= 11

--Matches that took place within the last game of the season
SELECT * FROM match
WHERE gameweek_id = 9
