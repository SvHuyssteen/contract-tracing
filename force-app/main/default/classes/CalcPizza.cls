public  class CalcPizza {
    
    public  Integer getCost(Integer slices){
        Integer cost = slices == 1 ? slices * 8 : (slices > 1 && slices <= 3) ? slices * 7 : slices * 6;
        return cost;
    }

}