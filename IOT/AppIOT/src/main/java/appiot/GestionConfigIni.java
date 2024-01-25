package appiot;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class GestionConfigIni {

    private String filePath = "config.ini";
    private String server;
    private int port;
    private String topic;
    private int delai;
	private int param;
	private boolean temperature;
	private boolean humidity;
	private boolean co2;
	private int seuilTemp;
	private int seuilHum;
	private int seuilCO2;
	private String nomFichier;
    

    public GestionConfigIni() {
        this.readConfig();
    }

    private void readConfig() {
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            String currentSection = null;

            while ((line = reader.readLine()) != null) {
                // Ignorer les lignes vides ou les lignes commençant par #
                if (line.trim().isEmpty() || line.trim().startsWith("#")) {
                    continue;
                }

                // Vérifier si la ligne est une section
                if (line.startsWith("[")) {
                    currentSection = line.substring(1, line.indexOf("]")).trim();
                    continue;
                }

                // Traiter chaque ligne ici selon votre structure de fichier
                String[] parts = line.split("=");
                if (parts.length == 2) {
                    String key = parts[0].trim();
                    String value = parts[1].trim();

                    // Assigner les valeurs appropriées aux champs de votre classe
                    switch (key) {
                        case "server":
                            this.server = value;
                            break;
                        case "port":
                            this.port = Integer.parseInt(value);
                            break;
                        case "topic":
                            this.topic = value;
                            break;
                        case "param":
                            this.param = Integer.parseInt(value);
                            break;
                        case "co2":
                            this.co2 = Boolean.parseBoolean(value);
                            break;
                        case "temperature":
                            this.temperature = Boolean.parseBoolean(value);
                            break;
                        case "humidity":
                            this.humidity = Boolean.parseBoolean(value);
                            break;
                        case "seuilHum":
                            this.seuilHum = Integer.parseInt(value);
                            break;
                        case "seuilTemp":
                            this.seuilTemp = Integer.parseInt(value);
                            break;
                        case "seuilCO2":
                            this.seuilCO2 = Integer.parseInt(value);
                            break;
                        case "delai":
                            this.delai = Integer.parseInt(value);
                            break;
                        case "nomFichier":
                            this.nomFichier = value;
                            break;
                        // Ajouter d'autres cas pour les autres clés dans chaque section
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("Le fichier config.ini n'existe pas. Création d'un nouveau fichier.");
            this.createDefaultConfig();
        }
    }


    private void createDefaultConfig() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
        	writer.write("[mqtt]");
            writer.newLine();
            writer.write("server = chirpstack.iut-blagnac.fr");
            writer.newLine();
            writer.write("port = 1883");
            writer.newLine();
            writer.write("topic = B212,B217");
            writer.newLine();
            writer.write("param = 60");
            writer.newLine();
            writer.write("temperature = true");
            writer.newLine();
            writer.write("humidity = true");
            writer.newLine();
            writer.write("co2 = true");
            writer.newLine();
            writer.write("seuilTemp = 15");
            writer.newLine();
            writer.write("seuilHum = 80");
            writer.newLine();
            writer.write("seuilCO2 = 500");
            writer.newLine();
            writer.write("delai = 1");
            writer.newLine();
            writer.write("nomFichier = data");
            // Ajoutez d'autres lignes pour les autres clés avec leurs valeurs par défaut
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    

    public void setServer(String server) {
        this.server = server;
        this.updateConfig();
    }

    public void setPort(int port) {
        this.port = port;
        this.updateConfig();
    }

    public void setTopic(List<String> topic) {
    	String chaine=topic.get(0);
    	for(int i=1;i<topic.size();i++) {
    		chaine=chaine+","+topic.get(i);
    	}
        this.topic = chaine;
        this.updateConfig();
    }
    public void setParam(int param) {
        this.param = param;
        this.updateConfig();
    }
    public void setTemperature(boolean temperature) {
        this.temperature = temperature;
        this.updateConfig();
    }
    public void setHumidity(boolean humidity) {
        this.humidity = humidity;
        this.updateConfig();
    }
    public void setCo2(boolean co2) {
        this.co2 = co2;
        this.updateConfig();
    }
    public void setSeuilTemperature(int seuilTemp) {
        this.seuilTemp = seuilTemp;
        this.updateConfig();
    }

    public void setSeuilHumidity(int seuilHum) {
        this.seuilHum = seuilHum;
        this.updateConfig();
    }
    public void setSeuilCo2(int seuilCo2) {
        this.seuilCO2 = seuilCo2;
        this.updateConfig();
    }

    public void setDelai(int delai) {
        this.delai = delai;
        this.updateConfig();
    }
    
    public void setNomFichier(String nomFichier) {
        this.nomFichier = nomFichier;
        this.updateConfig();
    }

    private void updateConfig() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
        	writer.write("[mqtt]");
            writer.newLine();
            writer.write("server = " + this.server);
            writer.newLine();
            writer.write("port = " + this.port);
            writer.newLine();
            writer.write("topic = " + this.topic);
            writer.newLine();
            writer.write("param = " + this.param);
            writer.newLine();
            writer.write("temperature = " + this.temperature);
            writer.newLine();
            writer.write("humidity = " + this.humidity);
            writer.newLine();
            writer.write("co2 = " + this.co2);
            writer.newLine();
            writer.write("seuilTemp = " + this.seuilTemp);
            writer.newLine();
            writer.write("seuilHum = " + this.seuilHum);
            writer.newLine();
            writer.write("seuilCO2 = " + this.seuilCO2);
            writer.newLine();
            writer.write("delai = " + this.delai);
            writer.newLine();
            writer.write("nomFichier = " + this.nomFichier);
            // Ajoutez d'autres lignes pour les autres clés avec leurs valeurs
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
}