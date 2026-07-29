// Not public - see a00.output.java for why.
class M00Function {
    static int addNums(int... numbers) {
        int sum = 0;
        for (int num : numbers) {
            sum += num;
        }
        return sum;
    }

    public static void main(String[] args) {
        System.out.println("The numbers to be added are 5, 2, 4, 3, 6.");

        int result = addNums(5, 2, 4, 3, 6);
        System.out.println("The result of their summation is: " + result + ".");
    }
}
