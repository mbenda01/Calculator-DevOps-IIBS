package com.devops;

import java.time.Instant;
import java.util.Locale;

public class Main {

    public static void main(String[] args) {
        int exitCode = new Main().run(args);
        if (exitCode != 0) {
            System.exit(exitCode);
        }
    }

    int run(String[] args) {
        if (args.length != 3) {
            printUsage();
            return 1;
        }

        String operator = normalizeOperator(args[1]);

        try {
            double leftOperand = Double.parseDouble(args[0]);
            double rightOperand = Double.parseDouble(args[2]);
            double result = calculate(leftOperand, rightOperand, operator);

            System.out.printf(Locale.US, "Resultat : %.1f%n", result);
            logEvent(buildSuccessEvent(operator, leftOperand, rightOperand, result));
            return 0;
        } catch (NumberFormatException exception) {
            String message = "Argument invalide - entrez des nombres valides";
            System.out.println("Erreur : " + message);
            logEvent(buildErrorEvent(operator, null, null, message));
            return 1;
        } catch (IllegalArgumentException | ArithmeticException exception) {
            System.out.println("Erreur : " + exception.getMessage());

            Double leftOperand = parseDoubleOrNull(args[0]);
            Double rightOperand = parseDoubleOrNull(args[2]);
            logEvent(buildErrorEvent(operator, leftOperand, rightOperand, exception.getMessage()));
            return 1;
        }
    }

    private double calculate(double leftOperand, double rightOperand, String operator) {
        Calculator calculator = new Calculator();

        return switch (operator) {
            case "+" -> calculator.add(leftOperand, rightOperand);
            case "-" -> calculator.subtract(leftOperand, rightOperand);
            case "*" -> calculator.multiply(leftOperand, rightOperand);
            case "/" -> calculator.divide(leftOperand, rightOperand);
            default -> throw new IllegalArgumentException("Operateur inconnu -> " + operator);
        };
    }

    private void printUsage() {
        System.out.println("Usage: java -jar target/calculator-devops.jar <nombre> <operateur> <nombre>");
        System.out.println("Operateurs disponibles: + - * /");
        System.out.println("Astuce: entourez * de quotes dans le shell, par exemple java -jar target/calculator-devops.jar 8 '*' 4");
    }

    private String normalizeOperator(String operator) {
        return operator.replace("\"", "").replace("'", "").trim();
    }

    private Double parseDoubleOrNull(String value) {
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException exception) {
            return null;
        }
    }

    private void logEvent(String payload) {
        System.out.println("CALC_EVENT " + payload);
    }

    private String buildSuccessEvent(String operator, double leftOperand, double rightOperand, double result) {
        return new StringBuilder()
            .append("{")
            .append("\"timestamp\":\"").append(Instant.now()).append("\",")
            .append("\"status\":\"SUCCESS\",")
            .append("\"operation\":\"").append(escapeJson(operator)).append("\",")
            .append("\"left_operand\":").append(formatNumber(leftOperand)).append(",")
            .append("\"right_operand\":").append(formatNumber(rightOperand)).append(",")
            .append("\"result\":").append(formatNumber(result))
            .append("}")
            .toString();
    }

    private String buildErrorEvent(String operator, Double leftOperand, Double rightOperand, String errorMessage) {
        StringBuilder payload = new StringBuilder()
            .append("{")
            .append("\"timestamp\":\"").append(Instant.now()).append("\",")
            .append("\"status\":\"ERROR\"");

        if (operator != null && !operator.isBlank()) {
            payload.append(",\"operation\":\"").append(escapeJson(operator)).append("\"");
        }
        if (leftOperand != null) {
            payload.append(",\"left_operand\":").append(formatNumber(leftOperand));
        }
        if (rightOperand != null) {
            payload.append(",\"right_operand\":").append(formatNumber(rightOperand));
        }

        payload.append(",\"error\":\"").append(escapeJson(errorMessage)).append("\"")
            .append("}");

        return payload.toString();
    }

    private String formatNumber(double value) {
        return String.format(Locale.US, "%.1f", value);
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
