import paho.mqtt.client as mqtt
import json
import configparser
import signal

config_object = configparser.ConfigParser()
co2Pending = []
humidityPending = []
temperaturePending = []
roomPending = []

with open("config.ini", "r") as file_object:
    config_object.read_file(file_object)
    server = config_object.get("mqtt", "server")
    temp = config_object.get("mqtt", "temperature")
    humid = config_object.get("mqtt", "humidity")
    carbon = config_object.get("mqtt", "co2")
    try:
        port = int(config_object.get("mqtt", "port"))
        param = int(config_object.get("mqtt", "param"))
        delai = int(config_object.get("mqtt", "delai"))
        tempSeuil = int(config_object.get("mqtt", "seuilTemp"))
        humSeuil = int(config_object.get("mqtt", "seuilHum"))
        co2Seuil = int(config_object.get("mqtt", "seuilCO2"))
    except:
        port = 1883
        param = 60
        delai = 10
        tempSeuil = 15
        humSeuil = 80
        co2Seuil = 1000
        print("nope")
    topic = config_object.get("mqtt", "topic")

def on_connect(client, userdata, flags, rc):
    global topic
    print("Connected with result code " + str(rc))
    client.subscribe(topic)

f = open("infosCapteurs.json", "a")
with open("infosCapteurs.json", "r+") as output:
    if output.read() == "":
        output.write("{}")
        output.close()
    else:
        output.close()

f = open("Alertes.json", "a")
with open("Alertes.json", "r+") as output:
    if output.read() == "":
        output.write("{}")
        output.close()

def on_message(client, userdata, msg):
    global co2Pending
    global humidityPending
    global temperaturePending
    global roomPending

    try:
        data = json.loads(msg.payload.decode("utf-8"))
        co2 = data[0]["co2"]
        humidity = data[0]["humidity"]
        temperature = data[0]["temperature"]
        room = data[1]["room"]
    except:
        co2 = 0
        humidity = 0
        temperature = 0
        room = "undefined"

    co2Pending.append(co2)
    humidityPending.append(humidity)
    temperaturePending.append(temperature)
    roomPending.append(room)

    print("Données reçues !")

def add_infos():
    global co2Pending
    global humidityPending
    global temperaturePending
    global roomPending

    myjson = {}
    alerts_json = {}

    for i in range(len(roomPending)):
        room = roomPending[i]

        if room in myjson:
            handle_sensor_data(myjson, room, "temperature", temperaturePending[i], temp)
            handle_sensor_data(myjson, room, "humidity", humidityPending[i], humid)
            handle_sensor_data(myjson, room, "co2", co2Pending[i], carbon)
        else:
            myjson[room] = {"temperature": [], "humidity": [], "co2": []}
            handle_sensor_data(myjson, room, "temperature", temperaturePending[i], temp)
            handle_sensor_data(myjson, room, "humidity", humidityPending[i], humid)
            handle_sensor_data(myjson, room, "co2", co2Pending[i], carbon)

        if co2Seuil < co2Pending[i]:
            if room not in alerts_json:
                alerts_json[room]["messageCo2"]= []
            alerts_json[room]["messageCo2"].append("CO2 a dépassé le seuil")
        
        if humSeuil < humidityPending[i]:
            if room not in alerts_json:
                alerts_json[room]["messageHum"] = []
            alerts_json[room]["messageHum"].append("Humidité a dépassé le seuil")
        
        if tempSeuil < temperaturePending[i]:
            if room not in alerts_json:
                alerts_json[room]["messageTemp"] = []
            alerts_json[room]["messageTemp"].append("Température a dépassé le seuil")

    myjson = json.dumps(myjson, indent=4)
    with open("infosCapteurs.json", "w") as output:
        output.write(myjson)
        output.close()

    alerts_json = json.dumps(alerts_json, indent=4)
    with open("Alertes.json", "w") as alert_output:
        alert_output.write(alerts_json)
        alert_output.close()

def handle_sensor_data(myjson, room, data_type, value, check):
    if len(myjson[room][data_type]) >= 20:
        myjson[room][data_type].pop(0)
        myjson[room][data_type].append(value)
    else:
        myjson[room][data_type].append(value)

def handlerAlert(tas, pile):
    global co2Pending
    global humidityPending
    global temperaturePending
    global roomPending

    add_infos()

    co2Pending = []
    humidityPending = []
    temperaturePending = []
    roomPending = []

    signal.alarm(delai * 5)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
try:
    client.connect(server, port, param)
except:
    print("Erreur de connexion au serveur MQTT")

signal.signal(signal.SIGALRM, handlerAlert)
signal.alarm(delai * 5)

client.loop_forever()
