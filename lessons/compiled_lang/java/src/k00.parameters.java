// Not public - see a00.output.java for why.
class K00Parameters {
    static void celsius(double fahrenheit) {
        double temperature = (fahrenheit - 32.0) * 5 / 9;
        System.out.printf("The Celsius temperature is %.1f degrees.\n", temperature);
    }

    public static void main(String[] args) {
        double temperature = 73;
        celsius(temperature);
    }
}
