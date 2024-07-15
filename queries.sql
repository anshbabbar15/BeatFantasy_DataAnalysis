--What were the top 10 user teams in the match and what were their respective ranks?
WITH team_points AS (
    SELECT
        ut.user_name,
        ut.user_team,
        SUM(
            CASE WHEN pp.player_name = ut.player1_captain THEN pp.player_points * 2 ELSE 0 END +
            CASE WHEN pp.player_name = ut.player2_vice_captain THEN pp.player_points * 1.5 ELSE 0 END +
            CASE WHEN pp.player_name = ut.player3 THEN pp.player_points ELSE 0 END +
            CASE WHEN pp.player_name = ut.player4 THEN pp.player_points ELSE 0 END +
            CASE WHEN pp.player_name = ut.player5 THEN pp.player_points ELSE 0 END +
            CASE WHEN pp.player_name = ut.player6 THEN pp.player_points ELSE 0 END +
            CASE WHEN pp.player_name = ut.player7 THEN pp.player_points ELSE 0 END +
            CASE WHEN pp.player_name = ut.player8 THEN pp.player_points ELSE 0 END +
            CASE WHEN pp.player_name = ut.player9 THEN pp.player_points ELSE 0 END +
            CASE WHEN pp.player_name = ut.player10 THEN pp.player_points ELSE 0 END +
            CASE WHEN pp.player_name = ut.player11 THEN pp.player_points ELSE 0 END
        ) AS total_points
    FROM
        user_teams ut
    LEFT JOIN player_points pp 
    ON pp.player_name IN (ut.player1_captain, ut.player2_vice_captain, ut.player3, ut.player4, ut.player5, ut.player6, ut.player7, ut.player8, ut.player9, ut.player10, ut.player11)
    GROUP BY
        ut.user_name,
        ut.user_team
)
SELECT
    user_name,
    user_team,
    total_points,
    RANK() OVER (ORDER BY total_points DESC) AS rank
FROM
    team_points
ORDER BY
    rank
LIMIT 10;


--What was the average number of teams created by a user?
SELECT 
    AVG(team_count) AS average_teams_per_user
FROM (
    SELECT
        user_name,
        COUNT(user_team) AS team_count
    FROM
        user_teams
    GROUP BY
        user_name
) AS user_team_counts;


--What percentage of users created 1 team, 2 teams, 3 teams, ..., up to 20 teams?
WITH user_team_counts AS (
    SELECT
        user_name,
        COUNT(user_team) AS team_count
    FROM
        user_teams
    GROUP BY
        user_name
),
team_distribution AS (
    SELECT
        team_count,
        COUNT(user_name) AS user_count
    FROM
        user_team_counts
    GROUP BY
        team_count
)
SELECT
    team_count,
    user_count,
    (user_count::FLOAT / (SELECT COUNT(DISTINCT user_name) FROM user_teams) * 100) AS percentage
FROM
    team_distribution
WHERE
    team_count <= 20
ORDER BY
    team_count;


--What percentage of teams had captains by positions - GK, DEF, MID, ST?
WITH captain_positions AS (
    SELECT
        ut.user_team,
        pp.player_pos AS captain_position
    FROM
        user_teams ut
    LEFT JOIN
        player_points pp ON ut.player1_captain = pp.player_name
),
position_counts AS (
    SELECT
        captain_position,
        COUNT(*) AS team_count
    FROM
        captain_positions
    GROUP BY
        captain_position
),
total_teams AS (
    SELECT
        COUNT(*) AS total_team_count
    FROM
        user_teams
)
SELECT
    pc.captain_position,
    pc.team_count,
    (pc.team_count::FLOAT / tt.total_team_count * 100) AS percentage
FROM
    position_counts pc,
    total_teams tt
WHERE
    pc.captain_position IN ('GK', 'DEF', 'MID', 'ST')
ORDER BY
    pc.captain_position;
	
	
--What percentage of teams had vice captains by team - ALK, PSV
WITH vice_captain_teams AS (
    SELECT
        ut.user_team,
        pp.team_name AS vice_captain_team
    FROM
        user_teams ut
    LEFT JOIN
        player_points pp ON ut.player2_vice_captain = pp.player_name
),
team_counts AS (
    SELECT
        vice_captain_team,
        COUNT(*) AS team_count
    FROM
        vice_captain_teams
    GROUP BY
        vice_captain_team
),
total_teams AS (
    SELECT
        COUNT(*) AS total_team_count
    FROM
        user_teams
)
SELECT
    tc.vice_captain_team,
    tc.team_count,
    (tc.team_count::FLOAT / tt.total_team_count * 100) AS percentage
FROM
    team_counts tc,
    total_teams tt
WHERE
    tc.vice_captain_team IN ('ALK', 'PSV')
ORDER BY
    tc.vice_captain_team;
