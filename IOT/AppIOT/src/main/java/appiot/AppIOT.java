package appiot;

import java.io.IOException;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import javafx.application.Application;
import javafx.beans.InvalidationListener;
import javafx.collections.FXCollections;
import javafx.collections.ListChangeListener;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.CheckBox;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.ScrollPane;
import javafx.scene.control.ScrollPane.ScrollBarPolicy;
import javafx.scene.control.Slider;
import javafx.scene.control.TextField;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Modality;
import javafx.stage.Stage;

public class AppIOT extends Application {
	

	private Stage primaryStage;
	private AnchorPane rootPane;
	
	private ConfigController configCTRL;
	private DonneesController donneesCTRL;
	private GraphiquesController graphiquesCTRL;
	private AlertesController alertesCTRL;
	
	private ObservableList<String> listeSalles = FXCollections.observableArrayList();
	private JSONObject donnees = null;
	private boolean h = false;
	private boolean temp = false;
	private boolean co2 = false;
	
	private JSONObject salleData;
	private JSONArray tempValueGraphic;
	private JSONArray humidityValueGraphic;
	private JSONArray co2ValueGraphic;

	/**
     * Fonction de lancement de l'application
     * Cette méthode est appelée lors du démarrage de l'application.
     * Elle permet d'appeler la méthode qui lance la page de configuration.
     *
     * @param primaryStage la fenêtre principale de l'application
	 * @throws Exception
     */
    @Override
    public void start(Stage primaryStage) throws Exception {
        this.primaryStage = primaryStage;
        this.primaryStage.setScene(showFenetreConfiguration());
        this.primaryStage.setTitle("AppIOT");
        this.primaryStage.show();
    }
	
    /**
     * Fonction permettant de récupérer les données à afficher dans fenetreVisualisation
     * Cette méthode est appelée dans la méthode showFentreVisualisation
     * 
     * @param les données renvoyées par le fichier de configuration
     */
    public void setData(ObservableList<String> listeSalles, JSONObject donnees, boolean h, boolean temp, boolean co2) {
    	this.listeSalles = listeSalles;
    	this.donnees = donnees;
    	this.h = h;
    	this.temp = temp;
    	this.co2 = co2;
    }
    
    /**
     * Méthode pour initialiser les données graphiques dans graphiqueController.
     *
     * @param salleDataGraphic       Les données spécifiques à une salle pour les graphiques.
     */
	public void setDataGraphic(JSONObject salleDataGraphic){
		this.salleData=salleDataGraphic;
	}
    
    public DonneesController getDonneesController() {
    	return this.donneesCTRL;
    }
    
    public AlertesController getAlertesController() {
    	return this.alertesCTRL;
    }
    
    /**
     * Fonction permettant de charger et d'afficher la fenetre de création du fichier de configuration
     * Est appelée au lancement de l'application
     * 
     *  @throws Exception
     */
	public Scene showFenetreConfiguration() throws Exception {
		
		try {
			FXMLLoader loader = new FXMLLoader();
			loader.setLocation( AppIOT.class.getResource("Configuration.fxml"));

			AnchorPane anchorPane = loader.load(); 
			configCTRL = loader.getController();
			
			configCTRL.setApp(this); 
			configCTRL.setFenetrePrincipale(primaryStage);
			 
			return new Scene(anchorPane);
				
		} catch (IOException e) {
			System.out.println("Ressource FXML non disponible");
			e.printStackTrace();
			System.exit(1);			
		}
		return null; 
		
	}

	/**
	 * Fonction permettant de charger et d'afficher la fenetre contenant les données récupérées
	 * Est appelée après la création du fichier de configuration lors de la réception des premières données 
	 * 
	 * @throws Exception
	 */
	public Scene showFenetreVisualisation() throws Exception {
		try {
			
			
		    	
			FXMLLoader loader = new FXMLLoader();
			loader.setLocation(AppIOT.class.getResource("Donnees.fxml"));
	
			AnchorPane anchorPane = loader.load();
			donneesCTRL = loader.getController();
			
			donneesCTRL.setApp(this);
			donneesCTRL.setFenetrePrincipale(primaryStage);
			
			donneesCTRL.setData(listeSalles, donnees, h, temp, co2);
			donneesCTRL.createPage();
			donneesCTRL.setPage(donnees);
			donneesCTRL.addGridPaneToAnchorPane();
			
			ScrollPane scrollPane = new ScrollPane();
			scrollPane.setContent(anchorPane);
			scrollPane.setVbarPolicy(ScrollBarPolicy.AS_NEEDED);
			scrollPane.setHbarPolicy(ScrollBarPolicy.NEVER);
			scrollPane.prefWidthProperty().bind(anchorPane.widthProperty());
			scrollPane.prefHeightProperty().bind(anchorPane.heightProperty());
			
			return new Scene(scrollPane,650,480);
		} catch (IOException e) {
			System.out.println("Ressource FXML non disponible");
			e.printStackTrace();
			System.exit(1);
		}
		return null;
	}
	
	
	
public Scene showFenetreGraphique() throws Exception {
		try {
		    	
			FXMLLoader loader = new FXMLLoader();
			loader.setLocation(AppIOT.class.getResource("Graphiques.fxml"));
	
			AnchorPane anchorPane = loader.load();
			graphiquesCTRL = loader.getController();
			
			graphiquesCTRL.setDataSalle(salleData, temp, h, co2);
			graphiquesCTRL.setChamps();
			graphiquesCTRL.setApp(this);
			graphiquesCTRL.setFenetrePrincipale(primaryStage);
			
			return new Scene(anchorPane);
		} catch (IOException e) {
			System.out.println("Ressource FXML non disponible");
			e.printStackTrace();
			System.exit(1);
		}
		return null;
	}


/**
 * Fonction permettant de charger et d'afficher la fenetre contenant les alertes récupérées
 * Est appelée après la création du fichier de configuration lors de la réception des premières données 
 * 
 * @throws Exception
 */
public Scene showFenetreAlertes(JSONObject donneesAlertes) throws Exception {
	try {
	    	
		FXMLLoader loader = new FXMLLoader();
		loader.setLocation(AppIOT.class.getResource("Alertes.fxml"));

		AnchorPane anchorPane = loader.load();
		alertesCTRL = loader.getController();
		
		alertesCTRL.setApp(this);
		alertesCTRL.setFenetrePrincipale(primaryStage);
		
		alertesCTRL.createPage();
		alertesCTRL.setPageAlertes(donneesAlertes, listeSalles, temp, h, co2);
		alertesCTRL.addGridPaneToAnchorPane();
		
		ScrollPane scrollPane = new ScrollPane();
		scrollPane.setContent(anchorPane);
		scrollPane.setVbarPolicy(ScrollBarPolicy.AS_NEEDED);
		scrollPane.setHbarPolicy(ScrollBarPolicy.NEVER);
		scrollPane.prefWidthProperty().bind(anchorPane.widthProperty());
		scrollPane.prefHeightProperty().bind(anchorPane.heightProperty());
		
		return new Scene(scrollPane,550,500);
	} catch (IOException e) {
		System.out.println("Ressource FXML non disponible");
		e.printStackTrace();
		System.exit(1);
	}
	return null;
}
	
	public static void main2(String[] args) {
		Application.launch(args);
	}
	
}