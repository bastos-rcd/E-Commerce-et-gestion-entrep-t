//GraphiqueController
package appiot;

import java.net.URL;
import java.util.Optional;
import java.util.ResourceBundle;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.chart.AreaChart;
import javafx.scene.chart.BarChart;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.XYChart;
import javafx.scene.control.Alert;
import javafx.scene.control.ButtonType;
import javafx.scene.control.Alert.AlertType;
import javafx.stage.Stage;


public class GraphiquesController implements Initializable{
    private Stage fenetrePrincipale = null;
	private Stage primaryStage;
	private AppIOT app;
	JSONArray tempValue=null;
	JSONArray humidityValue=null;
	JSONArray co2Value=null;
	@FXML
	private LineChart tempChart;
	@FXML
	private LineChart humChart;
	@FXML
	private LineChart coChart;

	public void setApp(AppIOT appIOT) {
	        this.app=appIOT;
	    }
	
    public void setDataSalle( JSONObject salleData, boolean isTemp,boolean isHumidity, boolean isCO2){
		if(isTemp){
			this.tempValue=(JSONArray) salleData.get("temperature");
			
		}
		if(isHumidity){
			this.humidityValue=(JSONArray) salleData.get("humidity");
		}
		if(isCO2){
			this.co2Value=(JSONArray) salleData.get("co2");
		}	
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
			/*try {
				this.fenetrePrincipale.setScene(this.app.showFenetreVisualisation());
				this.fenetrePrincipale.show();
			} catch (Exception e) {
				e.printStackTrace();
			}*/
		}
	}
    private void setTempChart(){
		XYChart.Series seriesTemp= new XYChart.Series<>();
		seriesTemp.setName("température");
		int time=10;
		for(int i=0; i<tempValue.size();i++){
			seriesTemp.getData().add(new XYChart.Data(time,tempValue.get(i)));
			time+=10;
		}
		tempChart.getData().add(seriesTemp);
	}
	private void setCoChart(){
		XYChart.Series seriesCO2= new XYChart.Series<>();
		seriesCO2.setName("co2");
		int time=10;
		for(int i=0; i<co2Value.size();i++){
			seriesCO2.getData().add(new XYChart.Data(time,co2Value.get(i)));
			time+=10;
		}
		coChart.getData().add(seriesCO2);
	}
	private void setHumChart(){
		XYChart.Series seriesHum= new XYChart.Series<>();
		seriesHum.setName("Humidité");
		int time=10;
		for(int i=0; i<humidityValue.size();i++){
			seriesHum.getData().add(new XYChart.Data(time,humidityValue.get(i)));
			time+=10;
		}
		humChart.getData().add(seriesHum);
	}

	public void setChamps(){
		if(tempValue!=null){
			setTempChart();
		}
		if(humidityValue!=null){
			setHumChart();
		}
		if(co2Value!=null){
			setCoChart();
		}
	}
	
	@Override
	public void initialize(URL location, ResourceBundle resources) {
		
	}
	
	@FXML
	public void onConfig() {}
	}