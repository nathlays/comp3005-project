CREATE TABLE Competitions (
    competition_id INT,
    season_id INT,
    country_name VARCHAR(255),
  	competition_name VARCHAR(255),
	competition_gender VARCHAR(255),
  	competition_youth BOOLEAN,
  	competition_international BOOLEAN,
  	season_name VARCHAR(255),
  	match_updated VARCHAR(255),
  	match_updated_360 VARCHAR(255),
  	match_available_360 VARCHAR(255),
  	match_available VARCHAR(255),
	PRIMARY KEY (competition_id, season_id)
);

CREATE TABLE Countries (
    country_id INT,
    country_name VARCHAR(255),
    PRIMARY KEY (country_id)
);

CREATE TABLE Stadiums (
    stadium_id INT,
    stadium_country_id INT,
    stadium_name VARCHAR(255),
    PRIMARY KEY (stadium_id),
    FOREIGN KEY (stadium_country_id)
        REFERENCES Countries (country_id)
);

CREATE TABLE Referees (
    ref_id INT,
    ref_country_id INT,
    ref_name VARCHAR(255),
    PRIMARY KEY (ref_id),
    FOREIGN KEY (ref_country_id)
        REFERENCES Countries (country_id)
);

CREATE TABLE Stages (
    stage_id INT,
    stage_name VARCHAR(255),
    PRIMARY KEY (stage_id)
);

CREATE TABLE Players (
    player_id INT,
    player_country_id INT,
    player_name VARCHAR(255),
    player_nickname VARCHAR(255),
    jersey_number INT,
    PRIMARY KEY (player_id),
    FOREIGN KEY (player_country_id)
        REFERENCES Countries (country_id)
);

CREATE TABLE Teams (
    team_id INT,
    team_country_id INT,
    team_name VARCHAR(255),
    team_gender VARCHAR(255),
    team_group VARCHAR(255),
    PRIMARY KEY (team_id),
    FOREIGN KEY (team_country_id)
        REFERENCES Countries (country_id)
);

CREATE TABLE Positions (
    position_id INT,
    position VARCHAR(255),
    PRIMARY KEY (position_id)
);

CREATE TABLE Managers (
    manager_id INT,
    manager_country_id INT,
    manager_name VARCHAR(255),
    manager_nickname VARCHAR(255),
    dob DATE,
    PRIMARY KEY (manager_id),
    FOREIGN KEY (manager_country_id)
        REFERENCES Countries (country_id)
);

