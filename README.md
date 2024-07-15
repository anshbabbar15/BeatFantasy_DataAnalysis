# BeatFantasy_DataAnalysis

## Instructions

To execute the SQL queries, follow these steps:

1. Set up a PostgreSQL database.
2. Create the tables using the provided schema.
3. Insert the sample data.
4. Execute the queries from the `queries.sql` file.

## Schema

```sql
CREATE TABLE user_teams (
    user_name VARCHAR(255),
    user_team VARCHAR(255),
    player1_captain VARCHAR(255),
    player2_vice_captain VARCHAR(255),
    player3 VARCHAR(255),
    player4 VARCHAR(255),
    player5 VARCHAR(255),
    player6 VARCHAR(255),
    player7 VARCHAR(255),
    player8 VARCHAR(255),
    player9 VARCHAR(255),
    player10 VARCHAR(255),
    player11 VARCHAR(255)
);

CREATE TABLE player_points (
    player_id SERIAL PRIMARY KEY,
    player_name VARCHAR(255),
    team_name VARCHAR(255),
    player_pos VARCHAR(50),
    player_points INTEGER,
    sel_percent DECIMAL(5, 2),
    c_percent DECIMAL(5, 2),
    vc_percent DECIMAL(5, 2)
);
```
