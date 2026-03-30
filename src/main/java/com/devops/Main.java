package com.devops;

public class Main {

    public static void main(String[] args) {
        if (args.length < 3) {
            System.out.println("Usage: java -jar calculator-devops.jar <nombre> <operateur> <nombre>");
            System.out.println("Operateurs disponibles: + - * /");
            System.exit(1);
        }

        try {
            double a = Double.parseDouble(args[0]);
            double b = Double.parseDouble(args[args.length - 1]);

            String operator;
            if (args.length > 3) {
                operator = "*";
            } else {
                operator = args[1].replace("'", "").replace("\"", "").trim();
            }

            Calculator calculator = new Calculator();
            double result;

            switch (operator) {
                case "+" -> result = calculator.add(a, b);
                case "-" -> result = calculator.subtract(a, b);
                case "*" -> result = calculator.multiply(a, b);
                case "/" -> result = calculator.divide(a, b);
                default -> {
                    System.out.println("Erreur : Operateur inconnu -> " + operator);
                    System.exit(1);
                    return;
                }
            }

            System.out.printf("Resultat : %.1f%n", result);

        } catch (ArithmeticException e) {
            System.out.println("Erreur : " + e.getMessage());
            System.exit(1);
        } catch (NumberFormatException e) {
            System.out.println("Erreur : Argument invalide - entrez des nombres valides");
            System.exit(1);
        }
    }
}
