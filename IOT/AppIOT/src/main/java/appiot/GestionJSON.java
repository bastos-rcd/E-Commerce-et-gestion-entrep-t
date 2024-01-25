package appiot;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class GestionJSON {
	
	/**
	 * Fonction statique permettant d'ouvrir le fichier JSON généré par le programme python 
	 * puis de mettre les données de ce fichier dans un objet JSON
	 * 
	 *  @param le chemin du fichier à ouvrir
	 */
	public static JSONObject ouvrirJSON (String fichier) {
		JSONParser parser = new JSONParser();
		JSONObject json = null;
		String path = new File(fichier + ".json").getAbsolutePath();
		try {
			json  = (JSONObject) parser.parse(new FileReader(path));
		} catch (FileNotFoundException e) {
			System.out.println("Fichier non trouvé");
		} catch (IOException e) {
			System.out.println("IOException");
		} catch (ParseException e) {
			System.out.println("ParseException");
		}
		return json;
	}
	
	/**
	 * Fonction statique permettant d'ouvrir le fichier JSON des alertes généré par le programme python 
	 * puis de mettre les données de ce fichier dans un objet JSON
	 * 
	 */
	public static JSONObject ouvrirJSONAlertes () {
		JSONParser parser = new JSONParser();
		JSONObject json = null;
		String path = new File("alertes.json").getAbsolutePath();
		try {
			json  = (JSONObject) parser.parse(new FileReader(path));
		} catch (FileNotFoundException e) {
			System.out.println("Fichier non trouvé");
		} catch (IOException e) {
			System.out.println("IOException");
		} catch (ParseException e) {
			System.out.println("ParseException");
		}
		return json;
	}
}
