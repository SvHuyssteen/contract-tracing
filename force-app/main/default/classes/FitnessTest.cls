@isTest
public class FitnessTest {
    
    Fitness Fit = new Fitness();
    
    @isTest
    public static void getBMITest(){
        Long bmi = Fitness.getBMI(100, 1.73).round();
        System.assert(bmi == 33, 'BMI calculation is not accurate');
         
    }
    @isTest
    public static void getPaceTest(){
        Decimal pace = Fitness.getPace(10, 60);
        System.assertEquals(pace, 10, 'Pace calculation is off');
    }

}