CREATE TABLE Matches (
    match_id INT,
    competition_id INT,
    season_id INT,
    stadium_id INT,
    ref_id INT,
    stage_id INT,
    home_team_id INT,
    away_team_id INT,
    match_date DATE,
    kick_off VARCHAR(255),
    home_score INT, 
    away_score INT,
    match_status VARCHAR(255),
    match_status_360 VARCHAR(255),
    last_updated VARCHAR(255),
    last_updated_360 VARCHAR(255),
    match_week INT,
    PRIMARY KEY(match_id),
    FOREIGN KEY (competition_id, season_id)
        REFERENCES Competitions (competition_id, season_id),
    FOREIGN KEY (stadium_id)
        REFERENCES Stadiums (stadium_id),
    FOREIGN KEY (ref_id)
        REFERENCES Referees (ref_id),
    FOREIGN KEY (stage_id)
        REFERENCES Stages (stage_id),
    FOREIGN KEY (home_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (away_team_id)
        REFERENCES Teams (team_id)
);

CREATE TABLE LinedUp (
    match_id INT,
    team_id INT,
    player_id INT,
    PRIMARY KEY (match_id, team_id, player_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id)
);

CREATE TABLE Cards (
    match_id INT,
    team_id INT,
    player_id INT,
    "time" VARCHAR(255),
    card_type VARCHAR(255),
    reason VARCHAR(255),
    "period" INT,
    PRIMARY KEY (match_id, team_id, player_id),
    FOREIGN KEY (match_id, team_id, player_id)
        REFERENCES LinedUp (match_id, team_id, player_id)
);

CREATE TABLE Management (
    match_id INT,
    team_id INT,
    manager_id INT,
    PRIMARY KEY (match_id, team_id, manager_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (manager_id)
        REFERENCES Managers (manager_id)
);


CREATE TABLE Positionings (
    match_id INT,
    team_id INT,
    player_id INT,
    position_id INT,
    "from" VARCHAR(255),
    "to" VARCHAR(255),
    from_period INT,
    to_period INT,
    start_reason VARCHAR(255),
    end_reason VARCHAR(255),
    PRIMARY KEY (match_id, team_id, player_id),
    FOREIGN KEY (match_id, team_id, player_id)
        REFERENCES LinedUp (match_id, team_id, player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Events (
    event_id VARCHAR(255),
    event_type VARCHAR(255),
    PRIMARY KEY (event_id)
);

CREATE TABLE RelatedEvents (
    event_id VARCHAR(255),
    related_event_id VARCHAR(255),
    PRIMARY KEY (event_id, related_event_id),
    FOREIGN KEY (event_id)
        REFERENCES Events (event_id),
    FOREIGN KEY (related_event_id)
        REFERENCES Events (event_id)
);


CREATE TABLE HalfStart (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    late_video_start BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE BallReceipt (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    outcome VARCHAR(255),

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Carry (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    end_x_location INT, 
    end_y_location INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Duel (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    type VARCHAR(255),
    counterpress BOOLEAN,
    outcome VARCHAR(255),


    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE BallRecovery (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    offensive BOOLEAN DEFAULT FALSE,
    recovery_failure BOOLEAN DEFAULT FALSE,


    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Pressure (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    counterpress BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Miscontrol (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    aerial_won BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Block (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    offensive BOOLEAN DEFAULT FALSE,
    counterpress BOOLEAN DEFAULT FALSE,
    save_block BOOLEAN DEFAULT FALSE,
    deflection BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Interception (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    counterpress BOOLEAN DEFAULT FALSE,
    outcome VARCHAR(255),

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Clearance (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    aerial_won BOOLEAN DEFAULT FALSE,
    body_part VARCHAR(255),

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Dispossessed (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Dribble (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    overrun BOOLEAN DEFAULT FALSE,
    no_touch BOOLEAN DEFAULT FALSE,
    nutmeg BOOLEAN DEFAULT FALSE,
    outcome VARCHAR(255),

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE FoulCommitted (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    type VARCHAR(255),
    card VARCHAR(255),
    offensive BOOLEAN DEFAULT FALSE,
    advantage BOOLEAN DEFAULT FALSE,
    counterpress BOOLEAN DEFAULT FALSE,
    penalty BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE FoulWon (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    advantage BOOLEAN DEFAULT FALSE,
    defensive BOOLEAN DEFAULT FALSE,
    penalty BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE DribbledPast (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    counterpress BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE BadBehaviour (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    card VARCHAR(255),

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE HalfEnd (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Substitution (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    outcome VARCHAR(255),
    replacement_id INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id),
    FOREIGN KEY (replacement_id)
        REFERENCES Players (player_id)
);

CREATE TABLE Error (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE InjuryStoppage (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    in_chain BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Shield (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Fiftyfifty (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    counterpress BOOLEAN DEFAULT FALSE,
    outcome VARCHAR(255),

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE OwnGoalFor (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE OwnGoalAgainst (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE PlayerOff (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE PlayerOn (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE RefereeBall_Drop (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Offside (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,


    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);

CREATE TABLE Pass (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    recipient_id INT,
    switch BOOLEAN DEFAULT FALSE,
    miscommunication  BOOLEAN DEFAULT FALSE,
    length DECIMAL(10,3),
    goal_assist BOOLEAN DEFAULT FALSE,
    through_ball BOOLEAN DEFAULT FALSE,
    inswinging BOOLEAN DEFAULT FALSE,
    technique VARCHAR(255),
    height VARCHAR(255),
    angle DECIMAL(10,3),
    shot_assist BOOLEAN DEFAULT FALSE,
    aerial_won BOOLEAN DEFAULT FALSE,
    body_part VARCHAR(255),
    cut_back BOOLEAN DEFAULT FALSE,
    type VARCHAR(255),
    outswinging BOOLEAN DEFAULT FALSE,
    counterpress BOOLEAN DEFAULT FALSE,
    no_touch BOOLEAN DEFAULT FALSE,
    outcome VARCHAR(255),
    assisted_shot_id VARCHAR(255),
    "cross" BOOLEAN DEFAULT FALSE,
    end_x_location INT,
    end_y_location INT,
    deflected BOOLEAN DEFAULT FALSE,
    straight BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id),
    FOREIGN KEY (recipient_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (assisted_shot_id)
        REFERENCES Events (event_id)
);

CREATE TABLE Goalkeeper (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    shot_saved_to_post BOOLEAN DEFAULT FALSE,
    punched_out BOOLEAN DEFAULT FALSE,
    shot_saved_off_target BOOLEAN DEFAULT FALSE,
    lost_in_play BOOLEAN DEFAULT FALSE,
    technique VARCHAR(255),
    lost_out BOOLEAN DEFAULT FALSE,
    body_part VARCHAR(255),
    type VARCHAR(255),
    outcome VARCHAR(255),
    position VARCHAR(255),
    end_x_location INT,
    end_y_location INT,
    success_in_play BOOLEAN DEFAULT FALSE,


    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id)
);


CREATE TABLE Shot (
    event_id VARCHAR(255),
    match_id INT,
    "index" INT,
    "period" INT,
    "timestamp" VARCHAR(255),
    minute INT,
    second INT,
    possession INT,
    possession_team_id INT,
    play_pattern VARCHAR(255),
    team_id INT,
    team_name VARCHAR(255),player_id INT,player_name VARCHAR(255),
    x_location INT,
    y_location INT,
    duration DECIMAL(15, 6),
    under_pressure BOOLEAN DEFAULT FALSE,
    off_camera BOOLEAN,
    out BOOLEAN DEFAULT FALSE,
    position_id INT,
    saved_off_target BOOLEAN DEFAULT FALSE,
    redirect BOOLEAN DEFAULT FALSE,
    open_goal BOOLEAN DEFAULT FALSE,
    technique VARCHAR(255),
    follows_dribble BOOLEAN DEFAULT FALSE,
    saved_to_post BOOLEAN DEFAULT FALSE,
    aerial_won BOOLEAN DEFAULT FALSE,
    first_time BOOLEAN DEFAULT FALSE,
    body_part VARCHAR(255),
    type VARCHAR(255),
    outcome VARCHAR(255),
    statsbomb_xg DECIMAL(15,10),
    key_pass_id VARCHAR(255),
    end_x_location DECIMAL (10,5),
    end_y_location DECIMAL (10,5),
    end_z_location DECIMAL (10,5),
    deflected BOOLEAN DEFAULT FALSE,
    one_on_one BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (event_id),
    FOREIGN KEY (match_id)
        REFERENCES Matches (match_id),
    FOREIGN KEY (possession_team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (team_id)
        REFERENCES Teams (team_id),
    FOREIGN KEY (player_id)
        REFERENCES Players (player_id),
    FOREIGN KEY (position_id)
        REFERENCES Positions (position_id),
    FOREIGN KEY (key_pass_id)
        REFERENCES Events (event_id)
);