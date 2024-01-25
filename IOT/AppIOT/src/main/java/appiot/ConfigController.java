package appiot;

import appiot.GestionConfigIni;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.nio.Buffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.ResourceBundle;
import java.util.Timer;
import java.util.concurrent.CountDownLatch;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import javafx.animation.KeyFrame;
import javafx.animation.KeyValue;
import javafx.animation.Timeline;
import javafx.beans.binding.Bindings;
import javafx.beans.property.IntegerProperty;
import javafx.beans.property.Property;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.ListView;
import javafx.scene.control.SelectionMode;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.Label;
import javafx.scene.control.RadioButton;
import javafx.scene.control.Slider;
import javafx.scene.control.TextField;
import javafx.scene.control.TextInputDialog;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.util.Duration;
import javafx.util.converter.NumberStringConverter;
import javafx.scene.control.CheckBox;


public class ConfigController implements Initializable{
	private Stage fenetrePrincipale = null;
	private Stage primaryStage;
	
	@FXML
	private TextField zoneFichier;
	
	@FXML
	private TextField zoneServeur;
	
	@FXML
	private TextField zonePort;
	
	@FXML
	private ListView<String> choiceSalle;
	
	@FXML
	private TextField searchBar;
	
	@FXML
	private CheckBox checkHumidity; 
	
	@FXML
	private CheckBox checkTemp;
	
	@FXML
	private CheckBox checkCO2;
	
	@FXML
	private TextField textSlider;
	
	@FXML
	private Slider freqSlider = new Slider();
	
	private IntegerProperty frequence = new SimpleIntegerProperty(10);
	
	private ObservableList<String> listeSalles = FXCollections.observableArrayList(
			"B110", "B111", "B201", "B202", "B203", "B001", "B002", "B003", "B101", "B102", "B103", "B105", "B106", "B108", "B109", "B112", "B113", "B212", "B217", "B219", "B234", "C004", "C006", "D001", "E003", "E004", "E001", "E006", "E007", "E101", "E102", "E103", "E104", "E105", "E106", "E100", "E208", "E209", "E206", "E207", "E210", "Salle-conseil", "A007", "Local-velo", "Foyer-personnels", "Foyer-etudiants-1", "Foyer-etudiants-2", "hall-1", "hall-2", "amphi1"
	    );

	private String fichier;
	private String serveur;
	private int port;
	private String salle;
	private boolean humidity;
	private boolean temp;
	private boolean co2;
	private int freq;
	
	private ObservableList<String> sallesSelectionnees;
	private List<TextField> textfieldList = new ArrayList<>();
	private TextField seuilTemp = new TextField();
    private TextField seuilHumidity = new TextField();
    private TextField seuilCO2 = new TextField();
    
    private JSONObject donnees;
    private JSONObject donneesAlertes;
    
    private AppIOT app; 
    private Timer timer;
    private UpdateData update;
    
    private Timer timerAlertes;
    private UpdateAlertes updateAlertes;
	
	public JSONObject getDonnes() {
		return this.donnees;
	}
	
	void setFenetrePrincipale(Stage fenetrePrincipale) {
		this.fenetrePrincipale = fenetrePrincipale;
		this.primaryStage = this.fenetrePrincipale;
		this.fenetrePrincipale.setOnCloseRequest(event -> {
			event.consume();
			actionQuitter();});
	}
	
