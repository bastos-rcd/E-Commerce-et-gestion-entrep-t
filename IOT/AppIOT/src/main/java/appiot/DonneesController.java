package appiot;

import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.ResourceBundle;
import java.util.Timer;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import javafx.collections.FXCollections;
import javafx.collections.ObservableArray;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextInputDialog;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.ColumnConstraints;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Priority;
import javafx.scene.layout.RowConstraints;
import javafx.scene.layout.VBox;
import javafx.scene.control.Alert.AlertType;
import javafx.scene.control.Button;
import javafx.stage.Stage;

/**
 * Classe controller de la fenetre de visualisation des données récupérées
 * 
 */


public class DonneesController implements Initializable{
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

    private ObservableList<String> salles = FXCollections.observableArrayList();
    private ObservableList<String> sallesGraphiques = FXCollections.observableArrayList();
    private ChoiceBox<String> choiceSalle = new ChoiceBox<>();
    private String selectedSalle;
    private ComboBox<String> comboBox = new ComboBox<>();
    
    
    private JSONObject obj;
    private boolean isHumidity;
    private boolean isTemp;
    private boolean isCO2;
    
    private int refreshTime;
    private AppIOT app;
    private Timer timer;
    
    private int row;
    private int column;
    private int nbInfos;
    
    @FXML
    private AnchorPane anchorPane;
    
    @FXML
    private Button graphiques;
    
    @FXML
    private GridPane gridPane = new GridPane();
    
    public void setData(ObservableList<String> listeSalles, JSONObject donnees, boolean h, boolean temp, boolean co2) {
    	this.salles = listeSalles;
    	this.obj = donnees;
    	this.isHumidity = h;
    	this.isTemp = temp;
    	this.isCO2 = co2;
    }
    
    public void setApp(AppIOT appIOT) {
        this.app=appIOT;
    }
    
    
	@Override
	public void initialize(URL location, ResourceBundle resources) {
		
		}
	
	/**
	 * Fonction permettant d'ajouter les données récupérées à la fenêtre de visualisation des données.
	 * Récupère les données à ajouter dans l'objet JSON.
	 */
	public void setPage(JSONObject donnees) {
	    System.out.println("\n" + "Données rafraîchies");
	    this.obj = donnees;
	    
	    this.nbInfos = 0;
	    
	    if(this.isTemp) {
	    	nbInfos++;
	    }
	    if(this.isCO2) {
	    	nbInfos++;
	    }
	    if(this.isHumidity) {
	    	nbInfos++;
	    }
	    
	    int cpt = 0;
	    this.row = 0;
	    this.column = 0;
	    
	    this.gridPane.getChildren().clear();
	    
	    for (String salle : this.salles) {
	        if (donnees.containsKey(salle)) {
	        	if(!this.sallesGraphiques.contains(salle)) {
	        		this.sallesGraphiques.add(salle);
	        	}
	            
	            JSONObject salleData = (JSONObject) donnees.get(salle);

	            JSONArray tempValue = (JSONArray) salleData.get("temperature");
	            JSONArray humidityValue = (JSONArray) salleData.get("humidity");
	            JSONArray co2Value = (JSONArray) salleData.get("co2");

	            if (cpt == 4) {
	                cpt = 0;
	                this.column = 0;
	                this.row += nbInfos+1;
	            }

	            Label emplacement = new Label("Salle : " + salle);
	            addLabelsToGridPane(emplacement, tempValue, humidityValue, co2Value);

	            this.column++;
	            cpt++;
	        }
	    }

	    gridPane.add(graphiques,3,this.row+4);
	    this.row++;
	}

	private void addLabelsToGridPane(Label emplacement, JSONArray tempValue, JSONArray humidityValue, JSONArray co2Value) {
		
	    gridPane.add(emplacement, this.column, this.row);
	    this.row++;

	    if (this.isTemp && tempValue.size() > 0) {
	        Label labelTemp = new Label("Température : " + tempValue.get(0) + "°C");
	        gridPane.add(labelTemp, this.column, this.row);
	        this.row++;
	    }

	    if (this.isHumidity && humidityValue.size() > 0) {
	        Label labelHum = new Label("Humidité : " + humidityValue.get(0) + "%");
	        gridPane.add(labelHum, this.column, this.row);
	        this.row++;
	    }

	    if (this.isCO2 && co2Value.size() > 0) {
	        Label labelCO2 = new Label("CO2 : " + co2Value.get(0) + "ppm");
	        gridPane.add(labelCO2, this.column, this.row++);
	        this.row++;
	    }
	    
	    this.row -= nbInfos+1;
	    
	}


	public void addGridPaneToAnchorPane() {
		anchorPane.prefWidthProperty().bind(gridPane.widthProperty());
        anchorPane.prefHeightProperty().bind(gridPane.heightProperty());
	    anchorPane.getChildren().add(gridPane);
	}

	
	/**
	 * Fonction permettant de créer l'élement sur lequel on ajoute les données 
	 */
	public void createPage() {
	    gridPane.setPadding(new Insets(10)); 
	    gridPane.setVgap(10);
	    gridPane.setHgap(10);
	}
	
	/**
	 * Méthodes utilisées pour implémenter les données graphiques
	 *  
	 */
	
	private Optional<String> choiceSalleGraphique() {
    	
        TextInputDialog dialog = new TextInputDialog();
        dialog.setTitle("Choix de salle");
        dialog.setHeaderText(null);

        VBox champs = createCustomFields();
        
        dialog.getDialogPane().setContent(champs);

		// Afficher le dialogue et attendre la réponse
		// Afficher le dialogue et attendre la réponse
		Optional<String> result = dialog.showAndWait();
		return result;
		
    }  
	
	private VBox createCustomFields() {
		
        VBox vbox = new VBox(10);
		if (choiceSalle == null) {
			choiceSalle = new ChoiceBox<>();
		}
		
		comboBox.setItems(this.sallesGraphiques);
		
		vbox.getChildren().addAll(new Label("Choisissez la salle: "),comboBox);
        return vbox;
    }
	
	private boolean selectedSalleValide( Optional<String> result){
		// Vérifier si l'utilisateur a appuyé sur "OK" ou "Annuler"
		if (result.isPresent()) {
			if(comboBox.getValue()!=null){
				this.selectedSalle = comboBox.getValue();
				return true;
			}
		}
		return false;
		
	}
	
	 private void setGraphicValue(){
		if(this.selectedSalle!=null){
	        JSONObject salleDataGraphic = (JSONObject) this.obj.get(selectedSalle);
	         
			this.app.setDataGraphic(salleDataGraphic);
		}

	 }

	
	@FXML
	private void actionValider() {
		Optional<String> result = choiceSalleGraphique();
		if(selectedSalleValide(result)){
					try {
						this.setGraphicValue();
						 // Créer une nouvelle instance de la fenêtre graphique (supposons que showFenetreGraphique() retourne une nouvelle scène)
    					Scene nouvelleSceneGraphique = this.app.showFenetreGraphique();
    
						// Créer une nouvelle fenêtre principale avec la nouvelle scène
						Stage nouvelleFenetrePrincipale = new Stage();
						nouvelleFenetrePrincipale.setScene(nouvelleSceneGraphique);
						
						// Afficher la nouvelle fenêtre principale
						nouvelleFenetrePrincipale.show();
					} catch (Exception e) {
						e.printStackTrace();
					}
		}
			
	}
		
	@FXML
	public void onConfig() {}
	}


