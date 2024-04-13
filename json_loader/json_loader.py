
import json
import os
import psycopg2

country_ids = []
position_ids = []



def insert_sql(table, dictio):

    if (table == "countries"):
        if dictio['country_id'] in country_ids:
            return
        else:
            country_ids.append(dictio['country_id'])

    if (table == "positions"):
        if dictio['position_id'] in position_ids:
            return
        else:
            position_ids.append(dictio['position_id'])

    if (table == "50/50"):
        table = "Fiftyfifty"
    if (table == "RefereeBall-Drop"):
        table = "RefereeBall_Drop"

    keys = ', '.join(dictio.keys()).replace('from,', '"from",').replace('to,', '"to",').replace('index,', '"index",').replace('cross,', '"cross",')

    values = ""

    print(keys)
    for val in dictio.values():
        if isinstance(val, dict):
            print(val)
            val = val['name']
        if val is None:
            values += "NULL"

        elif isinstance(val, str):
            values += "'" + val.replace("'", "") + "'"

        else:
            values += str(val)

        values += ","

    values = values[:-1]

    print(table)
    cursor.execute("""INSERT INTO """ + table + """ (""" + keys + """) VALUES 
                   (""" + values + """)
                   ON CONFLICT DO NOTHING""")
    
    conn.commit()

def insert_competition(comp_data):
    insert_sql("competitions", comp_data)


def insert_match(match_data):


    for t in ["home", "away"]:
        insert_sql("countries", {'country_id': match_data[t +"_team"]["country"]["id"], 'country_name': match_data[t+"_team"]["country"]["name"]})

        insert_sql("teams", {
            'team_id' : match_data[t + "_team"][t + "_team_id"],
            'team_country_id' : match_data[t + "_team"]["country"]["id"],
            'team_name' : match_data[t + "_team"][t + "_team_name"],
            'team_gender' : match_data[t + "_team"][t + "_team_gender"],
            'team_group' : match_data[t + "_team"][t + "_team_group"]
        })

    insert_sql("stages", {
        'stage_id' : match_data["competition_stage"]["id"],
        'stage_name' : match_data["competition_stage"]["name"],
    })

    stadium_id = None
    if 'stadium' in match_data:
        stadium_id = match_data["stadium"]["id"]
        insert_sql("countries", {'country_id': match_data["stadium"]["country"]["id"], 'country_name': match_data["stadium"]["country"]["name"]})
        insert_sql("stadiums", {
            'stadium_id' : match_data["stadium"]["id"],
            'stadium_country_id' : match_data["stadium"]["country"]["id"],
            'stadium_name' : match_data["stadium"]["name"]
        })

    ref_id = None
    if 'referee' in match_data:
        ref_id = match_data["referee"]["id"]
        insert_sql("countries", {'country_id': match_data["referee"]["country"]["id"], 'country_name': match_data["referee"]["country"]["name"]})
        insert_sql("referees", {
            'ref_id' : match_data["referee"]["id"],
            'ref_country_id' : match_data["referee"]["country"]["id"],
            'ref_name' : match_data["referee"]["name"]
        })

    insert_sql("matches", {
        'match_id' : match_data["match_id"],
        'competition_id' : match_data["competition"]["competition_id"],
        'season_id' : match_data["season"]["season_id"],
        'stadium_id' : stadium_id,
        'ref_id' : ref_id,
        'stage_id' : match_data["competition_stage"]["id"],
        'home_team_id' : match_data["home_team"]["home_team_id"],
        'away_team_id' : match_data["away_team"]["away_team_id"],
        'match_date' : match_data["match_date"],
        'kick_off' : match_data["kick_off"],
        'home_score' : match_data["home_score"],
        'away_score' : match_data["away_score"],
        'match_status' : match_data["match_status"],
        'match_status_360' : match_data["match_status_360"],
        'last_updated' : match_data["last_updated"],
        'last_updated_360' :  match_data["last_updated_360"],
        'match_week' :  match_data["match_week"]
    })

    for t in ["home", "away"]:
        if "managers" in match_data[t + "_team"]:
            for manager in match_data[t + "_team"]["managers"]:
                insert_sql("countries", {'country_id': manager["country"]["id"], 'country_name': manager["country"]["name"]})
                insert_sql("managers", {
                'manager_id' : manager["id"],
                'manager_name' : manager["name"],
                'manager_nickname' : manager["nickname"],
                'dob' : manager["dob"]
            })
            insert_sql("management", {
                'match_id': match_data["match_id"],
                'team_id' : match_data[t + "_team"][t + "_team_id"],
                'manager_id' : manager["id"]
            })    


