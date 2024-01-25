import paho.mqtt.client as mqtt
import json
import configparser
import signal
from datetime import datetime

# Décalaration et initialisation de variables

print("python starts")

config_object = configparser.ConfigParser()
co2Pending = []
humidityPending = []
temperaturePending = []
roomPending = []

#Récupération des données du fichier config.ini
fd = open("config.ini", "r")
with fd:
    config_object.read_file(fd)
    server = config_object.get("mqtt", "server")
    temp = config_object.get("mqtt", "temperature")
    humid = config_object.get("mqtt", "humidity")
    carbon = config_object.get("mqtt", "co2")
    nomFichier = config_object.get("mqtt", "nomFichier")
    try:
        port = int(config_object.get("mqtt", "port"))
        param = int(config_object.get("mqtt", "param"))
        delai = int(config_object.get("mqtt", "delai"))
        tempSeuil = int(config_object.get("mqtt", "seuilTemp"))
        humSeuil = int(config_object.get("mqtt", "seuilHum"))
        co2Seuil = int(config_object.get("mqtt", "seuilCO2"))
    except ValueError:
        port = 1883
        param = 60
        delai = 1
        tempSeuil = 15
        humSeuil = 80
        co2Seuil = 1000

    salles = config_object.get("mqtt", "topic").split(",")

# Fonction de connexion au broker MQTT
def on_connect(client, userdata, flags, rc):
    global salles
    print("Connected with result code " + str(rc))
    print(salles)  
    for topic in salles:
      client.subscribe("AM107/by-room/"+topic+"/data")
    # Abonnement à toutes les salles (pour démonstration)
    # client.subscribe("AM107/by-room/+/data")

# Chargement des données des fichiers JSON
fichier = nomFichier + ".json"
try:
    with open(fichier, "r") as json_file:
        myjson = json.load(json_file)
except (FileNotFoundError, json.JSONDecodeError):
    myjson = {}

alert_file_name = "alertes.json"
try:
    with open(alert_file_name, "r") as alert_file:
        myalert = json.load(alert_file)
except (FileNotFoundError, json.JSONDecodeError):
    myalert = {}

# Fonction de création de fichier JSON vide
def create_empty_json_file(file_path):
    with open(file_path, "w") as empty_file:
        json.dump({}, empty_file)

# Create empty JSON files if they don't exist
create_empty_json_file(fichier)
create_empty_json_file(alert_file_name)

# Fonction de réception des données
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
    except (json.JSONDecodeError, KeyError, IndexError):
        co2 = 0
        humidity = 0
        temperature = 0
        room = "undefined"

    co2Pending.append(co2)
    humidityPending.append(humidity)
    temperaturePending.append(temperature)
    roomPending.append(room)

    print("Données reçues !")

# Fonction d'ajout des données dans le fichier JSON
def add_infos():
    global co2Pending
    global humidityPending
    global temperaturePending
    global roomPending
    global myjson
    global myalert

    if len(roomPending) > 0:
        for i in range(len(roomPending)):
            handlerData("temperature", i, roomPending[i], temp)
            handlerData("humidity", i, roomPending[i], humid)
            handlerData("co2", i, roomPending[i], carbon)
            handlerDepassements(roomPending[i], "temperature", temperaturePending[i])
            handlerDepassements(roomPending[i], "humidity", humidityPending[i])
            handlerDepassements(roomPending[i], "co2", co2Pending[i])

    if myjson != {}:
        with open(fichier, "w") as output1:
            json.dump(myjson, output1, indent=4)

    if myalert != {}:
        with open(alert_file_name, "w") as output2:
            json.dump(myalert, output2, indent=4)

    # Reset data
    co2Pending.clear()
    humidityPending.clear()
    temperaturePending.clear()
    roomPending.clear()

# Fonction de gestion des alarmes
def handlerAlert(tas, pile):

    # On ajoute les données dans le fichier JSON
    add_infos()

    # On remet l'alarme
    signal.alarm(delai*60)

# Fonction de gestion des données
def handlerData(typeData, i, room, isIn):
    global myjson

    # On ajoute la salle si elle n'existe pas
    if room not in myjson:
        myjson[room] = {"temperature": [], "humidity": [], "co2": []}
        
    # On élimine les données les plus anciennes si elles sont trop nombreuses
    if len(myjson[room][typeData]) >= 10:
        if isIn == "true":
            myjson[room][typeData].pop(0)
            
    # On ajoute les données
    if isIn == "true":
        if typeData == "temperature":
            myjson[room][typeData].append(temperaturePending[i])
        elif typeData == "humidity":
            myjson[room][typeData].append(humidityPending[i])
        elif typeData == "co2":
            myjson[room][typeData].append(co2Pending[i])

# Fonction de gestion des alertes
def handlerDepassements(room, typeData, value):
    global myalert
    global tempSeuil
    global humSeuil
    global co2Seuil
    global myjson

    # On définit le seuil
    if typeData == "temperature":
        seuil = tempSeuil
    elif typeData == "humidity":
        seuil = humSeuil
    elif typeData == "co2":
        seuil = co2Seuil

    # On élimine les données les plus anciennes si elles sont trop nombreuses
    if len(myjson[room][typeData]) >= 10:
        myalert[room][typeData].pop(0)

    # On ajoute la salle si elle n'existe pas
    if room not in myalert:
        myalert[room] = {"temperature": [], "humidity": [], "co2": []}
    
    # On ajoute les alertes
    if value > seuil:
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        myalert[room][typeData].append(
            f"{typeData.capitalize()} a dépassé le seuil ({value} {get_unit(typeData)}) à {current_time}"
        )
    else:
        myalert[room][typeData].append("")

# Fonction de récupération de l'unité
def get_unit(typeData):
    if typeData == "temperature":
        return "°C"
    elif typeData == "humidity":
        return "%"
    elif typeData == "co2":
        return "ppm"


# On crée le client MQTT
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message


try:
    client.connect(server, port, param)
except ConnectionRefusedError:
    print("Erreur de connexion")

# On lance l'alarme une première fois
signal.signal(signal.SIGALRM, handlerAlert)
signal.alarm(delai*60)

client.loop_forever()