	@FXML
	private void actionQuitter() {
		Alert confirm = new Alert(AlertType.CONFIRMATION);
		confirm.setTitle("Quitter?");
		confirm.setHeaderText("Voulez-vous réellement quitter ?");
		Optional<ButtonType> optBut = confirm.showAndWait(); 
		if(optBut.orElse(null) == ButtonType.OK) {
			this.fenetrePrincipale.close();
		}
	}
	
	
	public void setApp(AppIOT appIOT) {
	        this.app=appIOT;
	    }
	
	
	@FXML
	private void actionValider() {
		
		boolean verif = validerChamps();
		
		if(verif) {
			
			defSeuils();
			
			boolean verifSeuil = seuilValides();
			
			if(verifSeuil) {
				
				GestionConfigIni configFile = new GestionConfigIni();
				configFile.setServer(this.serveur);
		    	configFile.setPort(this.port);
		    	configFile.setTopic(this.sallesSelectionnees);
		    	configFile.setParam(60);
		    	configFile.setCo2(this.co2);
		    	configFile.setHumidity(this.humidity);
		    	configFile.setTemperature(this.temp);
		    	if(this.checkCO2.isSelected()) {
		    		configFile.setSeuilCo2(Integer.parseInt(this.seuilCO2.getText()));
		    	}else {
		    		configFile.setSeuilCo2(800);
		    	}
		    	if(this.checkHumidity.isSelected()) {
		    		configFile.setSeuilHumidity(Integer.parseInt(this.seuilHumidity.getText()));
		    	}else {
		    		configFile.setSeuilHumidity(40);
		    	}
		    	if(this.checkTemp.isSelected()) {
		    		configFile.setSeuilTemperature(Integer.parseInt(this.seuilTemp.getText()));
		    	}else {
		    		configFile.setSeuilTemperature(30);
		    	}
		    	configFile.setDelai(this.freq);
		    	configFile.setNomFichier(this.fichier);
		        
		    	this.fenetrePrincipale.close();
		    	
		    	// Ouverture de la fenêtre de données
		    	
		        while(this.donnees == null || this.donnees.isEmpty()) {
		        	System.out.println("\n" + " En attente de données");
		        	this.donnees = GestionJSON.ouvrirJSON(this.fichier);
		        	try {
						Thread.sleep(5000);
					} catch (InterruptedException e) {
						System.out.println("Interruption du thread");
					}
		        }
		        
		        this.app.setData(sallesSelectionnees, donnees, humidity, temp, co2);
				
		        try {
					this.fenetrePrincipale.setScene(this.app.showFenetreVisualisation());
					this.fenetrePrincipale.show();
					
					this.update = new UpdateData(this.app.getDonneesController(), this.fichier);
			        this.timer = new Timer();
					this.timer.scheduleAtFixedRate(this.update, 500, this.freq*1000);
				} catch (Exception e) {
					e.printStackTrace();
				}
		        
		        // Ouverture de la fenêtre d'alertes
		    	
		    	while(this.donneesAlertes == null) {
		        	System.out.println("\n" + " Ouverture du fichier d'alertes");
		        	this.donneesAlertes = GestionJSON.ouvrirJSONAlertes();
		        	try {
						Thread.sleep(5000);
					} catch (InterruptedException e) {
						System.out.println("Interruption du thread");
					}
		    	}
		    	
		    	try {
		    		Scene nouvelleSceneAlertes = this.app.showFenetreAlertes(this.donneesAlertes);

					Stage nouvelleFenetrePrincipale = new Stage();
					nouvelleFenetrePrincipale.setScene(nouvelleSceneAlertes);
					nouvelleFenetrePrincipale.setTitle("Alertes");
					
					nouvelleFenetrePrincipale.show();
					
					this.updateAlertes = new UpdateAlertes(this.app.getAlertesController(), listeSalles, temp, humidity, co2);
					this.timerAlertes = new Timer();
					this.timerAlertes.scheduleAtFixedRate(this.updateAlertes, 500, this.freq*1000);
					
				
		    	} catch (Exception e) {
					e.printStackTrace();
				}
			} 
		}
	}
	 

	private boolean validerChamps() {
		
		this.fichier = zoneFichier.getText();
		this.serveur = zoneServeur.getText();
		this.humidity = checkHumidity.isSelected();
		this.temp = checkTemp.isSelected();
		this.co2 = checkCO2.isSelected();
		this.sallesSelectionnees = choiceSalle.getSelectionModel().getSelectedItems();
		
		boolean champsOk = true;
		
		this.textfieldList.add(this.zoneFichier);
		this.textfieldList.add(this.zoneServeur);
		
		for(int i=0;i<textfieldList.size();i++) {
			if(textfieldList.get(i).getText().isEmpty()) {
				textfieldList.get(i).setPromptText("Vous devez remplir ce champ !");
				textfieldList.get(i).getStyleClass().add("error");
				secouerChamp(textfieldList.get(i));
				champsOk = false;
			}else {
				textfieldList.get(i).getStyleClass().remove("error");
				textfieldList.get(i).setPromptText("");
			}
		}
		
		if(this.zonePort.getText().isEmpty()) {
			this.zonePort.setPromptText("Vous devez remplir ce champ !");
			this.zonePort.getStyleClass().add("error");
			secouerChamp(this.zonePort);
			champsOk = false;
		}else {
			try {
				this.port = Integer.parseInt(zonePort.getText());
				this.freq = Integer.parseInt(textSlider.getText());
			}catch(NumberFormatException f) {
				Alert alert = new Alert(AlertType.WARNING);
				alert.setTitle("Avertissement");
				alert.setHeaderText(null);
				alert.setContentText("Le port et la fréquence doivent être des nombres");
				alert.showAndWait();
			}
			this.zonePort.getStyleClass().remove("error");
			this.zonePort.setPromptText("");
		}
		
		if(!this.checkCO2.isSelected() && !this.checkTemp.isSelected() && !this.checkHumidity.isSelected()) {
			champsOk = false;
			Alert alert = new Alert(Alert.AlertType.WARNING);
            alert.setTitle("Avertissement");
            alert.setHeaderText(null);
            alert.setContentText("Veuillez sélectionner au moins l'un des boutons.");
            alert.showAndWait();
		}
		
		try {
			if(this.sallesSelectionnees.equals(null) || this.sallesSelectionnees.isEmpty()) {
				Alert alert = new Alert(AlertType.WARNING);
				alert.setTitle("Avertissement");
				alert.setHeaderText(null);
				alert.setContentText("Veuillez sélectionner au moins une salle");
				alert.showAndWait();
				champsOk = false;
			}
		}catch(NullPointerException n) {
			n.getStackTrace();
		}
		
		return champsOk;
	}
	
