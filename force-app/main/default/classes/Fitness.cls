public class Fitness {
    
    public static Decimal  getBMI(Decimal  weight, Decimal  height){
        Decimal  bmi = weight/(height.pow(2));
        return bmi;
    }
    
    public static Double  getPace(Double  distance, Double  minutes){
        Double  pace = distance/(minutes/60);
        return pace;
        
    }

}