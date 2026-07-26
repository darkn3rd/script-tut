// Not public - see a00.output.java for why.
class K10Parameters {
    static void addNums(int... numbers) {
        int sum = 0;
        for (int num : numbers) {
            sum += num;
        }
        System.out.println("The summation is: " + sum + ".");
    }

    public static void main(String[] args) {
        System.out.println("Sending: 5, 2, 4, 3, 6");
        addNums(5, 2, 4, 3, 6);
    }
}
