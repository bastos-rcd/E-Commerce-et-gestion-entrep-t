package appiot;

import java.net.URL;
import java.util.Optional;
import java.util.ResourceBundle;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.geometry.Insets;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Label;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.GridPane;
import javafx.scene.control.Alert.AlertType;
import javafx.stage.Stage;

public class AlertesController implements Initializable{
	
	private Stage fenetrePrincipale = null;
	private Stage primaryStage;

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
    
    @FXML
    private AnchorPane anchorPane;
    
    @FXML
    private GridPane gridPane = new GridPane();
    
    private int column;
    private int row;
    
    private AppIOT app;
    
    public void setApp(AppIOT appIOT) {
        this.app=appIOT;
    }

    
    public void createPage() {
	    gridPane.setPadding(new Insets(10)); 
	    gridPane.setVgap(10);
	    gridPane.setHgap(10);

	}
    
    /**
	 * Fonction permettant d'ajouter les données récupérées à la fenetre de visualisation des alertes
	 * Récupère les données à ajouter dans l'objet JSON
	 * 
	 */
	public void setPageAlertes(JSONObject donnees, ObservableList<String> salles, boolean isTemp, boolean isHumidity, boolean isCO2) {
		
		System.out.println("\n" + "Alertes rafraîchies");
		
		this.row = 0;
		this.column = 0;
		this.gridPane.getChildren().clear();
		
	    for (String salle : salles) {
	        if (donnees.containsKey(salle)) {
	        	
	            JSONObject salleData = (JSONObject) donnees.get(salle);

	            JSONArray tempAlert = (JSONArray) salleData.get("temperature");
	            JSONArray humidityAlert = (JSONArray) salleData.get("humidity");
	            JSONArray co2Alert = (JSONArray) salleData.get("co2");

	            if(tempAlert.get(0).toString().isEmpty()==false || humidityAlert.get(0).toString().isEmpty()==false || co2Alert.get(0).toString().isEmpty()==false) {
	            	Label emplacement = new Label("Salle : " + salle);
		            addLabelsToGridPane(emplacement, tempAlert, humidityAlert, co2Alert, isTemp, isHumidity, isCO2);
		            this.row++;
	            }
	        }
	    }
	}

	private void addLabelsToGridPane(Label emplacement, JSONArray tempAlert, JSONArray humidityAlert, JSONArray co2Alert, boolean isTemp, boolean isHumidity, boolean isCO2) {
	    gridPane.add(emplacement, this.column, this.row);
	    this.row++;

	    if (isTemp && tempAlert.size() > 0 && tempAlert.get(0).toString().isEmpty()==false) {
	        Label labelTemp = new Label("Alerte de température : " + tempAlert.get(0));
	        gridPane.add(labelTemp, this.column, this.row);
	        this.row++;
	    }

	    if (isHumidity && humidityAlert.size() > 0 && humidityAlert.get(0).toString().isEmpty()==false) {
	        Label labelHum = new Label("Alerte d'humidité : " + humidityAlert.get(0));
	        gridPane.add(labelHum, this.column, this.row);
	        this.row++;
	    }

	    if (isCO2 && co2Alert.size() > 0 && co2Alert.get(0).toString().isEmpty()==false) {
	        Label labelCO2 = new Label("Alerte de CO2 : " + co2Alert.get(0));
	        gridPane.add(labelCO2, this.column, this.row);
	        this.row++;
	    }
	}

	public void addGridPaneToAnchorPane() {
	    anchorPane.getChildren().add(gridPane);
	}
    
	@Override
	public void initialize(URL location, ResourceBundle resources) {
		
	}

}