	private void secouerChamp(TextField textField) {
        
        Timeline timeline = new Timeline(
                new KeyFrame(Duration.seconds(0.05), new KeyValue(textField.translateXProperty(), 5)),
                new KeyFrame(Duration.seconds(0.1), new KeyValue(textField.translateXProperty(), -5)),
                new KeyFrame(Duration.seconds(0.15), new KeyValue(textField.translateXProperty(), 5)),
                new KeyFrame(Duration.seconds(0.2), new KeyValue(textField.translateXProperty(), -5)),
                new KeyFrame(Duration.seconds(0.25), new KeyValue(textField.translateXProperty(), 0))
        );

        timeline.play();
    }
	
	private void updateSalleList(String filtre) {
        
        ObservableList<String> listeFiltree = FXCollections.observableArrayList();

        for (String salle : listeSalles) {
            if (salle.toLowerCase().contains(filtre.toLowerCase())) {
            	listeFiltree.add(salle);
            }
        }

        choiceSalle.setItems(listeFiltree);
    }
	
	private VBox createCustomFields() {
        VBox vbox = new VBox(10);
        
        if(this.checkCO2.isSelected()) {
        	vbox.getChildren().addAll(new Label("Définissez le seuil maximal de CO2 en ppm : "), this.seuilCO2);
        }
        
        if(this.checkHumidity.isSelected()) {
        	vbox.getChildren().addAll(new Label("Définissez le seuil maximal d'humidité en % : "), this.seuilHumidity);
        }
        
        if(this.checkTemp.isSelected()) {
        	vbox.getChildren().addAll(new Label("Définissez le seuil maximal de température en °C : "), this.seuilTemp);
        }
        
        return vbox;
    }
	
    private void defSeuils() {
    	
        TextInputDialog dialog = new TextInputDialog();
        dialog.setTitle("Configuration des seuils");
        dialog.setHeaderText(null);
        
        VBox champs = createCustomFields();
        
        dialog.getDialogPane().setContent(champs);

        dialog.showAndWait();
        
    }
	
    private boolean seuilValides() {
        boolean isValid = true;

        if (checkCO2.isSelected()) {
            String seuilCO2Text = seuilCO2.getText().trim();
            if (seuilCO2Text.isEmpty() || Double.parseDouble(seuilCO2Text) < 0) {
                isValid = false;
            }
        }

        if (checkHumidity.isSelected()) {
            String seuilHumidityText = seuilHumidity.getText().trim();
            if (seuilHumidityText.isEmpty() || Double.parseDouble(seuilHumidityText) < 0) {
                isValid = false;
            }
        }

        if (checkTemp.isSelected()) {
            String seuilTempText = seuilTemp.getText().trim();
            if (seuilTempText.isEmpty()) {
                isValid = false;
            }
        }

        return isValid;
    }


	
	private void gestConfig() {
    
        
    }



	private void actionSelect(ActionEvent event) {
		
	}

	@Override
	public void initialize(URL location, ResourceBundle resources) {
		Bindings.bindBidirectional(freqSlider.valueProperty(), this.frequence);
		Bindings.bindBidirectional(textSlider.textProperty(), this.frequence, new NumberStringConverter());
		choiceSalle.setItems(listeSalles);
        choiceSalle.getSelectionModel().setSelectionMode(SelectionMode.MULTIPLE);
        choiceSalle.setFocusTraversable(false);
        searchBar.textProperty().addListener((observable, oldValue, newValue) -> {
        	updateSalleList(newValue);
        });
		
		
	}
}