def parse_lineup(match_id, lineup_data):

    for player in lineup_data["lineup"]:
        insert_sql("countries", {'country_id': player["country"]["id"], 'country_name': player["country"]["name"]})
        insert_sql("players", {
            'player_id' : player['player_id'],
            'player_country_id' : player["country"]["id"],
            'player_name' : player['player_name'],
            'player_nickname' : player['player_nickname'],
            'jersey_number' : player['jersey_number']
        })
        
        curr_data = {'match_id': match_id, 'team_id': lineup_data['team_id'] ,'player_id': player['player_id']}

        insert_sql("linedup", curr_data)

        for card in player["cards"]:
             insert_sql("cards", {**curr_data, **card})

        for position in player["positions"]:
            insert_sql("positions", {'position_id' : position['position_id'], 'position' : position["position"]})
            del position['position']

            insert_sql("positionings", {**curr_data, **position})


def parse_event(match_id, event_data):
   # print(event_data['type'])
    
    type = event_data['type']['name'].replace(" ", "").replace("*", "")
    del event_data['type']

    
    event_data['event_id'] = event_data['id']
    del event_data['id']

    event_data['match_id'] = match_id

    event_data['possession_team_id'] = event_data['possession_team']['id']
    del event_data['possession_team']

    event_data['team_id'] =  event_data['team']['id']
    event_data['team_name'] =  event_data['team']['name']
    del event_data['team']
    

    if 'tactics' in event_data:
        return
    
    if 'related_events' in event_data:
        for e in event_data['related_events']:
            insert_sql("relatedevents", {'event_id': event_data['event_id'], 'related_event_id' : e})
        del event_data['related_events']


    if 'player' in event_data:
        event_data['player_id'] = event_data['player']['id']
        event_data['player_name'] = event_data['player']['name']
        del event_data['player']

    if 'position' in event_data:
        insert_sql("positions", {'position_id': event_data['position']['id'], 'position': event_data['position']['name']} )
        event_data['position_id'] = event_data['position']['id']
        del event_data['position']

    if 'team' in event_data:
        event_data['team_id'] = event_data['team']['id']
    
    if 'location' in event_data:
        event_data['x_location'] = event_data['location'][0]
        event_data['y_location'] = event_data['location'][1]
        del event_data['location']

    if 'outcome' in event_data:
        event_data['outcome'] = event_data['outcome']['name']
    
    if 'bad_behaviour' in event_data:
        event_data['card'] = event_data['bad_behaviour']['card']['name']
        del event_data['bad_behaviour']

    if 'carry' in event_data:
        event_data['end_x_location'] = event_data['carry']['end_location'][0]
        event_data['end_y_location'] = event_data['carry']['end_location'][1]
        del event_data['carry']

    if 'ball_receipt' in event_data:
        event_data = {**event_data, **event_data['ball_receipt']}
        del event_data['ball_receipt']

    if 'ball_recovery' in event_data:
        event_data = {**event_data, **event_data['ball_recovery']}
        del event_data['ball_recovery']

    if 'block' in event_data:
        event_data = {**event_data, **event_data['block']}
        del event_data['block']

    if 'clearance' in event_data:
        if 'aerial_won' in event_data['clearance']:
            event_data['aerial_won'] = event_data['clearance']['aerial_won']
        event_data['body_part'] = event_data['clearance']['body_part']['name']
        del event_data['clearance']

    if 'dribble' in event_data:
        event_data['outcome'] = event_data['dribble']['outcome']
        del event_data['dribble']['outcome']
        event_data = {**event_data, **event_data['dribble']}
        del event_data['dribble']

    if 'foul_committed' in event_data:
        event_data = {**event_data, **event_data['foul_committed']}
        del event_data['foul_committed']
    
    if 'foul_won' in event_data:
        event_data = {**event_data, **event_data['foul_won']}
        del event_data['foul_won']
    
    if 'half_start' in event_data:
        event_data = {**event_data, **event_data['half_start']}
        del event_data['half_start']
    
    if '50_50' in event_data:
        event_data = {**event_data, **event_data['50_50']}
        del event_data['50_50']

    if 'duel' in event_data:
        if 'counterpress' in event_data['duel']:
            event_data['counterpress'] = event_data['duel']['counterpress']
        if 'type' in event_data['duel']:
            event_data['type'] = event_data['duel']['type']['name']
        if 'outcome' in event_data['duel']:
            event_data['outcome'] = event_data['duel']['outcome']['name']
        del event_data['duel']

    if 'goalkeeper' in event_data:

        if 'end_location' in event_data['goalkeeper']:
            event_data['end_x_location'] = event_data['goalkeeper']['end_location'][0]
            event_data['end_y_location'] = event_data['goalkeeper']['end_location'][1]
            del event_data['goalkeeper']['end_location']
        
        event_data = {**event_data, **event_data['goalkeeper']}
        del event_data['goalkeeper']

    if 'interception' in event_data:
        event_data['outcome'] = event_data['interception']['outcome']['name']
        del event_data['interception']

    if 'miscontrol' in event_data:
        event_data = {**event_data, **event_data['miscontrol']}
        del event_data['miscontrol']

    if 'injury_stoppage' in event_data:
        event_data = {**event_data, **event_data['injury_stoppage']}
        del event_data['injury_stoppage']

    if 'pass' in event_data:
        if 'recipient' in event_data['pass']:
            event_data['recipient_id'] = event_data['pass']['recipient']['id']
            del event_data['pass']['recipient']
        event_data['end_x_location'] = event_data['pass']['end_location'][0]
        event_data['end_y_location'] = event_data['pass']['end_location'][1]
        del event_data['pass']['end_location']
        event_data = {**event_data,  **event_data['pass']}
        del event_data['pass']

    if 'shot' in event_data:
        event_data['end_x_location'] = event_data['shot']['end_location'][0]
        event_data['end_y_location'] = event_data['shot']['end_location'][1]
        if len(event_data['shot']['end_location']) == 3:
            event_data['end_z_location'] = event_data['shot']['end_location'][2]
        del event_data['shot']['end_location']
        if 'freeze_frame' in event_data['shot']:
            del event_data['shot']['freeze_frame']
        event_data = {**event_data,  **event_data['shot']}
        del event_data['shot']

    if 'substitution' in event_data:
        event_data['outcome'] = event_data['substitution']['outcome']
        event_data['replacement_id'] = event_data['substitution']['replacement']['id']
        del event_data['substitution']


    insert_sql(type, event_data)

    

    

