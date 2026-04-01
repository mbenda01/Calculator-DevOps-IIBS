// Fchier src/test/java/com/devops/CalculatorTest.java
package com.devops;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

class CalculatorTest {

    private Calculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new Calculator();
    }

    @Test
    @DisplayName("Addition de deux nombres positifs")
    void testAdd() {
        assertEquals(15.0, calculator.add(10, 5));
    }

    @Test
    @DisplayName("Soustraction avec résultat négatif")
    void testSubtractNegativeResult() {
        assertEquals(-5.0, calculator.subtract(3, 8));
    }

    @Test
    @DisplayName("Multiplication de deux nombres")
    void testMultiply() {
        assertEquals(32.0, calculator.multiply(8, 4));
    }

    @Test
    @DisplayName("Division normale")
    void testDivide() {
        assertEquals(4.0, calculator.divide(20, 5));
    }

    @Test
    @DisplayName("Division par zéro lève ArithmeticException")
    void testDivideByZero() {
        ArithmeticException exception = assertThrows(
            ArithmeticException.class,
            () -> calculator.divide(10, 0)
        );
        assertEquals("Division par zéro impossible", exception.getMessage());
    }

    @Test
    @DisplayName("Addition avec nombres négatifs")
    void testAddNegativeNumbers() {
        assertEquals(-3.0, calculator.add(-5, 2));
    }

    @Test
    @DisplayName("Multiplication par zéro")
    void testMultiplyByZero() {
        assertEquals(0.0, calculator.multiply(99, 0));
    }
}