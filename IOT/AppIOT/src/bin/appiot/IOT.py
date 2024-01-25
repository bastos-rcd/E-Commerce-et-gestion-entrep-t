import datetime
import paho.mqtt.client as mqtt
import json
import configparser
import base64
import random
import os, time, signal

config_object = configparser.ConfigParser()
co2Pending = []
humidityPending = []
temperaturePending = []
roomPending = []


with open("config.ini","r") as file_object:
    config_object.read_file(file_object)
    server = config_object.get("mqtt","server")
    temp = config_object.get("mqtt","temperature")
    humid = config_object.get("mqtt","humidity")
    carbon = config_object.get("mqtt","co2")
    fichier = config_object.get("mqtt","nomFichier")
    try:
        port = int(config_object.get("mqtt","port"))
        param = int(config_object.get("mqtt","param"))
        delai = int(config_object.get("mqtt","delai"))
        tempSeuil = int(config_object.get("mqtt","seuilTemp"))
        humSeuil = int(config_object.get("mqtt","seuilHum"))
        co2Seuil = int(config_object.get("mqtt","seuilCO2"))
    except:
        port = 1883
        param = 60
        delai = 10
        tempSeuil = 15
        humSeuil = 80
        co2Seuil = 1000
        print("nope")
    topic = config_object.get("mqtt","topic")

def on_connect(client, userdata, flags, rc):
    global topic
    print("Connected with result code "+str(rc))
    
    client.subscribe(topic)

fichier = fichier + ".json"
f = open(fichier, "a")

with open(fichier, "r+") as output:
    if output.read() == "":
        output.write("{}")
        output.close()
    else:
        output.close()

f = open("alerte.json", "a")

with open("alerte.json", "r+") as output:
    if output.read() == "":
        output.write("{}")
        output.close()
    else:
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
    
    jsonfile = open(fichier, "r")
    myjson = json.load(jsonfile)
    
    jsonAlert = open("alerte.json", "r")
    myAlert = json.load(jsonAlert)
    
    for i in range(len(roomPending)):
        if roomPending[i] in myjson:

            if len(myjson[roomPending[i]]["temperature"]) >= 20:
                if temp == "true":
                    myjson[roomPending[i]]["temperature"].pop(0)
                    myjson[roomPending[i]]["temperature"].append(temperaturePending[i])
            
                    
            else:
                if temp == "true":
                    myjson[roomPending[i]]["temperature"].append(temperaturePending[i])

            if len(myjson[roomPending[i]]["humidity"]) >= 20:
                if humid == "true":
                    myjson[roomPending[i]]["humidity"].pop(0)
                    myjson[roomPending[i]]["humidity"].append(humidityPending[i])
            else:
                if humid == "true":
                    myjson[roomPending[i]]["humidity"].append(humidityPending[i])

            if len(myjson[roomPending[i]]["co2"]) >= 20:
                if carbon == "true":
                    myjson[roomPending[i]]["co2"].pop(0)
                    myjson[roomPending[i]]["co2"].append(co2Pending[i])       
            else:
                if carbon == "true":
                    myjson[roomPending[i]]["co2"].append(co2Pending[i])
            
            if tempSeuil< temperaturePending[i] :
                myAlert[roomPending[i]]["messageTemperature"] = "La température a dépassé le seuil " + "(elle est arrivée à " + str(temperaturePending[i]) + "°C le " +time.today() + ")"
            if co2Seuil< co2Pending[i] :
                myAlert[roomPending[i]]["messageTemperature"] = "Le CO2 a dépassé le seuil " + "(il est arrivée à " + str(temperaturePending[i]) + " le " +time.today() + ")"
            if humSeuil< humidityPending[i] :
                myAlert[roomPending[i]]["messageHumidity"] = "L'humidité a dépassé le seuil " + "(elle est arrivée à " + str(temperaturePending[i]) + "%% le " +time.today() + ")"

        else:
            myjson[roomPending[i]] = {"temperature": [], "humidity": [], "co2": []}
            myAlert[roomPending[i]] = {"alertTemperature": [], "alertHumidity": [], "alertCo2": []}
            if temp == "true":
                myjson[roomPending[i]]["temperature"] = [temperaturePending[i]]
            if humid == "true":
                myjson[roomPending[i]]["humidity"] = [humidityPending[i]]
            if carbon == "true":
                myjson[roomPending[i]]["co2"] = [co2Pending[i]]
            if tempSeuil< temperaturePending[i] :
                myAlert[roomPending[i]]["messageTemperature"] = "La température a dépassé le seuil " + "(elle est arrivée à " + str(temperaturePending[i]) + "°C le " +time.today() + ")"
            if co2Seuil< co2Pending[i] :
                myAlert[roomPending[i]]["messageTemperature"] = "Le CO2 a dépassé le seuil " + "(il est arrivée à " + str(temperaturePending[i]) + " le " +time.today() + ")"
            if humSeuil< humidityPending[i] :
                myAlert[roomPending[i]]["messageHumidity"] = "L'humidité a dépassé le seuil " + "(elle est arrivée à " + str(temperaturePending[i]) + "%% le " +time.today() + ")"
            
    
    
    
    myjson = json.dumps(myjson, indent=4)
    with open(fichier, "w") as output:
        output.write(myjson)
        output.close()
    
    myAlert = json.dumps(myAlert, indent=4)
    with open("alerte.json", "w") as output:
        output.write(myAlert)
        output.close()

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
    
    signal.alarm(delai*60)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message
try:
    client.connect(server, port, param)
except:
    print("Erreur de connexion au serveur MQTT")
    
signal.signal(signal.SIGALRM, handlerAlert)
signal.alarm(delai*60)
    
client.loop_forever()