conn = psycopg2.connect(
    host="localhost",
    dbname="project_database",
    user="postgres",
    password="1234",
    port=5432
)
cursor = conn.cursor()


comps = []

with open('open-data/data/competitions.json') as json_file:
    data = json.load(json_file)

    for competition in data:

        if competition["competition_name"] == 'La Liga' and ( competition["season_name"] == "2018/2019" or competition["season_name"] == "2019/2020" or competition["season_name"] == "2020/2021" ):
            comps.append([competition["competition_id"], competition["season_id"]])
            insert_competition(competition)

        if competition["competition_name"] == 'Premier League' and competition["season_name"] == "2003/2004":
            comps.append([competition["competition_id"], competition["season_id"]])
            insert_competition(competition)


matches = []

for comp in comps:
    c_id = comp[0]
    s_id = comp[1]

    with open('open-data/data/matches/' + str(c_id) + '/' + str(s_id) + '.json', 'r', encoding='utf-8') as json_file:
        data = json.load(json_file)

        for match in data:
            matches.append(match["match_id"])
            insert_match(match)


for filename in os.listdir("open-data/data/lineups"):

        fn = filename.replace(".json", "")

        if (int(fn) in matches):

            with open('open-data/data/lineups/' + fn + '.json', 'r', encoding='utf-8') as json_file:
                #print(fn)
                data = json.load(json_file)
                for lineup in data:
                    parse_lineup(int(fn), lineup)


for filename in os.listdir("open-data/data/events"):

        fn = filename.replace(".json", "")

        if (int(fn) in matches):

            with open('open-data/data/events/' + fn + '.json', 'r', encoding='utf-8') as json_file:
                data = json.load(json_file)
                progressbar = 0
                for event in data:
                    insert_sql("events", {'event_id': event['id'], 'event_type': event['type']})
                for event in data:
                    parse_event(int(fn), event)


cursor.close()
conn.close()

block = ["event_id" ,
    "match_id" ,
    "index" ,
    "period" ,
    "timestamp" ,
    "minute",
    "second" ,
    "possession" ,
    "possession_team_id" ,
    "play_pattern",
    "team_id",
    "player_id",
    "x_location",
    "y_location",
    "duration" ,
    "under_pressure",
    "off_camera",
    "out"]
